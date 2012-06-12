" Vim compiler file
" Language:	JSX
" Maintainer:	

if exists("current_compiler")
  finish
endif
let current_compiler = "jsx"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo&vim

CompilerSet makeprg=jsx\ %
CompilerSet errorformat=[%f:%l]\ %m

let &cpo = s:cpo_save
unlet s:cpo_save
