FROM ocaml/opam:ubuntu-24.04-opam AS base

RUN sudo apt-get update && sudo apt-get install -y gawk autoconf2.69
RUN sudo apt-get install -y vim

ENV OPAMYES="1" OCAMLCONFIRMLEVEL="unsafe-yes" OPAMPRECISETRACKING="1"
RUN sudo ln -f /usr/bin/opam-2.3 /usr/bin/opam && opam update

RUN git clone https://github.com/dra27/ocaml.git
WORKDIR ocaml

FROM base AS test-4.08-vanilla
RUN git checkout fe541f3f8f0871a96fecd7dcbe2c12b1acd0b0e2 || git fetch origin && git checkout fe541f3f8f0871a96fecd7dcbe2c12b1acd0b0e2
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml
RUN make -j world.opt
RUN make -j ocamlnat
RUN make install
RUN mv _opam _opam.ref
RUN git checkout bd909001c147a1385056f7829093e22dbe020480 || git fetch origin && git checkout bd909001c147a1385056f7829093e22dbe020480
RUN make install
RUN if ! diff -Nrq _opam _opam.ref; then diff -Nr _opam _opam.ref | grep ^diff ; fi
RUN diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout 03989f39c7a4ceaa1a88bb959058bef0ad37eb92 || git fetch origin && git checkout 03989f39c7a4ceaa1a88bb959058bef0ad37eb92
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout cbb497ca9ff6145f627fe541582cc95b2c60d814 || git fetch origin && git checkout cbb497ca9ff6145f627fe541582cc95b2c60d814
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout bc6dce3e07e5839360f58a8d6eba9dc764a96215 || git fetch origin && git checkout bc6dce3e07e5839360f58a8d6eba9dc764a96215
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d; false; fi
RUN make INSTALL_MODE=display install
RUN make INSTALL_MODE=opam OPAM_PACKAGE_NAME=ocaml-variants install
RUN make INSTALL_MODE=clone OPAM_PACKAGE_NAME=ocaml-variants install
RUN test ! -d _opam
RUN opam switch create . --empty && opam pin add --no-action --kind=path ocaml-variants .
RUN opam install ocaml-variants --assume-built
FROM base AS test-4.08-relocatable
RUN git checkout fe541f3f8f0871a96fecd7dcbe2c12b1acd0b0e2 || git fetch origin && git checkout fe541f3f8f0871a96fecd7dcbe2c12b1acd0b0e2
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --with-relative-libdir=../lib/ocaml --enable-runtime-search=always --enable-runtime-search-target
RUN make -j world.opt
RUN make -j ocamlnat
RUN make install
RUN mv _opam _opam.ref
RUN git checkout bd909001c147a1385056f7829093e22dbe020480 || git fetch origin && git checkout bd909001c147a1385056f7829093e22dbe020480
RUN make install
RUN if ! diff -Nrq _opam _opam.ref; then diff -Nr _opam _opam.ref | grep ^diff ; fi
RUN diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout 03989f39c7a4ceaa1a88bb959058bef0ad37eb92 || git fetch origin && git checkout 03989f39c7a4ceaa1a88bb959058bef0ad37eb92
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout cbb497ca9ff6145f627fe541582cc95b2c60d814 || git fetch origin && git checkout cbb497ca9ff6145f627fe541582cc95b2c60d814
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout bc6dce3e07e5839360f58a8d6eba9dc764a96215 || git fetch origin && git checkout bc6dce3e07e5839360f58a8d6eba9dc764a96215
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d; false; fi
RUN make INSTALL_MODE=display install
RUN make INSTALL_MODE=opam OPAM_PACKAGE_NAME=ocaml-variants install
RUN make INSTALL_MODE=clone OPAM_PACKAGE_NAME=ocaml-variants install
RUN test ! -d _opam
RUN opam switch create . --empty && opam pin add --no-action --kind=path ocaml-variants .
RUN opam install ocaml-variants --assume-built
FROM base AS test-4.09-vanilla
RUN git checkout c02c78ef8e5af427131194399a4ad7499ad5e6e2 || git fetch origin && git checkout c02c78ef8e5af427131194399a4ad7499ad5e6e2
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml
RUN make -j world.opt
RUN make -j ocamlnat
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 5e57d9f31ab20f71aaf82cb1f92b1d414bcc096d || git fetch origin && git checkout 5e57d9f31ab20f71aaf82cb1f92b1d414bcc096d
RUN make install
RUN if ! diff -Nrq _opam _opam.ref; then diff -Nr _opam _opam.ref | grep ^diff ; fi
RUN diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout 7e5bf074f3ea47d6f07aba082593d553c6431827 || git fetch origin && git checkout 7e5bf074f3ea47d6f07aba082593d553c6431827
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout 9f443b960319f9f92dde896b7e06ce1ebbfc9f0e || git fetch origin && git checkout 9f443b960319f9f92dde896b7e06ce1ebbfc9f0e
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout 98f8a5dc0d200ebcdbda385e38c77bae7384d0b0 || git fetch origin && git checkout 98f8a5dc0d200ebcdbda385e38c77bae7384d0b0
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d; false; fi
RUN make INSTALL_MODE=display install
RUN make INSTALL_MODE=opam OPAM_PACKAGE_NAME=ocaml-variants install
RUN make INSTALL_MODE=clone OPAM_PACKAGE_NAME=ocaml-variants install
RUN test ! -d _opam
RUN opam switch create . --empty && opam pin add --no-action --kind=path ocaml-variants .
RUN opam install ocaml-variants --assume-built
FROM base AS test-4.09-relocatable
RUN git checkout c02c78ef8e5af427131194399a4ad7499ad5e6e2 || git fetch origin && git checkout c02c78ef8e5af427131194399a4ad7499ad5e6e2
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --with-relative-libdir=../lib/ocaml --enable-runtime-search=always --enable-runtime-search-target
RUN make -j world.opt
RUN make -j ocamlnat
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 5e57d9f31ab20f71aaf82cb1f92b1d414bcc096d || git fetch origin && git checkout 5e57d9f31ab20f71aaf82cb1f92b1d414bcc096d
RUN make install
RUN if ! diff -Nrq _opam _opam.ref; then diff -Nr _opam _opam.ref | grep ^diff ; fi
RUN diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout 7e5bf074f3ea47d6f07aba082593d553c6431827 || git fetch origin && git checkout 7e5bf074f3ea47d6f07aba082593d553c6431827
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout 9f443b960319f9f92dde896b7e06ce1ebbfc9f0e || git fetch origin && git checkout 9f443b960319f9f92dde896b7e06ce1ebbfc9f0e
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout 98f8a5dc0d200ebcdbda385e38c77bae7384d0b0 || git fetch origin && git checkout 98f8a5dc0d200ebcdbda385e38c77bae7384d0b0
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d; false; fi
RUN make INSTALL_MODE=display install
RUN make INSTALL_MODE=opam OPAM_PACKAGE_NAME=ocaml-variants install
RUN make INSTALL_MODE=clone OPAM_PACKAGE_NAME=ocaml-variants install
RUN test ! -d _opam
RUN opam switch create . --empty && opam pin add --no-action --kind=path ocaml-variants .
RUN opam install ocaml-variants --assume-built
FROM base AS test-4.10-vanilla
RUN git checkout 8e46a39165c5c98ac7fcd31fa6dbc7453720955b || git fetch origin && git checkout 8e46a39165c5c98ac7fcd31fa6dbc7453720955b
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml
RUN make -j
RUN make -j ocamlnat
RUN make install
RUN mv _opam _opam.ref
RUN git checkout b339d472c27b8d6076c8c659471a7b2e2f3b66cd || git fetch origin && git checkout b339d472c27b8d6076c8c659471a7b2e2f3b66cd
RUN make install
RUN if ! diff -Nrq _opam _opam.ref; then diff -Nr _opam _opam.ref | grep ^diff ; fi
RUN diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout ff12a7cb7b08b592bd2eaa8eac55b9a5278fd333 || git fetch origin && git checkout ff12a7cb7b08b592bd2eaa8eac55b9a5278fd333
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout 70356780eb0205b00bc76925f23f588b7bf24b7b || git fetch origin && git checkout 70356780eb0205b00bc76925f23f588b7bf24b7b
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout a6551a7bd00222089622d1912daa04bd3a6940af || git fetch origin && git checkout a6551a7bd00222089622d1912daa04bd3a6940af
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d; false; fi
RUN make INSTALL_MODE=display install
RUN make INSTALL_MODE=opam OPAM_PACKAGE_NAME=ocaml-variants install
RUN make INSTALL_MODE=clone OPAM_PACKAGE_NAME=ocaml-variants install
RUN test ! -d _opam
RUN opam switch create . --empty && opam pin add --no-action --kind=path ocaml-variants .
RUN opam install ocaml-variants --assume-built
FROM base AS test-4.10-relocatable
RUN git checkout 8e46a39165c5c98ac7fcd31fa6dbc7453720955b || git fetch origin && git checkout 8e46a39165c5c98ac7fcd31fa6dbc7453720955b
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --with-relative-libdir=../lib/ocaml --enable-runtime-search=always --enable-runtime-search-target
RUN make -j
RUN make -j ocamlnat
RUN make install
RUN mv _opam _opam.ref
RUN git checkout b339d472c27b8d6076c8c659471a7b2e2f3b66cd || git fetch origin && git checkout b339d472c27b8d6076c8c659471a7b2e2f3b66cd
RUN make install
RUN if ! diff -Nrq _opam _opam.ref; then diff -Nr _opam _opam.ref | grep ^diff ; fi
RUN diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout ff12a7cb7b08b592bd2eaa8eac55b9a5278fd333 || git fetch origin && git checkout ff12a7cb7b08b592bd2eaa8eac55b9a5278fd333
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout 70356780eb0205b00bc76925f23f588b7bf24b7b || git fetch origin && git checkout 70356780eb0205b00bc76925f23f588b7bf24b7b
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout a6551a7bd00222089622d1912daa04bd3a6940af || git fetch origin && git checkout a6551a7bd00222089622d1912daa04bd3a6940af
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d; false; fi
RUN make INSTALL_MODE=display install
RUN make INSTALL_MODE=opam OPAM_PACKAGE_NAME=ocaml-variants install
RUN make INSTALL_MODE=clone OPAM_PACKAGE_NAME=ocaml-variants install
RUN test ! -d _opam
RUN opam switch create . --empty && opam pin add --no-action --kind=path ocaml-variants .
RUN opam install ocaml-variants --assume-built
FROM base AS test-4.11-vanilla
RUN git checkout 0ed180590af537af90b3f419b9df1b88521b5ec9 || git fetch origin && git checkout 0ed180590af537af90b3f419b9df1b88521b5ec9
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml
RUN make -j
RUN make -j ocamlnat
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 10cfbf857aefc70e505b37e6b36c13cc32c9f478 || git fetch origin && git checkout 10cfbf857aefc70e505b37e6b36c13cc32c9f478
RUN make install
RUN if ! diff -Nrq _opam _opam.ref; then diff -Nr _opam _opam.ref | grep ^diff ; fi
RUN diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout 18b721cd503f7d25c6d99c732a50c338babe4a9e || git fetch origin && git checkout 18b721cd503f7d25c6d99c732a50c338babe4a9e
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout 42887e3a294569fccd5e2288f0da70537870caa6 || git fetch origin && git checkout 42887e3a294569fccd5e2288f0da70537870caa6
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout 19bae3a75e230a2db7b80aa633f894e224f17422 || git fetch origin && git checkout 19bae3a75e230a2db7b80aa633f894e224f17422
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d; false; fi
RUN make INSTALL_MODE=display install
RUN make INSTALL_MODE=opam OPAM_PACKAGE_NAME=ocaml-variants install
RUN make INSTALL_MODE=clone OPAM_PACKAGE_NAME=ocaml-variants install
RUN test ! -d _opam
RUN opam switch create . --empty && opam pin add --no-action --kind=path ocaml-variants .
RUN opam install ocaml-variants --assume-built
FROM base AS test-4.11-relocatable
RUN git checkout 0ed180590af537af90b3f419b9df1b88521b5ec9 || git fetch origin && git checkout 0ed180590af537af90b3f419b9df1b88521b5ec9
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --with-relative-libdir=../lib/ocaml --enable-runtime-search=always --enable-runtime-search-target
RUN make -j
RUN make -j ocamlnat
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 10cfbf857aefc70e505b37e6b36c13cc32c9f478 || git fetch origin && git checkout 10cfbf857aefc70e505b37e6b36c13cc32c9f478
RUN make install
RUN if ! diff -Nrq _opam _opam.ref; then diff -Nr _opam _opam.ref | grep ^diff ; fi
RUN diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout 18b721cd503f7d25c6d99c732a50c338babe4a9e || git fetch origin && git checkout 18b721cd503f7d25c6d99c732a50c338babe4a9e
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout 42887e3a294569fccd5e2288f0da70537870caa6 || git fetch origin && git checkout 42887e3a294569fccd5e2288f0da70537870caa6
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout 19bae3a75e230a2db7b80aa633f894e224f17422 || git fetch origin && git checkout 19bae3a75e230a2db7b80aa633f894e224f17422
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d; false; fi
RUN make INSTALL_MODE=display install
RUN make INSTALL_MODE=opam OPAM_PACKAGE_NAME=ocaml-variants install
RUN make INSTALL_MODE=clone OPAM_PACKAGE_NAME=ocaml-variants install
RUN test ! -d _opam
RUN opam switch create . --empty && opam pin add --no-action --kind=path ocaml-variants .
RUN opam install ocaml-variants --assume-built
FROM base AS test-4.12-vanilla
RUN git checkout 4db18e21d8c3ede8c4311025ebc541dc70f8daad || git fetch origin && git checkout 4db18e21d8c3ede8c4311025ebc541dc70f8daad
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml
RUN make -j
RUN make -j ocamlnat
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 52b967cbf665f6b8c488e31ab6b64fd05fc8fc79 || git fetch origin && git checkout 52b967cbf665f6b8c488e31ab6b64fd05fc8fc79
RUN make install
RUN if ! diff -Nrq _opam _opam.ref; then diff -Nr _opam _opam.ref | grep ^diff ; fi
RUN diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout 57afb7345a4ab23fefb66d2774eff32323c7cc5e || git fetch origin && git checkout 57afb7345a4ab23fefb66d2774eff32323c7cc5e
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout 13021285a8f2ef98e5c1a0cc435298d2914f0e99 || git fetch origin && git checkout 13021285a8f2ef98e5c1a0cc435298d2914f0e99
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout ee12da3e78b77455b7a72a58a10f18bdafc575b3 || git fetch origin && git checkout ee12da3e78b77455b7a72a58a10f18bdafc575b3
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d; false; fi
RUN make INSTALL_MODE=display install
RUN make INSTALL_MODE=opam OPAM_PACKAGE_NAME=ocaml-variants install
RUN make INSTALL_MODE=clone OPAM_PACKAGE_NAME=ocaml-variants install
RUN test ! -d _opam
RUN opam switch create . --empty && opam pin add --no-action --kind=path ocaml-variants .
RUN opam install ocaml-variants --assume-built
FROM base AS test-4.12-relocatable
RUN git checkout 4db18e21d8c3ede8c4311025ebc541dc70f8daad || git fetch origin && git checkout 4db18e21d8c3ede8c4311025ebc541dc70f8daad
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --with-relative-libdir=../lib/ocaml --enable-runtime-search=always --enable-runtime-search-target
RUN make -j
RUN make -j ocamlnat
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 52b967cbf665f6b8c488e31ab6b64fd05fc8fc79 || git fetch origin && git checkout 52b967cbf665f6b8c488e31ab6b64fd05fc8fc79
RUN make install
RUN if ! diff -Nrq _opam _opam.ref; then diff -Nr _opam _opam.ref | grep ^diff ; fi
RUN diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout 57afb7345a4ab23fefb66d2774eff32323c7cc5e || git fetch origin && git checkout 57afb7345a4ab23fefb66d2774eff32323c7cc5e
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout 13021285a8f2ef98e5c1a0cc435298d2914f0e99 || git fetch origin && git checkout 13021285a8f2ef98e5c1a0cc435298d2914f0e99
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout ee12da3e78b77455b7a72a58a10f18bdafc575b3 || git fetch origin && git checkout ee12da3e78b77455b7a72a58a10f18bdafc575b3
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d; false; fi
RUN make INSTALL_MODE=display install
RUN make INSTALL_MODE=opam OPAM_PACKAGE_NAME=ocaml-variants install
RUN make INSTALL_MODE=clone OPAM_PACKAGE_NAME=ocaml-variants install
RUN test ! -d _opam
RUN opam switch create . --empty && opam pin add --no-action --kind=path ocaml-variants .
RUN opam install ocaml-variants --assume-built
FROM base AS test-4.13-vanilla
RUN git checkout c8024d9caccd19b239ddd16d19465b5b93da4487 || git fetch origin && git checkout c8024d9caccd19b239ddd16d19465b5b93da4487
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml
RUN make -j
RUN make -j ocamlnat
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 19bdd126b8ff4a90931dae749752f4b3ee642aac || git fetch origin && git checkout 19bdd126b8ff4a90931dae749752f4b3ee642aac
RUN make install
RUN if ! diff -Nrq _opam _opam.ref; then diff -Nr _opam _opam.ref | grep ^diff ; fi
RUN diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout 25416d700c3bbb5e0779285cd1880518b0fe9706 || git fetch origin && git checkout 25416d700c3bbb5e0779285cd1880518b0fe9706
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout 5f876b79797bfb60b0983632339087e0fc94fe43 || git fetch origin && git checkout 5f876b79797bfb60b0983632339087e0fc94fe43
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout 5ea0af49dfc4a7709961379efe481f3a910302f3 || git fetch origin && git checkout 5ea0af49dfc4a7709961379efe481f3a910302f3
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d; false; fi
RUN make INSTALL_MODE=display install
RUN make INSTALL_MODE=opam OPAM_PACKAGE_NAME=ocaml-variants install
RUN make INSTALL_MODE=clone OPAM_PACKAGE_NAME=ocaml-variants install
RUN test ! -d _opam
RUN opam switch create . --empty && opam pin add --no-action --kind=path ocaml-variants .
RUN opam install ocaml-variants --assume-built
FROM base AS test-4.13-relocatable
RUN git checkout c8024d9caccd19b239ddd16d19465b5b93da4487 || git fetch origin && git checkout c8024d9caccd19b239ddd16d19465b5b93da4487
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --with-relative-libdir=../lib/ocaml --enable-runtime-search=always --enable-runtime-search-target
RUN make -j
RUN make -j ocamlnat
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 19bdd126b8ff4a90931dae749752f4b3ee642aac || git fetch origin && git checkout 19bdd126b8ff4a90931dae749752f4b3ee642aac
RUN make install
RUN if ! diff -Nrq _opam _opam.ref; then diff -Nr _opam _opam.ref | grep ^diff ; fi
RUN diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout 25416d700c3bbb5e0779285cd1880518b0fe9706 || git fetch origin && git checkout 25416d700c3bbb5e0779285cd1880518b0fe9706
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout 5f876b79797bfb60b0983632339087e0fc94fe43 || git fetch origin && git checkout 5f876b79797bfb60b0983632339087e0fc94fe43
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout 5ea0af49dfc4a7709961379efe481f3a910302f3 || git fetch origin && git checkout 5ea0af49dfc4a7709961379efe481f3a910302f3
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d; false; fi
RUN make INSTALL_MODE=display install
RUN make INSTALL_MODE=opam OPAM_PACKAGE_NAME=ocaml-variants install
RUN make INSTALL_MODE=clone OPAM_PACKAGE_NAME=ocaml-variants install
RUN test ! -d _opam
RUN opam switch create . --empty && opam pin add --no-action --kind=path ocaml-variants .
RUN opam install ocaml-variants --assume-built
FROM base AS test-4.14-vanilla
RUN git checkout 08e0bacc8c7efb35797234ba0d1a6ad309e2a5e0 || git fetch origin && git checkout 08e0bacc8c7efb35797234ba0d1a6ad309e2a5e0
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --enable-native-toplevel
RUN make -j
RUN make install
RUN mv _opam _opam.ref
RUN git checkout d86b1666cca7237b9c6eaeb9340cab2afe64dd11 || git fetch origin && git checkout d86b1666cca7237b9c6eaeb9340cab2afe64dd11
RUN make install
RUN if ! diff -Nrq _opam _opam.ref; then diff -Nr _opam _opam.ref | grep ^diff ; fi
RUN diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout c1eab473cb2384ee8668634936908dc2908ef1d6 || git fetch origin && git checkout c1eab473cb2384ee8668634936908dc2908ef1d6
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout e904df298760e89200408b0207af69b72936d6aa || git fetch origin && git checkout e904df298760e89200408b0207af69b72936d6aa
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout b273e7bc952a13e48b1ba5643cffcb29208aaba2 || git fetch origin && git checkout b273e7bc952a13e48b1ba5643cffcb29208aaba2
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d; false; fi
RUN make INSTALL_MODE=display install
RUN make INSTALL_MODE=opam OPAM_PACKAGE_NAME=ocaml-variants install
RUN make INSTALL_MODE=clone OPAM_PACKAGE_NAME=ocaml-variants install
RUN test ! -d _opam
RUN opam switch create . --empty && opam pin add --no-action --kind=path ocaml-variants .
RUN opam install ocaml-variants --assume-built
FROM base AS test-4.14-relocatable
RUN git checkout 08e0bacc8c7efb35797234ba0d1a6ad309e2a5e0 || git fetch origin && git checkout 08e0bacc8c7efb35797234ba0d1a6ad309e2a5e0
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --enable-native-toplevel --with-relative-libdir=../lib/ocaml --enable-runtime-search=always --enable-runtime-search-target
RUN make -j
RUN make install
RUN mv _opam _opam.ref
RUN git checkout d86b1666cca7237b9c6eaeb9340cab2afe64dd11 || git fetch origin && git checkout d86b1666cca7237b9c6eaeb9340cab2afe64dd11
RUN make install
RUN if ! diff -Nrq _opam _opam.ref; then diff -Nr _opam _opam.ref | grep ^diff ; fi
RUN diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout c1eab473cb2384ee8668634936908dc2908ef1d6 || git fetch origin && git checkout c1eab473cb2384ee8668634936908dc2908ef1d6
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout e904df298760e89200408b0207af69b72936d6aa || git fetch origin && git checkout e904df298760e89200408b0207af69b72936d6aa
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout b273e7bc952a13e48b1ba5643cffcb29208aaba2 || git fetch origin && git checkout b273e7bc952a13e48b1ba5643cffcb29208aaba2
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d; false; fi
RUN make INSTALL_MODE=display install
RUN make INSTALL_MODE=opam OPAM_PACKAGE_NAME=ocaml-variants install
RUN make INSTALL_MODE=clone OPAM_PACKAGE_NAME=ocaml-variants install
RUN test ! -d _opam
RUN opam switch create . --empty && opam pin add --no-action --kind=path ocaml-variants .
RUN opam install ocaml-variants --assume-built
FROM base AS test-5.0-vanilla
RUN git checkout 6eac835753047f22e5f67e0a889bf9ce56c6e551 || git fetch origin && git checkout 6eac835753047f22e5f67e0a889bf9ce56c6e551
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --enable-native-toplevel
RUN make -j
RUN make install
RUN mv _opam _opam.ref
RUN git checkout a5e0f318dd8c10e369837c567959802903fea9de || git fetch origin && git checkout a5e0f318dd8c10e369837c567959802903fea9de
RUN make install
RUN if ! diff -Nrq _opam _opam.ref; then diff -Nr _opam _opam.ref | grep ^diff ; fi
RUN diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout aed5720b542993a90a61e77af5139c8771e1a8f8 || git fetch origin && git checkout aed5720b542993a90a61e77af5139c8771e1a8f8
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout bf19ffd83d43442bd52a6f050a4686f110623d96 || git fetch origin && git checkout bf19ffd83d43442bd52a6f050a4686f110623d96
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout eb1b1c26ce983ad119d7d0fc2d0c5ef9ddc9eaaf || git fetch origin && git checkout eb1b1c26ce983ad119d7d0fc2d0c5ef9ddc9eaaf
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d; false; fi
RUN make INSTALL_MODE=display install
RUN make INSTALL_MODE=opam OPAM_PACKAGE_NAME=ocaml-variants install
RUN make INSTALL_MODE=clone OPAM_PACKAGE_NAME=ocaml-variants install
RUN test ! -d _opam
RUN opam switch create . --empty && opam pin add --no-action --kind=path ocaml-variants .
RUN opam install ocaml-variants --assume-built
FROM base AS test-5.0-relocatable
RUN git checkout 6eac835753047f22e5f67e0a889bf9ce56c6e551 || git fetch origin && git checkout 6eac835753047f22e5f67e0a889bf9ce56c6e551
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --enable-native-toplevel --with-relative-libdir=../lib/ocaml --enable-runtime-search=always --enable-runtime-search-target
RUN make -j
RUN make install
RUN mv _opam _opam.ref
RUN git checkout a5e0f318dd8c10e369837c567959802903fea9de || git fetch origin && git checkout a5e0f318dd8c10e369837c567959802903fea9de
RUN make install
RUN if ! diff -Nrq _opam _opam.ref; then diff -Nr _opam _opam.ref | grep ^diff ; fi
RUN diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout aed5720b542993a90a61e77af5139c8771e1a8f8 || git fetch origin && git checkout aed5720b542993a90a61e77af5139c8771e1a8f8
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout bf19ffd83d43442bd52a6f050a4686f110623d96 || git fetch origin && git checkout bf19ffd83d43442bd52a6f050a4686f110623d96
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout eb1b1c26ce983ad119d7d0fc2d0c5ef9ddc9eaaf || git fetch origin && git checkout eb1b1c26ce983ad119d7d0fc2d0c5ef9ddc9eaaf
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d; false; fi
RUN make INSTALL_MODE=display install
RUN make INSTALL_MODE=opam OPAM_PACKAGE_NAME=ocaml-variants install
RUN make INSTALL_MODE=clone OPAM_PACKAGE_NAME=ocaml-variants install
RUN test ! -d _opam
RUN opam switch create . --empty && opam pin add --no-action --kind=path ocaml-variants .
RUN opam install ocaml-variants --assume-built
FROM base AS test-5.1-vanilla
RUN git checkout 22daa2d8c2ee3ed168e288bcb3351d2c517f7a0f || git fetch origin && git checkout 22daa2d8c2ee3ed168e288bcb3351d2c517f7a0f
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --enable-native-toplevel
RUN make -j
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 11b8a7ae7ea79a73358e241dd7e6a0d79dc655b0 || git fetch origin && git checkout 11b8a7ae7ea79a73358e241dd7e6a0d79dc655b0
RUN make install
RUN if ! diff -Nrq _opam _opam.ref; then diff -Nr _opam _opam.ref | grep ^diff ; fi
RUN diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout f2ed45c2d623184ef1f42bca0c1cba18557b1af5 || git fetch origin && git checkout f2ed45c2d623184ef1f42bca0c1cba18557b1af5
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout eac6c9c7bf21c1d1c0141e98d0df1a09de10eecc || git fetch origin && git checkout eac6c9c7bf21c1d1c0141e98d0df1a09de10eecc
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout b0030e447cf05876924c39d53fbbde6b5180469a || git fetch origin && git checkout b0030e447cf05876924c39d53fbbde6b5180469a
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d; false; fi
RUN make INSTALL_MODE=display install
RUN make INSTALL_MODE=opam OPAM_PACKAGE_NAME=ocaml-variants install
RUN make INSTALL_MODE=clone OPAM_PACKAGE_NAME=ocaml-variants install
RUN test ! -d _opam
RUN opam switch create . --empty && opam pin add --no-action --kind=path ocaml-variants .
RUN opam install ocaml-variants --assume-built
FROM base AS test-5.1-relocatable
RUN git checkout 22daa2d8c2ee3ed168e288bcb3351d2c517f7a0f || git fetch origin && git checkout 22daa2d8c2ee3ed168e288bcb3351d2c517f7a0f
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --enable-native-toplevel --with-relative-libdir=../lib/ocaml --enable-runtime-search=always --enable-runtime-search-target
RUN make -j
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 11b8a7ae7ea79a73358e241dd7e6a0d79dc655b0 || git fetch origin && git checkout 11b8a7ae7ea79a73358e241dd7e6a0d79dc655b0
RUN make install
RUN if ! diff -Nrq _opam _opam.ref; then diff -Nr _opam _opam.ref | grep ^diff ; fi
RUN diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout f2ed45c2d623184ef1f42bca0c1cba18557b1af5 || git fetch origin && git checkout f2ed45c2d623184ef1f42bca0c1cba18557b1af5
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout eac6c9c7bf21c1d1c0141e98d0df1a09de10eecc || git fetch origin && git checkout eac6c9c7bf21c1d1c0141e98d0df1a09de10eecc
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout b0030e447cf05876924c39d53fbbde6b5180469a || git fetch origin && git checkout b0030e447cf05876924c39d53fbbde6b5180469a
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d; false; fi
RUN make INSTALL_MODE=display install
RUN make INSTALL_MODE=opam OPAM_PACKAGE_NAME=ocaml-variants install
RUN make INSTALL_MODE=clone OPAM_PACKAGE_NAME=ocaml-variants install
RUN test ! -d _opam
RUN opam switch create . --empty && opam pin add --no-action --kind=path ocaml-variants .
RUN opam install ocaml-variants --assume-built
FROM base AS test-5.2-vanilla
RUN git checkout 04de28301181cf00e582c5b8b6877b7d38e0bde8 || git fetch origin && git checkout 04de28301181cf00e582c5b8b6877b7d38e0bde8
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --enable-native-toplevel
RUN make -j
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 472843e5195b0da01b5af32517aa2206f33e3790 || git fetch origin && git checkout 472843e5195b0da01b5af32517aa2206f33e3790
RUN make install
RUN if ! diff -Nrq _opam _opam.ref; then diff -Nr _opam _opam.ref | grep ^diff ; fi
RUN diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout efa8c8511139572694d5d1a149ee8474613c2895 || git fetch origin && git checkout efa8c8511139572694d5d1a149ee8474613c2895
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout 931e829ba3f5e2423e68639298283c13ca971969 || git fetch origin && git checkout 931e829ba3f5e2423e68639298283c13ca971969
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout a910857b6aa2c318cd0627bff545ced82a3ee397 || git fetch origin && git checkout a910857b6aa2c318cd0627bff545ced82a3ee397
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d; false; fi
RUN make INSTALL_MODE=display install
RUN make INSTALL_MODE=opam OPAM_PACKAGE_NAME=ocaml-variants install
RUN make INSTALL_MODE=clone OPAM_PACKAGE_NAME=ocaml-variants install
RUN test ! -d _opam
RUN opam switch create . --empty && opam pin add --no-action --kind=path ocaml-variants .
RUN opam install ocaml-variants --assume-built
FROM base AS test-5.2-relocatable
RUN git checkout 04de28301181cf00e582c5b8b6877b7d38e0bde8 || git fetch origin && git checkout 04de28301181cf00e582c5b8b6877b7d38e0bde8
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --enable-native-toplevel --with-relative-libdir=../lib/ocaml --enable-runtime-search=always --enable-runtime-search-target
RUN make -j
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 472843e5195b0da01b5af32517aa2206f33e3790 || git fetch origin && git checkout 472843e5195b0da01b5af32517aa2206f33e3790
RUN make install
RUN if ! diff -Nrq _opam _opam.ref; then diff -Nr _opam _opam.ref | grep ^diff ; fi
RUN diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout efa8c8511139572694d5d1a149ee8474613c2895 || git fetch origin && git checkout efa8c8511139572694d5d1a149ee8474613c2895
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout 931e829ba3f5e2423e68639298283c13ca971969 || git fetch origin && git checkout 931e829ba3f5e2423e68639298283c13ca971969
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout a910857b6aa2c318cd0627bff545ced82a3ee397 || git fetch origin && git checkout a910857b6aa2c318cd0627bff545ced82a3ee397
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d; false; fi
RUN make INSTALL_MODE=display install
RUN make INSTALL_MODE=opam OPAM_PACKAGE_NAME=ocaml-variants install
RUN make INSTALL_MODE=clone OPAM_PACKAGE_NAME=ocaml-variants install
RUN test ! -d _opam
RUN opam switch create . --empty && opam pin add --no-action --kind=path ocaml-variants .
RUN opam install ocaml-variants --assume-built
FROM base AS test-5.3-vanilla
RUN git checkout 4d2a567db0b5967a2c916ea53d7c0b5067098b5c || git fetch origin && git checkout 4d2a567db0b5967a2c916ea53d7c0b5067098b5c
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --enable-native-toplevel
RUN make -j
RUN make install
RUN mv _opam _opam.ref
RUN git checkout fd8558a4d224a859edc23304bd1731a2ea62cc83 || git fetch origin && git checkout fd8558a4d224a859edc23304bd1731a2ea62cc83
RUN make install
RUN if ! diff -Nrq _opam _opam.ref; then diff -Nr _opam _opam.ref | grep ^diff ; fi
RUN diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout 48ba38b209bb2abcedb76f52d4232f7709745754 || git fetch origin && git checkout 48ba38b209bb2abcedb76f52d4232f7709745754
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout b249fb2d8787312a78302136638ccd41bc4466d0 || git fetch origin && git checkout b249fb2d8787312a78302136638ccd41bc4466d0
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout 5e0add95bc239e278c89ee52b2128d1dd5ede93d || git fetch origin && git checkout 5e0add95bc239e278c89ee52b2128d1dd5ede93d
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d; false; fi
RUN make INSTALL_MODE=display install
RUN make INSTALL_MODE=opam OPAM_PACKAGE_NAME=ocaml-variants install
RUN make INSTALL_MODE=clone OPAM_PACKAGE_NAME=ocaml-variants install
RUN test ! -d _opam
RUN opam switch create . --empty && opam pin add --no-action --kind=path ocaml-variants .
RUN opam install ocaml-variants --assume-built
FROM base AS test-5.3-relocatable
RUN git checkout 4d2a567db0b5967a2c916ea53d7c0b5067098b5c || git fetch origin && git checkout 4d2a567db0b5967a2c916ea53d7c0b5067098b5c
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --enable-native-toplevel --with-relative-libdir=../lib/ocaml --enable-runtime-search=always --enable-runtime-search-target
RUN make -j
RUN make install
RUN mv _opam _opam.ref
RUN git checkout fd8558a4d224a859edc23304bd1731a2ea62cc83 || git fetch origin && git checkout fd8558a4d224a859edc23304bd1731a2ea62cc83
RUN make install
RUN if ! diff -Nrq _opam _opam.ref; then diff -Nr _opam _opam.ref | grep ^diff ; fi
RUN diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout 48ba38b209bb2abcedb76f52d4232f7709745754 || git fetch origin && git checkout 48ba38b209bb2abcedb76f52d4232f7709745754
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout b249fb2d8787312a78302136638ccd41bc4466d0 || git fetch origin && git checkout b249fb2d8787312a78302136638ccd41bc4466d0
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout 5e0add95bc239e278c89ee52b2128d1dd5ede93d || git fetch origin && git checkout 5e0add95bc239e278c89ee52b2128d1dd5ede93d
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d; false; fi
RUN make INSTALL_MODE=display install
RUN make INSTALL_MODE=opam OPAM_PACKAGE_NAME=ocaml-variants install
RUN make INSTALL_MODE=clone OPAM_PACKAGE_NAME=ocaml-variants install
RUN test ! -d _opam
RUN opam switch create . --empty && opam pin add --no-action --kind=path ocaml-variants .
RUN opam install ocaml-variants --assume-built
FROM base AS test-5.4-vanilla
RUN git checkout ddeede8d5ee5c3c8ae627fcc33ca2db94fe79c82 || git fetch origin && git checkout ddeede8d5ee5c3c8ae627fcc33ca2db94fe79c82
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --enable-native-toplevel
RUN make -j
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 1c85986dbcbd22b13ef5a81c3cad172f1d6a8572 || git fetch origin && git checkout 1c85986dbcbd22b13ef5a81c3cad172f1d6a8572
RUN make install
RUN if ! diff -Nrq _opam _opam.ref; then diff -Nr _opam _opam.ref | grep ^diff ; fi
RUN diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout 893f4fc4f7523d140b77d137ddcc71906cc44b20 || git fetch origin && git checkout 893f4fc4f7523d140b77d137ddcc71906cc44b20
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout b4493e1950f04108be61424ec51a62f13b9c7664 || git fetch origin && git checkout b4493e1950f04108be61424ec51a62f13b9c7664
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout 15c4f0bf371dbe0032c00598db1b80de6cd7ae30 || git fetch origin && git checkout 15c4f0bf371dbe0032c00598db1b80de6cd7ae30
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d; false; fi
RUN make INSTALL_MODE=display install
RUN make INSTALL_MODE=opam OPAM_PACKAGE_NAME=ocaml-variants install
RUN make INSTALL_MODE=clone OPAM_PACKAGE_NAME=ocaml-variants install
RUN test ! -d _opam
RUN opam switch create . --empty && opam pin add --no-action --kind=path ocaml-variants .
RUN opam install ocaml-variants --assume-built
FROM base AS test-5.4-relocatable
RUN git checkout ddeede8d5ee5c3c8ae627fcc33ca2db94fe79c82 || git fetch origin && git checkout ddeede8d5ee5c3c8ae627fcc33ca2db94fe79c82
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --enable-native-toplevel --with-relative-libdir=../lib/ocaml --enable-runtime-search=always --enable-runtime-search-target
RUN make -j
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 1c85986dbcbd22b13ef5a81c3cad172f1d6a8572 || git fetch origin && git checkout 1c85986dbcbd22b13ef5a81c3cad172f1d6a8572
RUN make install
RUN if ! diff -Nrq _opam _opam.ref; then diff -Nr _opam _opam.ref | grep ^diff ; fi
RUN diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout 893f4fc4f7523d140b77d137ddcc71906cc44b20 || git fetch origin && git checkout 893f4fc4f7523d140b77d137ddcc71906cc44b20
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout b4493e1950f04108be61424ec51a62f13b9c7664 || git fetch origin && git checkout b4493e1950f04108be61424ec51a62f13b9c7664
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout 15c4f0bf371dbe0032c00598db1b80de6cd7ae30 || git fetch origin && git checkout 15c4f0bf371dbe0032c00598db1b80de6cd7ae30
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d; false; fi
RUN make INSTALL_MODE=display install
RUN make INSTALL_MODE=opam OPAM_PACKAGE_NAME=ocaml-variants install
RUN make INSTALL_MODE=clone OPAM_PACKAGE_NAME=ocaml-variants install
RUN test ! -d _opam
RUN opam switch create . --empty && opam pin add --no-action --kind=path ocaml-variants .
RUN opam install ocaml-variants --assume-built
FROM base AS test-trunk-vanilla
RUN git checkout 9ece65ae25e6eabe42bd46210de3a87c5a488442 || git fetch origin && git checkout 9ece65ae25e6eabe42bd46210de3a87c5a488442
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml
RUN make -j
RUN make -j ocamlnat
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 9bf5cdbb4d5d4d63e123be10b8873165490e27a0 || git fetch origin && git checkout 9bf5cdbb4d5d4d63e123be10b8873165490e27a0
RUN make install
RUN if ! diff -Nrq _opam _opam.ref; then diff -Nr _opam _opam.ref | grep ^diff ; fi
RUN diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout 2a9dc24d7a0a41dc3a289dfbab1c86b3030ba2dd || git fetch origin && git checkout 2a9dc24d7a0a41dc3a289dfbab1c86b3030ba2dd
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout c825ce6d5b357f43ca087c05f6c5e8f959fabd60 || git fetch origin && git checkout c825ce6d5b357f43ca087c05f6c5e8f959fabd60
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout 675ed295f662f94cec3cffda6af753c2cae8caef || git fetch origin && git checkout 675ed295f662f94cec3cffda6af753c2cae8caef
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d; false; fi
RUN make INSTALL_MODE=display install
RUN make INSTALL_MODE=opam OPAM_PACKAGE_NAME=ocaml-variants install
RUN make INSTALL_MODE=clone OPAM_PACKAGE_NAME=ocaml-variants install
RUN test ! -d _opam
RUN opam switch create . --empty && opam pin add --no-action --kind=path ocaml-variants .
RUN opam install ocaml-variants --assume-built
FROM base AS test-trunk-relocatable
RUN git checkout 9ece65ae25e6eabe42bd46210de3a87c5a488442 || git fetch origin && git checkout 9ece65ae25e6eabe42bd46210de3a87c5a488442
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --with-relative-libdir=../lib/ocaml --enable-runtime-search=always --enable-runtime-search-target
RUN make -j
RUN make -j ocamlnat
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 9bf5cdbb4d5d4d63e123be10b8873165490e27a0 || git fetch origin && git checkout 9bf5cdbb4d5d4d63e123be10b8873165490e27a0
RUN make install
RUN if ! diff -Nrq _opam _opam.ref; then diff -Nr _opam _opam.ref | grep ^diff ; fi
RUN diff -Nrq _opam _opam.ref && rm -rf _opam
RUN git checkout 2a9dc24d7a0a41dc3a289dfbab1c86b3030ba2dd || git fetch origin && git checkout 2a9dc24d7a0a41dc3a289dfbab1c86b3030ba2dd
RUN if grep '(\(COMPLIBDIR\|INSTALL_\(COMPLIBDIR\|INCDIR\|LIBRARIES_MAN_DIR\|PROGRAMS_MAN_DIR\|THREADSLIBDIR\|STDLIB_META_DIR\)\))' * -rI; then false; fi
RUN if test -n "$(grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -Fvx 'otherlibs/Makefile.otherlibs.common:INSTALL_LIBDIR_LIBNAME = $(INSTALL_LIBDIR)/$(LIBNAME)' | grep -v '^Makefile.common:')"; then grep 'INSTALL_LIBDIR_[A-Za-z_]* *:\?=' * -rI | grep -v '^Makefile.common:'; false; fi
RUN git checkout c825ce6d5b357f43ca087c05f6c5e8f959fabd60 || git fetch origin && git checkout c825ce6d5b357f43ca087c05f6c5e8f959fabd60
RUN if grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; then grep '^ROOTDIR *=' * -rIl | grep -v '^\(manual\|testsuite\)' | xargs grep -L SUBDIR_NAME | grep -vx 'Makefile\.tools\|api_docgen/Makefile\.common\|\(yacc\|ocamltest\|utils\|lex\|otherlibs/unix\)/Makefile'; false; fi
RUN git checkout 675ed295f662f94cec3cffda6af753c2cae8caef || git fetch origin && git checkout 675ed295f662f94cec3cffda6af753c2cae8caef
RUN if grep 'INSTALL_\(DATA\|PROG\)' * -rI | grep -v '^\(Makefile\.common\|configure\|Makefile\.build_config\(\.in\)\?\|config\.\(status\|log\)\):\|^autom4te\.cache\|^[^:]*:#'; then false; fi
RUN make install && diff -Nrq _opam _opam.ref && rm -rf _opam
RUN if test -n "$(make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d)"; then make INSTALL_MODE=list install | sed -ne "s/^-> //p" | sort | uniq -d; false; fi
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
