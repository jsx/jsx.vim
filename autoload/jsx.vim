" Language:    JSX
" Maintainer:  Fuji, Goro (gfx) <fuji.goro@dena.jp>
" URL:         http://github.com/jsx/jsx.vim
" License:     MIT License

let s:save_cpo = &cpo
set cpo&vim

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

  "try
    let ret = system(command, input_content)
    sandbox let candidates = eval(ret)
    let output = []
    for candidate in candidates
        if stridx(candidate.word, a:base) != 0
            continue
        endif

        " menu (extra information)
        if has_key(candidate, "returnType")
            " function type
            let candidate.abbr = candidate.word . "(" . join(map(candidate.args, 'v:val.name . " : " . v:val.type'), ", ") . ")"
            let candidate.menu = ": " . candidate.returnType
        elseif has_key(candidate, "type")
            " variable type
            let candidate.menu = ": " . candidate.type
        endif

        let candidate.info = ""

        " info (preview window)
        if has_key(candidate, "type")
            let candidate.info =  candidate.type
        endif

        if has_key(candidate, "doc")
            if (candidate.info)
                let candidate.info = candidate.info . "\n" . s:format_doc(candidate.doc)
            else
                let candidate.info = s:format_doc(candidate.doc)
            endif
        endif

        if strlen(candidate.info) > 0
            let candidate.info = candidate.info . "\n[" . candidate.kind . "]"
        else
            let candidate.info = "[" . candidate.kind . "]"
        endif

        call remove(candidate, "kind")
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
