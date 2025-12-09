local p = {
    bg    = "#040404",
    fg    = "#feffff",

    black     = "#040404",
    red       = "#d84a33",
    green     = "#5da602",
    yellow    = "#eebb6e",
    blue      = "#417ab3",
    magenta   = "#e5c499",
    cyan      = "#bdcfe5",
    white     = "#dbded8",

    br_black  = "#685656",
    br_red    = "#d76b42",
    br_green  = "#99b52c",
    br_yellow = "#ffb670",
    br_blue   = "#97d7ef",
    br_mag    = "#aa7900",
    br_cyan   = "#bdcfe5",
    br_white  = "#e4d5c7",

    selection = "#606060",
}

local transparent = vim.g.adventure_transparent == true

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then vim.cmd("syntax reset") end
vim.o.termguicolors = true
vim.g.colors_name = "adventure"

local function hi(group, opts)
    local c = "hi " .. group
    if opts.fg then c = c .. " guifg=" .. opts.fg end
    if opts.bg then
        if transparent then
            c = c .. " guibg=NONE"
        else
            c = c .. " guibg=" .. opts.bg
        end
    end
    if opts.bold then c = c .. " gui=bold" end
    if opts.italic then c = c .. " gui=italic" end
    if opts.none then c = "hi! clear " .. group end
    vim.cmd(c)
end

---------------------------------------------------------------------------
-- Core Editor UI
---------------------------------------------------------------------------

hi("Normal",        { fg = p.fg, bg = p.bg })
hi("NormalFloat",   { fg = p.fg, bg = p.bg })
hi("FloatBorder",   { fg = p.br_black })
hi("SignColumn",    { fg = p.br_black })

hi("CursorLine",    { bg = p.br_black })
hi("CursorLineNr",  { fg = p.br_yellow, bold = true })
hi("LineNr",        { fg = p.br_black })

hi("Visual",        { bg = p.selection })
-- Force Visual to always have a background, even in transparent mode
-- vim.cmd("hi Visual guifg=" .. p.fg .. " guibg=" .. p.selection)

hi("Search",        { fg = p.black, bg = p.yellow })
hi("IncSearch",     { fg = p.black, bg = p.br_yellow })

hi("Pmenu",         { fg = p.fg, bg = p.br_black })
hi("PmenuSel",      { fg = p.black, bg = p.br_blue })

hi("StatusLine",    { fg = p.fg, bg = p.br_black })
hi("StatusLineNC",  { fg = p.br_black, bg = p.black })

hi("TabLineSel",    { fg = p.black, bg = p.br_blue })
hi("TabLine",       { fg = p.br_black, bg = p.black })

hi("VertSplit",     { fg = p.br_black })

---------------------------------------------------------------------------
-- Syntax + Treesitter
---------------------------------------------------------------------------

hi("Comment",       { fg = p.br_black, italic = true })
hi("Identifier",    { fg = p.br_blue })
hi("Type",          { fg = p.br_green })
hi("String",        { fg = p.green })
hi("Number",        { fg = p.br_yellow })
hi("Keyword",       { fg = p.red })
hi("Function",      { fg = p.yellow })
hi("Constant",      { fg = p.br_blue })
hi("Boolean",       { fg = p.br_red })
hi("Operator",      { fg = p.red })

-- Treesitter groups
hi("@keyword",      { fg = p.red })
hi("@function",     { fg = p.yellow })
hi("@type",         { fg = p.br_green })
hi("@variable",     { fg = p.fg })
hi("@field",        { fg = p.br_blue })
hi("@property",     { fg = p.br_blue })
hi("@string",       { fg = p.green })
hi("@constant",     { fg = p.br_cyan })
hi("@number",       { fg = p.br_yellow })
hi("@boolean",      { fg = p.br_red })
hi("@comment",      { fg = p.br_black, italic = true })

---------------------------------------------------------------------------
-- Diagnostics + LSP
---------------------------------------------------------------------------

hi("DiagnosticError", { fg = p.br_red })
hi("DiagnosticWarn",  { fg = p.br_yellow })
hi("DiagnosticInfo",  { fg = p.br_blue })
hi("DiagnosticHint",  { fg = p.br_green })

hi("LspSignatureActiveParameter", { fg = p.br_red, bold = true })

---------------------------------------------------------------------------
-- Telescope integration
---------------------------------------------------------------------------

hi("TelescopeNormal",          { fg = p.fg, bg = p.bg })
hi("TelescopeSelection",       { fg = p.black, bg = p.br_blue })
hi("TelescopeSelectionCaret",  { fg = p.black, bg = p.br_blue })
hi("TelescopeBorder",          { fg = p.br_black })
hi("TelescopePromptBorder",    { fg = p.br_black })
hi("TelescopeResultsBorder",   { fg = p.br_black })
hi("TelescopePreviewBorder",   { fg = p.br_black })
hi("TelescopeMatching",         { fg = p.br_yellow, bold = true })

---------------------------------------------------------------------------
-- Diff
---------------------------------------------------------------------------

hi("DiffAdd",       { bg = p.green })
hi("DiffDelete",    { bg = p.red })
hi("DiffChange",    { bg = p.br_black })
hi("DiffText",      { bg = p.br_yellow })

---------------------------------------------------------------------------
-- Lualine Theme
---------------------------------------------------------------------------

_G.adventure_lualine = {
    normal = {
        a = { bg = p.blue, fg = p.black, gui = "bold" },
        b = { bg = p.br_black, fg = p.fg },
        c = { bg = p.bg, fg = p.fg },
    },
    insert = {
        a = { bg = p.green, fg = p.black, gui = "bold" },
    },
    visual = {
        a = { bg = p.yellow, fg = p.black, gui = "bold" },
    },
    replace = {
        a = { bg = p.red, fg = p.black, gui = "bold" },
    },
    command = {
        a = { bg = p.br_mag, fg = p.black, gui = "bold" },
    },
    inactive = {
        a = { bg = p.br_black, fg = p.bg },
        b = { bg = p.br_black, fg = p.fg },
        c = { bg = p.bg, fg = p.br_black },
    }
}
