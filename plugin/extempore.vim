"    Copyright 2011 Timothy Mellor
"
"    This program is free software: you can redistribute it and/or modify
"    it under the terms of the GNU General Public License as published by
"    the Free Software Foundation, either version 3 of the License, or
"    (at your option) any later version.
"
"    This program is distributed in the hope that it will be useful,
"    but WITHOUT ANY WARRANTY; without even the implied warranty of
"    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
"    GNU General Public License for more details.
"
"    You should have received a copy of the GNU General Public License
"    along with this program.  If not, see <http://www.gnu.org/licenses/>.


" A very simple plugin to work with extempore.
" In general, this could be a LOT faster, and much more
" elegant. But for now, it works :).
"
" INSTALL:
"  Option 1. Open vim, run ":source /path/to/extempore.vim". This is not
"     permanent! (:so % to source current file)
"  Option 2. Place extempore.vim in your vim plugin directory.
"
" TODO:
"   - allow vim command to specify host and port
"   - speed up algorithm for finding enclosing block
"   - add an indicator that a command was sent, maybe an underline or flash
"   - clean up code a bit

"" Add this (minus leading ") to netrwFileHandlers.vim
"" ---------------------------------------------------------------------
"" s:NFH_html: handles extempore when the user hits "x" when the {{{1
""                        cursor is atop a *.xtm file
"fun! s:NFH_xtm(xtmfile)
""  call Dfunc("s:NFH_xtm(".a:xtmfile.")")
""  call Decho("executing !mozilla ".a:xtmfile)
"  exe "!send_file -i ".shellescape(a:xtmfile,1)
""  call Dret("s:NFH_xtm 1")
"  return 1
"endfun

" These are the mappings I found to be convenient, which
" didn't interfere with my own personal setup. Feel free to change them.
augroup extemporeMaps
  autocmd!
  autocmd FileType extempore nnoremap <buffer> <Leader>o :ExtemporeOpenConnection() <CR>
  autocmd FileType extempore nnoremap <buffer> <Leader>O :ExtemporeCloseConnection() <CR>
  autocmd FileType extempore nnoremap <buffer> <Leader>x :ExtemporeCloseConnection() <CR>
  autocmd FileType extempore nnoremap <buffer> <Leader>w :ExtemporeSendEnclosingBlock() <CR>
  autocmd FileType extempore nnoremap <buffer> <Leader>a :ExtemporeSendEntireFile() <CR>
  autocmd FileType extempore nnoremap <buffer> <Leader>s :ExtemporeSendSelection() <CR>

  autocmd FileType extempore nnoremap <buffer> <F12> :ExtemporeSendUserInput()<CR>

  autocmd FileType extempore nnoremap <buffer> <Bar> :ExtemporeSendEntireFile()<CR>
  autocmd FileType extempore nnoremap <buffer> <BS> :ExtemporePanic()<CR>

  autocmd FileType extempore nnoremap <buffer> ] :ExtemporeSendBracketSelection()<CR>

  autocmd FileType extempore nnoremap <buffer> <Return> :ExtemporeSendSelection()<CR>
  autocmd FileType extempore xnoremap <buffer> <Return> <C-c> :ExtemporeSendSelection()<CR>

  autocmd FileType extempore nnoremap <buffer> <Tab> :ExtemporeSendEnclosingBlock()<CR>
  autocmd FileType extempore nnoremap <buffer> <S-Tab> :ExtemporeSendEnclosingBlock()<CR>
  autocmd FileType extempore xnoremap <buffer> <S-Tab> <C-c>:ExtemporeSendEnclosingBlock()<CR>
  autocmd FileType extempore inoremap <buffer> <S-Tab> <Esc>:ExtemporeSendEnclosingBlock()<CR>
  autocmd BufUnload *.xtm :ExtemporeCloseConnection()<CR>
augroup END

function! s:load_python_scripts(python_dir)
  if has('python3')
    exe 'python3 sys.path.insert(0, "' . escape(a:python_dir, '\"') . '")'
    python3 from extempore3 import *
    call s:define_extempore_commands('3')
  elseif has('python')
    exe 'python sys.path.insert(0, "' . escape(a:python_dir, '\"') . '")'
    python from extempore2 import *
    call s:define_extempore_commands('')
  endif
endfunction

function! s:reload_python_scripts()
  if has('python3')
    python3 reload(extempore3)
    call s:define_extempore_commands('3')
  elseif has('python')
    python reload(extempore2)
    call s:define_extempore_commands('')
  endif
endfunction

function! s:define_extempore_commands(py_version)
  exe 'command! -nargs=* ExtemporeOpenConnection :python' . a:py_version . ' connect()'
  exe 'command! -nargs=* ExtemporeOutputPoller :python' . a:py_version . ' output_poller()'
  exe 'command! -nargs=* ExtemporeCloseConnection :python' . a:py_version . ' close()'
  exe 'command! -nargs=* ExtemporePanic :python' . a:py_version . ' panic()'
  exe 'command! -nargs=* ExtemporeSendEnclosingBlock :python' . a:py_version . ' send_enclosing_block()'
  exe 'command! -nargs=* ExtemporeSendEntireFile :python' . a:py_version . ' send_entire_file()'
  exe 'command! -nargs=* ExtemporeSendSelection :python' . a:py_version . ' send_selection()'
  exe 'command! -nargs=* ExtemporeSendBracketSelection :python' . a:py_version . ' send_bracket_selection()'
  exe 'command! -nargs=* ExtemporeSendUserInput :python' . a:py_version . ' send_user_input()'
endfunction

" specify the directory of python scripts
let s:python_dir = fnamemodify(expand("<sfile>"), ':p:h:h') . '/python'

" load the python dir
if !exists('s:python')
  let s:python = 1
  call s:load_python_scripts(s:python_dir)
else
  call s:reload_python_scripts()
endif
