set nocompatible              " be iMproved, required
let $MYVIMRC = "/home/raja/.vimrc"
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
Plugin 'sainnhe/gruvbox-material'
Plugin 'nvim-treesitter/nvim-treesitter'
Plugin 'sheerun/vim-polyglot'
Plugin 'morhetz/gruvbox'
Plugin 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plugin 'mhinz/vim-startify'
Plugin 'preservim/nerdtree'
Plugin 'dense-analysis/ale'
Plugin 'dracula/vim'
Plugin 'lifepillar/vim-solarized8'
Plugin 'graywh/vim-colorindent'
Plugin 'suan/vim-instant-markdown'
Plugin 'plasticboy/vim-markdown'
Plugin 'godlygeek/tabular'
Plugin 'prabirshrestha/vim-lsp'
Plugin 'mattn/vim-lsp-settings'
Plugin 'leshill/vim-json'
Plugin 'pangloss/vim-javascript'
Plugin 'NLKNguyen/papercolor-theme'

Plugin 'jremmen/vim-ripgrep'
Plugin 'tpope/vim-surround'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'junegunn/fzf.vim'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'ervandew/supertab'
Plugin 'vim-syntastic/syntastic'
Plugin 'neoclide/coc.nvim', {'branch': 'release'}
Plugin 'elixir-editors/vim-elixir'
Plugin 'elixir-lsp/coc-elixir', {'do': 'yarn install && yarn prepack'}


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
set foldmethod=syntax
" Important!!
if has('termguicolors')
  set termguicolors
endif

let mapleader = ','

" Set contrast.
" This configuration option should be placed before `colorscheme gruvbox-material`.
" Available values: 'hard', 'medium'(default), 'soft'
let g:gruvbox_material_background = 'hard'

" For better performance
let g:gruvbox_material_better_performance = 1

colorscheme gruvbox
let g:airline_theme = 'gruvbox'
inoremap <silent><expr> <Tab> coc#pum#visible() ? coc#pum#confirm() : "<Tab>"
nnoremap <leader>tp :colorscheme PaperColor<CR>
nnoremap <leader>ts :colorscheme solarized8<CR>
nnoremap <leader>td :colorscheme dracula<CR>

nnoremap <leader>bd :set background=dark<CR>
nnoremap <leader>bl :set background=light<CR>
nnoremap <leader>n :NERDTreeToggle<cr>
nnoremap  <leader>v :edit   $MYVIMRC<CR>
nnoremap  <leader>u :source $MYVIMRC<CR>
" Start NERDTree and leave the cursor in it.
autocmd VimEnter * NERDTree
" toggle space to fold/unfold the code
nnoremap <space> za

let g:coc_global_extensions = [
      \'coc-markdownlint',
      \'coc-highlight',
      \'coc-vetur',
      \'coc-go',
      \'coc-python',
      \'coc-explorer',
      \'coc-flutter', 
      \'coc-json', 
      \'coc-git'
      \]

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" UNCOMMENT TO USE
set tabstop=2                    " Global tab width.
set shiftwidth=2                 " And again, related.
set expandtab                    " Use spaces instead of tabs

set laststatus=2                  " Show the status line all the time
set wildignore+=**/target/*,tmp/*,*.swp,*.class,**/build/**
let NERDTreeIgnore=['_build']

let g:airline_powerline_fonts = 1
let g:airline_inactive_collapse = 0

let g:mapleader=","
" Tab mappings.
map <leader>tt :tabnew<cr>
map <leader>te :tabedit
map <leader>tc :tabclose<cr>
map <leader>to :tabonly<cr>
map <leader>tn :tabnext<cr>
map <leader>tp :tabprevious<cr>
map <leader>tf :tabfirst<cr>
map <leader>tl :tablast<cr>
map <leader>tm :tabmove

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

""" Customize colors
func! s:my_colors_setup() abort
    " this is an example
    hi Pmenu guibg=#d7e5dc gui=NONE
    hi PmenuSel guibg=#b7c7b7 gui=NONE
    hi PmenuSbar guibg=#bcbcbc
    hi PmenuThumb guibg=#585858
endfunc

hi Normal guibg=NONE ctermbg=NONE
hi NonText ctermbg=none
hi Normal guibg=NONE ctermbg=NONE
augroup colorscheme_coc_setup | au!
    au ColorScheme * call s:my_colors_setup()
augroup END

command! -bang -nargs=* RG call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)

 nnoremap <C-q> :RG<cr>
 nnoremap <C-f> :Files<cr>

 set guioptions+=m
 map <C-n> :NERDTreeToggle<CR>

 function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
    nnoremap <buffer> <expr><c-d> lsp#scroll(-4)

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')

    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

