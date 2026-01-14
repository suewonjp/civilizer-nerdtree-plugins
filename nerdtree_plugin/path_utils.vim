if exists('g:loaded_nerd_tree_path_utils') || ! exists('g:loaded_nerd_tree') || ! g:loaded_nerd_tree
  finish
endif

let g:loaded_nerd_tree_path_utils = 1
let s:slash = !exists("+shellslash") || &shellslash ? '/' : '\'

function! NerdTreexGetAbsPath(...)
  let l:node = g:NERDTreeFileNode.GetSelected()
  let l:quote = ''
  let l:tilde = a:0 ? a:1 : ''
  if l:tilde != '~'
    let l:quote = a:0 ? a:1 : ''
  endif
  let l:path = l:quote . s:slash . join(l:node.path.pathSegments, s:slash) . l:quote
  if l:tilde == '~'
    let l:path = fnamemodify(l:path, ':p:~')
  endif
  return l:path
endfunction 

function! NerdTreexGetRelPath(...)
  let l:node = g:NERDTreeFileNode.GetSelected()
  let l:quote = a:0 ? a:1 : ''
  let l:fp = s:slash . join(l:node.path.pathSegments, s:slash)
  return l:quote . fnamemodify(l:fp, ':.') . l:quote
endfunction

function! NerdTreexGetPathTail( ... )
  let l:node = g:NERDTreeFileNode.GetSelected()
  let l:quote = a:0 ? a:1 : ''
  let l:fp = s:slash . join(l:node.path.pathSegments, s:slash)
  return l:quote . fnamemodify(l:fp, ':t') . l:quote
endfunction

function! NerdTreexGetRootPath( ... )
  let l:node = b:NERDTree.getRoot()
  let l:quote = a:0 ? a:1 : ''
  let l:fp = s:slash . join(l:node.path.pathSegments, s:slash)
  return l:quote . s:slash . join(l:node.path.pathSegments, s:slash) . l:quote
endfunction

function! NerdTreexInitPathUtils()
    nnoremap <buffer><silent> yy :<C-u>call setreg(v:register, NerdTreexGetAbsPath())<CR> \| :echo getreg(v:register)<CR>
    nnoremap <buffer><silent> y+ :<C-u>call setreg('*', NerdTreexGetAbsPath())<CR> \| :echo getreg('*')<CR>
    nnoremap <buffer><silent> "" :<C-u>call setreg(v:register, NerdTreexGetAbsPath('"'))<CR> \| :echo getreg(v:register)<CR>
    nnoremap <buffer><silent> '' :<C-u>call setreg(v:register, NerdTreexGetAbsPath("'"))<CR> \| :echo getreg(v:register)<CR>
    nnoremap <buffer><silent> ~~ :<C-u>call setreg(v:register, NerdTreexGetAbsPath('~'))<CR> \| :echo getreg(v:register)<CR>
    nnoremap <buffer><silent> ~+ :<C-u>call setreg('*', NerdTreexGetAbsPath('~'))<CR> \| :echo getreg('*')<CR>
    nnoremap <buffer><silent> rr :<C-u>call setreg(v:register, NerdTreexGetRelPath())<CR> \| :echo getreg(v:register)<CR>
    nnoremap <buffer><silent> r+ :<C-u>call setreg('*', NerdTreexGetRelPath())<CR> \| :echo getreg('*')<CR>
    nnoremap <buffer><silent> r" :<C-u>call setreg(v:register, NerdTreexGetRelPath('"'))<CR> \| :echo getreg(v:register)<CR>
    nnoremap <buffer><silent> r' :<C-u>call setreg(v:register, NerdTreexGetRelPath("'"))<CR> \| :echo getreg(v:register)<CR>
    nnoremap <buffer><silent> tt :<C-u>call setreg(v:register, NerdTreexGetPathTail())<CR> \| :echo getreg(v:register)<CR>
    nnoremap <buffer><silent> t+ :<C-u>call setreg('*', NerdTreexGetPathTail())<CR> \| :echo getreg('*')<CR>
    nnoremap <buffer><silent> t" :<C-u>call setreg(v:register, NerdTreexGetPathTail('"'))<CR> \| :echo getreg(v:register)<CR>
    nnoremap <buffer><silent> t' :<C-u>call setreg(v:register, NerdTreexGetPathTail("'"))<CR> \| :echo getreg(v:register)<CR>

    call NERDTreeAddKeyMap({ 'key':'yy', 'quickhelpText':'Yank absolute path', 'callback':v:null })
    call NERDTreeAddKeyMap({ 'key':'y+', 'quickhelpText':'Yank absolute path to system clipboard', 'callback':v:null })
    call NERDTreeAddKeyMap({ 'key':'""', 'quickhelpText':'Yank absolute double-quoted path', 'callback':v:null })
    call NERDTreeAddKeyMap({ 'key':"''", 'quickhelpText':'Yank absolute single-quoted path', 'callback':v:null })
    call NERDTreeAddKeyMap({ 'key':'~~', 'quickhelpText':'Yank absolute tilde path', 'callback':v:null })
    call NERDTreeAddKeyMap({ 'key':'~+', 'quickhelpText':'Yank absolute tilde path to system clipboard', 'callback':v:null })
    call NERDTreeAddKeyMap({ 'key':'rr', 'quickhelpText':'Yank relative path', 'callback':v:null })
    call NERDTreeAddKeyMap({ 'key':'r+', 'quickhelpText':'Yank relative path to system clipboard', 'callback':v:null })
    call NERDTreeAddKeyMap({ 'key':'r"', 'quickhelpText':'Yank relative double-quoted path', 'callback':v:null })
    call NERDTreeAddKeyMap({ 'key':"r'", 'quickhelpText':'Yank relative single-quoted path', 'callback':v:null })
    call NERDTreeAddKeyMap({ 'key':'tt', 'quickhelpText':'Yank path tail', 'callback':v:null })
    call NERDTreeAddKeyMap({ 'key':'t+', 'quickhelpText':'Yank path tail to system clipboard', 'callback':v:null })
    call NERDTreeAddKeyMap({ 'key':'t"', 'quickhelpText':'Yank double-quoted path tail', 'callback':v:null })
    call NERDTreeAddKeyMap({ 'key':"t'", 'quickhelpText':'Yank single-quoted path tail', 'callback':v:null })

    command! -nargs=* Cnr :let @+=NerdTreexGetRootPath(<f-args>)
endfunction

au FileType nerdtree call NerdTreexInitPathUtils()

" vim: sw=2 foldmethod=marker :
