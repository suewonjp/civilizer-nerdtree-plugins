" ============================================================================
" Civilizer Nerdtree Plugins
" Author:       Suewon Bahng <https://github.com/suewonjp/>
" Version:      1.1.0
" ============================================================================

if exists('g:loaded_nerd_tree_netrw_style_preview') || ! exists('g:loaded_nerd_tree') || ! g:loaded_nerd_tree
  finish
endif

let g:loaded_nerd_tree_netrw_style_preview = 1
let s:slash = !exists("+shellslash") || &shellslash ? '/' : '\'

function! NerdTreexPreview(key)
  if ! exists('t:nerdtreex_has_preview_win') || winnr('$') < 2
    let t:nerdtreex_has_preview_win = 0
  endif
  let l:is_dir = 0
  if exists('b:NERDTree')
    let l:node = g:NERDTreeFileNode.GetSelected()
    let l:is_dir = l:node.path.isDirectory
    let l:path = s:slash . join(l:node.path.pathSegments, s:slash)
  endif
  if l:is_dir
    return
  endif
  if a:key ==# 'pr'
    if t:nerdtreex_has_preview_win
      let l:wnr = winnr()
      exe '2wincmd w'
      exe 'edit ' . l:path
      exe l:wnr . 'wincmd w'
    else
      if exists('g:netrw_preview') && g:netrw_preview == 1
        exe 'norm gs'
      else
        exe 'norm gi'
      endif
      let t:nerdtreex_has_preview_win = 1
    endif
  elseif a:key ==# 'Pr'
    if t:nerdtreex_has_preview_win
      exe '2wincmd w'
      exe 'edit ' . l:path
    else
      exe 'norm s'
      let t:nerdtreex_has_preview_win = 1
    endif
  elseif a:key == '<C-w>p'
    if t:nerdtreex_has_preview_win
      exe '1wincmd w'
      exe "norm \<Up>"
      call NerdTreexPreview('Pr')
    endif
  elseif a:key == '<C-w>n'
    if t:nerdtreex_has_preview_win
      exe '1wincmd w'
      exe "norm \<Down>"
      call NerdTreexPreview('Pr')
    endif
  elseif a:key == '<C-w>z'
    if t:nerdtreex_has_preview_win
      exe '2wincmd c'
      let t:nerdtreex_has_preview_win = 0
    endif
  endif
endfunction

function! NerdTreexInitNetrwStylePreview()
    nnoremap <Plug>(nerdtree-x-preview-open) :<C-u>call NerdTreexPreview('pr')<CR>
    nnoremap <Plug>(nerdtree-x-preview-open-focus) :<C-u>call NerdTreexPreview('Pr')<CR>
    nnoremap <Plug>(nerdtree-x-preview-prev) :<C-u>call NerdTreexPreview("\<C-w\>p")<CR>
    nnoremap <Plug>(nerdtree-x-preview-next) :<C-u>call NerdTreexPreview("\<C-w\>n")<CR>
    nnoremap <Plug>(nerdtree-x-preview-close) :<C-u>call NerdTreexPreview("\<C-w\>z")<CR>

    nmap <buffer><silent> pr <Plug>(nerdtree-x-preview-open)
    nmap <buffer><silent> Pr <Plug>(nerdtree-x-preview-open-focus)
    nmap <expr><silent> <C-w>p get(t:, 'nerdtreex_has_preview_win', 0) ?  '<Plug>(nerdtree-x-preview-prev)' : '<C-w>p'
    nmap <buffer><silent> <C-w>n <Plug>(nerdtree-x-preview-next)
    nmap <expr><silent> <C-w>n get(t:, 'nerdtreex_has_preview_win', 0) ?  '<Plug>(nerdtree-x-preview-next)' : '<C-w>n'
    nmap <expr><silent> <C-w>z get(t:, 'nerdtreex_has_preview_win', 0) ?  '<Plug>(nerdtree-x-preview-close)' : '<C-w>z'

    call NERDTreeAddKeyMap({ 'key':'pr', 'quickhelpText':'Netrw style preview', 'callback':v:null })
    call NERDTreeAddKeyMap({ 'key':'Pr', 'quickhelpText':'Netrw style preview (focus taken)', 'callback':v:null })
    call NERDTreeAddKeyMap({ 'key':'<C-W>p', 'quickhelpText':'Netrw style preview (prev file)', 'callback':v:null })
    call NERDTreeAddKeyMap({ 'key':'<C-W>n', 'quickhelpText':'Netrw style preview (next file)', 'callback':v:null })
    call NERDTreeAddKeyMap({ 'key':'<C-W>z', 'quickhelpText':'Close Netrw style preview window', 'callback':v:null })
endfunction

au FileType nerdtree call NerdTreexInitNetrwStylePreview()

" vim: sw=2 foldmethod=marker :
