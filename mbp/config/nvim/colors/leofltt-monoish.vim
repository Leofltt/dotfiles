" vim: fdm=marker

" Name:      leofltt-monoish
" Author:    LeoFltt
" License:   MIT
" Version:   1.5 (Smoky Amethyst muted purple/grey palette + Treesitter & LSP semantic tokens)

" Initialization {{{1
hi clear
if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "leofltt-monoish"
set background=dark
set termguicolors

" Palette {{{1
" Grays / Whites (Dark to Light)
let s:black       = { "gui": "#000000", "cterm": "black", "ctermN": 0 }
let s:float_bg    = { "gui": "#18181C", "cterm": "234",   "ctermN": 234 } " Floating window bg
let s:dark_gray1  = { "gui": "#222222", "cterm": "235",   "ctermN": 235 } " Subtle bg
let s:dark_gray2  = { "gui": "#333333", "cterm": "236",   "ctermN": 236 } " Borders / Pmenu bg
let s:med_gray1   = { "gui": "#555555", "cterm": "240",   "ctermN": 240 } " Medium gray
let s:subtle_gray = { "gui": "#686C78", "cterm": "242",   "ctermN": 242 } " Inlay hints / ghost text
let s:comment     = { "gui": "#7C808C", "cterm": "grey",  "ctermN": 244 } " Cool muted comments
let s:med_gray2   = { "gui": "#888888", "cterm": "102",   "ctermN": 102 } " LineNr
let s:dim_silver  = { "gui": "#8F929E", "cterm": "103",   "ctermN": 103 } " Delimiters / punctuation
let s:light_gray1 = { "gui": "#C0C0C0", "cterm": "250",   "ctermN": 250 } " Members / properties
let s:cool_silver = { "gui": "#C6C8D6", "cterm": "251",   "ctermN": 251 } " Parameters
let s:light_gray2 = { "gui": "#DCDCDC", "cterm": "252",   "ctermN": 252 } " Normal code / variables
let s:off_white   = { "gui": "#EAEAEA", "cterm": "254",   "ctermN": 254 } " Bright gray
let s:white       = { "gui": "#FFFFFF", "cterm": "white", "ctermN": 15 }  " Brightest UI fg

" Muted Accent Colors (Greys / Blues / Purples)
let s:red              = { "gui": "#CC5555", "cterm": "167", "ctermN": 167 } " Error / Deletion (Ghostty 1/9)
let s:yellow           = { "gui": "#CCCC55", "cterm": "179", "ctermN": 179 } " Warning / Change (Ghostty 11)
let s:green            = { "gui": "#60D060", "cterm": "71",  "ctermN": 71 }  " Success
let s:muted_green      = { "gui": "#8FBC8F", "cterm": "142", "ctermN": 142 } " DiffAdd
let s:blue             = { "gui": "#5588CC", "cterm": "68",  "ctermN": 68 }  " Info
let s:muted_blue       = { "gui": "#6B88B3", "cterm": "67",  "ctermN": 67 }  " DiagnosticInfo
let s:slate_blue       = { "gui": "#7F97C4", "cterm": "68",  "ctermN": 68 }
let s:muted_periwinkle = { "gui": "#8FA6D4", "cterm": "110", "ctermN": 110 }
let s:cool_periwinkle  = { "gui": "#9FB1DD", "cterm": "110", "ctermN": 110 }
let s:dusky_plum       = { "gui": "#8A7FA8", "cterm": "103", "ctermN": 103 } " Builtin functions
let s:muted_wisteria   = { "gui": "#9D91BD", "cterm": "146", "ctermN": 146 } " Function calls
let s:smoky_amethyst   = { "gui": "#B0A4CF", "cterm": "146", "ctermN": 146 } " Function definitions
let s:cool_mist        = { "gui": "#AEBBC2", "cterm": "152", "ctermN": 152 } " Strings
let s:warm_stone       = { "gui": "#B5AEA0", "cterm": "144", "ctermN": 144 } " PreProc / Macros / Attributes
let s:heather_mist     = { "gui": "#9899B7", "cterm": "103", "ctermN": 103 } " Keywords / Statements
let s:rosy_lavender    = { "gui": "#A698B7", "cterm": "139", "ctermN": 139 } " Modules / Builtin vars
let s:muted_lavender   = { "gui": "#9B8FB8", "cterm": "103", "ctermN": 103 } " Operators
let s:muted_violet     = { "gui": "#B2A3C9", "cterm": "146", "ctermN": 146 }
let s:muted_wisteria_orchid = { "gui": "#B19AC2", "cterm": "146", "ctermN": 146 } " Builtin types
let s:wisteria_orchid       = { "gui": "#CBB1DF", "cterm": "183", "ctermN": 183 } " Types / Constructors
let s:dusty_lilac      = { "gui": "#B5A6C9", "cterm": "146", "ctermN": 146 } " Numbers / Booleans
let s:lavender_dream   = { "gui": "#AD9FDD", "cterm": "146", "ctermN": 146 } " Constants
let s:soft_lilac       = { "gui": "#CBB8E6", "cterm": "183", "ctermN": 183 }
let s:lilac            = { "gui": "#D3B1E6", "cterm": "175", "ctermN": 175 } " Special / Escapes
let s:lilac_bloom      = { "gui": "#C57FE0", "cterm": "177", "ctermN": 177 }
let s:muted_lilac1     = { "gui": "#F0EBD2", "cterm": "228", "ctermN": 228 }
let s:muted_lilac2     = { "gui": "#E6E2CC", "cterm": "235", "ctermN": 235 }
let s:muted_lilac3     = { "gui": "#DEBFFF", "cterm": "226", "ctermN": 226 }

