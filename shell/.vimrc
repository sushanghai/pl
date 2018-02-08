"if there is quotation mark at the beginnig of line,the line is mark info
"pay attenton,if the new .sh file edit by vim,it will be set by below cmds
"if it is not new .sh file,vim will not effect by below cmds
"new .sh file will be added excuted property
"cursor will be the last line in a new .sh file which edit by vim

set nu
set sm
syntax on
set tabstop=4
set ai 
"set cursorline

autocmd BufNewFile *.sh exec ":call SetTitle()"
autocmd BufNewFile *.py exec ":call SetTitle1()"

func SetTitle()
      if expand("%:e") == 'sh'
      call setline(1,"#!/bin/bash")
      call setline(2,"#")
      call setline(3,"#******************************************************************************")
      call setline(4,"#Author:               shanghai")
      call setline(5,"#Email:                shanghai@qq.com")
      call setline(6,"#Date:                 ".strftime("%Y-%m-%d"))
      call setline(7,"#FileName:             ".expand("%"))
      call setline(8,"#version:              1.0")
      call setline(9,"#Your change info:      ")
      call setline(10,"#Description:          For")
      call setline(11,"#DOC URL:               ")
      call setline(12,"#Copyright(C):         ".strftime("%Y")."  All rights reserved")
      call setline(13,"#*****************************************************************************")
      call setline(14,"")
      endif
endfunc

func SetTitle1()
      if expand("%:e") == 'py'
      call setline(1,"#!/bin/python")
      call setline(2,"#")
      call setline(3,"#******************************************************************************")
      call setline(4,"#Author:               shanghai")
      call setline(5,"#Email:                shanghai@qq.com")
      call setline(6,"#Date:                 ".strftime("%Y-%m-%d"))
      call setline(7,"#FileName:             ".expand("%"))
      call setline(8,"#version:              1.0")
      call setline(9,"#Your change info:      ")
      call setline(10,"#Description:          For")
      call setline(11,"#DOC URL:               ")
      call setline(12,"#Copyright(C):         ".strftime("%Y")."  All rights reserved")
      call setline(13,"#*****************************************************************************")
      call setline(14,"")
      endif
endfunc

" Define a function that can tell me if a file is executable
 function! FileExecutable (fname)
   execute "silent! ! test -x" a:fname
   return v:shell_error
   endfunction
" Automatically make Perl and Shell scripts executable if they aren't  already
 au BufWritePost *.sh,*.pl,*.cgi if FileExecutable("%:p") | :!chmod a+x %  ^@ endif

autocmd BufNewFile * normal G
