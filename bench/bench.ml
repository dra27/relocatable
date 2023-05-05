(* Return the power reading by calling YPower; Heavily Windows-biased *)
let get_power_reading () =
  let cmd =
    "YPower -r 172.16.0.127 -f \"[result]\" Thor-Power get_deliveredEnergyMeter"
  in
  let ch = Unix.open_process_in cmd in
  set_binary_mode_in ch false;
  let reading = input_line ch in
  match Unix.close_process_in ch with
  | Unix.WEXITED 0 -> float_of_string reading
  | Unix.WEXITED n
  | Unix.WSIGNALED n
  | Unix.WSTOPPED n ->
      Printf.eprintf "YPower exited unexpectedly with code %d\n" n;
      exit 1

let abs_start_time = Unix.gettimeofday ()
let abs_start_power = get_power_reading ()

(* Branches which cannot be built without sh *)
let no_cmd_branches = [
  "native-make";      (* Base - PR expected to merge in advance of the rest *)
  "baseline";         (* Preliminary tweaks not strictly related *)
  "opcodes";          (* Individual tweaks *)
  "awksed";
  "scripts";
  "expand";
  "simpler-prefixing";
  "tidy-flexlink";
  "combined-trunk";   (* Unified branch with all previous branches *)
  "all-the-parallel"; (* Improved parallelism on native-make *)
  "all-the-parallel-combined"; (* all-the-parallel on combined-trunk *)
]
(* Common branches *)
let common_branches = [
  "cmd-shell";           (* Building without sh on combined-trunk *)
  "all-the-parallel-cmd" (* all-the-parallel on cmd-shell *)
]

type platform =
| Linux
| Cygwin of (shell * make)
| MSYS2 of (shell * make)
and shell =
| Sh
| Cmd
and make =
| Platform
| Native

let all_tests, tests =
  let common_platforms = [
    Linux;
    Cygwin(Sh, Platform);
    Cygwin(Sh, Native);
    MSYS2(Sh, Platform);
    MSYS2(Sh, Native)
  ] in
  let all_platforms = MSYS2(Cmd, Native) :: common_platforms in
  let f platforms acc branch =
    let branch = "nosh-" ^ branch in
    List.fold_left (fun acc platform -> (platform, branch)::acc) acc platforms
  in
  let no_cmd = List.fold_left (f common_platforms) [] no_cmd_branches in
  let parallels = [0; (*1; 2; 3; 4; *)8; 16; 32] in
  let g acc (platform, branch) =
    List.fold_left (fun acc j -> (platform, branch, j)::acc) acc parallels in
  let all_tests = List.fold_left (f all_platforms) no_cmd common_branches in
  (List.fold_left g [] all_tests, all_tests)

let workdir_windows = {|C:\Devel\relocatable\ocaml|}
let workdir_linux = "/home/dra/ocaml"

(* XXX Tests to a hash table:
   - Need the results of each run
   - Then load the existing data set
   - Initially, want the lists of tests with no runs
   - Measure power idle power at start
   - Shuffle the tests
   - Pick a test
   - Wait for idle power within 10% of start and record
   - Run the test
   - Update the test with the idle reading (which is a pair - time and power) and the result (also a pair)
   - Write the result to the database
*)

(* Once we have the first result, we can work on a more sophisticated average *)

let parse_result s =
  match String.split_on_char ' ' s with
  | [platform; branch; j; _start; time; baseline; power] ->
    let platform =
      match platform with
      | "Linux" -> Linux
      | "Cygwin(Sh,Platform)" -> Cygwin(Sh, Platform)
      | "Cygwin(Sh,Native)" -> Cygwin(Sh, Native)
      | "Cygwin(Cmd,Platform)" -> Cygwin(Cmd, Platform)
      | "Cygwin(Cmd,Native)" -> Cygwin(Cmd, Native)
      | "MSYS2(Sh,Platform)" -> MSYS2(Sh, Platform)
      | "MSYS2(Sh,Native)" -> MSYS2(Sh, Native)
      | "MSYS2(Cmd,Platform)" -> MSYS2(Cmd, Platform)
      | "MSYS2(Cmd,Native)" -> MSYS2(Cmd, Native)
      | _ -> Printf.eprintf "Corrupt results platform: %S\n" platform; exit 1 in
    let time = float_of_string time in
    let baseline = float_of_string baseline in
    let power = float_of_string power in
    let j = int_of_string j in
    ((platform, branch, j), time, baseline, power)
  | _ -> Printf.eprintf "Corrupt results line:\n  %S\n" s; exit 1

let results = Hashtbl.create 512

let add_result test time baseline power =
  let existing =
    try Hashtbl.find results test
    with Not_found -> []
  in
  Hashtbl.replace results test ((time, baseline, power)::existing)

