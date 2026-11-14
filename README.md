# zed-ohh

Zed support for OHH (.ohh), same thin Rust-to-WASM shim shape as `zed-phh`: it only tells Zed how to
start `ohh-ls`; the grammar is `tree-sitter-ohh` and the language
intelligence is `ohh-ls`, the exact same artifacts every other editor in
this project uses.

## Build

```sh
rustup target add wasm32-wasip2   # one-time
cargo build --target wasm32-wasip2 --release
```

Produces `target/wasm32-wasip2/release/zed_ohh.wasm` (289 KB, matching
`zed-phh`'s own build size, unsurprising, since both shims use
essentially the same `zed_extension_api` surface).

## Install (dev extension only, not published to Zed's extension registry, see below)

Zed → command palette → `zed: extensions` → "Install Dev Extension" →
select this directory. Then in Zed's `settings.json`:

```json
{
  "lsp": {
    "ohh-ls": {
      "binary": {
        "path": "/absolute/path/to/ohh-ls/build/ohh-ls",
        "arguments": ["/absolute/path/to/ohh/registry"]
      }
    }
  }
}
```

## What's implemented

- **`src/lib.rs`**: same pattern as `zed-phh/src/lib.rs`, reads the
  user's `lsp.ohh-ls.binary` settings first, falling back to
  `worktree.which("ohh-ls")`, with a clear error if either the path or
  the registry argument is missing.
- **`extension.toml`**: declares `[language_servers.ohh-ls]` and
  `[grammars.ohh]` (one grammar, OHH has no second, injected grammar
  the way PHH has `tree-sitter-phh-actions`).
- **`languages/ohh/config.toml`**: checked against Zed's own real,
  current built-in JSON language config (`crates/grammars/src/json/config.toml`,
  fetched from `zed-industries/zed`'s `main` branch, JSON is built into
  Zed itself, not a separate community extension, so that's the closest
  real reference). Deliberately diverges from it in one place, not by
  oversight: Zed's own JSON config sets `line_comments = ["// "]` even
  though standard JSON has none; OHH's spec has no comment syntax at all,
  so this file omits `line_comments` entirely rather than copying a
  setting that doesn't fit this format.
- **Query files**: see the table below.

| File | Status |
|---|---|
| `languages/ohh/highlights.scm` | Synced verbatim from `../tree-sitter-ohh/queries/highlights.scm` via `scripts/sync-queries.sh`, confirmed against Zed's own real built-in JSON `highlights.scm`: this file's capture names (`@property`, `@string`, `@number`, `@constant.builtin.boolean`, `@punctuation.bracket`/`.delimiter`) are more specific than Zed's own flatter choices (`@property.json_key`, `@boolean`), but Zed resolves captures hierarchically by stripping trailing components, so this still renders correctly under Zed's theme fallback, same conclusion `zed-phh` reached for its own highlights.scm. |
| `languages/ohh/brackets.scm` | Confirmed **byte-for-byte identical in shape** to Zed's own real built-in JSON `brackets.scm`, `[`/`]` and `{`/`}` as plain `@open`/`@close` pairs, the quote pair with `(#set! rainbow.exclude)`. Verified matching via `tree-sitter query` against the full corpus (230+ quote-pair matches, 17 bracket, 35 brace matches on the one real example alone). |
| `languages/ohh/indents.scm` | Confirmed **byte-for-byte identical in shape** to Zed's own real built-in JSON `indents.scm` (`@indent`/`@end` on `object`/`array`), not Neovim's `@indent.begin`/`@indent.end` convention used in `tree-sitter-ohh/queries/indents.scm`; the two files are not interchangeable, same split as `tree-sitter-phh`/`zed-phh`. |
| `languages/ohh/outline.scm` | Synced verbatim from `../tree-sitter-ohh/queries/outline.scm` (one entry per hand, keyed by `game_number`), deliberately **not** Zed's own built-in JSON outline convention (which lists every single object key as its own outline item); for a multi-hand `.ohh` file, listing every field would be far too noisy to be useful, so this stays a hand-level summary instead, the same design choice `tree-sitter-phh`'s own outline.scm already made for `.phhs`. |

## How this was verified

- **Compiles for the real target**: `cargo build --target wasm32-wasip2 --release` succeeds cleanly, producing a real 289 KB `.wasm` module.
- **Every query file checked with `tree-sitter query` against the real corpus** (`../ohh/corpus/`), `brackets.scm`, `indents.scm`, `outline.scm`, `highlights.scm` all produce the expected captures on every `valid/`/`invalid` fixture, zero error-like output.
- **Both TOML config files parse** (`extension.toml`, `languages/ohh/config.toml`), checked with Python's `tomllib`.
- **The schema was checked against a real, current Zed reference**, not written from memory. Since there is no separate `zed-extensions/json` community extension (confirmed: that repo 404s), the reference used is Zed's own built-in JSON support, fetched directly from `zed-industries/zed`'s `crates/grammars/src/json/` on `main`. `brackets.scm` and `indents.scm` here are structurally identical to that real file; `config.toml` and `highlights.scm` diverge in the two specific, explained ways above.

## What's NOT verified, and why

- **Not installed or run inside real Zed.** Same reason as `zed-phh`: no
  headless Zed CLI mode exists for extension testing, and this session
  avoids an unrequested GUI launch. If you install this as a dev
  extension, please report back what works.
- **The grammar is now pushed and pinned, this blocker is resolved.**
  `extension.toml`'s `[grammars.ohh]` points at a real, pushed
  repository (`github.com/MrPoloGit/tree-sitter-ohh`) at a real commit,
  confirmed matching that repo's remote `HEAD` via `git ls-remote`, not
  a placeholder. Update the pinned commit again after that grammar repo
  gets a new commit, Zed pins to an exact commit, not a branch.
- **This extension itself is still not published to Zed's actual
  extension registry** (`zed-industries/extensions`, a git submodule
  per repo, see `docs/editor-extension-publishing.md`). `zed-ohh`'s own
  `repository` field is still a placeholder, since `zed-ohh` isn't a
  git repo yet. Until both are done, "Install Dev Extension" (pointing
  at this local directory) is the only way to load it, it will not
  appear in Zed's in-app extension browser.
