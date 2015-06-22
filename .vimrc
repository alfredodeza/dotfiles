""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins_Included:
"   > Pathogen.vim
"     Better Management of VIM plugins
"
"   > Chapa.vim
"     Moves to, or visually selects, or toggles comments on the
"     next/previous N function,method or class.
"
"   > GunDo.vim
"     Visual Undo in vim with diff's to check the differences
"
"   > Pytest.vim
"     Runs your Python tests in Vim.
"
"   > Konira.vim
"     Same as pytest.vim but for Konira-based files/tests
"
"   > Commant-T.vim
"     Allows easy search and opening of files within a given path
"
"   > Snipmate.vim
"     Configurable snippets to avoid re-typing common comands
"
"   > PyFlakes.vim
"     Underlines and displays errors with Python on-the-fly
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible

" Pathogen needs to be first to init all plugins
silent! call pathogen#infect()

set nowritebackup                           " Hate backups
set noswapfile                              " ...and swap files

" setting smartindent is depracated and breaks stuff
" unset it  regardless
set nosmartindent

" Fixes Comenting hash indentation
inoremap # X<BS>#

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Display
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set background=dark
if has("gui_running")
  let g:solarized_contrast='low'
else
  let g:solarized_contrast='high'
  let g:solarized_termtrans = 1
endif

colorscheme tomorrow-night


" terminal width
set wrap
set textwidth=79
set formatoptions=qrn1

syntax on                                  " always want syntax highlighting
filetype on                                " enables filetype detection
filetype plugin on                         " enables filetype specific plugins
filetype indent on                         " respect filetype indentation

set scrolloff=5                            " keep some more lines for scope

set backspace=indent,eol,start             " fixes odd backspace behavior
set vb

" GUI Stuff
if has("gui_running")
  set guifont=Ubuntu\ Mono:h17             " Font and Font Size
  highlight Statement gui=italic
  highlight pythonStatement gui=italic
  set go-=T                                " No toolbar
  set guioptions-=L                        " No scrollbar
  set guioptions-=r
  "set lines=999 columns=999                " open as large as possible
  highlight SpellBad gui=undercurl guisp=Orange
else
    set mouse=n
endif

" A status bar that shows nice information
set laststatus=2
set encoding=utf-8

