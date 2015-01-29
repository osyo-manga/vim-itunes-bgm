scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


function! itunes_bgm#echo(str)
	echo "itunes-bgm.vim : " . a:str
endfunction


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


" function! s:fitering(list)
" 	return 
" endfunction


function! itunes_bgm#search(request)
	let url = s:request_to_url(a:request)
	let http = s:Reunions.http_get(url)
	let http._respons = { "http" : http }
	function! http.then(output, ...)
		if a:output.status != 200
			return itunes_bgm#echo("Failed bad reques")
		end
		let results = s:JSON.decode(a:output.content).results
		if empty(results)
			return itunes_bgm#echo("Not found music.")
		endif
		call s:Reunions.update_in_cursorhold(1)
		return self._respons.then(results)
	endfunction
	call itunes_bgm#echo("start search...")
	return http._respons
endfunction


let s:update_enable = 0
function! s:start(request)
	let url = s:request_to_url(a:request)
	let http = s:Reunions.http_get(url)
	let s:update_enable = 1
	function! http.then(output, ...)
		let s:update_enable = 0
		if a:output.status != 200
			return itunes_bgm#echo("Failed bad reques")
		end
		let results = s:JSON.decode(a:output.content).results
		if empty(results)
			return itunes_bgm#echo("Not found music.")
		endif
		let s:play_list.list = results
		call s:play_list.start()
	endfunction
	call itunes_bgm#echo("start search...")
endfunction



function! itunes_bgm#start_by_playlist(list)
	let s:play_list.list = results
	call s:play_list.start()
endfunction


let g:itunes_bgm#default_itunes_api_request = get(g:, "itunes_bgm#default_itunes_api_request", {})

function! itunes_bgm#start_by_request(request)
	let request = extend(extend({ "country" : "JP", "entity" : "song", "media" : "music" }, deepcopy(g:itunes_bgm#default_itunes_api_request)), a:request)
	call s:start(request)
endfunction


function! itunes_bgm#start_by_term(term)
	return itunes_bgm#start_by_request({ "term" : a:term })
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


function! itunes_bgm#play(...)
	call call(s:play_list.play, a:000, s:play_list)
endfunction


function! itunes_bgm#playlist()
	return copy(s:play_list.list)
endfunction


function! itunes_bgm#history()
	return copy(s:play_list.history)
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
	autocmd VimLeave * call itunes_bgm#stop()
augroup END

