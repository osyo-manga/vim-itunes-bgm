scriptencoding utf-8
if exists('g:loaded_itunes_bgm')
  finish
endif
let g:loaded_itunes_bgm = 1

let s:save_cpo = &cpo
set cpo&vim

command! -nargs=1 ITunesBGMStart call itunes_bgm#start_by_term(<q-args>)

command! ITunesBGMStop call itunes_bgm#stop()
command! ITunesBGMNext call itunes_bgm#next()


let &cpo = s:save_cpo
unlet s:save_cpo
