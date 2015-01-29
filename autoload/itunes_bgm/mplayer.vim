scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let g:itunes_bgm#mplayer#bin = get(g:, "itunes_bgm#mplayer#bin", "mplayer")


let s:mplayer = {}
function! s:mplayer.play(music, ...)
" 	let force = 1
	if self.exit() != 1
		return
	endif
	let self.process = itunes_bgm#get_reunions().process(g:itunes_bgm#mplayer#bin . " -slave -really-quiet " . a:music)
endfunction


function! s:mplayer.is_exit()
	if has_key(self, "process")
		return self.process.is_exit()
	endif
	return 1
endfunction


function! s:mplayer.exit()
	if has_key(self, "process")
		call self.process.kill(1)
	endif
	return 1
endfunction


function! itunes_bgm#mplayer#make()
	return deepcopy(s:mplayer)
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
