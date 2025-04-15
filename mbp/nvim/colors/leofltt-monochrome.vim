" vim: fdm=marker

" Name:     leofltt-monochrome
" Author:   LeoFltt
" License:  MIT
" Version:  1.1

" Initialization {{{1
hi clear
if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "leofltt-monochrome"
set background=dark

" Palette {{{1
" Grays / Whites (Dark to Light)
let s:black      = { "gui": "#000000", "cterm": "black", "ctermN": 0 }
let s:dark_gray1 = { "gui": "#222222", "cterm": "235",   "ctermN": 235 } " Backgrounds
let s:dark_gray2 = { "gui": "#333333", "cterm": "236",   "ctermN": 236 } " Backgrounds
let s:med_gray1  = { "gui": "#555555", "cterm": "240",   "ctermN": 240 } " Medium
let s:med_gray2  = { "gui": "#888888", "cterm": "102",   "ctermN": 102 } " Comments Darker? UI?
let s:comment    = { "gui": "#A0A0A0", "cterm": "grey",  "ctermN": 7 }   " Comments / Dim Text
let s:light_gray1= { "gui": "#C0C0C0", "cterm": "250",   "ctermN": 250 } " Silver / Code Gray
let s:light_gray2= { "gui": "#DCDCDC", "cterm": "252",   "ctermN": 252 } " Gainsboro / Normal Code
let s:off_white  = { "gui": "#EAEAEA", "cterm": "254",   "ctermN": 254 } " Visual BG / Bright Gray
let s:white      = { "gui": "#FFFFFF", "cterm": "white", "ctermN": 15 }  " Brightest Code / UI FG

" Muted Accent Colors
let s:red        = { "gui": "#CC5555", "cterm": "167",   "ctermN": 167 } " Error / Deletion
let s:yellow     = { "gui": "#CCCC55", "cterm": "179",   "ctermN": 179 } " Warning / Change
let s:green      = { "gui": "#60D060", "cterm": "71",    "ctermN": 71 }  " Success / Addition
let s:blue       = { "gui": "#5588CC", "cterm": "68",    "ctermN": 68 }  " Info / Functions?
let s:magenta    = { "gui": "#CC55CC", "cterm": "176",   "ctermN": 176 } " Special / Types?
let s:purple = { "gui": "#C060C8", "cterm": "175", "ctermN": 175 } " Purple (Slightly Muted)"
let s:muted_purple = { "gui": "#A020F0", "cterm": "94", "ctermN": 94 }
let s:lilac = { "gui": "#D3B1E6", "cterm": "175", "ctermN": 175 }
let s:muted_lilac1 = { "gui": "#F0EBD2", "cterm": "228", "ctermN": 228 }
let s:muted_lilac2 = { "gui": "#E6E2CC", "cterm": "235", "ctermN": 235 }
let s:muted_lilac3 = { "gui": "#DEBFFF", "cterm": "226", "ctermN": 226 }
let s:darker_purple = { "gui": "#7014A6", "cterm": "92", "ctermN": 92 }
let s:muted_green = { "gui": "#8FBC8F", "cterm": "142", "ctermN": 142 }

" Helper function to define highlights {{{1
function! s:HL(group, fg, bg, ...)
  let gui_attr = get(a:, 1, "NONE")
  let cterm_attr = get(a:, 2, "NONE")

  let fg_gui = type(a:fg) == type({}) ? a:fg.gui : "NONE"
  let fg_cterm = type(a:fg) == type({}) ? a:fg.ctermN : "NONE"
  let bg_gui = type(a:bg) == type({}) ? a:bg.gui : "NONE"
  let bg_cterm = type(a:bg) == type({}) ? a:bg.ctermN : "NONE"

  let cmd = "highlight " . a:group
  let cmd .= " guifg=" . fg_gui
  let cmd .= " guibg=" . bg_gui
  let cmd .= " ctermfg=" . fg_cterm
  let cmd .= " ctermbg=" . bg_cterm
  let cmd .= " gui=" . gui_attr
  let cmd .= " cterm=" . cterm_attr

  " Make NONE explicit if needed for background, default otherwise
  if bg_gui == 'NONE' && bg_cterm == 'NONE'
      let cmd .= " guibg=NONE ctermbg=NONE"
  endif

  execute cmd
endfunction

" Syntax Highlighting {{{1

" Basic Code Elements
call s:HL("Normal",      s:light_gray2, s:black)       " Default text - light gray on black
call s:HL("Comment",     s:comment,     s:black,      "ITALIC") " Comments - medium gray, italic
call s:HL("Identifier",  s:muted_lilac1, s:black)       " Variable names, etc. - same as Normal
call s:HL("Function",    s:muted_lilac2,        s:black,      "BOLD")   " Function names - muted blue, bold
call s:HL("Statement",   s:white,       s:black,      "BOLD")   " Keywords like if, for, while - white, bold
hi! link Keyword Statement                                     " Link Keyword to Statement
hi! link Structure Statement                                   " Link Structure (struct, class) to Statement
hi! link PreProc Statement                                     " Preprocessor directives (#include)
call s:HL("Type",        s:muted_lilac3,     s:black,      "NONE")   " Data types (int, char, string) - muted magenta
hi! link StorageClass Type                                     " Link storage class (static, extern) to Type
hi! link Label Type                                            " Labels

" Literals
call s:HL("Constant",    s:purple,       s:black)       " Constants (true, false, NULL), Enums
call s:HL("String",      s:light_gray1, s:black)       " String literals - slightly darker than white
call s:HL("Character",   s:light_gray1, s:black)       " Character literals
call s:HL("Number",      s:light_gray1, s:black)       " Numbers (integers, floats)
call s:HL("Boolean",     s:white,       s:black,      "ITALIC") " true, false explicitly if needed

" Special Syntax Elements
call s:HL("Special",     s:lilac,     s:black,      "BOLD")   " Special symbols/syntax elements - magenta, bold
call s:HL("SpecialKey",  s:comment,     s:black,      "ITALIC") " Unprintable chars in text - comment color, italic
call s:HL("NonText",     s:comment,     s:black)       " Chars like trailing spaces, end-of-line markers
call s:HL("Delimiter",   s:light_gray2, s:black)       " Parentheses, braces, brackets
call s:HL("Operator",    s:white,       s:black)       " +, -, *, /, =, etc. - white

" Specific Language Elements (Examples - Add more as needed)
hi! link rubySymbol String                                     " Ruby symbols like strings
hi! link htmlTagN Normal                                       " HTML tag names - use Normal
hi! link cucumberTags Statement                                " Cucumber tags like statements

" Diagnostics & Todos {{{1
call s:HL("Error",       s:red,         s:black,      "BOLD")   " Errors - muted red, bold
call s:HL("ErrorMsg",    s:white,       s:red,        "BOLD")   " Error messages (often in cmdline) - white text on red bg
call s:HL("WarningMsg",  s:yellow,      s:black,      "BOLD")   " Warnings - muted yellow, bold
call s:HL("Todo",        s:yellow,      s:black,      "BOLD", "BOLD,UNDERLINE") " TODO, FIXME - yellow, bold, underline

" CoC / LSP Diagnostics (Link to base Error/Warning or define explicitly)
hi! link DiagnosticError Error
hi! link DiagnosticWarn WarningMsg
call s:HL("DiagnosticInfo", s:blue,     s:black)
call s:HL("DiagnosticHint", s:comment,  s:black, "ITALIC")

" Diff Mode {{{1
call s:HL("DiffAdd",     s:green,       s:black)       " Added lines - muted green text
call s:HL("DiffDelete",  s:red,         s:black)       " Deleted lines - muted red text
call s:HL("DiffChange",  s:yellow,      s:black)       " Changed lines - muted yellow text
call s:HL("DiffText",    s:white,       s:dark_gray2, "BOLD") " Text inside changed lines - white on dark gray, bold

" Interface Elements {{{1

" Cursor & Selection
call s:HL("Cursor",      s:black,       s:off_white,  "ITALIC") " Block cursor - black text on off-white, italic
call s:HL("CursorLine",  s:light_gray2, s:dark_gray1, "NONE")   " Background of cursor line - subtle dark gray
hi! link CursorColumn CursorLine                               " Highlight cursor column same as line
call s:HL("Visual",      s:black,       s:off_white,  "ITALIC") " Visual selection - black text on off-white, italic
hi! link VisualNOS Visual                                      " Non-owned visual selection

" Search & Matching
call s:HL("IncSearch",   s:black,       s:yellow,     "BOLD")   " Incremental search highlight - black text on yellow bg
call s:HL("Search",      s:black,       s:med_gray1,  "NONE")   " Regular search highlight - black text on medium gray bg
call s:HL("MatchParen",  s:white,       s:med_gray1,  "BOLD")   " Matching parenthesis - white text on medium gray bg, bold

" Pop-up Menu (Completion Menu)
call s:HL("Pmenu",       s:light_gray2, s:dark_gray2)  " Normal item - light gray text on dark gray bg
call s:HL("PmenuSel",    s:white,       s:blue,       "BOLD")   " Selected item - white text on muted blue bg, bold
call s:HL("PmenuSbar",   s:med_gray1,   s:dark_gray1)  " Scrollbar background
call s:HL("PmenuThumb",  s:comment,     s:med_gray1)   " Scrollbar thumb

" Status Line & Tab Line
call s:HL("StatusLine",  s:white,       s:dark_gray2, "BOLD")   " Status line, current window - white on dark gray, bold
call s:HL("StatusLineNC",s:comment,     s:dark_gray1, "NONE")   " Status line, non-current window - comment gray on darker gray
call s:HL("TabLine",     s:comment,     s:dark_gray1)  " Tab labels, non-selected
call s:HL("TabLineFill", s:comment,     s:dark_gray1)  " Tab line empty space
call s:HL("TabLineSel",  s:white,       s:dark_gray2, "BOLD")   " Selected tab label (same as StatusLine)

" Borders & separators
call s:HL("VertSplit",   s:dark_gray2,  s:black)       " Vertical window separator - dark gray on black
call s:HL("LineNr",      s:med_gray2,   s:black)       " Line numbers - medium dark gray
call s:HL("Folded",      s:comment,     s:dark_gray1, "NONE")   " Folded text marker - comment color on dark gray bg

" Command line & Messages
call s:HL("ModeMsg",     s:white,       s:black,      "BOLD")   " Mode messages (-- INSERT --)
call s:HL("MoreMsg",     s:muted_green,       s:black,      "BOLD")   " More prompt
call s:HL("Question",    s:muted_green,       s:black,      "BOLD")   " Question prompt
call s:HL("WildMenu",    s:white,       s:muted_lilac3,       "BOLD")   " Wildmenu completion selection (like PmenuSel)

" Other
call s:HL("Directory",   s:lilac,        s:black)       " Directory names
call s:HL("Title",       s:white,       s:black,      "BOLD")   " Titles (:set title)
call s:HL("Underlined",  s:muted_lilac1,        s:black,      "UNDERLINE") " Underlined text
call s:HL("Ignore",      s:comment,     s:black)       " Ignored text (e.g., some diffs)

" Cleanup helper function {{{1
delfunction s:HL

" vim: fdm=marker
