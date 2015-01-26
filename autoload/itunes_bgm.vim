scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


call vital#of("itunes_bgm").unload()
let s:V = vital#of("itunes_bgm")
function! itunes_bgm#get_vital()
	return s:V
endfunction


let s:Reunions = s:V.import("Reunions")
function! itunes_bgm#get_reunions()
	return s:Reunions
endfunction

let s:HTTP = s:V.import("Web.HTTP")
let s:JSON = s:V.import("Web.JSON")
let s:Message = s:V.import("Vim.Message")


if exists("s:play_list")
	call s:play_list.stop()
endif
let s:play_list = itunes_bgm#playlist#make()


function! s:play_list.apply(...)
	if self.mplayer.is_exit()
		return self.play_next()
	endif
	if has_key(self.now_music, "trackName")
		echo ("Now playing : " . self.now_music.trackName . " - " . self.now_music.artistName)[:s:Message.get_hit_enter_max_length()-1]
	endif
endfunction
call s:Reunions.register(s:play_list)


function! s:request_to_url(request)
	return "http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/wa/wsSearch?" . join(values(map(a:request, "v:key.'='.s:HTTP.encodeURI(v:val)")),"&")
endfunction


let s:update_enable = 0
function! s:start(request)
	let url = s:request_to_url(a:request)
	let http = s:Reunions.http_get(url)
	let s:update_enable = 1
	function! http.then(output, ...)
		if a:output.status != 200
			echom "Failed bad reques"
			return
		end
		let results = s:JSON.decode(a:output.content).results
		let s:play_list.list = results
		call s:play_list.start()
		let s:update_enable = 0
	endfunction
endfunction


function! itunes_bgm#start_by_request(request)
	call s:start(a:request)
endfunction


function! itunes_bgm#start_by_term(term)
	return itunes_bgm#start_by_request({ "term" : a:term, "country" : "JP", "entity" : "musicTrack" })
endfunction


function! itunes_bgm#restart()
	return s:play_list.start()
endfunction


function! itunes_bgm#stop()
	return s:play_list.stop()
endfunction


function! itunes_bgm#next()
	call s:play_list.play_next()
endfunction


function! itunes_bgm#play(music)
	call s:play_list.play(a:music)
endfunction


function! itunes_bgm#playlist()
	return copy(s:play_list.list)
endfunction


function! itunes_bgm#now_playing()
	return s:play_list.now_music
endfunction


function! itunes_bgm#debug()
	return s:play_list
endfunction


function! s:update()
	if s:play_list.is_stop() == 0 || s:update_enable
		call s:Reunions.update_in_cursorhold(1)
	endif
endfunction


augroup reunions-itunes_bgm
	autocmd!
	autocmd CursorHold * call s:update()
	autocmd VimLeave * call s:play_list.exit()
augroup END

