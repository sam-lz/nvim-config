return {


    {
        "natecraddock/workspaces.nvim",
        depencdencies = { "nvim-telescope/telescope.nvim" },
        opts = {
            cd_type = "tab",
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
        vim.keymap.set("n", "<leader>ba", function() harpoon:list():add() end)

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
    -- {
    --     "nvim-telescope/telescope-z.nvim",
    --     config = function()
    --         require("telescope").load_extension "z"
    --     end,
    -- },
    -- {
    --      "ahmedkhalf/project.nvim",
    --      config = function()
    --          require("project_nvim").setup({
    --              -- detection_methods = { "lsp", "pattern" },
    --              silent_chdir = false,
    --              scope_chdir = "global",
    --          })
    --      end,
    -- },



    {
        'nvim-telescope/telescope.nvim',
        -- tag = '0.1.9',
        branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' },

        config = function()
            local z_utils = require("telescope._extensions.zoxide.utils")
            local no_titles = {
              prompt_title  = "",
              results_title = "",
              preview_title = "",
            }
            require("telescope").setup({
                defaults = {
                  prompt_title  = "",
                  results_title = "",
                  preview_title = "",
                  dynamic_preview_title = false,
                  border = true,
                  layout_strategy = "vertical",
                  mappings = {
                    i = {
                      -- ["<esc>"] = require('telescope.actions').close,
                      -- ["<C-p>"] = require('telescope.layout_actions').toggle_preview,
                      -- ["<C-p>"] = require('telescope.actions').layout.toggle_preview,
                      ["<Tab>"] = false,      -- remove <Tab> in insert mode
                    },
                    n = {
                      -- ["q"] = require('telescope.actions').close,
                      --     ["<C-p>"] = require('telescope.actions').layout.toggle_preview,
                      -- ["m"] = require('telescope.builtin').keymaps.preview_scrolling_down,
                      -- [","] = require('telescope.builtin').keymaps.preview_scrolling_up,
                      ["<Tab>"] = false,
                    },
                  },
                  -- path_display = { "truncate" },
                  -- sorting_strategy = 'ascending',
                  -- path_display = {
                    --     filename_first = {
                      --         reverse_directories = true
                      --     },
                      -- },

                      -- path_display = function(opts, path)
                        --     local tail = require("telescope.utils").path_tail(path)
                        --     return string.format("%s (%s)", tail, path)
                        -- end,
                        -- path_display = function(_, path)
                          --     local utils = require("telescope.utils")
                          --     local tail = utils.path_tail(path)

                          --     local parts = {}
                          --     for part in string.gmatch(path, "[^/]+") do
                          --         table.insert(parts, 1, part) -- insert at front to reverse order
                          --     end
                          --     local reversed = table.concat(parts, "/")

                          --     return string.format("%s (%s)", tail, reversed)
                          -- end,
                          path_display = function(_, path)
                            local utils = require("telescope.utils")
                            local tail = utils.path_tail(path)   -- filename

                            -- directory part without the filename, e.g. "a/b/c/file" -> "a/b/c"
                            local dir = path:match("(.+)/[^/]+$")

                            if not dir then
                              -- no directory component, just return the filename
                              return tail
                            end

                            -- reverse the directory components: "a/b/c" -> "c/b/a"
                            local parts = {}
                            for part in string.gmatch(dir, "[^/]+") do
                              table.insert(parts, 1, part) -- insert at front to reverse
                            end
                            local reversed = table.concat(parts, "/")

                            return string.format("%s (%s)", tail, reversed)
                          end,



                          layout_config = {
                            vertical = {
                              -- width = {padding = 20},
                              -- height = {padding = 5},
                              width = {padding = 10},
                              height = {padding = 5},
                              -- prompt_position = "top",
                            },
                            -- horizontal = {
                              --     width = {padding = 0},
                              --     height = {padding = 15},
                              --     preview_cutoff = 120,
                              --     preview_width = 0.3,
                              --     results_width = 0.7,
                              -- },
                            },
                    },
                    pickers = {
                      buffers = {
                        prompt_title = "",
                        preview_title = "",
                        sort_lastused = true,
                        -- ignore_current_buffer = true
                        -- optionally:
                        -- only_cwd = true,          -- only buffers from current working dir
                      },
                      -- oldfiles = {
                      --   prompt_title = "",
                      -- },
                      find_files                    = no_titles,
                      live_grep                     = no_titles,
                      grep_string                   = no_titles,
                      -- buffers                       = no_titles,
                      oldfiles                      = no_titles,
                      help_tags                     = no_titles,
                      man_pages                     = no_titles,
                      current_buffer_fuzzy_find     = no_titles,
                      git_files                     = no_titles,
                      git_status                    = no_titles,
                      git_commits                   = no_titles,
                      git_bcommits                  = no_titles,
                      git_branches                  = no_titles,
                      lsp_references                = no_titles,
                      lsp_definitions               = no_titles,
                      lsp_implementations           = no_titles,
                      lsp_type_definitions          = no_titles,
                      diagnostics                   = no_titles,
                      treesitter                    = no_titles,
                      commands                      = no_titles,
                      command_history               = no_titles,
                      search_history                = no_titles,
                      marks                         = no_titles,
                      registers                     = no_titles,
                      keymaps                       = no_titles,
                      colorscheme                   = no_titles,
                      spell_suggest                 = no_titles,
                      jumplist                      = no_titles,
                      quickfix                      = no_titles,
                      loclist                       = no_titles,
                      -- add any plugin pickers you use here:
                      -- zoxide = no_titles,
                      -- projects = no_titles,
                    },
                    extensions = {
                        -- z = {
                        --     path_display = function(_, path)
                        --         local rev_dir, filename = reverse_dirs(path)
                        --         return string.format("%s (%s)", filename, rev_dir)
                        --     end,
                        -- },
                        zoxide = {
                            prompt_title = "",
                            results_title = "",
                            preview_title = "",
                            dynamic_preview_title = false,
                            mappings = {
                                default = {
                                    action = function(selection)
                                        -- vim.cmd.cd(selection.path)
                                        vim.cmd.tcd(vim.fn.fnameescape(selection.path))
                                    end,
                                    after_action = function(selection)
                                        if vim.fn.executable("yazi") == 1 then
                                            vim.cmd("Yazi cwd")
                                        else
                                            vim.notify("yazi not found on PATH", vim.log.levels.WARN)
                                        end
                                    end,
                                },
                                ["<Tab>"] = {
                                    action = function(selection)
                                        -- vim.cmd.cd(selection.path)
                                        vim.cmd.tcd(vim.fn.fnameescape(selection.path))
                                    end,
                                },
                                ["<C-s>"] = { action = z_utils.create_basic_command("split") },
                                ["<C-v>"] = { action = z_utils.create_basic_command("vsplit") },
                            },
                        },
                    },
                    preview_title = "",
                })
                require("telescope").load_extension("zoxide")

                vim.keymap.set("n", "<CR>", function()
                    require("telescope").extensions.zoxide.list({
                        picker_opts = {
                            -- preview_title = "",
                            path_display = { "tail" },
                            -- path_display = function(_, p) return require("telescope.utils").path_tail(p) end,
                        },
                        initial_mode = "insert",
                        keepinsert = true,
                        prompt_title          = "",
                        results_title         = "",
                        preview_title         = "",
                    })
                end, { desc = "Zoxide jump" })
            end,
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
                            change_working_directory = ";",
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
