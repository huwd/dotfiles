set nocompatible

if filereadable(expand("~/.vimrc.before"))
  source ~/.vimrc.before
endif

" ================ General Config ====================
nnoremap <Left> :echo "Use h to go left!"<CR>
vnoremap <Left> :<C-u>echo "Use h to go left!"<CR>
inoremap <Left> <C-o>:echo "Use h to go left!"<CR>

nnoremap <Right> :echo "Use l to go right!"<CR>
vnoremap <Right> :<C-u>echo "Use l to go right!"<CR>
inoremap <Right> <C-o>:echo "Use l to go right!"<CR>

nnoremap <Up> :echo "Use j to go up!"<CR>
vnoremap <Up> :<C-u>echo "Use j to go up!"<CR>
inoremap <Up> <C-o>:echo "Use j to go up"<CR>

nnoremap <Down> :echo "Use k to go down!"<CR>
vnoremap <Down> :<C-u>echo "Use k to go down!"<CR>
inoremap <Down> <C-o>:echo "Use k to go down!"<CR>


" =============== Vundle Initialization ===============
" This loads all the plugins specified in ~/.vim/vundles.vim
" Use Vundle plugin to manage all other plugins
if filereadable(expand("~/.dotfiles/nvim/bundle/vundle/vundles.vim"))
  source ~/.vim/bundle/bundle/vundles.vim
endif
au BufNewFile,BufRead *.vundle set filetype=vim
