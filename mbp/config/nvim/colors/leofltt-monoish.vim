" vim: fdm=marker

" Name:      leofltt-monoish
" Author:    LeoFltt
" License:   MIT
" Version:   1.3 (Corrected for terminal background transparency)

" Initialization {{{1
hi clear
if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "leofltt-monoish"
set background=dark
" Enable true colors in the terminal if supported, crucial for GUI colors
set termguicolors

" Palette {{{1
" Grays / Whites (Dark to Light)
let s:black       = { "gui": "#000000", "cterm": "black", "ctermN": 0 }
let s:dark_gray1  = { "gui": "#222222", "cterm": "235",   "ctermN": 235 } " Backgrounds
let s:dark_gray2  = { "gui": "#333333", "cterm": "236",   "ctermN": 236 } " Backgrounds
let s:med_gray1   = { "gui": "#555555", "cterm": "240",   "ctermN": 240 } " Medium
let s:med_gray2   = { "gui": "#888888", "cterm": "102",   "ctermN": 102 } " Comments Darker? UI?
let s:comment     = { "gui": "#A0A0A0", "cterm": "grey",  "ctermN": 7 }   " Comments / Dim Text
let s:light_gray1 = { "gui": "#C0C0C0", "cterm": "250",   "ctermN": 250 } " Silver / Code Gray
let s:light_gray2 = { "gui": "#DCDCDC", "cterm": "252",   "ctermN": 252 } " Gainsboro / Normal Code
let s:off_white   = { "gui": "#EAEAEA", "cterm": "254",   "ctermN": 254 } " Visual BG / Bright Gray
let s:white       = { "gui": "#FFFFFF", "cterm": "white", "ctermN": 15 }  " Brightest Code / UI FG

" Muted Accent Colors
let s:red         = { "gui": "#CC5555", "cterm": "167",   "ctermN": 167 } " Error / Deletion
let s:yellow      = { "gui": "#CCCC55", "cterm": "179",   "ctermN": 179 } " Warning / Change
let s:green       = { "gui": "#60D060", "cterm": "71",    "ctermN": 71 }  " Success / Addition
let s:blue        = { "gui": "#5588CC", "cterm": "68",    "ctermN": 68 }  " Info / Functions?
let s:magenta     = { "gui": "#CC55CC", "cterm": "176",   "ctermN": 176 } " Special / Types?
let s:purple = { "gui": "#C060C8", "cterm": "175", "ctermN": 175 } " Purple (Slightly Muted)"
let s:muted_purple = { "gui": "#A020F0", "cterm": "94", "ctermN": 94 }
let s:lilac = { "gui": "#D3B1E6", "cterm": "175", "ctermN": 175 }
let s:muted_lilac1 = { "gui": "#F0EBD2", "cterm": "228", "ctermN": 228 }
let s:muted_lilac2 = { "gui": "#E6E2CC", "cterm": "235", "ctermN": 235 }
let s:muted_lilac3 = { "gui": "#DEBFFF", "cterm": "226", "ctermN": 226 }
let s:darker_purple = { "gui": "#7014A6", "cterm": "92", "ctermN": 92 }
let s:muted_green = { "gui": "#8FBC8F", "cterm": "142", "ctermN": 142 }
let s:muted_blue = { "gui": "#6B88B3", "cterm": "67",    "ctermN": 67 }
let s:muted_purp = { "gui": "#95619B", "cterm": "96", "ctermN": 96 }
let s:dusky_violet = { "gui": "#79619B", "cterm": "60", "ctermN": 60 }
let s:soft_indigo = { "gui": "#947FE0", "cterm": "104", "ctermN": 104 }
let s:lilac_bloom = { "gui": "#C57FE0", "cterm": "177", "ctermN": 177 }
let s:lavender_dream    = { "gui": "#AD9FDD", "cterm": "146", "ctermN": 146 }
let s:cool_periwinkle  = { "gui": "#9FB1DD", "cterm": "110", "ctermN": 110 }
let s:heather_mist      = { "gui": "#9899B7", "cterm": "103", "ctermN": 103 }
let s:rosy_lavender    = { "gui": "#A698B7", "cterm": "139", "ctermN": 139 }


