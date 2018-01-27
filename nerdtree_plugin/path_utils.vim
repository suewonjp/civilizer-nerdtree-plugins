if exists('g:loaded_nerd_tree_path_utils') || ! exists('g:loaded_nerd_tree') || ! g:loaded_nerd_tree
  finish
endif

let g:loaded_nerd_tree_path_utils = 1
let g:slash = !exists("+shellslash") || &shellslash ? '/' : '\'

function! NerdTreexGetAbsPath(...)
  let l:node = g:NERDTreeFileNode.GetSelected()
  let l:quote = a:0 ? a:1 : ''
  return l:quote . g:slash . join(l:node.path.pathSegments, g:slash) . l:quote
endfunction 

au FileType nerdtree
    \ nnoremap <buffer><silent> yy :<C-u>call setreg(v:register, NerdTreexGetAbsPath())<CR> \| :echo getreg(v:register)<CR> |
    \ nnoremap <buffer><silent> y+ :<C-u>call setreg('*', NerdTreexGetAbsPath())<CR> \| :echo getreg('*')<CR> |
    \ nnoremap <buffer><silent> "" :<C-u>call setreg(v:register, NerdTreexGetAbsPath('"'))<CR> \| :echo getreg(v:register)<CR> |
    \ nnoremap <buffer><silent> '' :<C-u>call setreg(v:register, NerdTreexGetAbsPath("'"))<CR> \| :echo getreg(v:register)<CR> |
    \ nnoremap <buffer><silent> "+ :<C-u>call setreg('*', NerdTreexGetAbsPath('"'))<CR> \| :echo getreg('*')<CR> |
    \ nnoremap <buffer><silent> '+ :<C-u>call setreg('*', NerdTreexGetAbsPath("'"))<CR> \| :echo getreg('*')<CR>

" vim: sw=2 foldmethod=marker :
