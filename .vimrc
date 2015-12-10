set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

Plugin 'scrooloose/nerdtree'
let NERDTreeDirArrows = 0

Plugin 'kien/ctrlp.vim'
let g:ctrlp_max_files = 0
let g:ctrlp_by_filename = 1
" let g:ctrlp_clear_cache_on_exit = 0
if executable('ag')
  let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden
      \ --ignore .git
      \ --ignore lost+found
      \ --ignore obj.x86_64-dicos
      \ --ignore "**/*.pyc"
      \ --ignore "**/*.o" 
      \ --ignore "**/*.d"
      \ -g ""'
  set grepprg=ag\ --nogroup\ --nocolor
endif

Plugin 'FelikZ/ctrlp-py-matcher'
let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
let g:airline#extensions#tabline#enabled = 1

" Plugin 'JazzCore/ctrlp-cmatcher'
" let g:ctrlp_match_func = {'match' : 'matcher#cmatch' }

Plugin 'mileszs/ack.vim'
let g:ackprg = 'ag --nogroup --nocolor --column 
	\ --ignore lost+found 
	\ --ignore obj.x86_64-dicos 
	\ --ignore "**/*.a" 
	\ --ignore Test
	\ --ignore buildlogs
	\ --ignore "**/*.o" 
	\ --ignore "**/*.d"
	\ --ignore "**/*.skel"
	\ --ignore "**/*.log" '

Plugin 'jlanzarotta/bufexplorer'

" Plugin 'vim-scripts/a.vim'
" Plugin 'vim-scripts/taglist.vim'
" Plugin 'majutsushi/tagbar'
" nmap <F8> :TagbarToggle<CR>

Plugin 'bling/vim-airline'
let g:airline#extensions#tabline#enabled = 0

Plugin 'altercation/vim-colors-solarized'
" Plugin 'chriskempson/vim-tomorrow-theme'

Plugin 'vim-scripts/ccase.vim'

Plugin 'gustafj/vim-ttcn'

Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'garbas/vim-snipmate'
Plugin 'honza/vim-snippets'

" Plugin 'Valloric/YouCompleteMe'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Debug ycm
" let g:ycm_server_keep_logfiles = 0
" let g:ycm_server_log_level = 'debug'
" let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'

syntax enable
let g:solarized_termcolors=256
set background=dark
colorscheme solarized

set hlsearch
set guifont=DejaVu\ Sans\ Mono
set expandtab
set shiftwidth=4
set tabstop=4

" set ttcn
au BufNewFile,BufRead *.ttcn  setf ttcn
if !exists("g:ctags_ttcn_cmd")
    let g:ctags_ttcn_cmd = $TTCN3_DIR . "/bin/ctags_ttcn3"
endif

function! GenTtcnTags()
    silent !clear
    " default editor start under testobjects
    let b:mtas_ttcn3_to = "/vobs/ims_ttcn3/projects/TAS/imsas_ttcn/testobjects"
    let b:mtas_ttcn3_fw = "/vobs/ims_ttcn3/projects/TAS/FTFW/ttcn"
    let b:mtas_ttcn3 = "/vobs/ttcn/TCC_Releases"

    execute "!" . g:ctags_ttcn_cmd . " -R " . b:mtas_ttcn3_fw . " " . b:mtas_ttcn3_to . " " . b:mtas_ttcn3
endfunction

function! TagbarToggleForTtcn()
    let g:tagbar_ctags_bin = g:ctags_ttcn_cmd
    TagbarToggle
endfunction

function! s:ExecuteInShell(command)
    let command = join(map(split(a:command), 'expand(v:val)'))
    let winnr = bufwinnr('^' . command . '$')
    silent! execute  winnr < 0 ? 'botright new ' . fnameescape(command) : winnr . 'wincmd w'
    setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap number
    echo 'Execute ' . command . '...'
    silent! execute 'silent %!'. command
    silent! execute 'resize ' . line('$')
    silent! redraw
    silent! execute 'au BufUnload <buffer> execute bufwinnr(' . bufnr('#') . ') . ''wincmd w'''
    silent! execute 'nnoremap <silent> <buffer> <LocalLeader>r :call <SID>ExecuteInShell(''' . command . ''')<CR>'
    echo 'Shell command ' . command . ' executed.'
endfunction
command! -complete=shellcmd -nargs=+ Shell call s:ExecuteInShell(<q-args>)

function! BuildTtcnCode()
    let b:mtas_make_dir = "/vobs/ims_ttcn3/common/bin/.build"
    Shell /vobs/ims_ttcn3/projects/TAS/tools/tiger/src/ttcnmake.pl -dir=/vobs/ims_ttcn3/common/bin/.build -stopOnError
endfunction
" mapping key
map , :BufExplorer <CR>
map <F2> :mksession! ~/.vim_session <CR>
map <F3> :source ~/.vim_session <CR>

autocmd FileType ttcn map <F5> :call GenTtcnTags() <CR>
" autocmd FileType ttcn nmap <F6> :call TagbarToggleForTtcn()<CR>
autocmd FileType ttcn nmap <F7> :call BuildTtcnCode()<CR>
autocmd FileType * nmap <F8> :call ReloadAllSnippets()<CR>

if &term =~ '256color'
    set t_ut=
endif