let load_results () =
  let ch = open_in_gen [Open_rdonly; Open_creat; Open_text] 0o666 "results" in
  try while true do
    let (test, time, baseline, power) = parse_result (input_line ch) in
    add_result test time baseline power
  done; ch with End_of_file ->
    ch

module IntSet = Set.Make(Int)

let compare_test l r =
  let transform (platform, branch, j, result) =
    (branch, platform, (if j = 0 then max_int else j), result)
  in
  compare (transform l) (transform r)

let rec average n a = function
| x::xs -> average (succ n) (a +. x) xs
| [] -> (a /. float_of_int n, n)

let average = average 0 0.0

let left (a, _, _) = a

let display_results () =
  print_string "\027[H\027[2J";
  let fold (platform, branch, j) results ((max, columns, rows) as acc) =
    let max = Int.max max (String.length branch) in
    if results = [] then
      acc
    else
      let rows =
        (platform, branch, j, List.map left results)::rows in
      (max, IntSet.add j columns, rows) in
  let (max_branch_name, all_columns, all_results) =
    Hashtbl.fold fold results (0, IntSet.empty, []) in
  let all_columns = List.sort Int.compare (IntSet.elements (all_columns)) in
  let all_columns =
    match all_columns with
    | [] -> [0]
    | 0::all_columns -> all_columns @ [0]
    | all_columns -> all_columns
  in
  let default_column = List.hd all_columns in
  let (max_branch_name, results) =
    let fold ((max, rows) as acc) (platform, branch) =
      if Hashtbl.mem results (platform, branch, default_column) then
        acc
      else
        let max = Int.max max (String.length branch) in
        (max, (platform, branch, default_column, [])::rows)
    in
    List.fold_left fold (max_branch_name, all_results) tests in
  let rec print_test (current_platform, current_branch, js)
                     ((platform, branch, j, results) as result) =
    if current_platform = platform && current_branch = branch then
      match js with
      | current_j::js ->
          let (average_time, count, final) =
            match results with
            | [] -> (0, 0, ' ')
            | [result] -> (int_of_float (Float.round result), 1, '*')
            | (result::results) as all_results ->
                let (average_time, count) = average all_results in
                let average_time = int_of_float (Float.round average_time) in
                let check l = int_of_float (Float.round (fst (average l))) in
                let final =
                  if List.length results > 2 && average_time = check results then
                    ' '
                  else
                    '*'
                in
                  (average_time, count, final) in
          if current_j = j then
            let () =
              if count = 0 then
                print_string "|        "
              else
                Printf.printf "|%c%4d/%d%c" final average_time count final
            in
            (current_platform, current_branch, js)
          else
            let () = print_string "|        " in
            print_test (current_platform, current_branch, js) result
      | _ -> assert false
    else if js = [] then
      let os_platform =
        let format_platform = function
        | (Sh, Platform) -> " sh/platf"
        | (Sh, Native) -> " sh/win32"
        | (Cmd, Platform) -> "cmd/platf"
        | (Cmd, Native) -> "cmd/win32" in
        match platform with
        | Linux -> "Linux| sh/platf"
        | MSYS2 platform -> "MSYS2|" ^ format_platform platform
        | Cygwin platform -> "Cygwn|" ^ format_platform platform
      in
      Printf.printf "\n%s|%s%s"
                    os_platform branch
                    (String.make (max_branch_name - String.length branch) ' ');
      print_test (platform, branch, all_columns) result
    else
      let () = print_string "|        " in
      print_test (current_platform, current_branch, List.tl js) result
  in
  let infinity = "\xe2\x88\x9e" in
  let print_heading j =
    Printf.printf "|  %sj=%s  " (if j < 10 then " " else "")
                                (if j = 0 then infinity else string_of_int j)
  in
  let heading = "build time at -j=n in seconds/run-count" in
  let padding = (List.length all_columns * 9 - 1 - String.length heading) / 2 in
  Printf.printf "                 %s%s%s\n"
                (String.make max_branch_name ' ')
                (String.make (Int.max 0 padding) ' ')
                heading;
  Printf.printf " OS  | Platform| Branch%s"
                (String.make (max_branch_name - 7) ' ');
  List.iter print_heading all_columns;
  print_char '\n';
  Printf.printf "-----+---------+%s" (String.make max_branch_name '-');
  List.iter (fun _ -> print_string "+--------") all_columns;
  let (_, _, remaining_cols) =
    List.fold_left print_test (Linux, "", []) (List.sort compare_test results)
  in
  List.iter (fun _ -> print_string "|        ") remaining_cols;
  print_char '\n';
  flush stdout

