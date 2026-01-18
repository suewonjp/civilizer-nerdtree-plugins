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

function! s:HasPreviewWin() abort
  return winnr('$') > 1
endfunction

function! NerdTreexPreview(key)
  let l:preview_win_exists = s:HasPreviewWin()
  exe '1wincmd w'
  if exists('b:NERDTree')
    let l:node = g:NERDTreeFileNode.GetSelected()
    let l:path = s:slash . join(l:node.path.pathSegments, s:slash)
  endif
  if a:key ==# 'pr'
    if l:preview_win_exists
      let l:wnr = winnr()
      exe '2wincmd w'
      exe 'edit ' . l:path
      exe l:wnr . 'wincmd w'
    else
      call l:node.open({'where': 'v'})
      exe '1wincmd w'
      let l:preview_win_exists = 1
    endif
  elseif a:key ==# 'Pr'
    if l:preview_win_exists
      exe '2wincmd w'
      exe 'edit ' . l:path
    else
      call l:node.open({'where': 'v'})
      let l:preview_win_exists = 1
    endif
  elseif a:key == '<C-w>p'
    if l:preview_win_exists
      exe '1wincmd w'
      exe "norm \<Up>"
      call NerdTreexPreview('Pr')
    endif
  elseif a:key == '<C-w>n'
    if l:preview_win_exists
      exe '1wincmd w'
      exe "norm \<Down>"
      call NerdTreexPreview('Pr')
    endif
  elseif a:key == '<C-w>z'
    if l:preview_win_exists
      exe '2wincmd c'
      let l:preview_win_exists = 0
    endif
  endif
endfunction

function! NerdTreexClosePreviewWin(...) abort
  " Other mappings need no callback, but <C-w>z needs one.
  " Otherwise, it emits errors when closing preview window on a directory. (don't know why)
  call NerdTreexPreview('<C-w>z')
endfunction

function! NerdTreexInitNetrwStylePreview()
    nnoremap <Plug>(nerdtree-x-preview-open) :<C-u>call NerdTreexPreview('pr')<CR>
    nnoremap <Plug>(nerdtree-x-preview-open-focus) :<C-u>call NerdTreexPreview('Pr')<CR>
    nnoremap <Plug>(nerdtree-x-preview-prev) :<C-u>call NerdTreexPreview("\<C-w\>p")<CR>
    nnoremap <Plug>(nerdtree-x-preview-next) :<C-u>call NerdTreexPreview("\<C-w\>n")<CR>
    nnoremap <Plug>(nerdtree-x-preview-close) :<C-u>call NerdTreexPreview("\<C-w\>z")<CR>

    nmap <buffer><silent> pr <Plug>(nerdtree-x-preview-open)
    nmap <buffer><silent> Pr <Plug>(nerdtree-x-preview-open-focus)
    nmap <buffer><silent> <C-w>p <Plug>(nerdtree-x-preview-prev)
    nmap <expr><silent> <C-w>p <SID>HasPreviewWin() ? '<Plug>(nerdtree-x-preview-prev)' : '<C-w>p'
    nmap <buffer><silent> <C-w>n <Plug>(nerdtree-x-preview-next)
    nmap <expr><silent> <C-w>n <SID>HasPreviewWin() ? '<Plug>(nerdtree-x-preview-next)' : '<C-w>n'
    nmap <expr><silent> <C-w>z <SID>HasPreviewWin() ? '<Plug>(nerdtree-x-preview-close)' : '<C-w>z'

    call NERDTreeAddKeyMap({ 'key':'pr', 'quickhelpText':'Netrw style preview', 'callback':v:null })
    call NERDTreeAddKeyMap({ 'key':'Pr', 'quickhelpText':'Netrw style preview (focus taken)', 'callback':v:null })
    call NERDTreeAddKeyMap({ 'key':'<C-W>p', 'quickhelpText':'Netrw style preview (prev file)', 'callback':v:null })
    call NERDTreeAddKeyMap({ 'key':'<C-W>n', 'quickhelpText':'Netrw style preview (next file)', 'callback':v:null })
    call NERDTreeAddKeyMap({ 'key':'<C-W>z', 'quickhelpText':'Close Netrw style preview window', 'callback':'NerdTreexClosePreviewWin' })
endfunction

au FileType nerdtree call NerdTreexInitNetrwStylePreview()

" vim: sw=2 foldmethod=marker :
