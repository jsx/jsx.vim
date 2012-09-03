" Language:    JSX
" Maintainer:  Fuji, Goro (gfx) <fuji.goro@dena.jp>
" URL:         http://github.com/jsx/jsx.vim
" License:     MIT License

let s:save_cpo = &cpo
set cpo&vim

function! jsx#complete(findstart, base)
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
    sandbox let words = eval(ret)
    let output = filter(words, 'stridx(v:val.word, a:base) == 0')
  "catch
  "  let output = []
  "endtry

  return output
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et:
