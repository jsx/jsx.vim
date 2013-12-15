" Language:    JSX
" Maintainer:  Fuji, Goro (gfx) <fuji.goro@dena.jp>
" URL:         http://github.com/jsx/jsx.vim
" License:     MIT License
"
" JSX omni-complition function

let s:save_cpo = &cpo
set cpo&vim

let s:jsx_complete_ignore_syntax_type = {
      \ "jsxComment" : 1,
      \ "jsxLineComment" : 1,
      \ "jsxStringD" : 1,
      \ "jsxStringS" : 1,
      \ "jsxRegExp" : 1
      \ }

function! s:abbr(word, maxlen) abort
  if strdisplaywidth(a:word) > a:maxlen
    return a:word[0 : a:maxlen]. " ..."
  else
    return a:word
  endif
endfunction


" borrowed from html.vim in https://github.com/mattn/webapi-vim

function! s:nr2byte(nr)
  if a:nr < 0x80
    return nr2char(a:nr)
  elseif a:nr < 0x800
    return nr2char(a:nr/64+192).nr2char(a:nr%64+128)
  else
    return nr2char(a:nr/4096%16+224).nr2char(a:nr/64%64+128).nr2char(a:nr%64+128)
  endif
endfunction

function! s:nr2enc_char(charcode)
  if &encoding == 'utf-8'
    return nr2char(a:charcode)
  endif
  let char = s:nr2byte(a:charcode)
  if strlen(char) > 1
    let char = strtrans(iconv(char, 'utf-8', &encoding))
  endif
  return char
endfunction

function! s:format_doc(str) abort
    let str = a:str

    let str = substitute(str, '[ \t\r\n]*</p>[ \t\r\n]*', "\n", 'g')
    let str = substitute(str, '<[^>]*>', '', 'g')

    let str = substitute(str, '&gt;', '>', 'g')
    let str = substitute(str, '&lt;', '<', 'g')
    let str = substitute(str, '&quot;', '"', 'g')
    let str = substitute(str, '&apos;', "'", 'g')
    let str = substitute(str, '&nbsp;', ' ', 'g')
    let str = substitute(str, '&#\(\d\+\);', '\=s:nr2enc_char(submatch(1))', 'g')
    let str = substitute(str, '&amp;', '&', 'g')

    return str
endfunction

function! s:add_to_info(candidate, sep, message)
    if strlen(a:candidate.info) > 0
        let a:candidate.info = a:candidate.info . a:sep . a:message
    else
        let a:candidate.info = a:message
    endif
endfunction

function! s:current_word_starting_pos() abort
    let line = getline('.')
    let pos = col('.')
    if pos == col('$')
      let pos -= 1
    endif
    if pos > 0 && line[pos - 1] =~ '\w'
      while pos > 0 && line[pos - 1] =~ '\w'
        let pos -= 1
      endwhile
    endif
    return pos
endfunction


function! s:get_data_source()
  let input_content = join(getline(1, '$'), "\n")

  let command = printf('%s --input-filename %s --complete %d:%d -- -',
        \  get(g:, 'jsx_command', 'jsx-with-server'),
        \  shellescape(bufname('%')),
        \  line('.'), col('.')
        \)

  try
    let ret = system(command, input_content)
    sandbox let data_source = eval(ret)
  catch
    let data_source = []
  endtry

  return data_source
endfunction

function! s:is_completion_for_this(base)
  let this_pos = col('.') - len(a:base) - len("this.") - 1
  if this_pos >= 0
    return stridx(getline(".")[this_pos : ], "this.") == 0
  else
    return 0
  endif
endfunction

function! jsx#complete(findstart, base) abort
  if a:findstart
    " see :help complete-functions
    if has_key(s:jsx_complete_ignore_syntax_type, synIDattr(synID(line('.'), col('.')-1, 0), "name"))
      return -2
    endif
    return s:current_word_starting_pos()
  endif

  let data_source = s:get_data_source()

  let is_completion_for_this = s:is_completion_for_this(a:base)
  
  let max_menu_width = winwidth(winnr())
        \ - wincol()
        \ - get(g:, 'jsx_complete_max_menu_width', 22)


  let show_private = (len(a:base) > 0 && a:base[0] == "_") || is_completion_for_this

  let output = []
  for candidate in data_source
    if stridx(candidate.word, a:base) != 0
      continue
    endif

    if candidate.word[0] == "_" && !show_private
      continue
    endif

    " show overloaded functions
    let candidate.dup = 1
    " show mis-cased candidates
    let candidate.icase = 1

    let candidate.info = ""

    " menu (extra information)
    if has_key(candidate, "args")
      " function type
      let w = candidate.word . "(" . join(map(candidate.args, 'v:val.name . " : " . v:val.type'), ", ") . ")"

      let candidate.abbr = s:abbr(w, max_menu_width)
      let candidate.menu = ": " . candidate.returnType
      let candidate.info = w . " : " . candidate.returnType
    elseif has_key(candidate, "type")
      " variable type
      let candidate.abbr = s:abbr(candidate.word, max_menu_width)
      let candidate.menu = ": " . candidate.type
      let candidate.info = "var " . candidate.word . " : " . candidate.type
    endif

    if has_key(candidate, "doc") && strlen(candidate.doc) > 0
      call s:add_to_info(candidate, "\n", s:format_doc(candidate.doc))
    endif

    if has_key(candidate, "definedClass")
      call s:add_to_info(candidate, "\n", "[" . candidate.definedClass . "]")
    endif

    if strlen(candidate.info) == 0
      let candidate.info = candidate.word
    endif

    call add(output, candidate)
  endfor
  return output
endfunction

function! jsx#test_it() abort
  let l = line('.')
  let c = col('.')

  let pattern = '\(\C\<test\w\+\).*'

  if search(pattern, 'bcW') == 0
    echo "no test method found"
    return
  endif

  let test_name = substitute(getline('.')[col('.')-1 : ], pattern, '\1', '')

  call cursor(l, c)

  let command = printf('%s --input-filename %s --test -- - %s',
        \  get(g:, 'jsx_command', 'jsx'),
        \  shellescape(bufname('%')),
        \  test_name
        \)
  let input_content = join(getline(1, '$'), "\n")
  echo system(command, input_content)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: set tabstop=2:
" vim: set shiftwidth=2:
" vim: set et:
