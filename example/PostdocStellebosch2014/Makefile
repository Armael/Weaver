all: main.js

main.js:main.byte Makefile
	js_of_ocaml $<

main.byte:*.ml 
	ocamlbuild -use-ocamlfind  -cflag -g $@