let rec wait_for_result ch =
  match input_line ch with
  | line ->
      let (test, time, baseline, power) = parse_result line in
      add_result test time baseline power
  | exception End_of_file ->
      Unix.sleep 1;
      wait_for_result ch

let display () =
  let ch = load_results () in
  while true do
    display_results ();
    wait_for_result ch
  done

let shuffle list =
  let array = Array.of_list list in
  for i = Array.length array - 1 downto 1 do
    let source = Random.int (i + 1) in
    let dest = array.(i) in
    array.(i) <- array.(source);
    array.(source) <- dest;
  done;
  Array.to_list array

let string_of_platform = function
| Linux -> "Linux"
| Cygwin(Sh, Platform) -> "Cygwin(Sh,Platform)"
| Cygwin(Sh, Native) -> "Cygwin(Sh,Native)"
| Cygwin(Cmd, Platform) -> "Cygwin(Cmd,Platform)"
| Cygwin(Cmd, Native) -> "Cygwin(Cmd,Native)"
| MSYS2(Sh, Platform) -> "MSYS2(Sh,Platform)"
| MSYS2(Sh, Native) -> "MSYS2(Sh,Native)"
| MSYS2(Cmd, Platform) -> "MSYS2(Cmd,Platform)"
| MSYS2(Cmd, Native) -> "MSYS2(Cmd,Native)"

let log ch fmt =
  let print s =
    let offset_time = Unix.gettimeofday () -. abs_start_time in
    let offset_power = get_power_reading () -. abs_start_power in
    (* XXX Formatting could be nicer! *)
    Printf.fprintf ch "+%04.2fs/%04.3fWh %s\n%!" offset_time offset_power s
  in
  Printf.ksprintf print fmt

let dummy_workload _ =
  let running = ref true in
  let thread () =
    while !running do () done
  in
  let domains = Queue.create () in
  for i = 1 to 63 do
    Queue.push (Domain.spawn thread) domains
  done;
  Unix.sleep (Random.int 3);
  running := false;
  Queue.iter Domain.join domains

module Array = struct
  include Array

  let rec aux_findi p a n =
    if n = 0 then
      None
    else if p a.(n) then
      Some n
    else
      aux_findi p a (pred n)

  let findi p a = aux_findi p a (Array.length a - 1)
end

let prepare log_ch (platform, branch, j) =
  let log fmt = log log_ch fmt in
  let j = if j = 0 then "" else string_of_int j in
  let config_env, build_env =
    let env = Unix.environment () in
    let prepend_path s env =
      let prefix = "path=" in
      match Array.findi (fun s -> String.starts_with ~prefix (String.lowercase_ascii s)) env with
      | Some idx ->
          let entry = env.(idx) in
          env.(idx) <-
            Printf.sprintf "%s%s;%s"
                           (String.sub entry 0 5) s
                           (String.sub entry 5 (String.length entry - 5));
          env
      | None ->
          Array.append env [| "Path=" ^ s |] in
    match platform with
    | Linux ->
        env, env
    | MSYS2(Sh, Platform) ->
        let env =
          prepend_path {|C:\msys64\mingw64\bin;C:\msys64\usr\bin|} env
        in
        env, env
    | MSYS2(Sh, Native) ->
        let env =
          prepend_path {|C:\Devel\relocatable\bin;C:\msys64\mingw64\bin;C:\msys64\usr\bin|} env
        in
        env, env
    | MSYS2(Cmd, Platform)
    | Cygwin(Cmd, Platform) ->
        (* Not needed - requires passing SHELL=cmd to the build *)
        failwith "Not implemented"
    | MSYS2(Cmd, Native) ->
        let msys2_bin = {|C:\msys64\usr\bin|} in
        let common_bin = {|C:\Devel\relocatable\bin;C:\msys64\mingw64\bin|} in
        (* Pfff *)
        let config_env =
          prepend_path (common_bin ^ ";" ^ msys2_bin) (Array.copy env) in
        config_env, prepend_path common_bin env
    | Cygwin(_, Platform) ->
        let env =
          prepend_path {|C:\cygwin64\bin|} env
        in
        env, env
    | Cygwin(_, Native) ->
        let env =
          prepend_path {|C:\Devel\relocatable\bin;C:\cygwin64\bin|} env
        in
        env, env
  in
  let make =
    match platform with
    | Linux -> "" (* Not used *)
    | Cygwin(_, Native)
    | MSYS2(_, Native) -> {|C:\Devel\relocatable\bin\make.exe|}
    | Cygwin(_, Platform) -> {|C:\cygwin64\bin\make.exe|}
    | MSYS2(_, Platform) -> {|C:\msys64\usr\bin\make.exe|} in
  let config_command, config_args, build_command, build_args =
    match platform with
    | Linux -> "ssh", ["dra@ubuntu.thor"; "/home/dra/ocaml/execute"; branch], "ssh", ["dra@ubuntu.thor"; "make -C /home/dra/ocaml -j" ^ j]
    | MSYS2 _ -> {|C:\msys64\usr\bin\sh.exe|}, ["execute"; branch], make, ["-j" ^ j]
    | Cygwin _ -> {|C:\cygwin64\bin\sh.exe|}, ["execute"; branch; "--host=x86_64-w64-mingw32"], make, ["-j" ^ j]
  in
  log "Configuring";
  let () =
    let config_args =
      Array.of_list (config_command :: config_args)
    in
    match snd (Unix.waitpid [] (Unix.create_process_env config_command config_args config_env Unix.stdin Unix.stdout Unix.stderr)) with
    | Unix.WEXITED n ->
        if n <> 0 then begin
          log "Configuration failed with code %d" n;
          exit 2
        end
    | _ -> assert false (* XXX *) in
  fun () ->
    log "Executing";
    let build_args = Array.of_list (build_command :: build_args) in
    match snd (Unix.waitpid [] (Unix.create_process_env build_command build_args build_env Unix.stdin Unix.stdout Unix.stderr)) with
    | Unix.WEXITED n ->
        if n <> 0 then begin
          log "Build failed with code %d" n;
          exit 2
        end
    | _ -> assert false (* XXX *)

