" put this line first in ~/.vimrc
set nocompatible | filetype indent plugin on | syn on
let mapleader = "," " Set <leader> to ,

syntax on
set fileencoding=utf-8
set encoding=utf-8

set backspace=indent,eol,start    " Allow backspacing over autoindent, line breaks and start of insert
set cpo+=J                        " Use double spacing after periods.
set display=lastline,uhex         " Show the last line instead of '@'; show non-printable chars as <hex>
set esckeys                       " Allow sane use of cursor keys in various modes
set foldenable                    " Enable code folding
set foldlevelstart=10             " Open most folds by default
set foldnestmax=6                 " Set maximum number of nested folds
set foldmethod=indent             " Set fold based on indent level
set hidden                        " unsaved buffers allowed in the buffer list without saving
set hlsearch                      " Highlight the current search
set ignorecase                    " Usually I don't care about case when searching
set incsearch                     " Show matches as you type
set laststatus=2                  " Always show a status line.
set lazyredraw                    " Don't redraw during macros etc.
set list                          " display leading tabs as >· and trailing spaces as ·
set listchars=tab:»·,trail:·
set modeline                      " Look for embedded modelines at the top of the file.
set modelines=10                  " Don't look any further than this number of lines
set mousehide                     " Hide the mouse pointer while typing
set nobackup
set noerrorbells                  " enough with the beeping already!
set noshowmode                    " Hide mode text under powerbar
set nostartofline                 " keep cursor's column
set noswapfile                    " it's 2013, Vim.
set notextmode                    " Don't append bloody carriage returns.
set ruler                         " Enable ruler on status line.
set shiftround                    " Round indent to shiftwidth multiple, applies to < and >
set shortmess=atI                 " Shorter status messages.
set showcmd                       " Show (partial) command in status line.
set showmatch                     " Show matching ()'s []'s {}'s
set smartcase                     " only search case sensitively when not doing al all-lowercase search
set splitbelow                    " Split horizontally below.
set splitright                    " Split vertically to the right.
let Tlist_Ctags_Cmd = "/usr/local/bin/ctags"
set title                         " Better xterm titles
set ttyfast                       " Terminal connection is fast
set ttimeoutlen=50                " Faster exit from insert mode
set whichwrap=b,s,h,l,<,>,[,],~   " Wrap to the previous/next line on all keys and ~ command
set wildignore+=.svn,CVS,.git,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif,*.pyc,*.pyo,*.orig
set wildmenu                      " Better filename completion etc.
set wildmode=longest:full,full    " Complete only up to the point of ambiguity
                                  " (while still showing you what your options are)
set tabstop=4
set shiftwidth=4
set expandtab
set listchars=tab:»·,trail:·

fun! SetupVAM()
  let c = get(g:, 'vim_addon_manager', {})
  let g:vim_addon_manager = c
  let c.plugin_root_dir = expand('$HOME', 1) . '/.vim/vim-addons'

  " Force your ~/.vim/after directory to be last in &rtp always:
  " let g:vim_addon_manager.rtp_list_hook = 'vam#ForceUsersAfterDirectoriesToBeLast'

  " most used options you may want to use:
  " let c.log_to_buf = 1
  " let c.auto_install = 0
  let &rtp.=(empty(&rtp)?'':',').c.plugin_root_dir.'/vim-addon-manager'
  if !isdirectory(c.plugin_root_dir.'/vim-addon-manager/autoload')
    execute '!git clone --depth=1 git://github.com/MarcWeber/vim-addon-manager '
        \       shellescape(c.plugin_root_dir.'/vim-addon-manager', 1)
  endif

  " This provides the VAMActivate command, you could be passing plugin names, too
  call vam#ActivateAddons('molokai')
  call vam#ActivateAddons('vim-airline')
  call vam#ActivateAddons('ctrlp')
  call vam#ActivateAddons('Syntastic')
  call vam#ActivateAddons('github:nathanaelkane/vim-indent-guides')
endfun
call SetupVAM()

" Disable cursor keys
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>

" Disable the help key
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" Line numbering ---------------------------------------------------------
set relativenumber " have line numbers show as relative to current line
set number         " also show current line number
let s:color_column_old = 0
function! s:ToggleColorColumn()
    set invrelativenumber relativenumber?
    set invlist
    if s:color_column_old == 0
        let s:color_column_old = &colorcolumn
        windo let &colorcolumn = 0
    else
        windo let &colorcolumn=s:color_column_old
        let s:color_column_old = 0
    endif
endfunction
nmap <c-n><c-n> :call <SID>ToggleColorColumn()<CR>

" PLUGINS
" LycosaExplorer ---------------------------------------------------------
" Link - (http://www.vim.org/scripts/script.php?script_id=3659)
"  <Leader>lf  - Opens the filesystem explorer.
"  <Leader>lr  - Opens the filesystem explorer at the directory of the current file.
"  <Leader>lb  - Opens the buffer explorer.
let g:SuperTabDefaultCompletionType = "context"

" Airline ----------------------------------------------------------------

" Airline Theme
"let g:airline_theme="behelit"

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
" None

" powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.linenr = '¶'
"let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'

"let g:airline#extensions#syntastic#enabled = 0
"let g:airline#extensions#tabline#enabled = 1
"let g:airline_extensions = ['ctrlp']
let g:airline_detect_modified=1
let g:airline_detect_paste=1
let g:airline_inactive_collapse=1
let g:airline_skip_empty_sections = 1

" Syntastic
let g:syntastic_auto_loc_list=1 " Open location list if there are errors


" FUNCTIONS
augroup myStartup
    autocmd!

    autocmd FileType python setlocal commentstring=#\ %s

    " Set tab stops and whether to show ruler
    autocmd FileType python call <SID>CodingStyleFiletypes(4, 'on')

    " Auto-reload .vimrc on changes
    autocmd BufWritePost ~/.vimrc source ~/.vimrc
augroup END

function! s:CodingStyleFiletypes(tabstop_length, show_col)
    " Let filetype indentation do its own thing
    setlocal nocindent
    setlocal nosmartindent

    " mark the 80th col to avoid overstepping programming style
    if a:show_col == 'on'
        setlocal colorcolumn=120
        setlocal textwidth=120
    endif

    " Set 'formatoptions' to break comment lines but not other lines,
    " and insert the comment leader when hitting <CR> or using 'o'.
    setlocal formatoptions-=t formatoptions+=croql

    setlocal expandtab
    setlocal smarttab " unsure about this for now?
    let &l:shiftwidth = a:tabstop_length
    let &l:softtabstop = a:tabstop_length
    setlocal tabstop=4
endfun

