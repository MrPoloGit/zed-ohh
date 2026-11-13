; Confirmed against Zed's own real, current built-in JSON indents.scm
; (crates/grammars/src/json/indents.scm, fetched from zed-industries/zed),
; byte-for-byte the same shape. Zed's @indent/@end convention here, NOT
; tree-sitter-ohh/queries/indents.scm's own Neovim-convention
; (@indent.begin/@indent.end) file, the two are not interchangeable, same
; split as tree-sitter-phh/zed-phh.

(array
  "]" @end) @indent

(object
  "}" @end) @indent
