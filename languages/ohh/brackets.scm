; Confirmed against Zed's own real, current built-in JSON brackets.scm
; (crates/grammars/src/json/brackets.scm, fetched from zed-industries/zed),
; this is byte-for-byte the same shape, since tree-sitter-ohh's object/
; array/string nodes are named identically to the official tree-sitter-json
; grammar's.

("[" @open
  "]" @close)

("{" @open
  "}" @close)

(("\"" @open
  "\"" @close)
  (#set! rainbow.exclude))
