call plug#begin(stdpath('data') . '/plugged')

" Others
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'scrooloose/nerdcommenter'

Plug 'easymotion/vim-easymotion'
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-fuzzy.vim'

Plug 'jacquesbh/vim-showmarks'
Plug 'terryma/vim-smooth-scroll'
Plug 'andymass/vim-matchup' " () {} match
Plug 'regedarek/ZoomWin' " <C-w>o to zoom in and out of a window



" Window and tab management
Plug 't9md/vim-choosewin'

 

" Completion & Linting
Plug 'neoclide/coc.nvim', {'branch': 'release'}



" GDB console in neovim
Plug 'sakhnik/nvim-gdb', { 'do': ':!./install.sh \| UpdateRemotePlugins' }



" For syntax highlighting management -----
Plug 'jaxbot/semantic-highlight.vim'
Plug 'jcorbin/vim-lobster'



" For tag management -----
Plug 'majutsushi/tagbar'
Plug 'ludovicchabant/vim-gutentags'



" For fold management -----
Plug 'pseewald/vim-anyfold'
Plug 'konfekt/fastfold'
Plug 'arecarn/vim-fold-cycle'



" Text management -----
Plug 'tpope/vim-surround'
Plug 'godlygeek/tabular', { 'on': 'Tabularize' }
Plug 'svermeulen/vim-yoink'
Plug 'svermeulen/vim-subversive'

" Text objects -----
Plug 'michaeljsmith/vim-indent-object'
Plug 'bkad/CamelCaseMotion'
Plug 'vim-scripts/argtextobj.vim'



" Snippets -----
Plug 'honza/vim-snippets'
Plug 'sirver/ultisnips'



" Latex IDE
Plug 'lervag/vimtex', { 'for': 'tex' }
Plug 'KeitaNakamura/tex-conceal.vim', { 'for': 'tex' }



" For aestetics -----
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'powerline/powerline'
Plug 'powerline/fonts'

" Plug 'Yggdroot/indentLine'
Plug 'nathanaelkane/vim-indent-guides'

Plug 'lifepillar/vim-solarized8'
Plug 'challenger-deep-theme/vim', {'name': 'challenger-deep-theme'}
Plug 'Rigellute/rigel'


" All of your Plugins must be added before the following line
call plug#end()            " required


" Global Setting ----------------------------------------------------
syntax enable
set mouse=a
set foldlevel=0
set clipboard+=unnamedplus

" allows you to deal with multiple unsaved buffers
set hidden

set backspace=indent,eol,start

" Set to auto read when a file is changed from the outside
set autoread

set hlsearch

set incsearch

set showmatch

set mat=2


" Indentation
set ai "Auto indent
set si "Smart indent

" Use spaces instead of tabs
set expandtab

set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4


" Linebreak on 500 characters
set lbr
set tw=500

set colorcolumn=80

set wrap "Wrap lines
set noshowmode " Disable mode in command line

" CursorHold even ms delay
set updatetime=250

" For the numbers column
set number
set relativenumber


" Split new buffer to the right
set splitright

" Spellchecker config
set spelllang=en_us,fr

" Makes vim take the relative location not from the open buffer, but from the current working directory
set cpo=d

" Hides unnecessary things (used for Latex)
set conceallevel=0

" True color support
set termguicolors

" Makes a completion menu appear even when there is only one mathc
set completeopt+=menuone

" Leader key assignement
nnoremap <SPACE> <Nop>
let mapleader=" "
let maplocalleader=" "




" PLUGIN CONFIG -----------------------------------------------------

" nvimGDB Config
function! NvimGdbNoTKeymaps()
  tnoremap <silent> <buffer> <esc> <c-\><c-n>
endfunction

let g:nvimgdb_config_override = {
  \ 'key_next': 'n',
  \ 'key_step': 's',
  \ 'key_finish': 'f',
  \ 'key_continue': 'c',
  \ 'key_until': 'u',
  \ 'key_breakpoint': 'b',
  \ 'set_tkeymaps': "NvimGdbNoTKeymaps",
  \ 'sign_current_line': '▶',
  \ 'sign_breakpoint': [ '●', '●²', '●³', '●⁴', '●⁵', '●⁶', '●⁷', '●⁸', '●⁹', '●ⁿ' ],
  \ }



