#**************************************************************************
#*                                                                        *
#*                                 OCaml                                  *
#*                                                                        *
#*            Xavier Leroy, projet Cristal, INRIA Rocquencourt            *
#*                                                                        *
#*   Copyright 1999 Institut National de Recherche en Informatique et     *
#*     en Automatique.                                                    *
#*                                                                        *
#*   All rights reserved.  This file is distributed under the terms of    *
#*   the GNU Lesser General Public License version 2.1, with the          *
#*   special exception on linking described in the file LICENSE.          *
#*                                                                        *
#**************************************************************************

ROOTDIR = ..

include $(ROOTDIR)/Makefile.common

COMPILER=$(ROOTDIR)/ocamlc$(EXE)
CAMLC=$(CAMLRUN) $(COMPILER)
COMPFLAGS=-strict-sequence -absname -w +a-4-9-41-42-44-45-48 \
          -g -warn-error A -bin-annot -nostdlib -principal \
          -safe-string -strict-formats
ifeq "$(FLAMBDA)" "true"
OPTCOMPFLAGS += -O3
endif
OPTCOMPILER=$(ROOTDIR)/ocamlopt$(EXE)
CAMLOPT=$(CAMLRUN) $(OPTCOMPILER)
CAMLDEP=$(BOOT_OCAMLC) -depend
DEPFLAGS=-slash

OC_CPPFLAGS += -I$(ROOTDIR)/runtime

include StdlibModules

OBJS=$(addsuffix .cmo,$(STDLIB_MODULES))
NOSTDLIB= camlinternalFormatBasics.cmo camlinternalAtomic.cmo stdlib.cmo
OTHERS=$(filter-out $(NOSTDLIB),$(OBJS))

PREFIXED_OBJS=$(filter stdlib__%.cmo,$(OBJS))
UNPREFIXED_OBJS=$(PREFIXED_OBJS:stdlib__%.cmo=%)

.PHONY: all
all: stdlib.cma std_exit.cmo camlheader target_camlheader

.PHONY: allopt opt.opt # allopt and opt.opt are synonyms
allopt: stdlib.cmxa std_exit.cmx
opt.opt: allopt

.PHONY: install
install::
	$(INSTALL_DATA) \
	  stdlib.cma std_exit.cmo *.cmi "$(INSTALL_LIBDIR)"
ifeq "$(INSTALL_SOURCE_ARTIFACTS)" "true"
	$(INSTALL_DATA) \
	  *.cmt *.cmti *.mli *.ml \
	  "$(INSTALL_LIBDIR)"
endif
	$(INSTALL_DATA) target_camlheader "$(INSTALL_LIBDIR)/camlheader"

.PHONY: installopt
installopt: installopt-default

.PHONY: installopt-default
installopt-default:
	$(INSTALL_DATA) \
	  stdlib.cmxa stdlib.$(A) std_exit.$(O) *.cmx \
	  "$(INSTALL_LIBDIR)"
	cd "$(INSTALL_LIBDIR)"; $(RANLIB) stdlib.$(A)

ifeq "$(UNIX_OR_WIN32)" "unix"
HEADERPROGRAM = header
else # Windows
HEADERPROGRAM = headernt
endif

ifeq "$(SHEBANGSCRIPTS)" "true"

%header: %header.shebang
	sed -e 's/^ *//;/^\(#[^!]\|$$\)/d' $< > $@

else # Shebang scripts not supported

%header: $(HEADERPROGRAM).c $(ROOTDIR)/Makefile.config Makefile

# $@.exe is deleted to ensure no Cygwin .exe mangling takes place
%header: %header.shebang tmpheader.exe
	rm -f $@.exe
	sed -ne '/^\#!/s/^\#!/!\#/p' $< > $@
	cat tmpheader.exe >> $@
	rm -f tmpheader.exe

tmpheader.exe: $(HEADERPROGRAM).$(O)
	$(call MKEXE_BOOT,$@,$^ $(EXTRALIBS))
# FIXME This is wrong - mingw could invoke strip; MSVC equivalent?
ifneq "$(UNIX_OR_WIN32)" "win32"
	strip $@
endif

$(HEADERPROGRAM).$(O): $(HEADERPROGRAM).c
	$(CC) -c $(OC_CFLAGS) $(CFLAGS) $(OC_CPPFLAGS) $(CPPFLAGS) \
	  $(OUTPUTOBJ)$@ $^

endif # ifeq "$(SHEBANGSCRIPTS)" "true"

stdlib.cma: $(OBJS)
	$(CAMLC) -a -o $@ $^

stdlib.cmxa: $(OBJS:.cmo=.cmx)
	$(CAMLOPT) -a -o $@ $^

sys.ml: $(ROOTDIR)/VERSION sys.mlp
	sed -e "s|%%VERSION%%|`sed -e 1q $< | tr -d '\r'`|" sys.mlp > $@

.PHONY: clean
clean::
	rm -f sys.ml

.PHONY: distclean
distclean: clean
	rm -f *.shebang

clean::
	rm -f camlheader target_camlheader

.SUFFIXES: .mli .ml .cmi .cmo .cmx

export AWK

%.cmi: %.mli
	$(CAMLC) $(COMPFLAGS) $(shell ./Compflags $@) -c $<

stdlib__%.cmi: %.mli
	$(CAMLC) $(COMPFLAGS) $(shell ./Compflags $@) -o $@ -c $<

%.cmo: %.ml
	$(CAMLC) $(COMPFLAGS) $(shell ./Compflags $@) -c $<

stdlib__%.cmo: %.ml
	$(CAMLC) $(COMPFLAGS) $(shell ./Compflags $@) -o $@ -c $<

%.cmx: %.ml
	$(CAMLOPT) $(COMPFLAGS) $(OPTCOMPFLAGS) $(shell ./Compflags $@) -c $<

stdlib__%.cmx: %.ml
	$(CAMLOPT) $(COMPFLAGS) $(OPTCOMPFLAGS) $(shell ./Compflags $@) \
	           -o $@ -c $<

# Dependencies on the compiler
COMPILER_DEPS=$(filter-out -use-prims $(CAMLRUN), $(CAMLC))
$(OBJS) std_exit.cmo: $(COMPILER_DEPS)
$(OBJS:.cmo=.cmi) std_exit.cmi: $(COMPILER_DEPS)
$(OBJS:.cmo=.cmx) std_exit.cmx: $(OPTCOMPILER)

# Dependencies on Stdlib (not tracked by ocamlc -depend)

$(OTHERS) std_exit.cmo: stdlib.cmi
$(OTHERS:.cmo=.cmi) std_exit.cmi: stdlib.cmi
$(OBJS:.cmo=.cmx) std_exit.cmx: stdlib.cmi
$(OTHERS:.cmo=.cmx) std_exit.cmx: stdlib.cmx

clean::
	rm -f *.cm* *.o *.obj *.a *.lib *.odoc
	rm -rf flexdll

include .depend

EMPTY :=
SPACE := $(EMPTY) $(EMPTY)

.PHONY: depend
depend:
	$(CAMLDEP) $(DEPFLAGS) $(filter-out stdlib.%,$(wildcard *.mli *.ml)) \
	  > .depend.tmp
	$(CAMLDEP) $(DEPFLAGS) -pp "$(AWK) -f ./remove_module_aliases.awk" \
	  stdlib.ml stdlib.mli >> .depend.tmp
	sed -Ee \
	  's#(^| )(${subst ${SPACE},|,${UNPREFIXED_OBJS}})[.]#\1stdlib__\2.#g' \
	  .depend.tmp > .depend
	rm -f .depend.tmp
