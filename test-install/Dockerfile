FROM ocaml/opam:ubuntu-24.04-opam AS base

RUN sudo apt-get update && sudo apt-get install -y gawk autoconf2.69
RUN sudo apt-get install -y vim

RUN git clone https://github.com/dra27/ocaml.git
WORKDIR ocaml

FROM base AS test-4.08-vanilla
RUN git checkout cff8977fb336278eaa06ac16e51314f66363aa52
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml
RUN make -j world.opt
RUN make -j ocamlnat
RUN make install
RUN mv _opam _opam.ref
RUN git checkout ec1069c438960c77057114c8f84e1664cec4f7fd
RUN make install && rm -f _opam/lib/ocaml/camlheader_ur && diff -q _opam _opam.ref && rm -rf _opam
FROM base AS test-4.08-relocatable
RUN git checkout cff8977fb336278eaa06ac16e51314f66363aa52
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --with-relative-libdir=../lib/ocaml --enable-runtime-search=always --enable-runtime-search-target
RUN make -j world.opt
RUN make -j ocamlnat
RUN make install
RUN mv _opam _opam.ref
RUN git checkout ec1069c438960c77057114c8f84e1664cec4f7fd
RUN make install && rm -f _opam/lib/ocaml/camlheader_ur && diff -q _opam _opam.ref && rm -rf _opam
FROM base AS test-4.09-vanilla
RUN git checkout 60f04b7493613071c1d0df17481219010bf857d3
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml
RUN make -j world.opt
RUN make -j ocamlnat
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 7a4991cd62750bafdbcdcf27a4402f058441afea
RUN make install && rm -f _opam/lib/ocaml/camlheader_ur && diff -q _opam _opam.ref && rm -rf _opam
FROM base AS test-4.09-relocatable
RUN git checkout 60f04b7493613071c1d0df17481219010bf857d3
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --with-relative-libdir=../lib/ocaml --enable-runtime-search=always --enable-runtime-search-target
RUN make -j world.opt
RUN make -j ocamlnat
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 7a4991cd62750bafdbcdcf27a4402f058441afea
RUN make install && rm -f _opam/lib/ocaml/camlheader_ur && diff -q _opam _opam.ref && rm -rf _opam
FROM base AS test-4.10-vanilla
RUN git checkout e7575a011d2a03c89268498140c092facb2f5361
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml
RUN make -j
RUN make -j ocamlnat
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 655d346d302c4ce628af1669e9cded512a5372fe
RUN make install && rm -f _opam/lib/ocaml/camlheader_ur && diff -q _opam _opam.ref && rm -rf _opam
FROM base AS test-4.10-relocatable
RUN git checkout e7575a011d2a03c89268498140c092facb2f5361
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --with-relative-libdir=../lib/ocaml --enable-runtime-search=always --enable-runtime-search-target
RUN make -j
RUN make -j ocamlnat
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 655d346d302c4ce628af1669e9cded512a5372fe
RUN make install && rm -f _opam/lib/ocaml/camlheader_ur && diff -q _opam _opam.ref && rm -rf _opam
FROM base AS test-4.11-vanilla
RUN git checkout 55043936a678f665897f825d0f7d553ffa37c75b
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml
RUN make -j
RUN make -j ocamlnat
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 6b34155b9e55c43704a40159d8ed4b2dd77356eb
RUN make install && rm -f _opam/lib/ocaml/camlheader_ur && diff -q _opam _opam.ref && rm -rf _opam
FROM base AS test-4.11-relocatable
RUN git checkout 55043936a678f665897f825d0f7d553ffa37c75b
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --with-relative-libdir=../lib/ocaml --enable-runtime-search=always --enable-runtime-search-target
RUN make -j
RUN make -j ocamlnat
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 6b34155b9e55c43704a40159d8ed4b2dd77356eb
RUN make install && rm -f _opam/lib/ocaml/camlheader_ur && diff -q _opam _opam.ref && rm -rf _opam
FROM base AS test-4.12-vanilla
RUN git checkout 866987413a84fb0552109e2971a1cc34d8f84eae
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml
RUN make -j
RUN make -j ocamlnat
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 28e3b94bccff71974ec21fe4c3ce92d46b0f9dc0
RUN make install && rm -f _opam/lib/ocaml/camlheader_ur && diff -q _opam _opam.ref && rm -rf _opam
FROM base AS test-4.12-relocatable
RUN git checkout 866987413a84fb0552109e2971a1cc34d8f84eae
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --with-relative-libdir=../lib/ocaml --enable-runtime-search=always --enable-runtime-search-target
RUN make -j
RUN make -j ocamlnat
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 28e3b94bccff71974ec21fe4c3ce92d46b0f9dc0
RUN make install && rm -f _opam/lib/ocaml/camlheader_ur && diff -q _opam _opam.ref && rm -rf _opam
FROM base AS test-4.13-vanilla
RUN git checkout de4932b6f500251ae891c3b4264a2899f1e7a2f3
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml
RUN make -j
RUN make -j ocamlnat
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 76328157729cb0d2f93f89c728054470f8503c19
RUN make install && rm -f _opam/lib/ocaml/camlheader_ur && diff -q _opam _opam.ref && rm -rf _opam
FROM base AS test-4.13-relocatable
RUN git checkout de4932b6f500251ae891c3b4264a2899f1e7a2f3
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --with-relative-libdir=../lib/ocaml --enable-runtime-search=always --enable-runtime-search-target
RUN make -j
RUN make -j ocamlnat
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 76328157729cb0d2f93f89c728054470f8503c19
RUN make install && rm -f _opam/lib/ocaml/camlheader_ur && diff -q _opam _opam.ref && rm -rf _opam
FROM base AS test-4.14-vanilla
RUN git checkout 32d46126b2b993a7ac526a339c85d528d3a280cd
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --enable-native-toplevel
RUN make -j
RUN make install
RUN mv _opam _opam.ref
RUN git checkout e1794e2548a1e8f6dc11841b0ac9ad159ca89988
RUN make install && rm -f _opam/lib/ocaml/camlheader_ur && diff -q _opam _opam.ref && rm -rf _opam
FROM base AS test-4.14-relocatable
RUN git checkout 32d46126b2b993a7ac526a339c85d528d3a280cd
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --enable-native-toplevel --with-relative-libdir=../lib/ocaml --enable-runtime-search=always --enable-runtime-search-target
RUN make -j
RUN make install
RUN mv _opam _opam.ref
RUN git checkout e1794e2548a1e8f6dc11841b0ac9ad159ca89988
RUN make install && rm -f _opam/lib/ocaml/camlheader_ur && diff -q _opam _opam.ref && rm -rf _opam
FROM base AS test-5.0-vanilla
RUN git checkout 82f92de9deed7aaf8ddd04c3dfd375a14a581b6d
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --enable-native-toplevel
RUN make -j
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 972dcc345df8b5090cbdc4796bacb28af5e13716
RUN make install && rm -f _opam/lib/ocaml/camlheader_ur && diff -q _opam _opam.ref && rm -rf _opam
FROM base AS test-5.0-relocatable
RUN git checkout 82f92de9deed7aaf8ddd04c3dfd375a14a581b6d
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --enable-native-toplevel --with-relative-libdir=../lib/ocaml --enable-runtime-search=always --enable-runtime-search-target
RUN make -j
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 972dcc345df8b5090cbdc4796bacb28af5e13716
RUN make install && rm -f _opam/lib/ocaml/camlheader_ur && diff -q _opam _opam.ref && rm -rf _opam
FROM base AS test-5.1-vanilla
RUN git checkout 1c481272d70947bb40e2d42a4f30b44a6e648cc0
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --enable-native-toplevel
RUN make -j
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 9f4c7ad14b14c937e4d67a6fc6192f3ce6e9950a
RUN make install && rm -f _opam/lib/ocaml/camlheader_ur && diff -q _opam _opam.ref && rm -rf _opam
FROM base AS test-5.1-relocatable
RUN git checkout 1c481272d70947bb40e2d42a4f30b44a6e648cc0
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --enable-native-toplevel --with-relative-libdir=../lib/ocaml --enable-runtime-search=always --enable-runtime-search-target
RUN make -j
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 9f4c7ad14b14c937e4d67a6fc6192f3ce6e9950a
RUN make install && rm -f _opam/lib/ocaml/camlheader_ur && diff -q _opam _opam.ref && rm -rf _opam
FROM base AS test-5.2-vanilla
RUN git checkout c5bff8f0c7b102707125b51affecf4aecfce271a
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --enable-native-toplevel
RUN make -j
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 254e6cecb0cb12d5a02b04283820425510ba7827
RUN make install && rm -f _opam/lib/ocaml/camlheader_ur && diff -q _opam _opam.ref && rm -rf _opam
FROM base AS test-5.2-relocatable
RUN git checkout c5bff8f0c7b102707125b51affecf4aecfce271a
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --enable-native-toplevel --with-relative-libdir=../lib/ocaml --enable-runtime-search=always --enable-runtime-search-target
RUN make -j
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 254e6cecb0cb12d5a02b04283820425510ba7827
RUN make install && rm -f _opam/lib/ocaml/camlheader_ur && diff -q _opam _opam.ref && rm -rf _opam
FROM base AS test-5.3-vanilla
RUN git checkout 489d336937d572ca4736137f7454ebab09254f10
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --enable-native-toplevel
RUN make -j
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 5cf9b0e0b53a4aa102107994e611ee60dab5235c
RUN make install && rm -f _opam/lib/ocaml/camlheader_ur && diff -q _opam _opam.ref && rm -rf _opam
FROM base AS test-5.3-relocatable
RUN git checkout 489d336937d572ca4736137f7454ebab09254f10
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --enable-native-toplevel --with-relative-libdir=../lib/ocaml --enable-runtime-search=always --enable-runtime-search-target
RUN make -j
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 5cf9b0e0b53a4aa102107994e611ee60dab5235c
RUN make install && rm -f _opam/lib/ocaml/camlheader_ur && diff -q _opam _opam.ref && rm -rf _opam
FROM base AS test-5.4-vanilla
RUN git checkout 834f7ff03effb6863f4e469517d78fdb63549fd0
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --enable-native-toplevel
RUN make -j
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 46e658856dff840119e6cbaa6e0329b26ff42c4c
RUN make install && rm -f _opam/lib/ocaml/camlheader_ur && diff -q _opam _opam.ref && rm -rf _opam
FROM base AS test-5.4-relocatable
RUN git checkout 834f7ff03effb6863f4e469517d78fdb63549fd0
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --enable-native-toplevel --with-relative-libdir=../lib/ocaml --enable-runtime-search=always --enable-runtime-search-target
RUN make -j
RUN make install
RUN mv _opam _opam.ref
RUN git checkout 46e658856dff840119e6cbaa6e0329b26ff42c4c
RUN make install && rm -f _opam/lib/ocaml/camlheader_ur && diff -q _opam _opam.ref && rm -rf _opam
FROM base AS test-trunk-vanilla
RUN git checkout 1522b9c99159b6b471f10247b4421ec8c9106427
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml
RUN make -j
RUN make -j ocamlnat
RUN make install
RUN mv _opam _opam.ref
RUN git checkout ab91155bb820e8498aa8966f86f4145a90468ce1
RUN make install && rm -f _opam/lib/ocaml/camlheader_ur && diff -q _opam _opam.ref && rm -rf _opam
FROM base AS test-trunk-relocatable
RUN git checkout 1522b9c99159b6b471f10247b4421ec8c9106427
RUN ./configure -C --prefix $PWD/_opam --docdir $PWD/_opam/doc/ocaml --with-relative-libdir=../lib/ocaml --enable-runtime-search=always --enable-runtime-search-target
RUN make -j
RUN make -j ocamlnat
RUN make install
RUN mv _opam _opam.ref
RUN git checkout ab91155bb820e8498aa8966f86f4145a90468ce1
RUN make install && rm -f _opam/lib/ocaml/camlheader_ur && diff -q _opam _opam.ref && rm -rf _opam

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
