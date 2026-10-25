return {
  "nvim-lua/plenary.nvim", 
  lazy = false,
  priority = 1000,
  config = function()
    local c = {
      orange  = "#ff7a00",
      amber   = "#ffb000",
      pink    = "#ff2a6d",
      cyan    = "#05d9e8",
      purple  = "#b967ff",
      yellow  = "#f9f002",
      fg      = "#f3e9dc",
      comment = "#7a6a8a",
      popup   = "#1a1024",
      sel     = "#3a1f4d",
      line    = "#2a1838",
    }

    local function apply()
      local set = function(g, o) vim.api.nvim_set_hl(0, g, o) end

      for _, g in ipairs({
        "Normal", "NormalNC", "NormalFloat", "SignColumn", "EndOfBuffer",
        "LineNr", "FoldColumn", "StatusLine", "StatusLineNC", "WinSeparator",
      }) do
        set(g, { fg = c.fg, bg = "none" })
      end
      set("EndOfBuffer" , { fg = c.comment, bg  = "none" })
      set("WinSeparator", { fg = c.orange, bg   = "none" })
      set("FloatBorder" , { fg = c.orange, bg   = "none" })

      -- UI
      set("LineNr"      , { fg = c.comment, bg = "none" })
      set("CursorLineNr", { fg = c.orange, bold = true, bg = "none" })
      set("CursorLine"  , { bg = c.line })
      set("Visual"      , { bg = c.sel })
      set("Search"      , { fg = "#000000", bg = c.amber })
      set("IncSearch"   , { fg = "#000000", bg = c.orange })
      set("MatchParen"  , { fg = c.cyan, bold = true, underline = true })
      set("Pmenu"       , { fg = c.fg, bg = c.popup })
      set("PmenuSel"    , { fg = "#000000", bg = c.orange })

      -- syntax
      set("Comment"     , { fg = c.comment, italic = true })
      set("Keyword"     , { fg = c.orange, bold = true })
      set("Statement"   , { fg = c.orange, bold = true })
      set("Conditional" , { fg = c.orange, bold = true })
      set("Repeat"      , { fg = c.orange, bold = true })
      set("Function"    , { fg = c.amber })
      set("Identifier"  , { fg = c.fg })
      set("Type"        , { fg = c.cyan })
      set("String"      , { fg = c.yellow })
      set("Number"      , { fg = c.pink })
      set("Boolean"     , { fg = c.pink, bold = true })
      set("Constant"    , { fg = c.pink })
      set("Operator"    , { fg = c.purple })
      set("PreProc"     , { fg = c.purple })
      set("Special"     , { fg = c.cyan })

      -- treesitter
      set("@keyword"            , { link  = "Keyword" })
      set("@keyword.return"     , { fg    = c.pink, bold = true })
      set("@function"           , { link  = "Function" })
      set("@function.call"      , { fg    = c.amber })
      set("@variable"           , { fg    = c.fg })
      set("@variable.parameter" , { fg    = "#ffd1a0", italic = true })
      set("@property"           , { fg    = "#ffd1a0" })
      set("@type"               , { link  = "Type" })
      set("@type.builtin"       , { fg    = c.cyan, italic = true })
      set("@namespace"          , { fg    = c.purple })
      set("@constructor"        , { fg    = c.cyan })
      set("@punctuation"        , { fg    = c.comment })
      set("@lsp.type.macro"     , { fg    = c.purple })

      -- diagnostics
      set("DiagnosticError" , { fg = c.pink })
      set("DiagnosticWarn"  , { fg = c.yellow })
      set("DiagnosticInfo"  , { fg = c.cyan })
      set("DiagnosticHint"  , { fg = c.purple })

      -- blink.cmp
      set("BlinkCmpMenu"          , { fg = c.fg,      bg = c.popup })
      set("BlinkCmpMenuBorder"    , { fg = c.orange,  bg = c.popup })
      set("BlinkCmpMenuSelection" , { fg = "#000000", bg = c.orange })
      set("BlinkCmpDoc"           , { fg = c.fg,      bg = c.popup })
      set("BlinkCmpDocBorder"     , { fg = c.orange,  bg = c.popup })

      -- telescope
      set("TelescopeBorder"     , { fg = c.orange,    bg = "none" })
      set("TelescopeSelection"  , { fg = "#000000",   bg = c.orange })
      set("TelescopeMatching"   , { fg = c.cyan,      bold = true })
    end

    vim.api.nvim_create_autocmd("ColorScheme", { callback = apply })
    vim.o.termguicolors = true
    vim.o.background = "dark"
    vim.cmd.colorscheme("default")
    apply()
  end,
}
