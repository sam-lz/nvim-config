return {


    {
        "natecraddock/workspaces.nvim",
        depencdencies = { "nvim-telescope/telescope.nvim" },
        opts = {
            cd_type = "global",
            hooks = {
                open = {
                    function()
                        if vim.fn.exists(":Yazi") == 2 then
                            vim.cmd("Yazi cwd")                         -- yazi.nvim plugin
                        end
                    end,
                },
            },
        },
        -- keys = {
        --     { "<leader>dA", function() require("workspaces").add(vim.fn.getcwd()) end, desc = "Workspace: add CWD" },
        --     { "<leader>dw", function() require("telescope").extensions.workspaces.workspaces() end, desc = "Workspace: switch" },
        --     -- { "<leader>dr", function() require("workspaces").rename() end, desc = "Workspace: rename" },
        --     { "<leader>dR", function() require("workspaces").remove() end, desc = "Workspace: remove" },
        -- },
    },
    {
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
    },

    {
        "jvgrootveld/telescope-zoxide",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
            require("telescope").load_extension("zoxide")
            local function zadd(dir) vim.fn.jobstart({ "zoxide", "add", dir or vim.fn.getcwd() }) end
            vim.api.nvim_create_autocmd("VimEnter",   { callback = function() zadd() end })
            vim.api.nvim_create_autocmd("DirChanged", { callback = function() zadd(vim.v.event.cwd) end })
        end,
        opts = {},
        -- keys = {
            -- open picker and jump
            -- { "<leader>df", function() require("telescope").extensions.zoxide.list() end, desc = "Zoxide: pick & cd" },
            -- add/remove current cwd to/from zoxide db
            -- { "<leader>zA", function() vim.fn.jobstart({ "zoxide", "add", vim.fn.getcwd() }) end,  desc = "Zoxide: add CWD" },
            -- { "<leader>zD", function() vim.fn.jobstart({ "zoxide", "remove", vim.fn.getcwd() }) end, desc = "Zoxide: remove CWD" },
            -- optional: print full list to :messages
            -- { "<leader>zL", function() vim.fn.jobstart({ "zoxide", "query", "-l" }) end, desc = "Zoxide: list (messages)" },
        -- },
    },



    {
        'nvim-telescope/telescope.nvim', tag = '0.1.8',
        -- or                              , branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = {
        defaults = {
            -- mappings = {
            --    i = { ["<C-p>"] = actions.layout.toggle_preview },
            --    n = { ["<C-p>"] = actions.layout.toggle_preview },
            -- },
            path_display = { "truncate" },
            layout_strategy = 'horizontal',
            layout_config = {
                width = 0.9,
                horizontal = {
                    preview_cutoff = 90,
                    preview_width = 0.4,
                    results_width = 0.7,
                },
            },
            -- sorting_strategy = 'ascending',
        },
    },
   },


    {
        "mikavilpas/yazi.nvim",
        version = "*", -- use the latest stable version
        event = "VeryLazy",
        dependencies = {
            { "nvim-lua/plenary.nvim", lazy = true },
        },
        -- keymaps = {
        --     change_working_directory = "<leader>-",
        -- },
        keys = {
            -- {
                --   "f",
                --   mode = { "n", "v" },
                --   "<cmd>Yazi<cr>",
                --   desc = "Open yazi at the current file",
                -- },
                -- {
                    --   -- Open in the current working directory
                    --   "<leader>cw",
                    --   "<cmd>Yazi cwd<cr>",
                    --   desc = "Open the file manager in nvim's working directory",
                    -- },
                    -- {
                        --   "<c-up>",
                        --   "<cmd>Yazi toggle<cr>",
                        --   desc = "Resume the last yazi session",
                        -- },
                    },
                    opts = {
                        -- if you want to open yazi instead of netrw, see below for more info
                        open_for_directories = false,
                        keymaps = {
                            show_help = "H",
                        },
                    },
                    -- 👇 if you use `open_for_directories=true`, this is recommended
                    init = function()
                        -- mark netrw as loaded so it's not loaded at all.
                        --
                        -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
                        -- vim.g.loaded_netrwPlugin = 1
                    end,
                },
                {
                    "nvim-neo-tree/neo-tree.nvim",
                    branch = "v3.x",
                    dependencies = {
                        "nvim-lua/plenary.nvim",
                        "MunifTanjim/nui.nvim",
                        "nvim-tree/nvim-web-devicons", -- optional, but recommended
                    },
                    lazy = false, -- neo-tree will lazily load itself
                    opts = {
                        window = {width = 30},
                        filesystem = {
                            follow_current_file = { enabled = false },
                            bind_to_cwd = false,
                            cwd_target = { sidebar = "window" },
                        },
                    },
                },
}
