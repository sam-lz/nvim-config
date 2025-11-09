return {

    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()

        local harpoon = require("harpoon")
        harpoon:setup()

        -- add current file
        vim.keymap.set("n", "<leader>B", function() harpoon:list():add() end)

        -- quick menu
        vim.keymap.set("n", "<leader>bb", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

    end,
}
