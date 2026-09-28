return {
  -- Modern LSP configuration for Neovim 0.11+
  {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp" }, -- Ensures blink loads before LSP attaches
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- Fetches capabilities required to wire up dropdown completions
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- Lua Server
      vim.lsp.config.lua_ls = {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
        capabilities = capabilities, -- <-- Injected here
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = { enable = false },
          },
        },
      }

      -- C/C++ Server (Handles .cc and .hh automatically)
      vim.lsp.config.clangd = {
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--compile-commands-dir=build",
        },
        filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
        root_markers = { "compile_commands.json", ".clangd", ".git" },
        capabilities = capabilities, -- <-- Injected here
        init_options = {
          usePlaceholders = true,
          completeUnimported = true,
          clangdFileStatus = true,
        },
      }

      -- CMake Server
      vim.lsp.config.cmake = {
        cmd = { "cmake-language-server" },
        filetypes = { "cmake" },
        root_markers = { "CMakeLists.txt", ".git" },
        capabilities = capabilities, -- <-- Injected here
      }

      -- Enable configured servers
      vim.lsp.enable({ "lua_ls", "clangd", "cmake" })

      -- LSP Keymaps
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(args)
          local bufnr = args.buf
          local opts = { buffer = bufnr, silent = true }

          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "<leader>f", function()
            vim.lsp.buf.format({ async = true })
          end, opts)
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
          vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
        end,
      })
    end,
  },
}

