return {

  {
    "kwakzalver/duckytype.nvim",
    opts = {}
  },
  {
    'piersolenski/skifree.nvim',
    cmd = 'SkiFree',
  },
  {
    "frostzt/bongo-cat.nvim",
    config = function()
      require("bongo-cat").setup()
    end,
  },

}
