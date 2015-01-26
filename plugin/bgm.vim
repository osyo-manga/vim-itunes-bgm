scriptencoding utf-8
if exists('g:loaded_bgm')
  finish
endif
let g:loaded_bgm = 1

let s:save_cpo = &cpo
set cpo&vim

command! -nargs=1 BGMStart call bgm#start_by_term(<q-args>)

command! BGMStop call bgm#stop()
command! BGMNext call bgm#next()


let &cpo = s:save_cpo
unlet s:save_cpo
