scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:source = {
\	"name" : "itunes_bgm/history",
\	"description" : "itunes_bgm-history",
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
	let playlist = itunes_bgm#history()
	if empty(playlist)
		return []
	endif
	return map(reverse(playlist), '{
\		"word" : v:val.trackName . " - " . v:val.artistName,
\		"source__music" : v:val,
\		"action__path"  : v:val.trackViewUrl,
\		"default_action" : "play",
\		"kind" : "uri",
\	}')
endfunction


function! unite#sources#itunes_bgm_history#define()
	return s:source
endfunction


if expand("%:p") == expand("<sfile>:p")
	call unite#define_source(s:source)
endif

let &cpo = s:save_cpo
unlet s:save_cpo
