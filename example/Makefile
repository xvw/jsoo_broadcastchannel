OCAML    = ocamlfind ocamlc -g -package js_of_ocaml -package js_of_ocaml.ppx
DEP      = -package jsoo_broadcastchannel common.cmo
JSOCAML  = js_of_ocaml --pretty --sourcemap +weak.js +toplevel.js

.PHONY: send.ml answer.ml

# Specific rule
all: common send.js receive.js clean



# Generic rules

%.byte: %.ml
	$(OCAML) $(DEP) -linkpkg -o $(@) $(<)

%.js: %.byte
	$(JSOCAML) -o $(@) $(<)

common:
	ocamlfind ocamlc -g -package js_of_ocaml -package js_of_ocaml.ppx -package jsoo_broadcastchannel -linkpkg common.ml

clean:
	rm -rf *.byte
	rm -rf *.cm*
	rm *.out
