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
Plugin 'neoclide/coc.nvim', {'branch': 'release'}
Plugin 'sainnhe/gruvbox-material'
Plugin 'nvim-treesitter/nvim-treesitter'
Plugin 'sheerun/vim-polyglot'
Plugin 'morhetz/gruvbox'
Plugin 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plugin 'mhinz/vim-startify'
Plugin 'preservim/nerdtree'
Plugin 'dense-analysis/ale'
Plugin 'NLKNguyen/papercolor-theme'
Plugin 'dracula/vim'
Plugin 'lifepillar/vim-solarized8'
Plugin 'graywh/vim-colorindent'

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
