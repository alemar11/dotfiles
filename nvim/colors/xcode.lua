-- Syntax and editor colors from Xcode Default (Light/Dark) theme files.
-- UI surfaces without an Xcode equivalent reuse the same palette.
local palettes = {
  dark = {
    bg = "#1f1f24",
    line = "#23252b",
    selection = "#515b70",
    muted = "#424d5b",
    surface = "#303239",
    border = "#414249",
    error = "#f74a4a",
    warning = "#efb759",
    info = "#675fff",
    hint = "#a482ff",
    green = "#4fc941",
    fg = "#ddddde",
    comment = "#6c7986",
    doc = "#92a1b1",
    keyword = "#fc5fa3",
    string = "#fc6a5d",
    number = "#d0bf69",
    attribute = "#bf8555",
    type = "#9ef1dd",
    builtin = "#d0a8ff",
    func = "#67b7a4",
    builtin_func = "#a167e6",
    variable = "#67b7a4",
    constant = "#67b7a4",
    preproc = "#fd8f3f",
    url = "#5482ff",
    declaration = "#41a1c0",
    type_declaration = "#5dd8ff",
  },
  light = {
    bg = "#ffffff",
    line = "#e8f2ff",
    selection = "#a4cdff",
    muted = "#cccccc",
    surface = "#f5f5f5",
    border = "#e1e1e1",
    error = "#f74a4a",
    warning = "#efb759",
    info = "#675fff",
    hint = "#a482ff",
    green = "#277e1e",
    fg = "#262626",
    comment = "#5d6c79",
    doc = "#4a5560",
    keyword = "#9b2393",
    string = "#c41a16",
    number = "#1c00cf",
    attribute = "#815f03",
    type = "#1c464a",
    builtin = "#3900a0",
    func = "#326d74",
    builtin_func = "#6c36a9",
    variable = "#326d74",
    constant = "#326d74",
    preproc = "#643820",
    url = "#0e0eff",
    declaration = "#0f68a0",
    type_declaration = "#0b4f79",
  },
}

local c = palettes[vim.o.background]
vim.cmd("highlight clear")
vim.g.colors_name = "xcode"

local function hi(name, values)
  vim.api.nvim_set_hl(0, name, values)
end

local function link(name, target)
  hi(name, { link = target })
end
hi("Normal", { fg = c.fg, bg = c.bg })
hi("NormalFloat", { fg = c.fg, bg = c.surface })
hi("FloatBorder", { fg = c.border, bg = c.surface })
hi("FloatTitle", { fg = c.type_declaration, bg = c.surface, bold = true })
hi("Cursor", { fg = c.bg, bg = c.fg })
hi("CursorLine", { bg = c.line })
hi("LineNr", { fg = c.comment })
hi("CursorLineNr", { fg = c.fg, bold = true })
hi("SignColumn", { bg = c.bg })
hi("NonText", { fg = c.muted })
hi("WinSeparator", { fg = c.border })
hi("Visual", { bg = c.selection })
hi("Search", { fg = c.bg, bg = c.warning })
hi("CurSearch", { fg = c.bg, bg = c.keyword, bold = true })
hi("MatchParen", { fg = c.fg, bg = c.selection, bold = true })
hi("Pmenu", { fg = c.fg, bg = c.surface })
hi("PmenuSel", { fg = c.fg, bg = c.selection, bold = true })
hi("PmenuSbar", { bg = c.surface })
hi("PmenuThumb", { bg = c.border })
hi("StatusLine", { fg = c.fg, bg = c.surface })
hi("StatusLineNC", { fg = c.comment, bg = c.bg })
-- Give every statusline mode an explicit background instead of inheriting Diff groups.
hi("MiniStatuslineModeNormal", { fg = c.bg, bg = c.fg, bold = true })
hi("MiniStatuslineModeInsert", { fg = c.bg, bg = c.func, bold = true })
hi("MiniStatuslineModeVisual", { fg = c.bg, bg = c.keyword, bold = true })
hi("MiniStatuslineModeReplace", { fg = c.bg, bg = c.string, bold = true })
hi("MiniStatuslineModeCommand", { fg = c.bg, bg = c.attribute, bold = true })
hi("MiniStatuslineModeOther", { fg = c.bg, bg = c.builtin, bold = true })
hi("TabLine", { fg = c.comment, bg = c.surface })
hi("TabLineSel", { fg = c.fg, bg = c.selection, bold = true })
hi("Folded", { fg = c.comment, bg = c.line })
hi("ColorColumn", { bg = c.line })
hi("Directory", { fg = c.type_declaration })
hi("Title", { fg = c.type_declaration, bold = true })
hi("Comment", { fg = c.comment })
hi("Constant", { fg = c.constant })
hi("String", { fg = c.string })
hi("Number", { fg = c.number })
hi("Identifier", { fg = c.variable })
hi("Function", { fg = c.func })
hi("Statement", { fg = c.keyword })
hi("PreProc", { fg = c.preproc })
hi("Type", { fg = c.type })
hi("Special", { fg = c.attribute })
hi("Delimiter", { fg = c.fg })
hi("Operator", { fg = c.fg })
hi("Underlined", { fg = c.url, underline = true })
hi("Todo", { fg = c.doc, bold = true })
hi("Error", { fg = c.error })

