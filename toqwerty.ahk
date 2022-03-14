; Use the Dvorak Keyboard layout with Qwerty shortcuts (No need to relearn physical location of Ctrl+X, Ctrl+C, Ctrl+V, etc)
; Also contains my alt shortcuts for German characters

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance, force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; -- Scroll Lock turns QWERTY commands on/off (Scroll Lock off = QWERTY commands on)
~ScrollLock::Suspend

;----------------- CTRL + KEY
*^[::^-
*^]::^=

*^'::^q
*^,::^w
*^.::^e
*^p::^r
*^y::^t
*^f::^y
*^g::^u
*^c::^i
*^r::^o
*^l::^p
*^/::^[
*^=::^]

*^o::^s
*^e::^d
*^u::^f
*^i::^g
*^d::^h
*^h::^j
*^t::^k
*^n::^l
*^s::^`;
*^-::^'

*^`;::^z
*^q::^x
*^j::^c
*^k::^v
*^x::^b
*^b::^n 
*^m::^m
*^w::^,
*^v::^.
*^z::^/

;----------------- ALT + KEY

; Deutsch
; Quick reference: https://www.autohotkey.com/docs/Hotkeys.htm#Symbols
!a::Send ä
+!A::Send Ä
!o::Send ö
+!O::Send Ö
!u::Send ü
+!U::Send Ü
!`s::Send ß

; Quick reference: https://www.autohotkey.com/docs/commands/Send.htm#keynames
!'::Send {U+0323} ; Dot below
!,::Send {U+0320} ; line below a̠u̠ a̱ e̱
!.::Send {U+0308} ; umlaut above -̈ 


*![::!/
*!]::!=

; *!'::!q
; *!,::!w
; *!.::!e
*!p::!r
*!y::!t
*!f::!y
*!g::!u
*!c::!i
*!r::!o
*!l::!p
*!/::![ 
*!=::!]

; *!o::!s
*!e::!d
; *!u::!f
*!i::!g
*!d::!h
*!h::!j
*!t::!k
*!n::!l
; *!s::!`;
*!-::!'

*!`;::!z
*!q::!x
*!j::!c
*!k::!v
*!x::!b
*!b::!n
*!m::!m
*!w::!,
*!v::!.
*!z::!/

;----------------- WINDOWS + KEY

*#[::#-
*#]::#=

*#'::#q
*#,::#w
*#.::#e
*#p::#r
*#y::#t
*#f::#y
*#g::#u
*#c::#i
*#r::#o
*#l::#p
*#/::#[
*#=::#]

*#o::#s
*#e::#d
*#u::#f
*#i::#g
*#d::#h
*#h::#j
*#t::#k
*#n::#l
*#s::#`;
*#-::#'

*#`;::#z
*#q::#x
*#j::#c
*#k::#v
*#x::#b
*#b::#n
*#m::#m
*#w::#,
*#v::#.
*#z::#/