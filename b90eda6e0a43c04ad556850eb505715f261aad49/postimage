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
# NOTE: it is important that the OCAMLDEP variable is defined *before*
# Makefile.common gets included, so that its local definition here
# take precedence over its general shared definitions in Makefile.common.
OCAMLDEP ?= $(BOOT_OCAMLDEP)

include $(ROOTDIR)/Makefile.common

COMPILER=$(ROOTDIR)/ocamlc$(EXE)
CAMLC=$(OCAMLRUN) $(COMPILER)
COMPFLAGS=-strict-sequence -absname -w +a-4-9-41-42-44-45-48 \
          -g -warn-error +A -bin-annot -nostdlib -principal
ifeq "$(FLAMBDA)" "true"
OPTCOMPFLAGS += -O3
endif
OPTCOMPILER=$(ROOTDIR)/ocamlopt
CAMLOPT=$(OCAMLRUN) $(OPTCOMPILER)

include StdlibModules

OBJS=$(addsuffix .cmo,$(STDLIB_MODULES))
NOSTDLIB= camlinternalFormatBasics.cmo stdlib.cmo
OTHERS=$(filter-out $(NOSTDLIB),$(OBJS))

.PHONY: all
all: stdlib.cma std_exit.cmo camlheader target_camlheader

.PHONY: allopt opt.opt # allopt and opt.opt are synonyms
allopt: stdlib.cmxa std_exit.cmx
opt.opt: allopt

INSTALL_STDLIB_META_DIR=$(DESTDIR)$(LIBDIR)/stdlib

.PHONY: install
install::
	$(INSTALL_DATA) \
	  stdlib.cma std_exit.cmo *.cmi "$(INSTALL_LIBDIR)"
	$(MKDIR) "$(INSTALL_STDLIB_META_DIR)"
	$(INSTALL_DATA) META "$(INSTALL_STDLIB_META_DIR)"
ifeq "$(INSTALL_SOURCE_ARTIFACTS)" "true"
	$(INSTALL_DATA) \
	  *.cmt *.cmti *.mli *.ml *.ml.in \
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

ifeq "$(UNIX_OR_WIN32)" "unix"
HEADERPROGRAM = header
else # Windows
HEADERPROGRAM = headernt
endif

ifeq "$(SHEBANGSCRIPTS)" "true"

%header: %header.shebang
	$(V_GEN)sed -e 's/^ *//;/^#[^!]/d;/^$$/d' $< > $@

else # Shebang scripts not supported

%header: $(HEADERPROGRAM).c $(ROOTDIR)/Makefile.config Makefile

# $@.exe is deleted to ensure no Cygwin .exe mangling takes place
%header: %header.shebang tmpheader.exe
	@rm -f $@.exe
	$(V_GEN)sed -ne '/^\#!/s/^\#!/!\#/p' $< > $@
	@cat tmpheader.exe >> $@

.INTERMEDIATE: tmpheader.exe
tmpheader.exe: $(HEADERPROGRAM).$(O)
	$(call MKEXE_VIA_CC,$@,$^)
# FIXME This is wrong - mingw could invoke strip; MSVC equivalent?
ifneq "$(UNIX_OR_WIN32)" "win32"
	strip $@
endif

$(HEADERPROGRAM).$(O): $(HEADERPROGRAM).c
	$(V_CC)$(CC) -c $(OC_CFLAGS) $(CFLAGS) $(OC_CPPFLAGS) $(CPPFLAGS) \
	  $(OUTPUTOBJ)$@ $^

endif # ifeq "$(SHEBANGSCRIPTS)" "true"

stdlib.cma: $(OBJS)
	$(V_LINKC)$(CAMLC) -a -o $@ $^

stdlib.cmxa: $(OBJS:.cmo=.cmx)
	$(V_LINKOPT)$(CAMLOPT) -a -o $@ $^

.PHONY: distclean
distclean: clean
	rm -f sys.ml META *.shebang target_camlheader.shebang.in

.PHONY: clean
clean::
	rm -f camlheader target_camlheader

export AWK

%.cmi: %.mli
	$(V_OCAMLC)$(CAMLC) $(COMPFLAGS) $(shell ./Compflags $@) -c $<

# The dependency on the .mli file is in .depend (since stdlib__Foo.cmi
# depends on stdlib__foo.mli)
stdlib__%.cmi:
	$(V_OCAMLC)$(CAMLC) $(COMPFLAGS) $(shell ./Compflags $@) \
	         -o $@ -c $(filter %.mli, $^)

%.cmo: %.ml
	$(V_OCAMLC)$(CAMLC) $(COMPFLAGS) $(shell ./Compflags $@) -c $<

# The dependency on the .ml file is in .depend (since stdlib__Foo.cmo
# depends on stdlib__foo.ml)
stdlib__%.cmo:
	$(V_OCAMLC)$(CAMLC) $(COMPFLAGS) $(shell ./Compflags $@) \
	         -o $@ -c $(filter %.ml, $^)

%.cmx: %.ml
	$(V_OCAMLOPT)$(CAMLOPT) $(COMPFLAGS) $(OPTCOMPFLAGS) $(shell ./Compflags $@) -c $<

# The dependency on the .ml file is in .depend (since stdlib__Foo.cmx
# depends on stdlib__foo.ml)
stdlib__%.cmx:
	$(V_OCAMLOPT)$(CAMLOPT) $(COMPFLAGS) $(OPTCOMPFLAGS) $(shell ./Compflags $@) \
	           -o $@ -c $(filter %.ml, $^)

# Dependencies on the compiler
COMPILER_DEPS=$(filter-out -use-prims $(OCAMLRUN), $(CAMLC))
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

STDLIB_NAMESPACE_MODULES = $(subst $(SPACE),|,$(STDLIB_PREFIXED_MODULES))

GNUISH_SED = \
  $(if $(filter X,$(shell echo x | $(SED) -E -e 's/./\u&/' 2>/dev/null)),\
       $(SED),$(error GNU sed is needed for make depend))

.PHONY: depend
depend:
	$(V_OCAMLDEP){ \
	  $(OCAMLDEP_CMD) $(filter-out stdlib.%,$(wildcard *.mli *.ml)); \
	  $(OCAMLDEP_CMD) -pp "$(AWK) -f ./remove_module_aliases.awk" \
	  stdlib.ml stdlib.mli; \
	} | \
	$(GNUISH_SED) -E \
	-e 's/^(${STDLIB_NAMESPACE_MODULES})(\.[^i]*)(i?) :/\1\2\3 : \1.ml\3/' \
	-e 's#(^| )(${STDLIB_NAMESPACE_MODULES})[.]#\1stdlib__\u\2.#' \
	> .$@
