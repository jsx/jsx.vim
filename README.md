# NAME

jsx.vim - VIM support for JSX

# USAGE

Set the following command in your `.vimrc`:

```VimL
    " add the repository path
    set rtp+=/path/to/jsx.vim

    " when you use a plugin manager (vundle or NeoBundle),
    " just declare the repository path in your .vimrc

    " for vundle
    Bundle 'git://github.com/jsx/jsx.vim.git'

    " for NeoBundle
    NeoBundle 'git://github.com/jsx/jsx.vim.git'
```

# KEY BINDINGS

* `<Leader>t` (i.e. `\t` by default) in normal mode executes the current test method
* `g:jsx_no_default_key_mappings` prevents default key mappings

# CODE COMPLETION

There is an experimental code completion invoked by omni function (<code>^x^o</code>) as an interface to <code>jsx --complete</code>.

![screenshot](https://raw.github.com/jsx/jsx.vim/master/screenshot.png)

# AUTHOR

Fuji Goro (gfx) <fuji.goro@dena.jp>

# COPYRIGHT AND LICENSE

Copyright (c) 2012 DeNA, Co., Ltd (http://dena.jp/intl/).

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.

