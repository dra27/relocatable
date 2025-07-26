FROM ocaml/opam:ubuntu-24.04-opam AS base

RUN sudo apt-get update && sudo apt-get install -y gawk autoconf2.69
RUN sudo apt-get install -y vim

ENV OPAMYES="1" OCAMLCONFIRMLEVEL="unsafe-yes" OPAMPRECISETRACKING="1"
RUN sudo ln -f /usr/bin/opam-2.3 /usr/bin/opam && opam update

RUN git clone https://github.com/dra27/ocaml.git
WORKDIR ocaml

FROM base AS test-4.08-vanilla
RUN git checkout 800a2df74dcfa0fdcc0c9aabc59ac0e3bee7cf6b || git fetch origin && git checkout 800a2df74dcfa0fdcc0c9aabc59ac0e3bee7cf6b
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml
RUN make -j world.opt
RUN make -j ocamlnat
RUN make install
RUN mv _opam _opam.ref
RUN git checkout f2c4b5a7228f03b039babcbb0589194897a0789a || git fetch origin && git checkout f2c4b5a7228f03b039babcbb0589194897a0789a
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout 06f8e57ab1af9dac61a242413afc7a58cc109111 || git fetch origin && git checkout 06f8e57ab1af9dac61a242413afc7a58cc109111
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout 3b6adaae1c3a7d87455244c66ce2f9e55e6197b2 || git fetch origin && git checkout 3b6adaae1c3a7d87455244c66ce2f9e55e6197b2
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout 61306f45d7e636f58dc1549b1bee349ed3a9531e || git fetch origin && git checkout 61306f45d7e636f58dc1549b1bee349ed3a9531e
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d; false; fi
RUN make INSTALL_MODE=display install
RUN make INSTALL_MODE=opam OPAM_PACKAGE_NAME=ocaml-variants install
RUN make INSTALL_MODE=clone OPAM_PACKAGE_NAME=ocaml-variants install
RUN test ! -d _opam
RUN opam switch create . --empty && opam pin add --no-action --kind=path ocaml-variants .
RUN opam install ocaml-variants --assume-built
FROM base AS test-4.08-relocatable
RUN git checkout 800a2df74dcfa0fdcc0c9aabc59ac0e3bee7cf6b || git fetch origin && git checkout 800a2df74dcfa0fdcc0c9aabc59ac0e3bee7cf6b
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --with-relative-libdir=../lib/ocaml --enable-runtime-search=always --enable-runtime-search-target
RUN make -j world.opt
RUN make -j ocamlnat
RUN make install
RUN mv _opam _opam.ref
RUN git checkout f2c4b5a7228f03b039babcbb0589194897a0789a || git fetch origin && git checkout f2c4b5a7228f03b039babcbb0589194897a0789a
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout 06f8e57ab1af9dac61a242413afc7a58cc109111 || git fetch origin && git checkout 06f8e57ab1af9dac61a242413afc7a58cc109111
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout 3b6adaae1c3a7d87455244c66ce2f9e55e6197b2 || git fetch origin && git checkout 3b6adaae1c3a7d87455244c66ce2f9e55e6197b2
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout 61306f45d7e636f58dc1549b1bee349ed3a9531e || git fetch origin && git checkout 61306f45d7e636f58dc1549b1bee349ed3a9531e
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d; false; fi
RUN make INSTALL_MODE=display install
RUN make INSTALL_MODE=opam OPAM_PACKAGE_NAME=ocaml-variants install
RUN make INSTALL_MODE=clone OPAM_PACKAGE_NAME=ocaml-variants install
RUN test ! -d _opam
RUN opam switch create . --empty && opam pin add --no-action --kind=path ocaml-variants .
RUN opam install ocaml-variants --assume-built
FROM base AS test-4.09-vanilla
RUN git checkout b43f2055f4e9f4154de77719345b6f62f2dc769b || git fetch origin && git checkout b43f2055f4e9f4154de77719345b6f62f2dc769b
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml
RUN make -j world.opt
RUN make -j ocamlnat
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 2b72c577922ebd898beb8a3d17374aac479209dd || git fetch origin && git checkout 2b72c577922ebd898beb8a3d17374aac479209dd
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout 2160b27cfa685540a90a903537cefa38a00fd2f0 || git fetch origin && git checkout 2160b27cfa685540a90a903537cefa38a00fd2f0
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout 27b953e50b026718eab6f4ee8aaeee6446844211 || git fetch origin && git checkout 27b953e50b026718eab6f4ee8aaeee6446844211
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout afd606751ac77b8f3b953cb22cb5e60dd023ce64 || git fetch origin && git checkout afd606751ac77b8f3b953cb22cb5e60dd023ce64
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d; false; fi
RUN make INSTALL_MODE=display install
RUN make INSTALL_MODE=opam OPAM_PACKAGE_NAME=ocaml-variants install
RUN make INSTALL_MODE=clone OPAM_PACKAGE_NAME=ocaml-variants install
RUN test ! -d _opam
RUN opam switch create . --empty && opam pin add --no-action --kind=path ocaml-variants .
RUN opam install ocaml-variants --assume-built
FROM base AS test-4.09-relocatable
RUN git checkout b43f2055f4e9f4154de77719345b6f62f2dc769b || git fetch origin && git checkout b43f2055f4e9f4154de77719345b6f62f2dc769b
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --with-relative-libdir=../lib/ocaml --enable-runtime-search=always --enable-runtime-search-target
RUN make -j world.opt
RUN make -j ocamlnat
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 2b72c577922ebd898beb8a3d17374aac479209dd || git fetch origin && git checkout 2b72c577922ebd898beb8a3d17374aac479209dd
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout 2160b27cfa685540a90a903537cefa38a00fd2f0 || git fetch origin && git checkout 2160b27cfa685540a90a903537cefa38a00fd2f0
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout 27b953e50b026718eab6f4ee8aaeee6446844211 || git fetch origin && git checkout 27b953e50b026718eab6f4ee8aaeee6446844211
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout afd606751ac77b8f3b953cb22cb5e60dd023ce64 || git fetch origin && git checkout afd606751ac77b8f3b953cb22cb5e60dd023ce64
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d; false; fi
RUN make INSTALL_MODE=display install
RUN make INSTALL_MODE=opam OPAM_PACKAGE_NAME=ocaml-variants install
RUN make INSTALL_MODE=clone OPAM_PACKAGE_NAME=ocaml-variants install
RUN test ! -d _opam
RUN opam switch create . --empty && opam pin add --no-action --kind=path ocaml-variants .
RUN opam install ocaml-variants --assume-built
FROM base AS test-4.10-vanilla
RUN git checkout d4a50dc832ab35cd66b51995354f2d4b53ee4fa5 || git fetch origin && git checkout d4a50dc832ab35cd66b51995354f2d4b53ee4fa5
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml
RUN make -j
RUN make -j ocamlnat
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 390928a69469c56b9e3aa89aeaa4e380b92bccae || git fetch origin && git checkout 390928a69469c56b9e3aa89aeaa4e380b92bccae
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout 878d0ea77b138afb33fac26da8eff4e808da11d5 || git fetch origin && git checkout 878d0ea77b138afb33fac26da8eff4e808da11d5
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout df8610b19576420f73cc7b5dc2d2fb959b1ea530 || git fetch origin && git checkout df8610b19576420f73cc7b5dc2d2fb959b1ea530
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout 071870a13c2c40536b3db6072826e44cfbe02943 || git fetch origin && git checkout 071870a13c2c40536b3db6072826e44cfbe02943
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d; false; fi
RUN make INSTALL_MODE=display install
RUN make INSTALL_MODE=opam OPAM_PACKAGE_NAME=ocaml-variants install
RUN make INSTALL_MODE=clone OPAM_PACKAGE_NAME=ocaml-variants install
RUN test ! -d _opam
RUN opam switch create . --empty && opam pin add --no-action --kind=path ocaml-variants .
RUN opam install ocaml-variants --assume-built
FROM base AS test-4.10-relocatable
RUN git checkout d4a50dc832ab35cd66b51995354f2d4b53ee4fa5 || git fetch origin && git checkout d4a50dc832ab35cd66b51995354f2d4b53ee4fa5
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --with-relative-libdir=../lib/ocaml --enable-runtime-search=always --enable-runtime-search-target
RUN make -j
RUN make -j ocamlnat
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 390928a69469c56b9e3aa89aeaa4e380b92bccae || git fetch origin && git checkout 390928a69469c56b9e3aa89aeaa4e380b92bccae
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout 878d0ea77b138afb33fac26da8eff4e808da11d5 || git fetch origin && git checkout 878d0ea77b138afb33fac26da8eff4e808da11d5
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout df8610b19576420f73cc7b5dc2d2fb959b1ea530 || git fetch origin && git checkout df8610b19576420f73cc7b5dc2d2fb959b1ea530
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout 071870a13c2c40536b3db6072826e44cfbe02943 || git fetch origin && git checkout 071870a13c2c40536b3db6072826e44cfbe02943
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d; false; fi
RUN make INSTALL_MODE=display install
RUN make INSTALL_MODE=opam OPAM_PACKAGE_NAME=ocaml-variants install
RUN make INSTALL_MODE=clone OPAM_PACKAGE_NAME=ocaml-variants install
RUN test ! -d _opam
RUN opam switch create . --empty && opam pin add --no-action --kind=path ocaml-variants .
RUN opam install ocaml-variants --assume-built
FROM base AS test-4.11-vanilla
RUN git checkout 0e70215446b36ec3de534098efc114bca1afe0d3 || git fetch origin && git checkout 0e70215446b36ec3de534098efc114bca1afe0d3
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml
RUN make -j
RUN make -j ocamlnat
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 195f4eeefc7c4756562f9c1c2b66c834aaaba224 || git fetch origin && git checkout 195f4eeefc7c4756562f9c1c2b66c834aaaba224
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout f614657134e7c69a19edd99cbb346419c4611885 || git fetch origin && git checkout f614657134e7c69a19edd99cbb346419c4611885
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout 3f10e54c620af5eca3f60e808529475d22e5db43 || git fetch origin && git checkout 3f10e54c620af5eca3f60e808529475d22e5db43
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout 870a046835be490288f3ae436cdf3bfa0fd71a51 || git fetch origin && git checkout 870a046835be490288f3ae436cdf3bfa0fd71a51
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d; false; fi
RUN make INSTALL_MODE=display install
RUN make INSTALL_MODE=opam OPAM_PACKAGE_NAME=ocaml-variants install
RUN make INSTALL_MODE=clone OPAM_PACKAGE_NAME=ocaml-variants install
RUN test ! -d _opam
RUN opam switch create . --empty && opam pin add --no-action --kind=path ocaml-variants .
RUN opam install ocaml-variants --assume-built
FROM base AS test-4.11-relocatable
RUN git checkout 0e70215446b36ec3de534098efc114bca1afe0d3 || git fetch origin && git checkout 0e70215446b36ec3de534098efc114bca1afe0d3
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --with-relative-libdir=../lib/ocaml --enable-runtime-search=always --enable-runtime-search-target
RUN make -j
RUN make -j ocamlnat
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 195f4eeefc7c4756562f9c1c2b66c834aaaba224 || git fetch origin && git checkout 195f4eeefc7c4756562f9c1c2b66c834aaaba224
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout f614657134e7c69a19edd99cbb346419c4611885 || git fetch origin && git checkout f614657134e7c69a19edd99cbb346419c4611885
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout 3f10e54c620af5eca3f60e808529475d22e5db43 || git fetch origin && git checkout 3f10e54c620af5eca3f60e808529475d22e5db43
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout 870a046835be490288f3ae436cdf3bfa0fd71a51 || git fetch origin && git checkout 870a046835be490288f3ae436cdf3bfa0fd71a51
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d; false; fi
RUN make INSTALL_MODE=display install
RUN make INSTALL_MODE=opam OPAM_PACKAGE_NAME=ocaml-variants install
RUN make INSTALL_MODE=clone OPAM_PACKAGE_NAME=ocaml-variants install
RUN test ! -d _opam
RUN opam switch create . --empty && opam pin add --no-action --kind=path ocaml-variants .
RUN opam install ocaml-variants --assume-built
FROM base AS test-4.12-vanilla
RUN git checkout 6d8327037c6e05f140bd3766163e14cc02e7cc6d || git fetch origin && git checkout 6d8327037c6e05f140bd3766163e14cc02e7cc6d
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml
RUN make -j
RUN make -j ocamlnat
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 9a1569205a644085d247cf05fe51cbe79e309c0a || git fetch origin && git checkout 9a1569205a644085d247cf05fe51cbe79e309c0a
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout 6190d679363018e09d76e1ae6811836cc5eeb86b || git fetch origin && git checkout 6190d679363018e09d76e1ae6811836cc5eeb86b
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout b35b2f848b1ab77724128667dd6f5936cdf456fb || git fetch origin && git checkout b35b2f848b1ab77724128667dd6f5936cdf456fb
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout b9057ac2b131fb604d2bd2076a59257868e04ebc || git fetch origin && git checkout b9057ac2b131fb604d2bd2076a59257868e04ebc
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d; false; fi
RUN make INSTALL_MODE=display install
RUN make INSTALL_MODE=opam OPAM_PACKAGE_NAME=ocaml-variants install
RUN make INSTALL_MODE=clone OPAM_PACKAGE_NAME=ocaml-variants install
RUN test ! -d _opam
RUN opam switch create . --empty && opam pin add --no-action --kind=path ocaml-variants .
RUN opam install ocaml-variants --assume-built
FROM base AS test-4.12-relocatable
RUN git checkout 6d8327037c6e05f140bd3766163e14cc02e7cc6d || git fetch origin && git checkout 6d8327037c6e05f140bd3766163e14cc02e7cc6d
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --with-relative-libdir=../lib/ocaml --enable-runtime-search=always --enable-runtime-search-target
RUN make -j
RUN make -j ocamlnat
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 9a1569205a644085d247cf05fe51cbe79e309c0a || git fetch origin && git checkout 9a1569205a644085d247cf05fe51cbe79e309c0a
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout 6190d679363018e09d76e1ae6811836cc5eeb86b || git fetch origin && git checkout 6190d679363018e09d76e1ae6811836cc5eeb86b
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout b35b2f848b1ab77724128667dd6f5936cdf456fb || git fetch origin && git checkout b35b2f848b1ab77724128667dd6f5936cdf456fb
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout b9057ac2b131fb604d2bd2076a59257868e04ebc || git fetch origin && git checkout b9057ac2b131fb604d2bd2076a59257868e04ebc
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d; false; fi
RUN make INSTALL_MODE=display install
RUN make INSTALL_MODE=opam OPAM_PACKAGE_NAME=ocaml-variants install
RUN make INSTALL_MODE=clone OPAM_PACKAGE_NAME=ocaml-variants install
RUN test ! -d _opam
RUN opam switch create . --empty && opam pin add --no-action --kind=path ocaml-variants .
RUN opam install ocaml-variants --assume-built
FROM base AS test-4.13-vanilla
RUN git checkout eda2a97d56d473743f06c924f4694a08999807fa || git fetch origin && git checkout eda2a97d56d473743f06c924f4694a08999807fa
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml
RUN make -j
RUN make -j ocamlnat
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 37d6441898cb66bfeb899b0852a9d60066e4e4d8 || git fetch origin && git checkout 37d6441898cb66bfeb899b0852a9d60066e4e4d8
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout f401aacc1819d9d022afb49850ce6598b313d8cd || git fetch origin && git checkout f401aacc1819d9d022afb49850ce6598b313d8cd
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout e7c82d251fb709e7972ffaf299b82dd827bd7b8f || git fetch origin && git checkout e7c82d251fb709e7972ffaf299b82dd827bd7b8f
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout 91ac848e5bc5fd9389a1450cd534286cea8f3817 || git fetch origin && git checkout 91ac848e5bc5fd9389a1450cd534286cea8f3817
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d; false; fi
RUN make INSTALL_MODE=display install
RUN make INSTALL_MODE=opam OPAM_PACKAGE_NAME=ocaml-variants install
RUN make INSTALL_MODE=clone OPAM_PACKAGE_NAME=ocaml-variants install
RUN test ! -d _opam
RUN opam switch create . --empty && opam pin add --no-action --kind=path ocaml-variants .
RUN opam install ocaml-variants --assume-built
FROM base AS test-4.13-relocatable
RUN git checkout eda2a97d56d473743f06c924f4694a08999807fa || git fetch origin && git checkout eda2a97d56d473743f06c924f4694a08999807fa
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --with-relative-libdir=../lib/ocaml --enable-runtime-search=always --enable-runtime-search-target
RUN make -j
RUN make -j ocamlnat
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 37d6441898cb66bfeb899b0852a9d60066e4e4d8 || git fetch origin && git checkout 37d6441898cb66bfeb899b0852a9d60066e4e4d8
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout f401aacc1819d9d022afb49850ce6598b313d8cd || git fetch origin && git checkout f401aacc1819d9d022afb49850ce6598b313d8cd
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout e7c82d251fb709e7972ffaf299b82dd827bd7b8f || git fetch origin && git checkout e7c82d251fb709e7972ffaf299b82dd827bd7b8f
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout 91ac848e5bc5fd9389a1450cd534286cea8f3817 || git fetch origin && git checkout 91ac848e5bc5fd9389a1450cd534286cea8f3817
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d; false; fi
RUN make INSTALL_MODE=display install
RUN make INSTALL_MODE=opam OPAM_PACKAGE_NAME=ocaml-variants install
RUN make INSTALL_MODE=clone OPAM_PACKAGE_NAME=ocaml-variants install
RUN test ! -d _opam
RUN opam switch create . --empty && opam pin add --no-action --kind=path ocaml-variants .
RUN opam install ocaml-variants --assume-built
FROM base AS test-4.14-vanilla
RUN git checkout 32d46126b2b993a7ac526a339c85d528d3a280cd || git fetch origin && git checkout 32d46126b2b993a7ac526a339c85d528d3a280cd
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --enable-native-toplevel
RUN make -j
RUN make install
RUN mv _opam _opam.ref
RUN git checkout e1794e2548a1e8f6dc11841b0ac9ad159ca89988 || git fetch origin && git checkout e1794e2548a1e8f6dc11841b0ac9ad159ca89988
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout 86ecf4399873045d7eca03560d9ac84eebae38e8 || git fetch origin && git checkout 86ecf4399873045d7eca03560d9ac84eebae38e8
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout 671122db576cb0e6531cf1fa3b18af225f840c36 || git fetch origin && git checkout 671122db576cb0e6531cf1fa3b18af225f840c36
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout fbf12456dd47d758d1858bd6edf8dd3310a7ca3b || git fetch origin && git checkout fbf12456dd47d758d1858bd6edf8dd3310a7ca3b
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d; false; fi
RUN make INSTALL_MODE=display install
RUN make INSTALL_MODE=opam OPAM_PACKAGE_NAME=ocaml-variants install
RUN make INSTALL_MODE=clone OPAM_PACKAGE_NAME=ocaml-variants install
RUN test ! -d _opam
RUN opam switch create . --empty && opam pin add --no-action --kind=path ocaml-variants .
RUN opam install ocaml-variants --assume-built
FROM base AS test-4.14-relocatable
RUN git checkout 32d46126b2b993a7ac526a339c85d528d3a280cd || git fetch origin && git checkout 32d46126b2b993a7ac526a339c85d528d3a280cd
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --enable-native-toplevel --with-relative-libdir=../lib/ocaml --enable-runtime-search=always --enable-runtime-search-target
RUN make -j
RUN make install
RUN mv _opam _opam.ref
RUN git checkout e1794e2548a1e8f6dc11841b0ac9ad159ca89988 || git fetch origin && git checkout e1794e2548a1e8f6dc11841b0ac9ad159ca89988
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout 86ecf4399873045d7eca03560d9ac84eebae38e8 || git fetch origin && git checkout 86ecf4399873045d7eca03560d9ac84eebae38e8
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout 671122db576cb0e6531cf1fa3b18af225f840c36 || git fetch origin && git checkout 671122db576cb0e6531cf1fa3b18af225f840c36
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout fbf12456dd47d758d1858bd6edf8dd3310a7ca3b || git fetch origin && git checkout fbf12456dd47d758d1858bd6edf8dd3310a7ca3b
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d; false; fi
RUN make INSTALL_MODE=display install
RUN make INSTALL_MODE=opam OPAM_PACKAGE_NAME=ocaml-variants install
RUN make INSTALL_MODE=clone OPAM_PACKAGE_NAME=ocaml-variants install
RUN test ! -d _opam
RUN opam switch create . --empty && opam pin add --no-action --kind=path ocaml-variants .
RUN opam install ocaml-variants --assume-built
FROM base AS test-5.0-vanilla
RUN git checkout 82f92de9deed7aaf8ddd04c3dfd375a14a581b6d || git fetch origin && git checkout 82f92de9deed7aaf8ddd04c3dfd375a14a581b6d
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --enable-native-toplevel
RUN make -j
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 972dcc345df8b5090cbdc4796bacb28af5e13716 || git fetch origin && git checkout 972dcc345df8b5090cbdc4796bacb28af5e13716
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout db6eea87587f286d337af39c2cd4c7aa0311e3ec || git fetch origin && git checkout db6eea87587f286d337af39c2cd4c7aa0311e3ec
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout dba90aee6889f6f61cfdd34894ba9477ea14be8f || git fetch origin && git checkout dba90aee6889f6f61cfdd34894ba9477ea14be8f
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout 13b35456fbae450d890e09449eef446972b6b412 || git fetch origin && git checkout 13b35456fbae450d890e09449eef446972b6b412
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d; false; fi
RUN make INSTALL_MODE=display install
RUN make INSTALL_MODE=opam OPAM_PACKAGE_NAME=ocaml-variants install
RUN make INSTALL_MODE=clone OPAM_PACKAGE_NAME=ocaml-variants install
RUN test ! -d _opam
RUN opam switch create . --empty && opam pin add --no-action --kind=path ocaml-variants .
RUN opam install ocaml-variants --assume-built
FROM base AS test-5.0-relocatable
RUN git checkout 82f92de9deed7aaf8ddd04c3dfd375a14a581b6d || git fetch origin && git checkout 82f92de9deed7aaf8ddd04c3dfd375a14a581b6d
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --enable-native-toplevel --with-relative-libdir=../lib/ocaml --enable-runtime-search=always --enable-runtime-search-target
RUN make -j
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 972dcc345df8b5090cbdc4796bacb28af5e13716 || git fetch origin && git checkout 972dcc345df8b5090cbdc4796bacb28af5e13716
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout db6eea87587f286d337af39c2cd4c7aa0311e3ec || git fetch origin && git checkout db6eea87587f286d337af39c2cd4c7aa0311e3ec
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout dba90aee6889f6f61cfdd34894ba9477ea14be8f || git fetch origin && git checkout dba90aee6889f6f61cfdd34894ba9477ea14be8f
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout 13b35456fbae450d890e09449eef446972b6b412 || git fetch origin && git checkout 13b35456fbae450d890e09449eef446972b6b412
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d; false; fi
RUN make INSTALL_MODE=display install
RUN make INSTALL_MODE=opam OPAM_PACKAGE_NAME=ocaml-variants install
RUN make INSTALL_MODE=clone OPAM_PACKAGE_NAME=ocaml-variants install
RUN test ! -d _opam
RUN opam switch create . --empty && opam pin add --no-action --kind=path ocaml-variants .
RUN opam install ocaml-variants --assume-built
FROM base AS test-5.1-vanilla
RUN git checkout 1c481272d70947bb40e2d42a4f30b44a6e648cc0 || git fetch origin && git checkout 1c481272d70947bb40e2d42a4f30b44a6e648cc0
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --enable-native-toplevel
RUN make -j
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 9f4c7ad14b14c937e4d67a6fc6192f3ce6e9950a || git fetch origin && git checkout 9f4c7ad14b14c937e4d67a6fc6192f3ce6e9950a
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout 04b42a2363b3a7efa03a8e389572988fb78b0bdb || git fetch origin && git checkout 04b42a2363b3a7efa03a8e389572988fb78b0bdb
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout dd64ef76c9acae89ad83c1e7f5b54bfaaf28343e || git fetch origin && git checkout dd64ef76c9acae89ad83c1e7f5b54bfaaf28343e
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout 61511e1795a4d754990e2cf02dcfde3e7e1de1a4 || git fetch origin && git checkout 61511e1795a4d754990e2cf02dcfde3e7e1de1a4
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d; false; fi
RUN make INSTALL_MODE=display install
RUN make INSTALL_MODE=opam OPAM_PACKAGE_NAME=ocaml-variants install
RUN make INSTALL_MODE=clone OPAM_PACKAGE_NAME=ocaml-variants install
RUN test ! -d _opam
RUN opam switch create . --empty && opam pin add --no-action --kind=path ocaml-variants .
RUN opam install ocaml-variants --assume-built
FROM base AS test-5.1-relocatable
RUN git checkout 1c481272d70947bb40e2d42a4f30b44a6e648cc0 || git fetch origin && git checkout 1c481272d70947bb40e2d42a4f30b44a6e648cc0
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --enable-native-toplevel --with-relative-libdir=../lib/ocaml --enable-runtime-search=always --enable-runtime-search-target
RUN make -j
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 9f4c7ad14b14c937e4d67a6fc6192f3ce6e9950a || git fetch origin && git checkout 9f4c7ad14b14c937e4d67a6fc6192f3ce6e9950a
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout 04b42a2363b3a7efa03a8e389572988fb78b0bdb || git fetch origin && git checkout 04b42a2363b3a7efa03a8e389572988fb78b0bdb
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout dd64ef76c9acae89ad83c1e7f5b54bfaaf28343e || git fetch origin && git checkout dd64ef76c9acae89ad83c1e7f5b54bfaaf28343e
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout 61511e1795a4d754990e2cf02dcfde3e7e1de1a4 || git fetch origin && git checkout 61511e1795a4d754990e2cf02dcfde3e7e1de1a4
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d; false; fi
RUN make INSTALL_MODE=display install
RUN make INSTALL_MODE=opam OPAM_PACKAGE_NAME=ocaml-variants install
RUN make INSTALL_MODE=clone OPAM_PACKAGE_NAME=ocaml-variants install
RUN test ! -d _opam
RUN opam switch create . --empty && opam pin add --no-action --kind=path ocaml-variants .
RUN opam install ocaml-variants --assume-built
FROM base AS test-5.2-vanilla
RUN git checkout c5bff8f0c7b102707125b51affecf4aecfce271a || git fetch origin && git checkout c5bff8f0c7b102707125b51affecf4aecfce271a
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --enable-native-toplevel
RUN make -j
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 254e6cecb0cb12d5a02b04283820425510ba7827 || git fetch origin && git checkout 254e6cecb0cb12d5a02b04283820425510ba7827
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout 908ef4199aacfd3b497922658d7df3ee8997ede9 || git fetch origin && git checkout 908ef4199aacfd3b497922658d7df3ee8997ede9
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout 7728718d120db88a021434171cc7de6eebf83c01 || git fetch origin && git checkout 7728718d120db88a021434171cc7de6eebf83c01
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout 6d7b692b9ecc082858afa19d00dbdb9dac676d52 || git fetch origin && git checkout 6d7b692b9ecc082858afa19d00dbdb9dac676d52
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d; false; fi
RUN make INSTALL_MODE=display install
RUN make INSTALL_MODE=opam OPAM_PACKAGE_NAME=ocaml-variants install
RUN make INSTALL_MODE=clone OPAM_PACKAGE_NAME=ocaml-variants install
RUN test ! -d _opam
RUN opam switch create . --empty && opam pin add --no-action --kind=path ocaml-variants .
RUN opam install ocaml-variants --assume-built
FROM base AS test-5.2-relocatable
RUN git checkout c5bff8f0c7b102707125b51affecf4aecfce271a || git fetch origin && git checkout c5bff8f0c7b102707125b51affecf4aecfce271a
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --enable-native-toplevel --with-relative-libdir=../lib/ocaml --enable-runtime-search=always --enable-runtime-search-target
RUN make -j
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 254e6cecb0cb12d5a02b04283820425510ba7827 || git fetch origin && git checkout 254e6cecb0cb12d5a02b04283820425510ba7827
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout 908ef4199aacfd3b497922658d7df3ee8997ede9 || git fetch origin && git checkout 908ef4199aacfd3b497922658d7df3ee8997ede9
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout 7728718d120db88a021434171cc7de6eebf83c01 || git fetch origin && git checkout 7728718d120db88a021434171cc7de6eebf83c01
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout 6d7b692b9ecc082858afa19d00dbdb9dac676d52 || git fetch origin && git checkout 6d7b692b9ecc082858afa19d00dbdb9dac676d52
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d; false; fi
RUN make INSTALL_MODE=display install
RUN make INSTALL_MODE=opam OPAM_PACKAGE_NAME=ocaml-variants install
RUN make INSTALL_MODE=clone OPAM_PACKAGE_NAME=ocaml-variants install
RUN test ! -d _opam
RUN opam switch create . --empty && opam pin add --no-action --kind=path ocaml-variants .
RUN opam install ocaml-variants --assume-built
FROM base AS test-5.3-vanilla
RUN git checkout 489d336937d572ca4736137f7454ebab09254f10 || git fetch origin && git checkout 489d336937d572ca4736137f7454ebab09254f10
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --enable-native-toplevel
RUN make -j
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 5cf9b0e0b53a4aa102107994e611ee60dab5235c || git fetch origin && git checkout 5cf9b0e0b53a4aa102107994e611ee60dab5235c
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout 01484a48cff1161a480a91528aa840f201b95955 || git fetch origin && git checkout 01484a48cff1161a480a91528aa840f201b95955
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout 42789985c1978a88241587dac3260d8d056e5c91 || git fetch origin && git checkout 42789985c1978a88241587dac3260d8d056e5c91
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout 47f72fb25fa8efaa83afc73622c2a259bc5f404e || git fetch origin && git checkout 47f72fb25fa8efaa83afc73622c2a259bc5f404e
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d; false; fi
RUN make INSTALL_MODE=display install
RUN make INSTALL_MODE=opam OPAM_PACKAGE_NAME=ocaml-variants install
RUN make INSTALL_MODE=clone OPAM_PACKAGE_NAME=ocaml-variants install
RUN test ! -d _opam
RUN opam switch create . --empty && opam pin add --no-action --kind=path ocaml-variants .
RUN opam install ocaml-variants --assume-built
FROM base AS test-5.3-relocatable
RUN git checkout 489d336937d572ca4736137f7454ebab09254f10 || git fetch origin && git checkout 489d336937d572ca4736137f7454ebab09254f10
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --enable-native-toplevel --with-relative-libdir=../lib/ocaml --enable-runtime-search=always --enable-runtime-search-target
RUN make -j
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 5cf9b0e0b53a4aa102107994e611ee60dab5235c || git fetch origin && git checkout 5cf9b0e0b53a4aa102107994e611ee60dab5235c
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout 01484a48cff1161a480a91528aa840f201b95955 || git fetch origin && git checkout 01484a48cff1161a480a91528aa840f201b95955
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout 42789985c1978a88241587dac3260d8d056e5c91 || git fetch origin && git checkout 42789985c1978a88241587dac3260d8d056e5c91
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout 47f72fb25fa8efaa83afc73622c2a259bc5f404e || git fetch origin && git checkout 47f72fb25fa8efaa83afc73622c2a259bc5f404e
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d; false; fi
RUN make INSTALL_MODE=display install
RUN make INSTALL_MODE=opam OPAM_PACKAGE_NAME=ocaml-variants install
RUN make INSTALL_MODE=clone OPAM_PACKAGE_NAME=ocaml-variants install
RUN test ! -d _opam
RUN opam switch create . --empty && opam pin add --no-action --kind=path ocaml-variants .
RUN opam install ocaml-variants --assume-built
FROM base AS test-5.4-vanilla
RUN git checkout 834f7ff03effb6863f4e469517d78fdb63549fd0 || git fetch origin && git checkout 834f7ff03effb6863f4e469517d78fdb63549fd0
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --enable-native-toplevel
RUN make -j
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 46e658856dff840119e6cbaa6e0329b26ff42c4c || git fetch origin && git checkout 46e658856dff840119e6cbaa6e0329b26ff42c4c
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout 537240c6b8231f6070e4b60a69fb71d1834e8c2a || git fetch origin && git checkout 537240c6b8231f6070e4b60a69fb71d1834e8c2a
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout c80787f7f68d82b2173584073f74a473b39935b8 || git fetch origin && git checkout c80787f7f68d82b2173584073f74a473b39935b8
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout c4a9c58f54bc549a599cd73c8964046727409dc1 || git fetch origin && git checkout c4a9c58f54bc549a599cd73c8964046727409dc1
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d; false; fi
RUN make INSTALL_MODE=display install
RUN make INSTALL_MODE=opam OPAM_PACKAGE_NAME=ocaml-variants install
RUN make INSTALL_MODE=clone OPAM_PACKAGE_NAME=ocaml-variants install
RUN test ! -d _opam
RUN opam switch create . --empty && opam pin add --no-action --kind=path ocaml-variants .
RUN opam install ocaml-variants --assume-built
FROM base AS test-5.4-relocatable
RUN git checkout 834f7ff03effb6863f4e469517d78fdb63549fd0 || git fetch origin && git checkout 834f7ff03effb6863f4e469517d78fdb63549fd0
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --enable-native-toplevel --with-relative-libdir=../lib/ocaml --enable-runtime-search=always --enable-runtime-search-target
RUN make -j
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 46e658856dff840119e6cbaa6e0329b26ff42c4c || git fetch origin && git checkout 46e658856dff840119e6cbaa6e0329b26ff42c4c
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout 537240c6b8231f6070e4b60a69fb71d1834e8c2a || git fetch origin && git checkout 537240c6b8231f6070e4b60a69fb71d1834e8c2a
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout c80787f7f68d82b2173584073f74a473b39935b8 || git fetch origin && git checkout c80787f7f68d82b2173584073f74a473b39935b8
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout c4a9c58f54bc549a599cd73c8964046727409dc1 || git fetch origin && git checkout c4a9c58f54bc549a599cd73c8964046727409dc1
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d; false; fi
RUN make INSTALL_MODE=display install
RUN make INSTALL_MODE=opam OPAM_PACKAGE_NAME=ocaml-variants install
RUN make INSTALL_MODE=clone OPAM_PACKAGE_NAME=ocaml-variants install
RUN test ! -d _opam
RUN opam switch create . --empty && opam pin add --no-action --kind=path ocaml-variants .
RUN opam install ocaml-variants --assume-built
FROM base AS test-trunk-vanilla
RUN git checkout 1522b9c99159b6b471f10247b4421ec8c9106427 || git fetch origin && git checkout 1522b9c99159b6b471f10247b4421ec8c9106427
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml
RUN make -j
RUN make -j ocamlnat
RUN make install
RUN mv _opam _opam.ref
RUN git checkout ab91155bb820e8498aa8966f86f4145a90468ce1 || git fetch origin && git checkout ab91155bb820e8498aa8966f86f4145a90468ce1
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout d391cc2b8b47cb7aeefd246a28279f22b7555d06 || git fetch origin && git checkout d391cc2b8b47cb7aeefd246a28279f22b7555d06
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout eaf4016417c1a1e23964cbffa7550b5cf893fc3a || git fetch origin && git checkout eaf4016417c1a1e23964cbffa7550b5cf893fc3a
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout eea5af36d6c58b0a095928181efd0959e6db50e9 || git fetch origin && git checkout eea5af36d6c58b0a095928181efd0959e6db50e9
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d; false; fi
RUN make INSTALL_MODE=display install
RUN make INSTALL_MODE=opam OPAM_PACKAGE_NAME=ocaml-variants install
RUN make INSTALL_MODE=clone OPAM_PACKAGE_NAME=ocaml-variants install
RUN test ! -d _opam
RUN opam switch create . --empty && opam pin add --no-action --kind=path ocaml-variants .
RUN opam install ocaml-variants --assume-built
FROM base AS test-trunk-relocatable
RUN git checkout 1522b9c99159b6b471f10247b4421ec8c9106427 || git fetch origin && git checkout 1522b9c99159b6b471f10247b4421ec8c9106427
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --with-relative-libdir=../lib/ocaml --enable-runtime-search=always --enable-runtime-search-target
RUN make -j
RUN make -j ocamlnat
RUN make install
RUN mv _opam _opam.ref
RUN git checkout ab91155bb820e8498aa8966f86f4145a90468ce1 || git fetch origin && git checkout ab91155bb820e8498aa8966f86f4145a90468ce1
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout d391cc2b8b47cb7aeefd246a28279f22b7555d06 || git fetch origin && git checkout d391cc2b8b47cb7aeefd246a28279f22b7555d06
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout eaf4016417c1a1e23964cbffa7550b5cf893fc3a || git fetch origin && git checkout eaf4016417c1a1e23964cbffa7550b5cf893fc3a
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout eea5af36d6c58b0a095928181efd0959e6db50e9 || git fetch origin && git checkout eea5af36d6c58b0a095928181efd0959e6db50e9
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^++ //p" | sort | uniq -d; false; fi
RUN make INSTALL_MODE=display install
RUN make INSTALL_MODE=opam OPAM_PACKAGE_NAME=ocaml-variants install
RUN make INSTALL_MODE=clone OPAM_PACKAGE_NAME=ocaml-variants install
RUN test ! -d _opam
RUN opam switch create . --empty && opam pin add --no-action --kind=path ocaml-variants .
RUN opam install ocaml-variants --assume-built

