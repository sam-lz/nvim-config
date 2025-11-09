return {
    -- {
    --     "jackMort/ChatGPT.nvim",
    --     event = "VeryLazy",
    --     config = function()
    --         require("chatgpt").setup()
    --     end,
    --     dependencies = {
    --         "MunifTanjim/nui.nvim",
    --         "nvim-lua/plenary.nvim",
    --         -- "folke/trouble.nvim", -- optional
    --         "nvim-telescope/telescope.nvim"
    --     }
    -- },

    {"zbirenbaum/copilot.lua",
    -- { "zbirenbaum/copilot.lua", enabled = false } -- to disable the plugin
    -- event = "VeryLazy",
    config = function()
        require("copilot").setup({
            filetypes = {
                markdown = false,
                org = false,
                text = false,
                norg = false,
            },
            suggestion = {
                enabled = true,
                auto_trigger = true,
                debounce = 75,
                keymap = {
                    accept = "<C-a>",
                    accept_word = "<C-w>",
                    accept_line = "<C-e>",
                    -- next = "<C-]>",
                    -- prev = "<C-[>",
                    -- dismiss = "<esc>",
                },
            },
            panel = {
                enabled = true,
                auto_refresh = true,
                keymap = {
                }
              }
            })
        end,
    },
    -- {
    --     "github/copilot.vim",
    -- },
}







