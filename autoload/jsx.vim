" Language:    JSX
" Maintainer:  Fuji, Goro (gfx) <fuji.goro@dena.jp>
" URL:         http://github.com/jsx/jsx.vim
" License:     MIT License

let s:save_cpo = &cpo
set cpo&vim

function! jsx#complete(findstart, base)
  if a:findstart
    let line = getline('.')
    let pos = col('.') - 1
    while pos > 0 && line[pos - 1] =~ '\s'
      let pos -= 1
    endwhile
    let b:jsx_complete_pos = pos
    return pos
  endif

  let f = tempname()
  call writefile(getline(1, '$'), f)

  let command = printf('%s --complete %d:%d %s',
  \  get(g:, 'jsx_command', 'jsx'),
  \  line('.'), get(b:, 'jsx_complete_pos', col('.')),
  \  shellescape(f)
  \)

  try
    let ret = join(split(system(command), "\n"), "")
    sandbox let output = filter(eval(ret), 'stridx(v:val, a:base) == 0')
  catch
    let output = []
  finally
    call delete(f)
  endtry
  return output
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et:
