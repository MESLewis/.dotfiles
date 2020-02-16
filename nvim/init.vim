set showmatch             " show matching bracket
set tabstop=2             "
set softtabstop=2         "
set shiftwidth=2          " autoindent width
set number                " Add line numbers
set expandtab             " convert tab to white space
set wildmode=longest,list " bash-like tab completion
set mouse=a               " enable mouse support in all modes
filetype plugin indent on " turn on auto-indent depending on file type
syntax on                 " syntax highlighting

source $VIMRUNTIME/mswin.vim " Load defaults for windows


" Specify directory for plugins
call plug#begin(stdpath('data') . '/plugged')

Plug 'icymind/NeoSolarized' " Solarized color scheme
Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } } " Google Chrome vim interop
Plug 'junegunn/vim-easy-align'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install' } " Preview markdown files in browser
Plug 'tpope/vim-fugitive' " Adds git commands to vim
Plug 'ncm2/ncm2' " Code completion
Plug 'prabirshrestha/async.vim' " Compatibility layer for vim-lsp
Plug 'prabirshrestha/vim-lsp' " Consumes Language Server Protocol
Plug 'mattn/vim-lsp-settings' " Auto config for vim-lsp

" Automcompletion
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
let g:deoplete#enable_at_startup = 1

" Call PlugInstall when new plugins added
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif

" Initialize plugin system
call plug#end()

""""""""THEME
set termguicolors

set background=dark
colorscheme NeoSolarized


""""""""Plug: EasyAlign 
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
""""""""End Plug


""""""""Plug: markdown-preview.vim
" TODO Doesn't launch
" set to 1, nvim will open the preview window after entering the markdown buffer
" default: 0
let g:mkdp_auto_start = 1

" set to 1, the nvim will auto close current preview window when change
" from markdown buffer to another buffer
" default: 1
let g:mkdp_auto_close = 1

" set to 1, the vim will refresh markdown when save the buffer or
" leave from insert mode, default 0 is auto refresh markdown as you edit or
" move the cursor
" default: 0
let g:mkdp_refresh_slow = 0

" set to 1, the MarkdownPreview command can be use for all files,
" by default it can be use in markdown file
" default: 0
let g:mkdp_command_for_global = 0

" set to 1, preview server available to others in your network
" by default, the server listens on localhost (127.0.0.1)
" default: 0
let g:mkdp_open_to_the_world = 0

" use custom IP to open preview page
" useful when you work in remote vim and preview on local browser
" more detail see: https://github.com/iamcco/markdown-preview.nvim/pull/9
" default empty
let g:mkdp_open_ip = ''

" specify browser to open preview page
" default: ''
let g:mkdp_browser = 'chrome'

" set to 1, echo preview page url in command line when open preview page
" default is 0
let g:mkdp_echo_preview_url = 0

" a custom vim function name to open preview page
" this function will receive url as param
" default is empty
let g:mkdp_browserfunc = ''

" options for markdown render
" mkit: markdown-it options for render
" katex: katex options for math
" uml: markdown-it-plantuml options
" maid: mermaid options
" disable_sync_scroll: if disable sync scroll, default 0
" sync_scroll_type: 'middle', 'top' or 'relative', default value is 'middle'
"   middle: mean the cursor position alway show at the middle of the preview page
"   top: mean the vim top viewport alway show at the top of the preview page
"   relative: mean the cursor position alway show at the relative positon of the preview page
" hide_yaml_meta: if hide yaml metadata, default is 1
" sequence_diagrams: js-sequence-diagrams options
let g:mkdp_preview_options = {
    \ 'mkit': {},
    \ 'katex': {},
    \ 'uml': {},
    \ 'maid': {},
    \ 'disable_sync_scroll': 0,
    \ 'sync_scroll_type': 'middle',
    \ 'hide_yaml_meta': 1,
    \ 'sequence_diagrams': {},
    \ 'flowchart_diagrams': {}
    \ }

" use a custom markdown style must be absolute path
let g:mkdp_markdown_css = ''

" use a custom highlight style must absolute path
let g:mkdp_highlight_css = ''

" use a custom port to start server or random for empty
let g:mkdp_port = ''

" preview page title
" ${name} will be replace with the file name
let g:mkdp_page_title = '「${name}」'
""""""""End Plug: markdown-preview.vim

" Reloads vimrc after saving
if !exists('*ReloadVimrc')
    fun! ReloadVimrc()
	    let save_cursor = getcurpos()
		source $MYVIMRC
		call setpos('.', save_cursor)
	endfun
endif
autocmd! BufWritePost $MYVIMRC call ReloadVimrc()
