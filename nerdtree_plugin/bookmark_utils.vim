if exists('g:loaded_nerd_tree_bookmark_utils') || ! exists('g:loaded_nerd_tree') || ! g:loaded_nerd_tree
  finish
endif

let g:loaded_nerd_tree_bookmark_utils = 1
let g:slash = !exists("+shellslash") || &shellslash ? '/' : '\'

function! s:BookmarkPrefix(id)
  return '<<' . a:id . '>>_'
endfunction

function! s:AvailableBookmarkId()
  let l:names = g:NERDTreeBookmark.BookmarkNames()
  call filter(l:names, 'v:val =~# "^<<[0-9]>>_"')
  if empty(l:names)
    return 0
  endif
  call sort(l:names)
  call map(l:names, 'v:val[2]')
  for i in range(10)
    if index(l:names, string(l:i)) < 0
      return l:i
    endif
  endfor
  return '-'
endfunction

function! NerdTreexOverrideKeyMap(key, scope, newCallback)
  call g:NERDTreeKeyMap.Remove(a:key, a:scope)
  call NERDTreeAddKeyMap({ 'key': a:key, 'scope': a:scope, 'callback': a:newCallback })
  let l:keymap = g:NERDTreeKeyMap.FindFor(a:key, a:scope)
  call l:keymap.bind()
endfunction

function! NerdTreexBookmark()
  let l:node = g:NERDTreeFileNode.GetSelected()
  let l:path = g:slash . join(l:node.path.pathSegments, g:slash)
  let l:path = substitute(l:path, '\s', '@', 'g')
  let l:name = s:BookmarkPrefix(s:AvailableBookmarkId()) . l:path
  exe 'Bookmark ' . l:name
endfunction

function! NerdTreexAccessBookmark(id)
  if !b:NERDTree.ui.getShowBookmarks()
    exe 'norm ' . g:NERDTreeMapToggleBookmarks
  endif

  let l:tmp = @/
  silent! exe '/[^{]' . s:BookmarkPrefix(a:id)
  nohls 
  let @/ = l:tmp
endfunction

function! NerdTreexOpenHSplitBookmark(bm)
  call a:bm.activate(b:NERDTree, {'where': 'h'})
endfunction

function! NerdTreexOpenVSplitBookmark(bm)
  call a:bm.activate(b:NERDTree, {'where': 'v'})
endfunction

function! NerdTreexPreviewNodeCurrentBookmark(bm)
  call a:bm.activate(b:NERDTree, {'where': 'p', 'stay':'1', 'keepopen':'1'})
endfunction

function! NerdTreexPreviewNodeHSplitBookmark(bm)
  call a:bm.activate(b:NERDTree, {'where': 'h', 'stay':'1', 'keepopen':'1'})
endfunction

function! NerdTreexPreviewNodeVSplitBookmark(bm)
  call a:bm.activate(b:NERDTree, {'where': 'v', 'stay':'1', 'keepopen':'1'})
endfunction

function! NerdTreexActivateBookmark(bm)
  call a:bm.activate(b:NERDTree, {'where': 'p'})
  let l:root = b:NERDTree.root.path
  call s:AddItemToRootHistory(l:root.str())
endfunction

function! NerdTreexUpDirCurrentRootOpen()
  call nerdtree#ui_glue#upDir(1)
  let l:root = b:NERDTree.root.path
  call s:AddItemToRootHistory(l:root.str())
endfunction

function! NerdTreexUpDirCurrentRootClosed()
  call nerdtree#ui_glue#upDir(0)
  let l:root = b:NERDTree.root.path
  call s:AddItemToRootHistory(l:root.str())
endfunction

function! NerdTreexChangeRoot(node)
  call b:NERDTree.changeRoot(a:node)
  let l:root = b:NERDTree.root.path
  call s:AddItemToRootHistory(l:root.str())
endfunction

function! NerdTreexChangeRootToCwd(node)
  try
    let cwd = g:NERDTreePath.New(getcwd())
  catch /^NERDTree.InvalidArgumentsError/
    call nerdtree#echo("current directory does not exist.")
    return
  endtry
  call b:NERDTree.changeRoot(g:NERDTreeDirNode.New(cwd, b:NERDTree))
  let l:root = b:NERDTree.root.path
  call s:AddItemToRootHistory(l:root.str())
endfunction

function! s:AddItemToRootHistory(item)
  if w:nerdtreex_rh_ptr < -1
    " During history navigation
    call remove(w:nerdtreex_rh, w:nerdtreex_rh_ptr+1, -1)
  endif
  let l:last = empty(w:nerdtreex_rh) ? '' : w:nerdtreex_rh[-1]
  if l:last ==# a:item
    return
  endif
  let w:nerdtreex_rh = add(w:nerdtreex_rh, a:item)
  let w:nerdtreex_rh_ptr = -1
endfunction

function! NerdTreexChangeRootByPath(path)
  let l:pathObj = g:NERDTreePath.New(a:path)
  call b:NERDTree.changeRoot(g:NERDTreeDirNode.New(l:pathObj, b:NERDTree))
endfunction

function! NerdTreexRootHistoryBackward()
  let l:len = len(w:nerdtreex_rh)
  let w:nerdtreex_rh_ptr = w:nerdtreex_rh_ptr - 1
  if w:nerdtreex_rh_ptr >= -l:len
    call NerdTreexChangeRootByPath(w:nerdtreex_rh[w:nerdtreex_rh_ptr])
  else
    let w:nerdtreex_rh_ptr = -l:len
  endif
endfunction

function! NerdTreexRootHistoryForward()
  if w:nerdtreex_rh_ptr < -1
    let w:nerdtreex_rh_ptr = w:nerdtreex_rh_ptr + 1
    call NerdTreexChangeRootByPath(w:nerdtreex_rh[w:nerdtreex_rh_ptr])
  endif
endfunction

function! NerdTreexShowRootHistory()
  let l:len = len(w:nerdtreex_rh)
  for i in range(l:len)
    let l:r = w:nerdtreex_rh[i]
    if i == len+w:nerdtreex_rh_ptr
      echohl Special | echo '>> ' . l:r
    else
      echohl PmenuSel | echo '   ' . l:r
    endif
  endfor
  echohl None
endfunction

function! NerdTreexInitBookmarkUtils()
      nnoremap <buffer><silent> g<CR> :<C-u>call NerdTreexBookmark()<CR>
      nnoremap <buffer><silent> g0 :<C-u>call NerdTreexAccessBookmark(0)<CR>
      nnoremap <buffer><silent> g1 :<C-u>call NerdTreexAccessBookmark(1)<CR>
      nnoremap <buffer><silent> g2 :<C-u>call NerdTreexAccessBookmark(2)<CR>
      nnoremap <buffer><silent> g3 :<C-u>call NerdTreexAccessBookmark(3)<CR>
      nnoremap <buffer><silent> g4 :<C-u>call NerdTreexAccessBookmark(4)<CR>
      nnoremap <buffer><silent> g5 :<C-u>call NerdTreexAccessBookmark(5)<CR>
      nnoremap <buffer><silent> g6 :<C-u>call NerdTreexAccessBookmark(6)<CR>
      nnoremap <buffer><silent> g7 :<C-u>call NerdTreexAccessBookmark(7)<CR>
      nnoremap <buffer><silent> g8 :<C-u>call NerdTreexAccessBookmark(8)<CR>
      nnoremap <buffer><silent> g9 :<C-u>call NerdTreexAccessBookmark(9)<CR>
      nnoremap <buffer><silent> g- :<C-u>call NerdTreexAccessBookmark('-')<CR>
      nnoremap <buffer><silent> gk :<C-u>call NerdTreexRootHistoryBackward()<CR>
      nnoremap <buffer><silent> gj :<C-u>call NerdTreexRootHistoryForward()<CR>
      nnoremap <buffer><silent> Sh :<C-u>call NerdTreexShowRootHistory()<CR>

      call NERDTreeAddKeyMap({ 'key':'g<CR>', 'quickhelpText':'Add bookmark', 'callback':v:none })
      call NERDTreeAddKeyMap({ 'key':'g0', 'quickhelpText':'Move cursor to bookmark 0', 'callback':v:none })
      call NERDTreeAddKeyMap({ 'key':'g1', 'quickhelpText':'Move cursor to bookmark 1', 'callback':v:none })
      call NERDTreeAddKeyMap({ 'key':'g9', 'quickhelpText':'Move cursor to bookmark 9', 'callback':v:none })
      call NERDTreeAddKeyMap({ 'key':'gk', 'quickhelpText':'Root history backward', 'callback':v:none })
      call NERDTreeAddKeyMap({ 'key':'gj', 'quickhelpText':'Root history forward', 'callback':v:none })
      call NERDTreeAddKeyMap({ 'key':'Sh', 'quickhelpText':'Show root history', 'callback':v:none })

      if ! exists('w:nerdtreex_rh_ptr')
        let w:nerdtreex_rh_ptr = -1
      endif

      if ! exists('w:nerdtreex_rh')
        let w:nerdtreex_rh = []
        if exists('b:NERDTree')
          let l:root = b:NERDTree.root.path.str()
        else
          let l:root = expand('%:p:h')
        endif
        call s:AddItemToRootHistory(l:root)
      endif

      call NerdTreexOverrideKeyMap(g:NERDTreeMapOpenSplit, 'Bookmark', 'NerdTreexOpenHSplitBookmark')
      call NerdTreexOverrideKeyMap(g:NERDTreeMapOpenVSplit, 'Bookmark', 'NerdTreexOpenVSplitBookmark')
      call NerdTreexOverrideKeyMap(g:NERDTreeMapPreview, 'Bookmark', 'NerdTreexPreviewNodeCurrentBookmark')
      call NerdTreexOverrideKeyMap(g:NERDTreeMapPreviewSplit, 'Bookmark', 'NerdTreexPreviewNodeHSplitBookmark')
      call NerdTreexOverrideKeyMap(g:NERDTreeMapPreviewVSplit, 'Bookmark', 'NerdTreexPreviewNodeVSplitBookmark')
      call NerdTreexOverrideKeyMap(g:NERDTreeMapActivateNode, 'Bookmark', 'NerdTreexActivateBookmark')
      call NerdTreexOverrideKeyMap(g:NERDTreeMapUpdirKeepOpen, 'all', 'NerdTreexUpDirCurrentRootOpen')
      call NerdTreexOverrideKeyMap(g:NERDTreeMapUpdir, 'all', 'NerdTreexUpDirCurrentRootClosed')
      call NerdTreexOverrideKeyMap(g:NERDTreeMapChangeRoot, 'Node', 'NerdTreexChangeRoot')
      call NerdTreexOverrideKeyMap(g:NERDTreeMapCWD, 'Node', 'NerdTreexChangeRootToCwd')
endfunction

au FileType nerdtree call NerdTreexInitBookmarkUtils()

" vim: sw=2 foldmethod=marker :
