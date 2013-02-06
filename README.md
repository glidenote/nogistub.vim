nogistub.vim
========

This is a vimscript for creating gistub. ( http://gistub-demo.seratch.net/ )

For the latest version please see https://github.com/glidenote/nogistub.vim

Usage:
------

- Post current buffer to gistub

    :Nogistub

- Post selected text to gistub

    :'<,'>Nogistub

Options:
------

You can use options, write it to .vimrc.

Set url, if you want to change url to post.
default url is "http://gistub-demo.seratch.net/"

    let g:nogistub_url = "http://gistub.local"

If you want to open the browser after the post

    let g:nogistub_open_browser_after_post = 1

Requirements:
--------

- curl command (http://curl.haxx.se/)

License:
--------

    MIT license
    Permission is hereby granted, free of charge, to any person obtaining
    a copy of this software and associated documentation files (the
    "Software"), to deal in the Software without restriction, including
    without limitation the rights to use, copy, modify, merge, publish,
    distribute, sublicense, and/or sell copies of the Software, and to
    permit persons to whom the Software is furnished to do so, subject to
    the following conditions:

    The above copyright notice and this permission notice shall be
    included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
    NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
    LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
    OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
    WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Install:
--------

Copy it to your plugin and autoload directory.