for name, target in pairs({
  NormalNC = "Normal", EndOfBuffer = "NonText", SpecialKey = "NonText",
  CursorColumn = "CursorLine", FoldColumn = "LineNr", VisualNOS = "Visual",
  IncSearch = "CurSearch", QuickFixLine = "PmenuSel", WildMenu = "PmenuSel",
  TabLineFill = "TabLine", WinBar = "StatusLine", WinBarNC = "StatusLineNC",
  Character = "String", Float = "Number", Boolean = "Statement",
  Keyword = "Statement", ErrorMsg = "DiagnosticError", WarningMsg = "DiagnosticWarn",
  MoreMsg = "DiagnosticInfo", Question = "DiagnosticInfo",
}) do
  link(name, target)
end

for severity, color in pairs({ Error = c.error, Warn = c.warning, Info = c.info, Hint = c.hint, Ok = c.green }) do
  hi("Diagnostic" .. severity, { fg = color })
  hi("DiagnosticUnderline" .. severity, { sp = color, undercurl = true })
  link("DiagnosticSign" .. severity, "Diagnostic" .. severity)
  link("DiagnosticVirtualText" .. severity, "Diagnostic" .. severity)
  link("DiagnosticFloating" .. severity, "Diagnostic" .. severity)
end

hi("DiffAdd", { fg = c.green, bg = c.line })
hi("DiffChange", { fg = c.declaration, bg = c.line })
hi("DiffDelete", { fg = c.error, bg = c.line })
hi("DiffText", { fg = c.fg, bg = c.selection })

for capture, target in pairs({
  ["variable"] = "Normal", ["variable.member"] = "Identifier",
  ["variable.parameter"] = "Normal", ["constant"] = "Constant",
  ["string"] = "String", ["string.escape"] = "Special", ["string.regexp"] = "String",
  ["character"] = "String", ["number"] = "Number", ["boolean"] = "Boolean",
  ["keyword"] = "Keyword", ["keyword.directive"] = "PreProc",
  ["operator"] = "Operator", ["punctuation"] = "Delimiter",
  ["type"] = "Type", ["type.qualifier"] = "Keyword",
  ["function"] = "Function", ["function.call"] = "Function",
  ["function.method"] = "Function", ["function.macro"] = "PreProc",
  ["constructor"] = "Type", ["attribute"] = "Special",
  ["module"] = "Type", ["comment"] = "Comment", ["comment.todo"] = "Todo",
  ["markup.heading"] = "Title", ["markup.raw"] = "String",
  ["markup.link.url"] = "Underlined", ["markup.link.label"] = "Underlined",
  ["tag"] = "Keyword", ["tag.attribute"] = "Special", ["tag.delimiter"] = "Delimiter",
}) do
  link("@" .. capture, target)
end
hi("@type.builtin", { fg = c.builtin })
hi("@function.builtin", { fg = c.builtin_func })
hi("@variable.builtin", { fg = c.builtin_func })
hi("@constant.builtin", { fg = c.builtin_func })
hi("@comment.documentation", { fg = c.doc })
hi("@markup.strong", { bold = true })
hi("@markup.italic", { italic = true })
hi("@markup.strikethrough", { strikethrough = true })

for token, target in pairs({
  class = "Type", struct = "Type", enum = "Type", interface = "Type",
  type = "Type", typeParameter = "Type", namespace = "Type",
  variable = "Identifier", parameter = "Normal", property = "Identifier",
  enumMember = "Constant", ["function"] = "Function", method = "Function",
  macro = "PreProc", keyword = "Keyword", comment = "Comment", string = "String",
  number = "Number", operator = "Operator", decorator = "Special",
}) do
  link("@lsp.type." .. token, target)
end
hi("@lsp.mod.defaultLibrary", { fg = c.builtin })
hi("@lsp.typemod.function.defaultLibrary", { fg = c.builtin_func })
hi("@lsp.typemod.method.defaultLibrary", { fg = c.builtin_func })
hi("@lsp.typemod.function.declaration", { fg = c.declaration })
hi("@lsp.typemod.method.declaration", { fg = c.declaration })
for _, token in ipairs({ "class", "struct", "enum", "interface", "type" }) do
  hi("@lsp.typemod." .. token .. ".declaration", { fg = c.type_declaration })
end

for name, target in pairs({
  MiniFilesNormal = "NormalFloat", MiniFilesBorder = "FloatBorder",
  MiniFilesTitle = "FloatTitle", MiniFilesTitleFocused = "FloatTitle",
  MiniFilesDirectory = "Directory", MiniFilesFile = "NormalFloat",
  MiniFilesCursorLine = "PmenuSel", MiniPickNormal = "NormalFloat",
  MiniPickBorder = "FloatBorder", MiniPickMatchCurrent = "PmenuSel",
  MiniPickMatchRanges = "Special", MiniPickPrompt = "Title",
  MiniNotifyNormal = "NormalFloat", MiniNotifyBorder = "FloatBorder",
}) do
  link(name, target)
end
hi("MiniDiffSignAdd", { fg = c.green })
hi("MiniDiffSignChange", { fg = c.declaration })
hi("MiniDiffSignDelete", { fg = c.error })
