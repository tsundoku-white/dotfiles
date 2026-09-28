return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    -- Delay loading slightly until the UI is drawn
    event = { "VeryLazy" },
    config = function()
      -- Schedule execution to prevent blocking the main startup thread
      vim.schedule(function()
        require("nvim-treesitter.configs").setup({
          ensure_installed = { "c", "cpp", "lua", "cmake" },
          auto_install = false,

          highlight = {
            enable = true,
            disable = function(lang, buf)
              local max_filesize = 200 * 1024 -- 200 KB
              local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
              if ok and stats and stats.size > max_filesize then
                return true
              end
            end,
            additional_vim_regex_highlighting = false,
          },
        })
      end)
    end,
  },
}
