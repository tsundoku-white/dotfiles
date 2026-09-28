return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8', -- Or your preferred branch
    dependencies = { 'nvim-lua/plenary.nvim' }, -- Crucial!

    keys = {
      { '<leader>ff', '<cmd>Telescope find_files<cr>', desc = 'Find Files' },
      { '<leader>fg', '<cmd>Telescope live_grep<cr>', desc = 'Live Grep (Search Text)' },
      { '<leader>fb', '<cmd>Telescope buffers<cr>', desc = 'Find Buffers' },
      { '<leader>fh', '<cmd>Telescope help_tags<cr>', desc = 'Find Help' },
    },

    config = function()
      require('telescope').setup({})
    end
  }
}