let baseline = ref 0.0

let measure f v =
  let start_power = get_power_reading () in
  let start_clock = Unix.gettimeofday () in
  let r = f v in
  let finish_clock = Unix.gettimeofday () in
  let finish_power = get_power_reading () in
  let time = finish_clock -. start_clock in
  let power = finish_power -. start_power in
  (r, start_clock, time, power)

let within x p y =
  assert (p > 0.0 && p <= 1.0);
  x >= y *. (1.0 -. p) && x <= y *. (1.0 +. p)

let settle log_ch () =
  let log fmt = log log_ch fmt in
  log "Waiting for power to return to baseline";
  let ((), _, time, power) = measure Unix.sleep 3 in
  let reading = power /. time in
  if not (within reading 0.1 !baseline) then
    let rec cycle last n =
      if n > 0 then
        let () = log "Waiting for power to return to baseline (n=%d)" n in
        let ((), _, time, power) = measure Unix.sleep 3 in
        let reading = power /. time in
        if within reading 0.1 !baseline then
          log "Power has re-settled"
        else if last = 0.0 || within reading 0.1 last then
          cycle reading (pred n)
        else
          let () = log "Un-steady reading" in
          cycle reading n
      else
        let () = log "New baseline: %fWh/s" reading in
        baseline := reading
    in
      cycle 0.0 3

let run_test log_ch ((platform, branch, j) as test) =
  let log fmt = log log_ch fmt in
  let settle = settle log_ch in
  log "%s: executing j=%d for %s" (string_of_platform platform) j branch;
  let execute = prepare log_ch test in
  settle ();
  let ((), start_clock, time, power) = measure execute () in
  let ch = open_out_gen [Open_wronly; Open_append; Open_text] 0o666 {|C:\Devel\relocatable\bench\results|} in
  log "Test took %fs and consumed %fWh" time power;
  Printf.fprintf ch "%s %s %d %f %f %f %f\n"
                 (string_of_platform platform) branch j
                 start_clock time !baseline power;
  close_out ch;
  add_result test time !baseline power;
  settle ()

let () = Random.self_init ()

let run () =
  close_in (load_results ());
  let need_test test =
    (*not (Hashtbl.mem results test)*)
    match Hashtbl.find results test with
    | (result::results) as all_results ->
      let check l =
        int_of_float (Float.round (fst (average (List.map left l))))
      in
      List.length results < 3 || check all_results <> check results
    | [] -> true
    | exception Not_found -> true
  in
  let get_tests () = shuffle (List.filter need_test all_tests) in
  let log_ch =
    open_out_gen [Open_wronly; Open_creat; Open_append; Open_text] 0o666 "log"
  in
  let log fmt = log log_ch fmt in
  log "Calming down";
  Unix.sleep 5;
  log "Taking initial baseline power reading";
  let ((), _, time, power) = measure Unix.sleep 5 in
  baseline := power /. time;
  log "Baseline: %fWh/s" !baseline;
  Unix.chdir {|C:\Devel\relocatable\ocaml|};
  let rec loop todo =
    if todo = [] then
      log "Run complete"
    else
      let () = List.iter (run_test log_ch) todo in
      loop (get_tests ())
  in
  loop (get_tests ())

let () =
  match Sys.argv with
  | [| _; "display" |] -> display ()
  | [| _; "run" |] -> run ()
  | _ -> Printf.eprintf "Incorrect command line\n"; exit 1
