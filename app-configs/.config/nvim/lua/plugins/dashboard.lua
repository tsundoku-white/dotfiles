return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('dashboard').setup({
      theme = 'hyper', -- or 'doom'
      config = {
        header = {
          "   _  _         _               ",
          "  | \\| |___ ___v|_|_+_)\\^/___   ",
          "  | .` | -_) _ \\ V V V V '_ \\  ",
          "  |_|\\_|___\\___/\\_/\\_/\\_/._/  ",
        },
        shortcut = {
          { desc = '   Update', group = '@property', action = 'Lazy update', key = 'u' },
          { desc = ' Files', group = 'Label', action = 'Telescope find_files', key = 'f' },
          { desc = ' Quit', group = 'DiagnosticHint', action = 'qa', key = 'q' },
        },
        footer = function()
          return { '⚡ Neovim loaded' }
        end,
      },
    })
  end,
}