FROM base AS collect
WORKDIR /home/opam
COPY --from=test-4.08-vanilla /home/opam/ocaml/config.cache cache-4.08-vanilla
COPY --from=test-4.08-relocatable /home/opam/ocaml/config.cache cache-4.08-relocatable
COPY --from=test-4.09-vanilla /home/opam/ocaml/config.cache cache-4.09-vanilla
COPY --from=test-4.09-relocatable /home/opam/ocaml/config.cache cache-4.09-relocatable
COPY --from=test-4.10-vanilla /home/opam/ocaml/config.cache cache-4.10-vanilla
COPY --from=test-4.10-relocatable /home/opam/ocaml/config.cache cache-4.10-relocatable
COPY --from=test-4.11-vanilla /home/opam/ocaml/config.cache cache-4.11-vanilla
COPY --from=test-4.11-relocatable /home/opam/ocaml/config.cache cache-4.11-relocatable
COPY --from=test-4.12-vanilla /home/opam/ocaml/config.cache cache-4.12-vanilla
COPY --from=test-4.12-relocatable /home/opam/ocaml/config.cache cache-4.12-relocatable
COPY --from=test-4.13-vanilla /home/opam/ocaml/config.cache cache-4.13-vanilla
COPY --from=test-4.13-relocatable /home/opam/ocaml/config.cache cache-4.13-relocatable
COPY --from=test-4.14-vanilla /home/opam/ocaml/config.cache cache-4.14-vanilla
COPY --from=test-4.14-relocatable /home/opam/ocaml/config.cache cache-4.14-relocatable
COPY --from=test-5.0-vanilla /home/opam/ocaml/config.cache cache-5.0-vanilla
COPY --from=test-5.0-relocatable /home/opam/ocaml/config.cache cache-5.0-relocatable
COPY --from=test-5.1-vanilla /home/opam/ocaml/config.cache cache-5.1-vanilla
COPY --from=test-5.1-relocatable /home/opam/ocaml/config.cache cache-5.1-relocatable
COPY --from=test-5.2-vanilla /home/opam/ocaml/config.cache cache-5.2-vanilla
COPY --from=test-5.2-relocatable /home/opam/ocaml/config.cache cache-5.2-relocatable
COPY --from=test-5.3-vanilla /home/opam/ocaml/config.cache cache-5.3-vanilla
COPY --from=test-5.3-relocatable /home/opam/ocaml/config.cache cache-5.3-relocatable
COPY --from=test-5.4-vanilla /home/opam/ocaml/config.cache cache-5.4-vanilla
COPY --from=test-5.4-relocatable /home/opam/ocaml/config.cache cache-5.4-relocatable
COPY --from=test-trunk-vanilla /home/opam/ocaml/config.cache cache-trunk-vanilla
COPY --from=test-trunk-relocatable /home/opam/ocaml/config.cache cache-trunk-relocatable
