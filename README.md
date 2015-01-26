#bgm.vim

iTunes ストアのサンプル曲の再生を非同期で行う

* 参照
 * http://hitode909.hatenablog.com/entry/2015/01/24/173901
 * http://d.hatena.ne.jp/syohex/20150126/1422286605

##Requirement

* command
 * mplayer
 * wget or curl
* vim plugin
 * [vimproc](https://github.com/Shougo/vimproc)

## Using

```
" 引数のワードにマッチする曲のランダム再生を開始
:BGMStart アイドルマスター

" 再生を停止
:BGMStop

" 次の曲へ移動
:BGMNext

" :BGMStart でマッチした曲の一覧を unite で表示
" Use unite.vim
:Unite bgm
```

## Screencapture

![](http://i.gyazo.com/aeba838ff832a80491cc817eb8098e6d.png)


