return {

  {
    'stevearc/conform.nvim',
    opts = {
    },
  },
  {
    "monaqa/dial.nvim",
    keys = {
      { "<C-'>", function() return require("dial.map").inc_normal() end, expr = true, desc = "Increment" },
      { "<C-;>", function() return require("dial.map").dec_normal() end, expr = true, desc = "Decrement" },
    },
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group({
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias["%Y/%m/%d"],
          augend.constant.alias.bool,
          augend.semver.alias.semver,
          augend.constant.new({ elements = { "let", "const" } }),
        },
      })
    end,
  },
  -- {
  --   "kazhala/close-buffers.nvim",
  --   event = "VeryLazy",
  --   keys = {
  --     {
  --       "<leader>th",
  --       function()
  --         require("close_buffers").delete({ type = "hidden" })
  --       end,
  --       "Close Hidden Buffers",
  --     },
  --     {
  --       "<leader>tu",
  --       function()
  --         require("close_buffers").delete({ type = "nameless" })
  --       end,
  --       "Close Nameless Buffers",
  --     },
  --   },
  -- },

  -- {
  --   "L3MON4D3/LuaSnip",
  --   keys = function()
  --     -- Disable default tab keybinding in LuaSnip
  --     return {}
  --   end,
  -- },

  -- {"j-hui/fidget.nvim"},
  -- opts = {
  -- },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true
    -- use opts = {} for passing setup options
    -- this is equivalent to setup({}) function
  },

  {
    "kylechui/nvim-surround",
    version = "^3.0.0",     -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },

  -- The three "core" operations of add/delete/change can be done
  -- with the keymaps ys{motion}{char}, ds{char}, and cs{target}{replacement}, respectively.
  -- For the following examples, * will denote the cursor position:

  --     Old text                    Command         New text
  -- --------------------------------------------------------------------------------
  --     surr*ound_words             ysiw)           (surround_words)
  --     surr*ound_words             ysiw(           ( surround_words )
  --     *make strings               ys$"            "make strings"
  --     [delete ar*ound me!]        ds]             delete around me!
  --     remove <b>HTML t*ags</b>    dst             remove HTML tags
  --     'change quot*es'            cs'"            "change quotes"
  --     <b>or tag* types</b>        csth1<CR>       <h1>or tag types</h1>
  --     delete(functi*on calls)     dsf             function calls


  {
    'abecodes/tabout.nvim',
    lazy = false,
    config = function()
      require('tabout').setup {
        tabkey = '<Tab>',             -- key to trigger tabout, set to an empty string to disable
        backwards_tabkey = '<S-Tab>', -- key to trigger backwards tabout, set to an empty string to disable
        act_as_tab = true,            -- shift content if tab out is not possible
        act_as_shift_tab = false,     -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
        default_tab = '<C-t>',        -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
        default_shift_tab = '<C-d>',  -- reverse shift default action,
        enable_backwards = true,      -- well ...
        completion = false,           -- if the tabkey is used in a completion pum
        tabouts = {
          { open = "'", close = "'" },
          { open = '"', close = '"' },
          { open = '`', close = '`' },
          { open = '(', close = ')' },
          { open = '[', close = ']' },
          { open = '{', close = '}' }
        },
        ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
        exclude = {} -- tabout will ignore these filetypes
      }
    end,
    dependencies = { -- These are optional
      -- "nvim-treesitter/nvim-treesitter",
      -- "L3MON4D3/LuaSnip",
      -- "hrsh7th/nvim-cmp"
    },
    opt = true,              -- Set this to true if the plugin is optional
    event = 'InsertCharPre', -- Set the event to 'InsertCharPre' for better compatibility
    priority = 1000,
  },

}
