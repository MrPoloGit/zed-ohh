; Zed's (and an editor outline view's generally) per-hand listing, keyed by
; game_number, never assumed to be the first/only hand in the file, since
; a multi-hand .ohh file is several top-level `{"ohh": {...}}` objects,
; mirroring tree-sitter-phh's own "never assume sequential" outline
; convention for .phhs.
;
; NOT validated against a live Zed install (same caveat as
; tree-sitter-phh/queries/outline.scm), matches Zed's documented
; @item/@name convention, confirmed only via `tree-sitter query` here.
(object
  (pair
    key: (string) @_wrapper_key
    value: (object
      (pair
        key: (string) @_name_key
        value: (string) @name)))
  (#eq? @_wrapper_key "\"ohh\"")
  (#eq? @_name_key "\"game_number\"")) @item
