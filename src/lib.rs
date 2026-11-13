//! Zed extension for OHH (.ohh).
//!
//! Same shape as zed-phh/src/lib.rs (the thin Rust shim this project needs):
//! it only tells Zed how to *start* `ohh-ls`. No parsing, no diagnostics
//! logic lives here, the grammar is `tree-sitter-ohh` and the language
//! intelligence is `ohh-ls` itself, the exact same binary VS Code, Neovim
//! and Vim all start the same way.

use zed_extension_api::{self as zed, Command, LanguageServerId, Result, Worktree, settings::LspSettings};

struct OhhExtension;

impl zed::Extension for OhhExtension {
    fn new() -> Self {
        OhhExtension
    }

    fn language_server_command(
        &mut self,
        _language_server_id: &LanguageServerId,
        worktree: &Worktree,
    ) -> Result<Command> {
        // Same "never approximate silently" reasoning as zed-phh: no
        // bundled/auto-downloaded ohh-ls binary and no sensible default
        // registry path, so both must come from Zed's settings.json under
        // "lsp": {"ohh-ls": {"binary": {...}}}.
        let lsp_settings = LspSettings::for_worktree("ohh-ls", worktree).ok();
        let binary_settings = lsp_settings.and_then(|s| s.binary);

        let path = binary_settings
            .as_ref()
            .and_then(|b| b.path.clone())
            .or_else(|| worktree.which("ohh-ls"))
            .ok_or_else(|| {
                "ohh-ls not found. Set it in Zed's settings.json: \
                 \"lsp\": {\"ohh-ls\": {\"binary\": {\"path\": \"/absolute/path/to/ohh-ls\", \
                 \"arguments\": [\"/absolute/path/to/ohh/registry\"]}}}}"
                    .to_string()
            })?;

        let args = binary_settings
            .and_then(|b| b.arguments)
            .ok_or_else(|| {
                "ohh-ls needs the path to ohh/registry as its one argument. Set it in Zed's \
                 settings.json: \"lsp\": {\"ohh-ls\": {\"binary\": {\"arguments\": \
                 [\"/absolute/path/to/ohh/registry\"]}}}}"
                    .to_string()
            })?;

        Ok(Command {
            command: path,
            args,
            env: Default::default(),
        })
    }
}

zed::register_extension!(OhhExtension);
