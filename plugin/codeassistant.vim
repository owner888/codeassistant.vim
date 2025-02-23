if !has('python3')
    echomsg ':python3 is not available, codeassistant will not be loaded.'
    finish
endif

python3 import codeassistant
python3 codeassistant = codeassistant.AutoComplete()

" command! Comment python3 codeassistant.comment()
command! -range Comment python3 codeassistant.comment(<line1>, <line2>)
command! -range AutoComplete python3 codeassistant.autocomplete(<line1>, <line2>)

" function! PromptAsyncCallback(timer)
"     python3 codeassistant.exec_prompt333()
" endfunction  
  
" 定义一个接口函数，方便从 Python 或 Vimscript 里调用
" function! PromptAsync() abort
"     call timer_start(0, 'PromptAsyncCallback')
" endfunction

function! PromptAsync() abort
    let job = job_start(['python3', '-i'], {
        \ 'out_cb':  function('PromptAsyncOut'),
        \ 'err_cb':  function('PromptAsyncErr'),
        \ 'exit_cb': function('PromptAsyncCallback'),
        \ 'mode': 'nl'
        \ })
    echo 'Job started with ID: ' . job
    let channel = job_getchannel(job)
    " call appendbufline('python_output', '$', 'Python job started.')

    call ch_sendraw(channel, "import time\ntime.sleep(5)\n")
    call ch_sendraw(channel, "print('Hello from Vim')\n")
endfunction
  
" 当子进程退出时，会调用该函数
function! PromptAsyncCallback(channel, msg) abort
    " echo "PromptAsyncCallback triggered! channel=" . a:channel . " msg=" . a:msg
    call append(line('$'), 'Output: ' . a:msg)
endfunction

" 当子进程有标准输出时，会调用该函数
function! PromptAsyncOut(channel, msg) abort
    echo "Stdout: channel=" . a:channel . " msg=" . a:msg
endfunction

" 当子进程有错误输出时，会调用该函数
function! PromptAsyncErr(channel, msg) abort
    echohl ErrorMsg
    " echo "Stderr: " . join(a:msg, ' ')
    echohl None
endfunction
  