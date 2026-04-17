return {
  -- {
  --   lazy = false,
  --   priority = 1000,
  --   -- dir = "~/plugins/colorbuddy.nvim",
  --   "tjdevries/colorbuddy.nvim",
  --   config = function()
  --     vim.cmd.colorscheme "gruvbuddy"
  --   end,
  -- },
  -- "rktjmp/lush.nvim",
  -- "tckmn/hotdog.vim",
  -- "dundargoc/fakedonalds.nvim",
  -- "craftzdog/solarized-osaka.nvim",
  -- { "rose-pine/neovim", name = "rose-pine" },
  -- "eldritch-theme/eldritch.nvim",
  -- "jesseleite/nvim-noirbuddy",
  -- "miikanissi/modus-themes.nvim",
  -- "rebelot/kanagawa.nvim",
  { "gremble0/yellowbeans.nvim" },
  {
    "webhooked/kanso.nvim",
    lazy = false,
    config = function()
      require('kanso').setup({
        transparent = false,
        foreground = {
          dark = "saturated"
        }
      })
    end,
  },
  { "blazkowolf/gruber-darker.nvim" },
  -- "rockyzhang24/arctic.nvim",
  { "folke/tokyonight.nvim" },
  { "Shatur/neovim-ayu" },
  -- {"RRethy/base16-nvim"},
  -- "xero/miasma.nvim",
  -- "cocopon/iceberg.vim",
  { "kepano/flexoki-neovim" },
  -- "uloco/bluloco.nvim",
  { "LuRsT/austere.vim" },
  { "p00f/alabaster.nvim" },
  {
    "mellow-theme/mellow.nvim",
    config = function()
      vim.g.mellow_transparent = true
    end
  },
  {
    "uhs-robert/oasis.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    "dybdeskarphet/gruvbox-minimal.nvim",
    config = function()
      require("gruvbox-minimal").setup({
        transparent = false,    -- Sets all the major background values to 'none'
        italic_comments = true, -- Italic comments
        contrast = "low",       -- Available values: "high", "low"
        theme = "dark",         -- Available values: "dark", "light"
        accent = "red",         -- Changes the definition (functions, structs etc.) colors. Available values: "red", "orange", "yellow", "green", "cyan", "blue", "magenta"
      })
    end
  },


  {
    "metalelf0/jellybeans-nvim",
    dependencies = {
      'rktjmp/lush.nvim',
    }
  },

  { "bluz71/vim-moonfly-colors", name = "moonfly", lazy = false, priority = 1000 },

  { "tiagovla/tokyodark.nvim" },

  -- {
  --   "zenbones-theme/zenbones.nvim",
  --   -- Optionally install Lush. Allows for more configuration or extending the colorscheme
  --   -- If you don't want to install lush, make sure to set g:zenbones_compat = 1
  --   -- In Vim, compat mode is turned on as Lush only works in Neovim.
  --   -- dependencies = "rktjmp/lush.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   -- you can set set configuration options here
  --   config = function()
  --   --     vim.g.zenbones_darken_comments = 45
  --          vim.g.zenbones_compat = 1
  --   --     vim.cmd.colorscheme('zenbones')
  --   end
  -- },
  -- "ricardoraposo/gruvbox-minor.nvim",
  -- "NTBBloodbath/sweetie.nvim",
  -- {"vim-scripts/MountainDew.vim"},
  -- {
  --   "maxmx03/fluoromachine.nvim",
  --   -- config = function()
  --   --   local fm = require "fluoromachine"
  --   --   fm.setup { glow = true, theme = "fluoromachine" }
  --   -- end,
  -- },
}
