if exists('g:loaded_nerd_tree_netrw_style_preview') || ! exists('g:loaded_nerd_tree') || ! g:loaded_nerd_tree
  finish
endif

let g:loaded_nerd_tree_netrw_style_preview = 1
let g:slash = !exists("+shellslash") || &shellslash ? '/' : '\'

function! NerdTreexPreview(key)
  if ! exists('t:nerdtreex_has_preview_win')
    let t:nerdtreex_has_preview_win = 0
  endif
  if exists('b:NERDTree')
    let l:node = g:NERDTreeFileNode.GetSelected()
    let l:path = g:slash . join(l:node.path.pathSegments, g:slash)
  endif
  if a:key == 'pr'
    if t:nerdtreex_has_preview_win
      let l:wnr = winnr()
      exe t:nerdtreex_has_preview_win . 'wincmd w'
      exe 'edit ' . l:path
      exe l:wnr . 'wincmd w'
    else
      exe 'norm gs'
      let t:nerdtreex_has_preview_win = winnr() - 1
    endif
  elseif a:key == 'Pr'
    if t:nerdtreex_has_preview_win
      exe t:nerdtreex_has_preview_win . 'wincmd w'
      exe 'edit ' . l:path
    else
      exe 'norm s'
      let t:nerdtreex_has_preview_win = winnr() - 1
    endif
  elseif a:key == '<C-w>z'
    if t:nerdtreex_has_preview_win
      exe t:nerdtreex_has_preview_win . 'wincmd c'
      let t:nerdtreex_has_preview_win = 0
    endif
  endif
endfunction

function! NerdTreexInitNetrwKeymaps()
    nmap <buffer><silent> pr :<C-u>call NerdTreexPreview('pr')<CR>
    nmap <buffer><silent> Pr :<C-u>call NerdTreexPreview('Pr')<CR>
    nmap <silent> <C-w>z :<C-u>call NerdTreexPreview("\<C-w\>z")<CR>
endfunction

au FileType nerdtree call NerdTreexInitNetrwKeymaps()

" vim: sw=2 foldmethod=marker :
