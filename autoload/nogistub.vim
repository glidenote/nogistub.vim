"=============================================================================
" File        : nogistub.vim
" Author      : Akira Maeda <glidenote@gmail.com>
" WebPage     : http://github.com/glidenote/nogistub.vim
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be
"     included in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
"     EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
"     NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
"     LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
"     OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
"     WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}

let s:save_cpo = &cpo
set cpo&vim

if !exists('g:nogistub_url')
  let g:nogistub_url = "http://gistub-demo.seratch.net/"
endif

function! s:get_current_filename(no)
  let filename = expand('%:t')
  if len(filename) == 0 && &ft != ''
    let pair = filter(items(s:extmap), 'v:val[1] == &ft')
    if len(pair) > 0
      let filename = printf('nogistubfile%d%s', a:no, pair[0][0])
    endif
  endif
  if filename == ''
    let filename = printf('nogistubfile%d.txt', a:no)
  endif
  return filename
endfunction

function! s:get_browser_command()
  let nogistub_browser_command = get(g:, 'nogistub_browser_command', '')
  if nogistub_browser_command == ''
    if has('win32') || has('win64')
      let nogistub_browser_command = '!start rundll32 url.dll,FileProtocolHandler %URL%'
    elseif has('mac') || has('macunix') || has('gui_macvim') || system('uname') =~? '^darwin'
      let nogistub_browser_command = 'open %URL%'
    elseif executable('xdg-open')
      let nogistub_browser_command = 'xdg-open %URL%'
    elseif executable('firefox')
      let nogistub_browser_command = 'firefox %URL% &'
    else
      let nogistub_browser_command = ''
    endif
  endif
  return nogistub_browser_command
endfunction

function! s:open_browser(location)
  let cmd = s:get_browser_command()
  if len(cmd) == 0
    redraw
    echohl WarningMsg
    echo "It seems that you don't have general web browser. Open URL below."
    echohl None
    echo a:location
    return
  endif
  if cmd =~ '^!'
    let cmd = substitute(cmd, '%URL%', '\=shellescape(a:location)', 'g')
    silent! exec cmd
  elseif cmd =~ '^:[A-Z]'
    let cmd = substitute(cmd, '%URL%', '\=a:location', 'g')
    exec cmd
  else
    let cmd = substitute(cmd, '%URL%', '\=shellescape(a:location)', 'g')
    call system(cmd)
  endif
endfunction

function! nogistub#Nogistub(count, line1, line2, ...)
  let s:curl_cmd = 'curl -i'
  let s:url      = g:nogistub_url . "/gists"
  let title      = s:get_current_filename(1)
  let filename   = s:get_current_filename(1)
  let body       = join(getline(a:line1, a:line2), "\n")

  " escape quotation
  let body = substitute(body, '"', '\\"', "g")

  let post_data = ' --form-string "gist[title]=' . title . '"'
                  \ . ' --form-string "gist_file_names[]=' . filename . '"'
                  \ . ' --form-string "gist_file_bodies[]=' . body . '"'

  let confirm = input("Are you sure to post? [" . s:url . "] (y/n [n]): ")
  if confirm != "y"
    echo ""
    return
  endif
  let cmd = s:curl_cmd . ' ' . post_data . ' ' . s:url

  echon 'Posting it to nogistub... '

  let res      = system(cmd)
  let headers  = split(res, '\(\r\?\n\|\r\n\?\)')
  let location = matchstr(headers, '^Location: ')
  let location = substitute(location, '^[^:]\+: ', '', '')
  if len(location) > 0
    redraw
    if (has('clipboard'))
      let @*=location
    endif
    echomsg 'Done: ' . location

    if get(g:, 'nogistub_open_browser_after_post', 0) == 1
      call s:open_browser(location)
    endif

  else
    let message = matchstr(headers, '^Status: ')
    let message = substitute(message, '^[^:]\+: [0-9]\+ ', '', '')
    echohl ErrorMsg | echomsg 'Post failed: ' . message | echohl None
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

" __END__
" vim: set et:
" vim: foldmethod=marker
