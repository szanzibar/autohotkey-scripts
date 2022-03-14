#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance, force
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;;;; Ctrl + Alt + Gui modifier, for use with QMK keyboard
; Quick reference: https://www.autohotkey.com/docs/Hotkeys.htm#Symbols
^!#a::Send ä
^!#+A::Send Ä
^!#s::Send ö
^!#+S::Send Ö
^!#f::Send ü
^!#+F::Send Ü
^!#`;::Send ß

; Quick reference: https://www.autohotkey.com/docs/commands/Send.htm#keynames
^!#e::Send {U+0323} ; Dot below
^!#w::Send {U+0320} ; line below a̠u̠ a̱ e̱
^!#q::Send {U+0308} ; umlaut above -̈ 