" Helper function to define highlights {{{1
" This function is modified to handle 'reverse' attribute.
" If 'reverse' is present in gui_attr or cterm_attr,
" it will override explicit fg/bg colors and set them to NONE.
function! s:HL(group, fg, bg, ...)
  let gui_attr_input = get(a:, 1, "NONE")
  let cterm_attr_input = get(a:, 2, "NONE")

  " Check if 'reverse' attribute is requested (case-insensitive)
  let is_reverse = (stridx(tolower(gui_attr_input), 'reverse') != -1 || stridx(tolower(cterm_attr_input), 'reverse') != -1)

  let fg_gui = "NONE"
  let fg_cterm = "NONE"
  let bg_gui = "NONE"
  let bg_cterm = "NONE"
  let gui_attr_final = gui_attr_input
  let cterm_attr_final = cterm_attr_input

  if !is_reverse
    " Only apply explicit fg/bg if not reversing
    " If a:fg or a:bg is the string "NONE", use that directly.
    " Otherwise, extract from the dictionary.
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

" Basic Code Elements
" *** IMPORTANT CHANGE HERE ***
" Set Normal background to "NONE" to allow terminal transparency.
" This tells Neovim not to draw a background color for the main editor.
call s:HL("Normal",      s:light_gray2, "NONE")        " Default text - light gray, transparent background

call s:HL("Comment",     s:comment,     "NONE",       "ITALIC") " Comments - medium gray, italic
call s:HL("Identifier",  s:muted_lilac1, "NONE")        " Variable names, etc. - same as Normal
call s:HL("Function",    s:muted_lilac2, "NONE",       "BOLD")    " Function names - muted blue, bold
call s:HL("Statement",   s:heather_mist, "NONE",       "BOLD")    " Keywords like if, for, while - white, bold
hi! link Keyword Statement                                          " Link Keyword to Statement
hi! link Structure Statement                                        " Link Structure (struct, class) to Statement
hi! link PreProc Statement                                          " Preprocessor directives (#include)
call s:HL("Type",        s:muted_lilac3,      "NONE",       "NONE")    " Data types (int, char, string) - muted magenta
hi! link StorageClass Type                                          " Link storage class (static, extern) to Type
hi! link Label Type                                                 " Labels

" Literals
call s:HL("Constant",    s:rosy_lavender,       "NONE")        " Constants (true, false, NULL), Enums
call s:HL("String",      s:light_gray1, "NONE")        " String literals - slightly darker than white
call s:HL("Character",   s:light_gray1, "NONE")        " Character literals
call s:HL("Number",      s:light_gray1, "NONE")        " Numbers (integers, floats)
call s:HL("Boolean",     s:light_gray1,         "NONE",       "ITALIC") " true, false explicitly if needed

" Special Syntax Elements
call s:HL("Special",     s:lilac,       "NONE",       "BOLD")    " Special symbols/syntax elements - magenta, bold
call s:HL("SpecialKey",  s:comment,     "NONE",       "ITALIC") " Unprintable chars in text - comment color, italic
call s:HL("NonText",     s:comment,     "NONE")        " Chars like trailing spaces, end-of-line markers
call s:HL("Delimiter",   s:light_gray2, "NONE")        " Parentheses, braces, brackets
call s:HL("Operator",    s:lilac_bloom, "NONE")        " +, -, *, /, =, etc. - white


" Specific Language Elements (Examples - Add more as needed)
hi! link rubySymbol String                                          " Ruby symbols like strings
hi! link htmlTagN Normal                                            " HTML tag names - use Normal
hi! link cucumberTags Statement                                     " Cucumber tags like statements

" Diagnostics & Todos {{{1
call s:HL("Error",       s:red,         "NONE",       "BOLD")    " Errors - muted red, bold
call s:HL("ErrorMsg",    s:white,       s:red,         "BOLD")    " Error messages (often in cmdline) - white text on red bg
call s:HL("WarningMsg",  s:yellow,      "NONE",       "BOLD")    " Warnings - muted yellow, bold
call s:HL("Todo",        s:yellow,      "NONE",       "BOLD", "BOLD,UNDERLINE") " TODO, FIXME - yellow, bold, underline

" CoC / LSP Diagnostics (Link to base Error/Warning or define explicitly)
hi! link DiagnosticError Error
hi! link DiagnosticWarn WarningMsg
call s:HL("DiagnosticInfo", s:muted_blue,      "NONE")
call s:HL("DiagnosticHint", s:comment,  "NONE", "ITALIC")

" Diff Mode {{{1
call s:HL("DiffAdd",     s:muted_green,         "NONE")        " Added lines - muted green text
call s:HL("DiffDelete",  s:red,         "NONE")        " Deleted lines - muted red text
call s:HL("DiffChange",  s:yellow,      "NONE")        " Changed lines - muted yellow text
call s:HL("DiffText",    s:white,       s:dark_gray2, "BOLD") " Text inside changed lines - white on dark gray, bold

" Interface Elements {{{1

" Cursor & Selection
" Changed to use 'reverse' for inverted highlighting
call s:HL("Cursor",      "NONE",        "NONE",        "reverse", "reverse") " Block cursor - inverted
call s:HL("CursorLine",  s:light_gray2, s:dark_gray1, "NONE")    " Background of cursor line - subtle dark gray
hi! link CursorColumn CursorLine                                   " Highlight cursor column same as line
" Changed to use 'reverse' for inverted highlighting
call s:HL("Visual",      "NONE",        "NONE",        "reverse", "reverse") " Visual selection - inverted
hi! link VisualNOS Visual                                           " Non-owned visual selection

" Search & Matching
" Changed to use 'reverse' for inverted highlighting
call s:HL("IncSearch",   "NONE",        "NONE",        "reverse", "reverse") " Incremental search highlight - inverted
" Changed to use 'reverse' for inverted highlighting
call s:HL("Search",      "NONE",        "NONE",        "reverse", "reverse") " Regular search highlight - inverted
" Changed to use 'reverse' for inverted highlighting
call s:HL("MatchParen",  "NONE",        "NONE",        "reverse", "reverse") " Matching parenthesis - inverted

" Pop-up Menu (Completion Menu)
call s:HL("Pmenu",       s:light_gray2, s:dark_gray2)  " Normal item - light gray text on dark gray bg
" Changed to use 'reverse' for inverted highlighting
call s:HL("PmenuSel",    "NONE",        "NONE",        "reverse", "reverse") " Selected item - inverted
call s:HL("PmenuSbar",   s:med_gray1,   s:dark_gray1)  " Scrollbar background
call s:HL("PmenuThumb",  s:comment,     s:med_gray1)   " Scrollbar thumb

" Status Line & Tab Line
" Changed to use 'reverse' for inverted highlighting
call s:HL("StatusLine",  "NONE",        "NONE",        "reverse", "reverse") " Status line, current window - inverted
call s:HL("StatusLineNC",s:comment,     s:dark_gray1, "NONE")    " Status line, non-current window - comment gray on darker gray
call s:HL("TabLine",     s:comment,     s:dark_gray1)  " Tab labels, non-selected
call s:HL("TabLineFill", s:comment,     s:dark_gray1)  " Tab line empty space
" Changed to use 'reverse' for inverted highlighting
call s:HL("TabLineSel",  "NONE",        "NONE",        "reverse", "reverse") " Selected tab label (same as StatusLine)

" Borders & separators
call s:HL("VertSplit",   s:dark_gray2,  "NONE")        " Vertical window separator - dark gray on transparent
call s:HL("LineNr",      s:med_gray2,   "NONE")        " Line numbers - medium dark gray on transparent
call s:HL("Folded",      s:comment,     s:dark_gray1, "NONE")    " Folded text marker - comment color on dark gray bg

" Command line & Messages
call s:HL("ModeMsg",     s:white,       "NONE",       "BOLD")    " Mode messages (-- INSERT --)
call s:HL("MoreMsg",     s:muted_green,         "NONE",       "BOLD")    " More prompt
call s:HL("Question",    s:muted_green,         "NONE",       "BOLD")    " Question prompt
" Changed to use 'reverse' for inverted highlighting
call s:HL("WildMenu",    "NONE",        "NONE",        "reverse", "reverse") " Wildmenu completion selection (like PmenuSel)

" Other
call s:HL("Directory",   s:lilac,         "NONE")        " Directory names
call s:HL("Title",       s:white,       "NONE",       "BOLD")    " Titles (:set title)
call s:HL("Underlined",  s:muted_lilac1,          "NONE",       "UNDERLINE") " Underlined text
call s:HL("Ignore",      s:comment,     "NONE")        " Ignored text (e.g., some diffs)

" Cleanup helper function {{{1
delfunction s:HL

" vim: fdm=marker

