; Highlighting queries for OHH (.ohh), consumed by Neovim and Zed directly,
; and the ground truth VS Code's separately-maintained TextMate grammar
; should agree with (same discipline as tree-sitter-phh/queries/highlights.scm).

(pair key: (string) @property)

"{" @punctuation.bracket
"}" @punctuation.bracket
"[" @punctuation.bracket
"]" @punctuation.bracket
":" @punctuation.delimiter
"," @punctuation.delimiter

(string) @string
(escape_sequence) @string.escape
(number) @number
(true) @constant.builtin.boolean
(false) @constant.builtin.boolean
(null) @constant.builtin

; -- OHH-specific: the root "ohh" key and well-known enum-valued string
; values, text-matched the same way tree-sitter-phh text-matches `variant`
; (ohh/registry/enums.json is the source of truth; a query can't read JSON,
; but ohh-ls's hover/completion reads the same registry, so grammar-level
; highlighting and server-level semantics agree on separate copies of the
; same facts rather than one depending on the other at runtime).
(pair
  key: (string) @_key
  value: (string) @string.special
  (#any-of? @_key "\"game_type\"" "\"bet_type\"" "\"street\"" "\"action\""))
