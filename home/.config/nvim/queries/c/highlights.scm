; extends

; Consolidate all keywords to use consistent @keyword styling

[
  "break"
  "case"
  "continue"
  "default"
  "do"
  "else"
  "for"
  "goto"
  "if"
  "return"
  "switch"
  "while"
  "asm"
  "__asm__"
  "__extension__"
  "enum"
  "struct"
  "typedef"
  "union"
  "sizeof"
  "offsetof"
] @keyword

(alignof_expression
  .
  _ @keyword)

[
  "#define"
  "#elif"
  "#elifdef"
  "#elifndef"
  "#else"
  "#endif"
  "#if"
  "#ifdef"
  "#ifndef"
  "#include"
  (preproc_directive)
] @keyword

[
  (storage_class_specifier)
  (type_qualifier)
  (gnu_asm_qualifier)
] @keyword

(conditional_expression
  [
    "?"
    ":"
  ] @keyword)
