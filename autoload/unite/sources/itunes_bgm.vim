scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:source = {
\	"name" : "itunes_bgm",
\	"description" : "itunes_bgm-playlist",
\	"action_table" : {
\		"play" : {
\			"is_selectable" : 0,
\		},
\	},
\	"default_action" : "play",
\	"is_volatile" : 0,
\}


function! s:source.action_table.play.func(candidate)
	call itunes_bgm#play(a:candidate.source__music)
endfunction


function! s:source.gather_candidates(args, context)
	let playlist = itunes_bgm#playlist()
	if empty(playlist)
		return []
	endif
	let now = itunes_bgm#now_playing()
	return map(playlist, '{
\		"word" : (v:val is now ? "* " : "  ") . v:val.trackName . " - " . v:val.artistName,
\		"source__music" : v:val,
\		"default_action" : "play",
\	}')
endfunction


function! unite#sources#itunes_bgm#define()
	return s:source
endfunction


if expand("%:p") == expand("<sfile>:p")
	call unite#define_source(s:source)
endif

let &cpo = s:save_cpo
unlet s:save_cpo
