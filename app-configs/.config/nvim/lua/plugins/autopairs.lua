return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true, -- use treesitter to be smarter about when to pair
        ts_config = {
          lua = { "string" }, -- don't add pairs inside lua strings
          cpp = { "string" },
          c = { "string" },
        },
      })

      -- make autopairs and blink.cmp play nicely together: when you accept
      -- a completion for something like a function call, auto-insert the
      -- matching closing paren
      local ok_cmp_autopairs, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
      if ok_cmp_autopairs then
        -- only relevant if you ever switch to nvim-cmp; blink.cmp handles
        -- this itself, so this block is a harmless no-op for you right now
        cmp_autopairs.setup({})
      end
    end,
  },
}