" Ultisnips Options
let g:UltiSnipsExpandTrigger="<c-f>"
let g:UltiSnipsJumpForwardTrigger="<c-f>"
let g:UltiSnipsJumpBackwardTrigger="<c-b>"



" Gutentags Options
let g:gutentags_ctags_extra_args = ['--fields=+l', '--c-kinds=+p', '--c++-kinds=+p']

if executable('rg')
  let g:gutentags_file_list_command = 'rg --files'
endif



" Vimtex Options
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
let g:tex_conceal='abdmg'



" Fuzzy Incsearch
function! s:config_fuzzyall(...) abort
  return extend(copy({
  \   'converters': [
  \     incsearch#config#fuzzy#converter(),
  \     incsearch#config#fuzzyspell#converter()
  \   ],
  \ }), get(a:, 1, {}))
endfunction



" Indent line Config
let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_start_level=2
let g:indent_guides_guide_size=1



" Other Options
let g:yoinkIncludeDeleteOperations=1

let anyfold_fold_comments=1

let g:camelcasemotion_key = '<leader>'

let g:fold_cycle_default_mapping = 0 "disable default mappings

let g:choosewin_overlay_enable = 0

let g:EasyMotion_startofline = 0 " keep cursor column when JK motion

let g:incsearch#auto_nohlsearch = 1





" MAPPINGS ------------------------------------------------------------

" Fast saving
nmap ,w  :w!<cr>

" Way more convenient [ and ] mappings
nmap < [
nmap > ]
omap < [
omap > ]
xmap < [
xmap > ]
nmap << [[
nmap >> ]] nmap <> [] nmap >< ][

" Disabling the arrow keys
no <down> ddp
no <left> <Nop>
no <right> <Nop>
no <up> ddkP
ino <down> <Nop>
ino <left> <Nop>
ino <right> <Nop>
ino <up> <Nop>
vno <down> <Nop>
vno <left> <Nop>
vno <right> <Nop>
vno <up> <Nop>

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Choosewin keybindings
nmap  -  <Plug>(choosewin)

" Terminal Stuff
tnoremap <Esc> <C-\><C-n>
tnoremap <C-h> <C-\><C-N><C-w>h
tnoremap <C-l> <C-\><C-N><C-w>l
tnoremap <C-j> <C-\><C-N><C-w>j
tnoremap <C-k> <C-\><C-N><C-w>k

" Smooth scroll for large scroll motions
noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 0, 2)<CR>
noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 0, 2)<CR>
noremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 0, 4)<CR>
noremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 0, 4)<CR>