" Helper function to define highlights {{{1
function! s:HL(group, fg, bg, ...)
  let gui_attr_input = get(a:, 1, "NONE")
  let cterm_attr_input = get(a:, 2, "NONE")

  let is_reverse = (stridx(tolower(gui_attr_input), 'reverse') != -1 || stridx(tolower(cterm_attr_input), 'reverse') != -1)

  let fg_gui = "NONE"
  let fg_cterm = "NONE"
  let bg_gui = "NONE"
  let bg_cterm = "NONE"
  let gui_attr_final = gui_attr_input
  let cterm_attr_final = cterm_attr_input

  if !is_reverse
    let fg_gui = type(a:fg) == type({}) ? a:fg.gui : a:fg
    let fg_cterm = type(a:fg) == type({}) ? a:fg.ctermN : a:fg
    let bg_gui = type(a:bg) == type({}) ? a:bg.gui : a:bg
    let bg_cterm = type(a:bg) == type({}) ? a:bg.ctermN : a:bg
  endif

  let cmd = "highlight " . a:group
  let cmd .= " guifg=" . fg_gui
  let cmd .= " guibg=" . bg_gui
  let cmd .= " ctermfg=" . fg_cterm
  let cmd .= " ctermbg=" . bg_cterm
  let cmd .= " gui=" . gui_attr_final
  let cmd .= " cterm=" . cterm_attr_final

  execute cmd
endfunction

" Syntax Highlighting {{{1

" Basic Code Elements (Normal bg NONE for terminal transparency)
call s:HL("Normal",       s:light_gray2,     "NONE")
call s:HL("Comment",      s:comment,         "NONE", "ITALIC")
call s:HL("Identifier",   s:light_gray2,     "NONE")
call s:HL("Function",     s:smoky_amethyst,  "NONE", "BOLD")
call s:HL("Statement",    s:heather_mist,    "NONE", "BOLD")
hi! link Keyword Statement
hi! link Structure Statement
call s:HL("PreProc",      s:warm_stone,      "NONE")
call s:HL("Type",         s:wisteria_orchid, "NONE")
hi! link StorageClass Type
hi! link Label Type

" Literals
call s:HL("Constant",     s:lavender_dream,  "NONE")
call s:HL("String",       s:cool_mist,       "NONE")
call s:HL("Character",    s:cool_mist,       "NONE")
call s:HL("Number",       s:dusty_lilac,     "NONE")
call s:HL("Float",        s:dusty_lilac,     "NONE")
call s:HL("Boolean",      s:dusty_lilac,     "NONE", "ITALIC")

