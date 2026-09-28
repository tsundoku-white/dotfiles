return {
  {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets" },
    version = "1.*", -- use the prebuilt release (no rust toolchain needed)
    opts = {
      keymap = {
        preset = "default",
        ["<CR>"] = { "accept", "fallback" },
      },
      appearance = {
        nerd_font_variant = "mono",
      },
      completion = {
        documentation = { auto_show = true },
      },
      sources = {
        -- order matters for ranking; lsp results from clangd/lua_ls/cmake
        -- will show up here automatically once capabilities are wired in
        default = { "lsp", "path", "snippets", "buffer" },
      },
      -- 'prefer_rust_with_warning' downloads a prebuilt matcher, falls back
      -- to the lua implementation if that fails (e.g. offline)
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },
}
