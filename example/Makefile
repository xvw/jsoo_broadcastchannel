OCAML    = ocamlfind ocamlc -g -package js_of_ocaml -package js_of_ocaml.ppx
DEP      = -package jsoo_broadcastchannel
JSOCAML  = js_of_ocaml --pretty --sourcemap +weak.js +toplevel.js

.PHONY: example.ml answer.ml

# Specific rule
all: send.js receive.js clean



# Generic rules

%.byte: %.ml
	$(OCAML) $(DEP) -linkpkg -o $(@) $(<)

%.js: %.byte
	$(JSOCAML) -o $(@) $(<)

clean:
	rm -rf *.byte
	rm -rf *.cm*
