return {
  "folke/flash.nvim",
  event = "VeryLazy",
  ---@type Flash.Config
  opts = {modes = { char = { enabled = false } }},
  keys = {
    { "/", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { ":", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    -- { "?", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    -- { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    -- { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
     {
      ";",
      mode = "n",
      function()
        require("flash").toggle(true)                 -- ensure Flash is ON in cmdline
        vim.api.nvim_feedkeys("/", "n", false)        -- enter '/'
      end,
      desc = "Search with Flash",
    },
  },
}