" Special Syntax Elements
call s:HL("Special",      s:lilac,           "NONE", "BOLD")
call s:HL("SpecialKey",   s:comment,         "NONE", "ITALIC")
call s:HL("NonText",      s:comment,         "NONE")
call s:HL("Delimiter",    s:dim_silver,      "NONE")
call s:HL("Operator",     s:muted_lavender,  "NONE")

" Specific Language Elements
hi! link rubySymbol String
hi! link htmlTagN Normal
hi! link cucumberTags Statement

" Treesitter Highlight Groups {{{1
call s:HL("@variable",               s:light_gray2,      "NONE")
call s:HL("@variable.builtin",       s:rosy_lavender,    "NONE", "ITALIC")
call s:HL("@variable.parameter",     s:cool_silver,      "NONE", "ITALIC")
call s:HL("@variable.member",        s:light_gray1,      "NONE")
hi! link @property @variable.member

call s:HL("@function",               s:smoky_amethyst,   "NONE", "BOLD")
call s:HL("@function.method",        s:smoky_amethyst,   "NONE", "BOLD")
call s:HL("@function.call",          s:muted_wisteria,   "NONE")
call s:HL("@function.method.call",   s:muted_wisteria,   "NONE")
call s:HL("@function.builtin",       s:dusky_plum,       "NONE", "ITALIC")
call s:HL("@function.macro",         s:warm_stone,       "NONE")

call s:HL("@constructor",            s:wisteria_orchid,       "NONE")
call s:HL("@type",                   s:wisteria_orchid,       "NONE")
call s:HL("@type.builtin",           s:muted_wisteria_orchid, "NONE")
call s:HL("@type.qualifier",         s:heather_mist,     "NONE", "ITALIC")
call s:HL("@module",                 s:rosy_lavender,    "NONE")
hi! link @namespace @module

call s:HL("@keyword",                s:heather_mist,     "NONE", "BOLD")
hi! link @keyword.function @keyword
hi! link @keyword.return @keyword
hi! link @keyword.conditional @keyword
hi! link @keyword.repeat @keyword
call s:HL("@keyword.modifier",       s:heather_mist,     "NONE", "ITALIC")
call s:HL("@keyword.operator",       s:muted_lavender,   "NONE")
call s:HL("@keyword.import",         s:warm_stone,       "NONE")
call s:HL("@keyword.directive",      s:warm_stone,       "NONE")
call s:HL("@attribute",              s:warm_stone,       "NONE", "ITALIC")

call s:HL("@constant",               s:lavender_dream,   "NONE")
hi! link @constant.builtin @constant
call s:HL("@string",                 s:cool_mist,        "NONE")
call s:HL("@string.escape",          s:lilac,            "NONE")
hi! link @string.special @string.escape
call s:HL("@number",                 s:dusty_lilac,      "NONE")
hi! link @number.float @number
call s:HL("@boolean",                s:dusty_lilac,      "NONE", "ITALIC")
call s:HL("@operator",               s:muted_lavender,   "NONE")
call s:HL("@punctuation.delimiter",  s:dim_silver,       "NONE")
call s:HL("@punctuation.bracket",    s:dim_silver,       "NONE")
call s:HL("@punctuation.special",    s:rosy_lavender,    "NONE")
call s:HL("@comment",                s:comment,          "NONE", "ITALIC")

" LSP Semantic Tokens {{{1
hi! link @lsp.type.variable @variable
hi! link @lsp.type.parameter @variable.parameter
hi! link @lsp.type.property @variable.member
hi! link @lsp.type.function @function.call
hi! link @lsp.type.method @function.method.call
hi! link @lsp.typemod.function.declaration @function
hi! link @lsp.typemod.function.definition @function
hi! link @lsp.typemod.method.declaration @function.method
hi! link @lsp.typemod.method.definition @function.method
hi! link @lsp.type.macro @function.macro
hi! link @lsp.type.type @type
hi! link @lsp.type.class @type
hi! link @lsp.type.struct @type
hi! link @lsp.type.enum @type
hi! link @lsp.type.interface @type
hi! link @lsp.type.typeParameter @type
hi! link @lsp.type.enumMember @constant
hi! link @lsp.type.namespace @module
hi! link @lsp.type.keyword @keyword
hi! link @lsp.type.operator @operator
hi! link @lsp.type.decorator @attribute
call s:HL("LspInlayHint",            s:subtle_gray,      "NONE", "ITALIC")