" Reposition screen when doing large movements
nmap n nzz
nmap N Nzz
nmap } }zz
nmap { {zz
nmap ) )zz
nmap ( (zz

" tab-complete
inoremap <expr> <Tab>   pumvisible() ? "\\<C-n>" : "\\<Tab>" " This makes absolutely no sense
inoremap <expr> <S-Tab> pumvisible() ? "\\<C-p>" : "\\<S-Tab>"

" transparency
nnoremap <C-t> :call mappings#transparency#Toggle_transparent()<CR>

" Yoinks keybinds
nmap <a-h> <plug>(YoinkPostPasteSwapBack)
nmap <a-l> <plug>(YoinkPostPasteSwapForward)

nmap p <plug>(YoinkPaste_p)
nmap P <plug>(YoinkPaste_P)

nmap [y <plug>(YoinkRotateBack)
nmap ]y <plug>(YoinkRotateForward)

nmap <c-=> <plug>(YoinkPostPasteToggleFormat)



" Subversive keybinds
" s for substitute
nmap s <plug>(SubversiveSubstitute)
nmap ss <plug>(SubversiveSubstituteLine)
nmap S <plug>(SubversiveSubstituteToEndOfLine)

nmap <leader>s <plug>(SubversiveSubstituteRange)
xmap <leader>s <plug>(SubversiveSubstituteRange)

nmap <leader>ss <plug>(SubversiveSubstituteWordRange)

nmap <leader>cr <plug>(SubversiveSubstituteRangeConfirm)
xmap <leader>cr <plug>(SubversiveSubstituteRangeConfirm)
nmap <leader>crr <plug>(SubversiveSubstituteWordRangeConfirm)

" Yoink Integration
xmap s <plug>(SubversiveSubstitute)
xmap p <plug>(SubversiveSubstitute)
xmap P <plug>(SubversiveSubstitute)



" Very useful function keybindings
map <F2> :CocCommand explorer<CR>
map <F3> :TagbarToggle<CR>
map <F4> :DoShowMarks!<CR>
map <F5> :make<CR>
map <F6> :setlocal spell!<CR>



" Using Buffers
nnoremap gb :ls<CR>:b<Space>

" Fold cylcle keybindings
nmap <leader><Tab> <Plug>(fold-cycle-open)
nmap <leader><S-Tab> <Plug>(fold-cycle-close)

" Incsearch mappings
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
noremap <silent><expr> fs incsearch#go(<SID>config_fuzzyall())
noremap <silent><expr> z? incsearch#go(<SID>config_fuzzyall({'command': '?'}))
noremap <silent><expr> zg/ incsearch#go(<SID>config_fuzzyall({'is_stay': 1}))
noremap <silent><expr> <Space>m incsearch#go(<SID>config_easyfuzzymotion())

" Auto disabling of highlighting after search
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)

" Easymotion keybinds
map <Leader>l <Plug>(easymotion-lineforward)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>h <Plug>(easymotion-linebackward)



" Conquer of completion

inoremap <silent><expr> <C-j>
  \ pumvisible() ? "\\<C-n>" :
  \ coc#refresh()

inoremap <silent><expr> <C-k>
  \ pumvisible() ? "\\<C-p>" :
  \ coc#refresh()

inoremap <silent><expr> <TAB>
  \ coc#expandableOrJumpable() ? "\\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\\<CR>" :
  \ <SID>check_back_space() ? "\\<TAB>" :
  \ coc#refresh()

let g:coc_snippet_next = '<TAB>'

inoremap <expr> <CR> pumvisible() ? "\\<C-y>" : "\\<CR>"




" AUTOCOMMANDS ----------------------------------------------------------

" Startup script
autocmd vimenter * AnyFoldActivate

" Terminal autoinsert (I think)
autocmd BufWinEnter,WinEnter term://* startinsert


" Open Quickfix window automatically after running :make
augroup OpenQuickfixWindowAfterMake
    autocmd QuickFixCmdPost [^l]* nested cwindow
    autocmd QuickFixCmdPost    l* nested lwindow
augroup END


" Activate anyfold by default
augroup anyfold
    autocmd!
    autocmd Filetype <filetype> AnyFoldActivate
augroup END

" Disable anyfold for large files
let g:LargeFile = 1000000 " File is large if size greater than 1MB
autocmd BufReadPre,BufRead * let f=getfsize(expand("<afile>")) | if f > g:LargeFile || f == -2 | call LargeFile() | endif
function LargeFile()
    augroup anyfold
        autocmd! " Remove AnyFoldActivate
        autocmd Filetype <filetype> setlocal foldmethod=indent " Fall back to indent folding
    augroup END
endfunction

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction



" COLORSCHEME ----------------------------------------------------------

" Dark color scheme
set background=dark

" In case the color scheme doesn't have a ColorColumn
highlight ColorColumn ctermbg=darkgray

" autocmd ColorScheme * hi Normal ctermbg=none guibg=none " For transparency
colorscheme challenger_deep

" Transparency keybinding variables
let g:is_transparent=0
hi link backup backup
execute "hi backup guibg =" synIDattr(hlID("Normal"), "bg")

" Airline theme
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
