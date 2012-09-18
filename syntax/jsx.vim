" Vim syntax file
" Language:    JSX
" Maintainer:  Fuji, Goro (gfx) <fuji.goro@dena.jp>
" URL:         http://github.com/jsx/jsx.vim
" License:     MIT License

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
" tuning parameters:

if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'jsx'
endif

" Drop fold if it set but vim doesn't support it.
if version < 600 && exists("jsx_fold")
  unlet jsx_fold
endif

" jsx
syn keyword jsxCommentTodo	contained TODO FIXME XXX TBD
syn match   jsxLineComment	"\/\/.*" contains=@Spell,jsxCommentTodo
syn match   jsxCommentSkip	"^[ \t]*\*\($\|[ \t]\+\)"
syn region  jsxComment		start="/\*"  end="\*/" contains=@Spell,jsxCommentTodo

syn match   jsxSpecial		/\\x\x\{2\}\|\\u\x\{4\}\|\\./
syn region  jsxStringD		start=+"+  skip=+\\\\\|\\"+  end=+"\|$+	contains=jsxSpecial,@htmlPreproc
syn region  jsxStringS		start=+'+  skip=+\\\\\|\\'+  end=+'\|$+	contains=jsxSpecial,@htmlPreproc
" 15.10.1 Patterns (ECMA 262 5th)
syn match   jsxRegExpMeta	/\\[\\bwWsSdD]/
syn region  jsxRegExp		start=+/[^/*]+me=e-1 skip=+\\\\\|\\/+ end=+/[gim]*\s*$+ end=+/[gim]*\s*[;.,)\]}]+me=e-1 contains=@htmlPreproc,jsxRegExpMeta,jsxSpecial oneline

" see the JSX parser
syn match   jsxInteger		/\<\d\+\>\|\<0[xX][0-9a-fA-F]\+\>/
syn match   jsxFloat		/\<\%(\d\+\.\d\+\|\d\+\.\|\.\d\+\)\%([eE][+-]\=\d\+\)\=\>/
syn match   jsxFloatX		/\<\d\+\%([eE][+-]\=\d\+\)\>/
syn keyword jsxSpecialNumbers	NaN Infinity

syn keyword jsxConditional	if else switch
syn keyword jsxRepeat		while for do
syn keyword jsxBranch		break continue
syn keyword jsxOperator		new delete in instanceof typeof as __noconvert__
syn keyword jsxType		Array boolean Boolean Date number Number Map int Object string String RegExp JSON Nullable variant void
syn keyword jsxException	Error EvalError RangeError ReferenceError SyntaxError TypeError URIError
syn keyword jsxStatement	return var const
syn keyword jsxBoolean		true false
syn keyword jsxNull		null
syn keyword jsxIdentifier	this __FILE__ __LINE__
syn keyword jsxLabel		case default
syn keyword jsxException	try catch finally throw
syn keyword jsxClass		class interface mixin
syn keyword jsxModifiers	final override native __fake__ extends abstract static implements __readonly__
syn keyword jsxImport		import from into
syn keyword jsxEntryPoint	_Main _Test
" reserved by ECMA-262 but not used in JSX
syn keyword jsxReserved		enum export let private public protected arguments eval with
" reserved by Google Closure Compiler
" defined in src/com/google/javascript/rhino/TokenStream.java
syn keyword jsxGCCReserved	byte char double float long short goto synchronized throws transient volatile
syn keyword jsxDebug		debugger assert log

" jsxdoc
syn region  jsxDocComment start="/\*\*"  end="\*/" contains=@Spell,jsxDocTags,jsxCommentTodo
syn match   jsxDocTags     contained /@\(param\|return\)\>/
syn match   jsxDocTags     contained /@\(see\|deprecated\|since\)\>/
syn match   jsxDocTags     contained /@\(author\|version\)\>/

if exists("jsx_fold")
    syn match	jsxFunction	"\<function\>"
    syn region	jsxFunctionFold	start="\<function\>.*[^};]$" end="^\z1}.*$" transparent fold keepend

    syn sync match jsxSync	grouphere jsxFunctionFold "\<function\>"
    syn sync match jsxSync	grouphere NONE "^}"

    setlocal foldmethod=syntax
    setlocal foldtext=getline(v:foldstart)
else
    syn keyword jsxFunction	function
    syn match	jsxBraces	"[{}\[\]]"
    syn match	jsxParens	"[()]"
endif

syn sync fromstart
syn sync maxlines=100

if main_syntax == "jsx"
  syn sync ccomment jsxComment
endif

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_jsx_syn_inits")
  if version < 508
    let did_jsx_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink jsxDocComment		Comment
  HiLink jsxDocTags		Special
  HiLink jsxComment		Comment
  HiLink jsxLineComment		Comment
  HiLink jsxCommentTodo		Todo
  HiLink jsxSpecial		Special
  HiLink jsxStringS		String
  HiLink jsxStringD		String
  HiLink jsxInteger		Number
  HiLink jsxFloat		Number
  HiLink jsxFloatX		Number
  HiLink jsxSpecialNumbers	Number
  HiLink jsxConditional		Conditional
  HiLink jsxRepeat		Repeat
  HiLink jsxBranch		Conditional
  HiLink jsxOperator		Operator
  HiLink jsxType		Type
  HiLink jsxStatement		Statement
  HiLink jsxFunction		Function
  HiLink jsxBraces		Function
  HiLink jsxNull		Constant
  HiLink jsxBoolean		Boolean
  HiLink jsxRegExp		String

  HiLink jsxIdentifier		Identifier
  HiLink jsxLabel		Label
  HiLink jsxException		Exception
  HiLink jsxClass		Structure
  HiLink jsxModifiers		Structure
  HiLink jsxImport		Special
  HiLink jsxEntryPoint		Keyword
  HiLink jsxReserved		Error
  HiLink jsxGCCReserved		Error
  HiLink jsxDebug		Debug

  delcommand HiLink
endif

let b:current_syntax = 'jsx'
if main_syntax == 'jsx'
  unlet main_syntax
endif

" vim: ts=8
" vim: noexpandtab