" Diagnostics & Todos {{{1
call s:HL("Error",       s:red,          "NONE", "BOLD")
call s:HL("ErrorMsg",    s:white,        s:red,  "BOLD")
call s:HL("WarningMsg",  s:yellow,       "NONE", "BOLD")
call s:HL("Todo",        s:yellow,       "NONE", "BOLD", "BOLD,UNDERLINE")

call s:HL("DiagnosticError", s:red,         "NONE", "BOLD")
call s:HL("DiagnosticWarn",  s:yellow,      "NONE", "BOLD")
call s:HL("DiagnosticInfo",  s:muted_blue,  "NONE")
call s:HL("DiagnosticHint",  s:comment,     "NONE", "ITALIC")
call s:HL("DiagnosticOk",    s:muted_green, "NONE")
call s:HL("OkMsg",           s:muted_green, "NONE")

highlight DiagnosticUnderlineError gui=undercurl guisp=#CC5555 cterm=underline
highlight DiagnosticUnderlineWarn  gui=undercurl guisp=#CCCC55 cterm=underline
highlight DiagnosticUnderlineInfo  gui=undercurl guisp=#6B88B3 cterm=underline
highlight DiagnosticUnderlineHint  gui=undercurl guisp=#7C808C cterm=underline
highlight DiagnosticUnderlineOk    gui=undercurl guisp=#8FBC8F cterm=underline
highlight DiagnosticDeprecated     gui=strikethrough guisp=#CC5555

highlight SpellBad   gui=undercurl guisp=#CC5555 cterm=underline
highlight SpellCap   gui=undercurl guisp=#CCCC55 cterm=underline
highlight SpellRare  gui=undercurl guisp=#6B88B3 cterm=underline
highlight SpellLocal gui=undercurl guisp=#8FBC8F cterm=underline

" Diff, QuickFix & GitSigns {{{1
call s:HL("DiffAdd",      s:muted_green,    "NONE")
call s:HL("DiffDelete",   s:red,            "NONE")
call s:HL("DiffChange",   s:yellow,         "NONE")
call s:HL("DiffText",     s:white,          s:dark_gray2, "BOLD")

call s:HL("Added",        s:muted_green,    "NONE")
call s:HL("Removed",      s:red,            "NONE")
call s:HL("Changed",      s:muted_blue,     "NONE")
hi! link @diff.plus  Added
hi! link @diff.minus Removed
hi! link @diff.delta Changed

call s:HL("QuickFixLine", s:smoky_amethyst, s:dark_gray1, "BOLD")

call s:HL("GitSignsAdd",    s:muted_green,    "NONE")
call s:HL("GitSignsChange", s:smoky_amethyst, "NONE")
call s:HL("GitSignsDelete", s:red,            "NONE")

" Interface Elements {{{1
call s:HL("Cursor",       "NONE",        "NONE", "reverse", "reverse")
call s:HL("CursorLine",   s:light_gray2, s:dark_gray1, "NONE")
hi! link CursorColumn CursorLine
call s:HL("Visual",       "NONE",        "NONE", "reverse", "reverse")
hi! link VisualNOS Visual

call s:HL("IncSearch",    "NONE",        "NONE", "reverse", "reverse")
call s:HL("Search",       "NONE",        "NONE", "reverse", "reverse")
call s:HL("MatchParen",   "NONE",        "NONE", "reverse", "reverse")

call s:HL("Pmenu",        s:light_gray2, s:dark_gray2)
call s:HL("PmenuSel",     "NONE",        "NONE", "reverse", "reverse")
call s:HL("PmenuSbar",    s:med_gray1,   s:dark_gray1)
call s:HL("PmenuThumb",   s:comment,     s:med_gray1)

call s:HL("NormalFloat",  s:light_gray2,    s:float_bg)
call s:HL("FloatBorder",  s:med_gray1,      "NONE")
call s:HL("FloatTitle",   s:smoky_amethyst, "NONE", "BOLD")

