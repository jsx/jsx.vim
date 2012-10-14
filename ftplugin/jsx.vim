" Language:    JSX
" Maintainer:  Fuji, Goro (gfx) <fuji.goro@dena.jp>
" URL:         http://github.com/jsx/jsx.vim
" License:     MIT License
"

setlocal omnifunc=jsx#complete

noremap t :call jsx#test_it()<CR>

compiler jsx

" Tagbar http://majutsushi.github.com/tagbar/
let g:tagbar_type_jsx = {}
let g:tagbar_type_jsx.ctagstype = "jsx"
let g:tagbar_type_jsx.kinds = [
    \ 'r:imports',
    \ 'i:interfaces',
    \ 'm:mixins',
    \ 'c:classes',
    \ 'f:functions'
\ ]
let g:tagbar_type_jsx.sro = '.'

"let g:tagbar_type_jsx.kind2scope = {
"    \ 'i' : 'interface',
"    \ 'm' : 'mixin',
"    \ 'c' : 'class'
"\ }
"let g:tagbar_type_jsx.scope2kind = {
"    \ 'interface' : 'i',
"    \ 'mixin'     : 'm',
"    \ 'class'     : 'c'
"\ }

let g:tagbar_type_jsx.sort = 0
let g:tagbar_type_jsx.deffile = expand('<sfile>:p:h:h') . '/ctags/jsx.conf'
" End of Tagbar setting

