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
"   > Conque.vim 
"     Makes possible to execute anything and run it within VIM.
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
"   > Autocomplpop.vim
"     Uses the power of <C-N> and <C-P> for auto completion
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible

" Pathogen needs to be first to init all plugins
silent! call pathogen#runtime_append_all_bundles()
silent! call pathogen#runtime_prepend_subdirectories("~/.vim/bundle")
 
set nowritebackup                           " Hate backups
set noswapfile                              " ...and swap files

"set smartindent

" Fixes Comenting hash indentation
inoremap # X#

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Display
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
colorscheme ir_black                        " Color Theme

set guifont=Menlo:h12                       " Font and Font Size

" terminal width
set wrap
set textwidth=79
set formatoptions=qrn1

" Remember cursor position
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

syntax on
filetype on                                " enables filetype detection
filetype plugin on                         " enables filetype specific plugins
filetype indent on 

" keep some more lines for scope
set scrolloff=5

set backspace=indent,eol,start
set vb

" GUI Stuff
if has("gui_running")
  "set autochdir                             " Chdir where the edited file lives
  set go-=T                                 " No toolbar
  set guioptions-=L                         " No scrollbar
  set guioptions-=r
  set lines=999 columns=999
  highlight SpellBad term=underline gui=undercurl guisp=Orange
endif

set ruler

" I have a dark terminal
set background=dark

" A status bar that shows nice information
set laststatus=2
set statusline=%F%m%r%h\ %w\ \ CWD:\ %r%{CurDir()}%h\ \ \ Line:\ %l/%L:%c

" Searching
set ignorecase
set smartcase
" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
map N Nzz
map n nzz
" Get the title right
set title

" Highlight search on
set hlsearch

" Menus
set wildmode=list:longest,full
set wildmenu

" For xml, xhtml and html let's use 2 spaces of indentation
autocmd FileType html,xhtml,xml setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2

" Let me know what command I'm typing 
set showcmd

" Jumping into arrow darkness with this 
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
nnoremap j gj
nnoremap k gk

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Tag List Plugin
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set the tags in current dir and walk up if necessary
" ctags  --exclude='*.js' -R .
set tags=tags;/

" I have Exuberant Ctags (tag_list plugin)
let Tlist_Ctags_Cmd = "/usr/local/bin/ctags"

let Tlist_File_Fold_Auto_Close = 1                  " folds all but the current buffer
let Tlist_GainFocus_On_ToggleOpen = 1               " Go to the list window if I open it

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Chapa Python Plugin
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:chapa_default_mappings = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Python
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd BufRead,BufNewFile *.py syntax on
autocmd BufRead,BufNewFile *.py set ai
autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,with,try,except,finally,def,class
set tabstop=4 expandtab shiftwidth=4 softtabstop=4

" hide some files and remove stupid help
let g:netrw_list_hide='^\.,.\(pyc\|pyo\|o\)$'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Custom Commands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vertical Split Buffer 
command -nargs=1 Vbuffer call VerticalSplitBuffer(<f-args>)

" Edit Vimrc 
command Vimrc :e $MYVIMRC

" Reload/Source vimrc 
command Reload :so $MYVIMRC

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Mappings 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" jj for quick escaping
imap jj <ESC>

" Make sure we use a better leader key
let mapleader = ","
let g:mapleader = ","


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Leaders
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Underline Titles 
nnoremap <Leader>1 yypVr=
nnoremap <Leader>2 yypVr-

" Count current word 
nmap <Leader>w <Esc>:call Count(expand("<cword>"))<CR>

" Ack searching 
nmap <Leader>a <Esc>:Ack 

" gundo
nnoremap <Leader>u <ESC>:GundoToggle<CR>

" Insert blank lines and stay in normal mode dude
" blank line  below 
nnoremap <Leader>l <ESC>:put =''<CR>

" blank line  above
nnoremap <Leader>ll <ESC>:put! =''<CR>

" set paste no paste
nmap <Leader>p <Esc>:call TogglePaste()<CR>

" toggle number
nmap <Leader>n <Esc>:call ToggleNumber()<CR>

" toggle relative number 
nmap <Leader>r <Esc>:call ToggleRelativeNumber()<CR>

" set hls / nohls
nmap <Leader>s <Esc>:call ToggleHLSearch()<CR>

" Toggle Tag_List plugin 
nmap <Leader>c <Esc>:TlistToggle<CR> 

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
function Count(word)
    let count_word = "%s/" . a:word . "//gn"
    execute count_word
endfunction

" Vertical Split Buffer 
function VerticalSplitBuffer(buffer)
    let split_command = "vert belowright sb " . a:buffer
    execute split_command
    call Echo(split_command)
endfunction

" Toggle Number ON/OFF 
function ToggleNumber()
    if &number
        set nonumber
        echo "set nonumber"
    else
        set number 
        echo "set number"
    endif 
endfunction

" Toggle Relative Number ON/OFF 
function ToggleRelativeNumber()
    if &relativenumber
        set norelativenumber
        echo "set norelativenumber"
    else
        set relativenumber 
        echo "set relativenumber"
    endif 
endfunction

" Toggle Highlight Searc ON / OFF
function ToggleHLSearch()
       if &hls
            set nohlsearch
            echo "set nohls"
       else
            set hls
            echo "set hls"
       endif
endfunction

" Toggle Paste
function TogglePaste()
       if &paste
            set nopaste
            echo "set nopaste"
       else
            set paste
            echo "set paste"
       endif
endfunction

" Format XML
function FormatXML()
    let ft = 'set filetype?'
    if ft == 'filetype='
      set filetype=xml " sometimes you might be just copy pasting
    endif
    silent exe "%s/></>\r</g"
    silent normal gg=G
endfunction

" To get nice CWD with ~ substitution
function! CurDir()
        let curdir = substitute(getcwd(), '/Users/alfredo', "~/", "g")
            return curdir
        endfunction

" If we have a local vimrc source it 
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

