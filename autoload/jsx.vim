" Language:    JSX
" Maintainer:  Fuji, Goro (gfx) <fuji.goro@dena.jp>
" URL:         http://github.com/jsx/jsx.vim
" License:     MIT License

let s:save_cpo = &cpo
set cpo&vim


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
    let str = substitute(str, '&yen;', '\&#65509;', 'g')
    let str = substitute(str, '&#\(\d\+\);', '\=s:nr2enc_char(submatch(1))', 'g')
    let str = substitute(str, '&amp;', '\&', 'g')
    let str = substitute(str, '&raquo;', '>', 'g')
    let str = substitute(str, '&laquo;', '<', 'g')

    return str
endfunction

function! s:addToInfo(candidate, sep, message)
    if strlen(a:candidate.info) > 0
        let a:candidate.info = a:candidate.info . a:sep . a:message
    else
        let a:candidate.info = a:message
    endif
endfunction

function! jsx#complete(findstart, base) abort
  if a:findstart
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
  endif

  let input_content = join(getline(1, '$'), "\n")

  let command = printf('%s --input-filename %s --complete %d:%d -- -',
              \  get(g:, 'jsx_command', 'jsx'),
              \  shellescape(bufname('%')),
              \  line('.'), col('.')
              \)

    let max_menu_width = winwidth(winnr())
                \ - wincol()
                \ - get(g:, 'jsx_complete_max_menu_width', 22)

  "try
    let ret = system(command, input_content)
    sandbox let candidates = eval(ret)
    let output = []
    for candidate in candidates
        if stridx(candidate.word, a:base) != 0
            continue
        endif

        " show overloaded functions
        let candidate.dup = 1

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

        if has_key(candidate, "doc")
            call s:addToInfo(candidate, "\n", s:format_doc(candidate.doc))
        endif

        if has_key(candidate, "definedClass")
            call s:addToInfo(candidate, "\n", "[" . candidate.definedClass . "]")
        endif

        call add(output, candidate)
    endfor
  "catch
  "  let output = []
  "endtry

  return output
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et:
