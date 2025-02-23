if !has('python3')
    echomsg ':python3 is not available, codeassistant will not be loaded.'
    finish
endif

python3 import codeassistant
python3 codeassistant = codeassistant.AutoComplete()

" command! Comment python3 codeassistant.comment()
command! -range Comment python3 codeassistant.comment(<line1>, <line2>)
command! -range AutoComplete python3 codeassistant.autocomplete(<line1>, <line2>)

function! MyAsyncCallback(timer)
py3 << EOF
import vim, json
  
raw_data = vim.vars["SomeData"]
print(raw_data)
data = json.loads(raw_data)
bufnr = data["bufnr"]
start_line = data["start_line"]
code = data["code"]
  
buf = vim.buffers[bufnr]
buf[start_line - 1 : (start_line - 1) + len(code)] = code
EOF
endfunction  
  
" 定义一个接口函数，方便从 Python 或 Vimscript 里调用
function! ScheduleAsyncWrite() abort
    call timer_start(0, 'MyAsyncCallback')
endfunction
