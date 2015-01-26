scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:source = {
\	"name" : "bgm",
\	"description" : "bgm-playlist",
\	"action_table" : {
\		"play" : {
\			"is_selectable" : 0,
\		},
\	},
\	"default_action" : "play",
\	"is_volatile" : 0,
\}


function! s:source.action_table.play.func(candidate)
	call bgm#play(a:candidate.source__music)
endfunction


function! s:source.gather_candidates(args, context)
	let playlist = bgm#playlist()
	if empty(playlist)
		return []
	endif
	let now = bgm#now_playing()
	return map(playlist, '{
\		"word" : (v:val is now ? "* " : "  ") . v:val.trackName . " - " . v:val.artistName,
\		"source__music" : v:val,
\		"default_action" : "play",
\	}')
endfunction


function! unite#sources#bgm#define()
	return s:source
endfunction


if expand("%:p") == expand("<sfile>:p")
	call unite#define_source(s:source)
endif

let &cpo = s:save_cpo
unlet s:save_cpo
