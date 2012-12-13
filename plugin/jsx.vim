" Language:    JSX
" Maintainer:  Fuji, Goro (gfx) <fuji.goro@dena.jp>
" URL:         http://github.com/jsx/jsx.vim
" License:     MIT License

autocmd! BufRead,BufNewFile *.jsx setlocal filetype=jsx

autocmd! BufNewFile *.jsx   0r <sfile>:h/../template/jsx-app.jsx
autocmd! BufNewFile t/*.jsx 0r <sfile>:h/../template/jsx-test.jsx