" All status line
set statusline+=%*                           " switch back to normal status color
set statusline+=%{bondsman#Bail()}%*       " give me a branch name (is modified?)
set statusline+=%#ErrorMsg#                   " set the highlight to error
set statusline+=%{khuno#Status()}%*          " Tell me how many Flake errors I have
set statusline+=%*                           " switch back to normal status color
set statusline+=%{Collapse(expand('%:p'))}   " absolute path truncated
set statusline+=%m                           " are you modified?
set statusline+=%r                           " are you read only?
set statusline+=%h                           " is it a help file
set statusline+=%w                           " are we in a preview window
set statusline+=\ \ \ %{Collapse(Getcwd())}  " current working dir truncated
set statusline+=%=                           " right align
set statusline+=\ \ \ \ %y                   " what the file type
set statusline+=[                            "
set statusline+=\ Line:                      "
set statusline+=%3l/                         " Line number with padding
set statusline+=%L                           " Total lines in the file
set statusline+=:%2c                         " column number
set statusline+=]                            "

" Searching
set ignorecase
set smartcase

" These will make it so that going to the next one in a
" search will center on the line it's found in.
map N Nzz
map n nzz

set title                                  " Get the title right

set hlsearch                               " Highlight search on

set wildmode=list:longest,full             " Menus like bash/zsh
set wildmenu

" insert completion
set completeopt=menuone,longest            " Completion that follows your typing
set pumheight=6                            " Show 6 items at the most

set showcmd                                " Let me know what command I'm typing
set mousehide                              " When I go into insert mode, hide the mouse
set nocursorline                           " Don't highlight where the cursor is
set shellcmdflag=-c                       " Tell the shell it is OK not to be interactive

" default to 4 spaces of indentation
set tabstop=4 expandtab shiftwidth=4 softtabstop=4

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Autocommands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Remember cursor position
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" Detect test files and apply according syntax
autocmd BufNewFile,BufRead,BufEnter *.py call s:SelectTestRunner()

" For xml, xhtml and html let's use 2 spaces of indentation
autocmd FileType html,xhtml,xml,yaml,yml setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
"autocmd FileType html call s:SelectSyntax()

" For VimL do 2 spaces as well
autocmd FileType vim setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2

" Less should look like CSS, right?
autocmd BufNewFile,BufRead *.less setlocal ft=css

" modula is not really modula, it is markdown
autocmd BufNewFile,BufRead *.md setlocal ft=markdown

" For Makefilels let's use tabs
autocmd FileType make setlocal shiftwidth=4 tabstop=4 softtabstop=4

" Template Autodetection
autocmd BufNewFile,BufRead *.mako,*.mak setlocal ft=html

" JSON Syntax
autocmd BufNewFile,BufRead *.json call jacinto#syntax()

" Python whitespace
au FileType python setlocal tabstop=4 expandtab shiftwidth=4 softtabstop=4

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Movement Settings and Mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" move one line at a time regardless
" of wrapping
nnoremap j gj
nnoremap k gk

set virtualedit=block                      " follow the block in virtual block selections

" bang bang to sudo save a file
cmap w!! %!sudo tee > /dev/null %

" It is so much fun to nuke these ones
" that I am adding them back. No arrow keys!
nnoremap <down>  <nop>
nnoremap <left>  <nop>
nnoremap <right> <nop>
nnoremap <up>    <nop>
inoremap <up>    <nop>
inoremap <down>  <nop>
inoremap <left>  <nop>
inoremap <right> <nop>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Other Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set clipboard=unnamed                      " copies y, yy, d, D, dd and other to the
                                           " system clipboard


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin specific options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Chapa
let g:chapa_default_mappings = 1

" Posero
let g:posero_default_mappings = 1

set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*.pyc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Python
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" hide some files and remove stupid help
let g:netrw_list_hide='^\.,.\(pyc\|pyo\|o\)$'

" Let Ack highlight when I search
let g:ackhighlight = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Custom Commands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vertical Split Buffer
command! -nargs=1 -complete=buffer Vbuffer call VerticalSplitBuffer(<f-args>)

" Edit Vimrc
command!  Vimrc :e $MYVIMRC

" Reload/Source vimrc
command! Reload :so $MYVIMRC | :filetype detect | :call Echo("re-sourced ~/.vimrc")

" Git commit add
command! Gca call Gca()

" Git commit add all
command! Gcall call Gcall()

" Git Push
command! Gp exe 'Git push'

" I really can't be bothered with these:
cmap WQ wq
cmap Wq wq
cmap Q q

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Make sure we use a better leader key
let mapleader   = ","
let g:mapleader = ","

" surround
nnoremap <silent> s :set opfunc=Surround<cr>g@
vnoremap <silent> s :<c-u>call Surround(visualmode(), 1)<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Leaders
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Underline Titles
nnoremap <Leader>1 yypVr=
nnoremap <Leader>2 yypVr-

" Count current word
nmap <Leader>w <Esc>:call Count(expand("<cword>"))<CR>

" gundo
nnoremap <Leader>u <ESC>:GundoToggle<CR>

" Insert blank lines and stay in normal mode dude
" blank line  below
nnoremap <Leader>l <ESC>:put =''<CR>

" blank line  above
nnoremap <Leader>,l <ESC>:put! =''<CR>

" Ctrl-P
nmap <Leader>p <Esc>:CtrlP<CR>

" toggle number
nnoremap <Leader>n <Esc>:call ToggleNumber()<CR>

" toggle relative number
nnoremap <Leader>r <Esc>:call ToggleRelativeNumber()<CR>

" set hls / nohls
nnoremap <Leader>s <Esc>:set hls!<CR>

" visual select last paste
nnoremap <Leader>v  V`]

" format xml
nmap <Leader>x <Esc>:call FormatXML()<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" In certain situations, it allows you to echo something without
" having to hit Return again to do exec the command.
function! Echo(msg)
  let x=&ruler | let y=&showcmd
  set noruler noshowcmd
  redraw
  echo a:msg
  let &ruler=x | let &showcmd=y
endfun

" Count number of occurances of a word
function! Count(word)
    let count_word = "%s/" . a:word . "//gn"
    execute count_word
endfunction

" Replace the deleted text with surrounding char
" InputChar and Surround are my attempt at playing with
" custom motions in Vim. This is not intended to replace
" tpope's surround.vim which does 10K more things and better
" For reference see
" http://stackoverflow.com/questions/8994276/mapping-a-new-motion-in-vim-with-a-required-parameter
function! InputChar()
    let c = getchar()
    let c = type(c) == type(0) ? nr2char(c) : c
    return c
endfunction


function! Surround(vt, ...)
    let s = InputChar()
    if s =~ "\<esc>" || s =~ "\<c-c>"
        return
    endif
    let [sl, sc] = getpos(a:0 ? "'<" : "'[")[1:2]
    let [el, ec] = getpos(a:0 ? "'>" : "']")[1:2]
    if a:vt == 'line' || a:vt == 'V'
        call append(el, s)
        call append(sl-1, s)
    elseif a:vt == 'block' || a:vt == "\<c-v>"
        exe sl.','.el 's/\%'.sc.'c\|\%'.ec.'c.\zs/\=s/g|norm!``'
    else
        exe el 's/\%'.ec.'c.\zs/\=s/|norm!``'
        exe sl 's/\%'.sc.'c/\=s/|norm!``'
    endif
endfunction


" Vertical Split Buffer
function! VerticalSplitBuffer(buffer)
    let split_command = "vert belowright sb " . a:buffer
    execute split_command
    execute 'wincmd p'
    call Echo(split_command)
endfunction


" Toggle Number ON/OFF
function! ToggleNumber()
    if &number
        set nonumber
        echo "set nonumber"
    else
        set number
        echo "set number"
    endif
endfunction


" Toggle Relative Number ON/OFF
function! ToggleRelativeNumber()
    if &relativenumber
        set norelativenumber
        echo "set norelativenumber"
    else
        set relativenumber
        echo "set relativenumber"
    endif
endfunction


" Toggle Paste
function! TogglePaste()
       if &paste
            set nopaste
            echo "set nopaste"
       else
            set paste
            echo "set paste"
       endif
endfunction


" Format XML
function! FormatXML()
    let ft = 'set filetype?'
    if ft == 'filetype='
      set filetype=xml " sometimes you might be just copy pasting
    endif
    silent exe "%s/></>\r</g"
    silent normal gg=G
endfunction

" If we have a local vimrc source it
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

" Git commit add single file please
function! Gca()
    let cwd = expand("%:p")
    exe 'Git add ' . cwd
    exe 'Gcommit'
endfunction

" Git commit add all changed files please
function! Gcall()
    let cwd = expand("%:p")
    exe 'Git add .'
    exe 'Gcommit'
endfunction


"" Set the right test runner mappings
fun! s:SelectTestRunner()
  nmap <silent><Leader>f <Esc>:Pytest file<CR>
  nmap <silent><Leader>c <Esc>:Pytest class<CR>
  nmap <silent><Leader>m <Esc>:Pytest method<CR>
  nmap <silent><Leader>q <Esc>:Pytest first<CR>
  nmap <silent><Leader>w <Esc>:Pytest previous<CR>
  nmap <silent><Leader>e <Esc>:Pytest next<CR>
  nmap <silent><Leader>r <Esc>:Pytest last<CR>
  nmap <silent><Leader>,f <Esc>:Pytest fails<CR>
  nmap <silent><Leader>,d <Esc>:Pytest error<CR>
  nmap <silent><Leader>,s <Esc>:Pytest session<CR>
  nmap <silent><Leader>,a <Esc>:Pytest end<CR>
endfun

""" These functions are helpers for the statusline
function! Collapse(string)
    let threshold = 30
    let total_length = len(a:string)
    if total_length > threshold
        let difference = total_length - threshold
        return ' ...' . strpart(a:string, difference)
    else
        return a:string
    endif
endfunction

function! Getcwd()
    let current_dir = getcwd()
    let current_path = expand("%:p:h")
    if current_dir == current_path
        return ""
    else
        return "cwd: " .current_dir
    endif
endfunction

" Whitespace ammo. Everything here is meant to aid in the whitespace
" war. Always leaving the cursor where you left it and toggling hls
" if needed.

" Show me where the whitespace is
command! -bang Ws let orig_line = line('.') | exe ((<bang>0)?":set hls!":":set hls") | silent! exe '/\s\+$' |  exe orig_line

" Remove all trailing whitespace
command! Trailing let orig_line = line('.') | let orig_col = col('.') | exe ":set nohls" | silent! exe '%s/\s\+$//g' |  exe orig_line | exe "normal " .orig_col . "|"

" Remove all trailing whitespace when you write a file
autocmd BufWritePost * :Trailing

" I like Fugitive.vim but tpope does not want to add customizable statusline
" support, so I have to add all of these just to conform to have something like
" [BRANCH*] where the '*' is present if the branch is modified or not.  le sigh

autocmd BufWritePost,BufReadPost,BufNewFile,BufEnter * call s:SetGitModified()


function! s:SetGitModified() abort
  if !exists('b:git_dir')
    return ''
  endif
  let repo_name = RepoHead()
  let modified = GitIsModified() ? '*' : ''
  let b:git_statusline = '['.repo_name.modified.']'
endfunction

function! FindGit(type) abort
    let found = finddir(".git", ".;")
    if (found !~ '.git')
        return ""
    endif
    " Return the actual directory where .coverage is found
    if a:type == "dir"
        return fnamemodify(found, ":h")
    else
        return found
    endif
endfunction

function! GitIsModified() abort
    let rvalue = 0
    " First try to see if we actually have a .git dir
    let has_git = FindGit('dir')
    if (has_git == "")
        return rvalue
    else
        let original_dir = getcwd()
        " change dir to where coverage is
        " and do all the magic we need
        if original_dir
            exe "cd " . has_git
            let cmd = "git status -s 2> /dev/null""
            let out = system(cmd)
            if out != ""
                let rvalue = 1
            endif
            " Finally get back to where we initially where
            exe "cd " . original_dir
            return rvalue
        else
            return ''
    endif
endfunction

function! RepoHead() abort
  let path = FindGit('repo') . '/HEAD'
  if ! filereadable(path)
      return 'NoBranch'
  endif
  let repo_name = ''
  let repo_line =  readfile(path)[0]

  if repo_line =~# '^ref: '
    let repo_name .= substitute(repo_line, '\v^(.*)/','', '')
  elseif repo_line =~# '^\x\{40\}$'
    let repo_name .= repo_line[0:7]
  endif
  return repo_name
endfunction

function! GitStatusline() abort
  " Note: Works just as long as fugitive is installed
  " should remove the depedency
  if exists('b:git_statusline')
      return b:git_statusline
  endif
  if !exists('b:git_dir')
      return ''
  else
      let repo_name = RepoHead()
      return '['.repo_name.']'
  endif
  return ''
endfunction

function! ToggleMinimap()
    " Want a 1000FT view of whatever you have in front of you?
    " Are you looking at code that is waaaay longer than your screen?
    " this function will do that for you in GUI interfaces. The mapping
    " is set below to `:Mini`
    if !has("gui_running")
        echohl ErrorMsg | echo "Not in GUI Vim." | echohl None
        return
    endif

    if exists("s:isMini") && s:isMini == 0
        let s:isMini = 1
    else
        let s:isMini = 0
    end

    if (s:isMini == 0)
        " save current visible lines
        let s:firstLine = line("w0")
        let s:lastLine = line("w$")


        " don't change window size
        let c = &columns * 12
        let l = &lines * 12
        exe "set columns=" . c
        exe "set lines=" . l

        " make font small
        set guifont=Menlo:h1

    else
        set guifont=Menlo:h12

    endif
endfunction

command! Mini call ToggleMinimap()

function! s:Echo(msg, ...)
    redraw!
    let x=&ruler | let y=&showcmd
    set noruler noshowcmd
    if (a:0 == 1)
        echo a:msg
    else
        echohl WarningMsg | echo a:msg | echohl None
    endif

    let &ruler=x | let &showcmd=y
endfun


""" FocusMode
function! ToggleFocusMode()
  let sidebar = SidebarSize()
  if s:focus_is_on == 0
      if winwidth(winnr()) <= 150
          call Echo("Not enough space to focus")
          return
      endif
    let s:focus_is_on = 1
    set laststatus=0
    "set foldcolumn=12
    set noruler
    set nocursorline
    hi FoldColumn ctermbg=none guibg=fg
    hi LineNr ctermfg=8 ctermbg=NONE guifg=bg
    hi NonText ctermfg=8 guifg=bg
    set nowrap
    set nolinebreak

    " Create the left sidebar
    exec( "silent leftabove " . sidebar . "vsplit new" )
    setlocal noma
    setlocal nocursorline
    setlocal nonumber
    silent! setlocal norelativenumber
    wincmd l
    " Create the right sidebar
    exec( "silent rightbelow " . sidebar . "vsplit new" )
    setlocal noma
    setlocal nocursorline
    setlocal nonumber
    silent! setlocal norelativenumber
    wincmd h

    let cterm_colors = Blackout()
    let l:highlightbgcolor = "ctermbg=8"
    let l:highlightfgbgcolor = "ctermfg=8" . " " . l:highlightbgcolor
    let l:ctermfg = cterm_colors[0]
    let l:ctermbg = cterm_colors[1]
    let l:guifg = cterm_colors[2]
    let l:guibg = cterm_colors[3]
    let l:no_color = "ctermfg=" . l:ctermbg ." ctermbg=" . l:ctermbg . " guifg=" . l:guifg . " guibg=" . l:guibg
    echom l:no_color
    exec("hi Normal " . "ctermfg=" .l:ctermfg . " guifg=" . l:guifg )
    exec("hi VertSplit " . l:no_color )
    exec("hi NonText " . l:no_color )
    exec("hi StatusLine " . l:no_color )
    exec("hi StatusLineNC " . l:no_color )
  else
     let s:focus_is_on = 0
     wincmd l
     close
     wincmd h
     close
    set laststatus=2
    set numberwidth=4
    set foldcolumn=0
    set ruler
    execute "colorscheme " . g:colors_name
  endif
  echo ''

endfunc
let s:focus_is_on = 0
command! Focus :call ToggleFocusMode()

function! SidebarSize()
    return (winwidth( winnr() ) - 102 ) / 2
endfunction

function! Blackout()
        redir => current | silent highlight Normal | redir END
        let current = substitute(current, " xxx ","  ", "")
        let guibg = matchlist(current, '\vguibg\=(.*)')[1]
        let guifg = matchlist(current, '\vguifg\=(.*)\s+')[1]
        "let ctermbg = matchlist(current, '\vctermbg\=(.*)\s+')[1]
        let ctermbg = matchlist(current, '\vctermbg\=(\d+)\s+')[1]
        let ctermfg = matchlist(current, '\vctermfg\=(\d+)\s+')[1]
        "let ctermfg = matchlist(current, '\vctermfg\=(.*)\s+')[1]
        echom guibg
        echom guifg
        echom ctermfg
        echom ctermbg
        return [ctermfg, ctermbg, guifg, guibg]
endfunction

if has('persistent_undo')
    " Save all undo files in a single location (less messy, more risky)...
    set undodir=$HOME/tmp/.vim_undo

    " Save a lot of back-history...
    set undolevels=5000

    " Actually switch on persistent undo
    set undofile
endif

function! WhichPython()
  if exists('$VIRTUAL_ENV')
    let _python = $VIRTUAL_ENV . "/bin/python"
  else
    let _python= "python"
  endif
  return _python
endfunction


" Lets try out more Python integration
function! PyModuleVersion(module)
  let exec = "exec \'try: import pkg_resources; print pkg_resources.get_distribution(\\'" . a:module . "\\').version\\nexcept Exception, e: print \\'Not Found.\\'\'"
  let command = WhichPython() . ' -c "' . exec . '"'
  let out = system(command)
  return substitute(out, '\n$', '', '')
endfunction

function! PyModulePath(module)
  let exec = "exec \'try: import os.path as _, ". a:module . "; print _.dirname(_.realpath(" . a:module . ".__file__))\\nexcept Exception, e: print e\'"
  let command = WhichPython() . ' -c "' . exec . '"'
  let out = system(command)
  return substitute(out, '\n$', '', '')
endfunction

function! PyCd(module)
  let path = PyModulePath(a:module)
  let command = "cd " . path
  execute command
  call s:Echo(command, 1)
endfunction

function! PyInfo(module)
  let _path = PyModulePath(a:module)
  let _version = PyModuleVersion(a:module)
  echo "Python Module: " . a:module
  echo "Version: " . _version
  echo "Path: " . _path
endfunction


command! -nargs=1 Pcd call PyCd(<f-args>)
command! -nargs=1 Pinfo call PyInfo(<f-args>)


function! PyVersion()
  let out = system("python --version")
  let major_version = get(matchlist(out, '\d'), 0, '2')
  echo "This is Python version " . major_version
endfunction



" Highlight the word under the cursor so variable names are visible
let s:python_keywords=split(system('python -c "import keyword; print \",\".join(dir(__builtins__) + keyword.kwlist)"'), ',')
function! s:Highlight_Python_Variables()
    let g:word = expand("<cword>")
    if index(s:python_keywords, g:word) < 0
        "exe printf('match IncSearch /\<%s\>/', g:word)
        exe printf('match TabLineFill /\<%s\>/', g:word)
    endif
endfunction
autocmd CursorMoved * if &ft ==# 'python' | silent! call s:Highlight_Python_Variables() | endif
