# zed-ohh

Zed support for OHH (.ohh).

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
        "arguments": ["/absolute/path/to/ohh-data/registry"]
      }
    }
  }
}
```