call s:HL("StatusLine",   "NONE",        "NONE", "reverse", "reverse")
call s:HL("StatusLineNC", s:comment,     s:dark_gray1, "NONE")
call s:HL("TabLine",      s:comment,     s:dark_gray1)
call s:HL("TabLineFill",  s:comment,     s:dark_gray1)
call s:HL("TabLineSel",   "NONE",        "NONE", "reverse", "reverse")

call s:HL("VertSplit",    s:dark_gray2,  "NONE")
call s:HL("WinSeparator", s:dark_gray2,  "NONE")
call s:HL("LineNr",       s:med_gray2,   "NONE")
call s:HL("Folded",       s:comment,     s:dark_gray1, "NONE")

call s:HL("ModeMsg",      s:white,       "NONE", "BOLD")
call s:HL("MoreMsg",      s:muted_green, "NONE", "BOLD")
call s:HL("Question",     s:muted_green, "NONE", "BOLD")
call s:HL("WildMenu",     "NONE",        "NONE", "reverse", "reverse")

" Plugin UI (Telescope, blink.cmp) {{{1
call s:HL("TelescopeBorder",       s:med_gray1,      "NONE")
call s:HL("TelescopePromptTitle",  s:smoky_amethyst, "NONE", "BOLD")
call s:HL("TelescopeResultsTitle", s:smoky_amethyst, "NONE", "BOLD")
call s:HL("TelescopePreviewTitle", s:smoky_amethyst, "NONE", "BOLD")
call s:HL("TelescopeMatching",     s:lilac,          "NONE", "BOLD")

call s:HL("BlinkCmpMenu",                s:light_gray2, s:float_bg)
call s:HL("BlinkCmpMenuBorder",          s:med_gray1,   "NONE")
call s:HL("BlinkCmpDocBorder",           s:med_gray1,   "NONE")
call s:HL("BlinkCmpSignatureHelpBorder", s:med_gray1,   "NONE")
call s:HL("BlinkCmpGhostText",           s:subtle_gray, "NONE", "ITALIC")

call s:HL("NvimTreeGitNewIcon",     s:muted_green, "NONE")
call s:HL("NvimTreeGitStagedIcon",  s:muted_green, "NONE")
call s:HL("NvimTreeGitDeletedIcon", s:red,         "NONE")
call s:HL("NvimTreeGitMergeIcon",   s:red,         "NONE")
call s:HL("NvimTreeGitDirtyIcon",   s:yellow,      "NONE")
call s:HL("NvimTreeGitRenamedIcon", s:yellow,      "NONE")

call s:HL("NeotestPassed",  s:muted_green, "NONE")
call s:HL("NeotestFailed",  s:red,         "NONE")
call s:HL("NeotestRunning", s:yellow,      "NONE")
call s:HL("NeotestSkipped", s:muted_blue,  "NONE")

" Embedded Terminal Palette (Ghostty match) {{{1
let g:terminal_color_0  = "#282828"
let g:terminal_color_1  = "#cc5555"
let g:terminal_color_2  = "#8fbc8f"
let g:terminal_color_3  = "#f0ebd2"
let g:terminal_color_4  = "#6b88b3"
let g:terminal_color_5  = "#debfff"
let g:terminal_color_6  = "#d8d8d8"
let g:terminal_color_7  = "#e8e8e8"
let g:terminal_color_8  = "#383838"
let g:terminal_color_9  = "#cc5555"
let g:terminal_color_10 = "#60d060"
let g:terminal_color_11 = "#cccc55"
let g:terminal_color_12 = "#c0c0c0"
let g:terminal_color_13 = "#d0d0d0"
let g:terminal_color_14 = "#e0e0e0"
let g:terminal_color_15 = "#f0f0f0"

" Other {{{1
call s:HL("Directory",   s:lilac,          "NONE")
call s:HL("Title",       s:white,          "NONE", "BOLD")
call s:HL("Underlined",  s:smoky_amethyst, "NONE", "UNDERLINE")
call s:HL("Ignore",      s:comment,         "NONE")

" Cleanup helper function {{{1
delfunction s:HL

" vim: fdm=marker
