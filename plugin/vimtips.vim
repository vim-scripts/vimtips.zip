" File:  "vimtips.vim"
" LAST MODIFICATION: "Thu, 20 Sep 2001 10:55:34 Eastern Daylight Time ()"
" Sourcing this script will display a "Tip Of The Day" when starting vim.
" Requires:  Vim version 6.0 or later.
"
" A sample file vimtips.txt should be included with this file.  You may be
" able to download an updated version from http://vim.sf.net .
"
" Installation:  Save vimtips.txt in your local doc/ directory.  (See :help
" local-help for an example.)  Save this file (vimtips.vim) in your plugin
" directory.  Start Vim and enter
"   :helptags {dir}
" where {dir} is your local doc/ directory.  The next time you start Vim, and
" daily until you remove this from your plugin directory, Vim will start with
" a tip from vimtips.txt displayed in a help window.  With or without this
" plugin, you can read vimtips.txt with :help vimtips.txt .

" TODO Make it fault-tolerant:  test for filereadable("vimtips.txt")
" Remind the user how to turn this feature off.
" Enable random selection of a tip.
" If requested:  add a :Tip command or menu item.

augroup VimTip
  autocmd!
  " if has("gui_running")
    " autocmd GUIEnter * split <sfile>:p | call Vimtips()
  " else
    autocmd VimEnter * split <sfile>:p | call Vimtips()
  " endif
augroup END

fun! Vimtips()
  let save_cpo = &cpo
  set cpo&vim

  " Note:  The autocommand that calls this function first edits this file, to
  " obtain and update the vimtips modeline at the end of the file.
  let quit = 0
  " Fetch the date of the last time the script was run:
  let datepat = '\(^\s*"\s\+vimtips:.*\<date\s*=\s*\)\d\+'
  $
  if !search(datepat, "bW")
    let quit = 1
  endif
  let prevdate = matchstr(getline("."), datepat)
  let prevdate = matchstr(prevdate, '\d\+$')
  let currdate = strftime("%Y%m%d")
  if !strlen(prevdate) || prevdate+0 >= currdate+0
    let quit = 1
  endif
  " Fetch the line number of the previous tip:
  let linepat = '\(^\s*"\s\+vimtips:.*\<line\s*=\s*\)\d\+'
  $
  if !search(linepat, "bW")
    let quit = 1
  endif
  let prevline = matchstr(getline("."), linepat)
  let prevline = matchstr(prevline, '\d\+$')
  if !quit
    " Open the tips file and find the next tip:
    silent! help vimtips.txt
    execute prevline
    call search('^VimTip\s\+\d\+:', 'w')
    " Position the tip at the top of the screen:
    normal! zt
    " Save the new line number:
    let prevline = line(".")
    " Go back to vimtips.vim:
    execute "normal! \<C-W>p"
    " Update the modelines.
    silent! execute 's/' . linepat . '/\1' . prevline
    $
    call search(datepat, "bW")
    silent! execute 's/' . datepat . '/\1' . currdate
  endif " !quit
  update
  bwipe
  let &cpo = save_cpo
endfun

" vimtips:date=00000000:line=1:
" vim:sw=2:sts=2:
