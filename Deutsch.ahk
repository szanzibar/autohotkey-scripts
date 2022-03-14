#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance, force
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;;;; Ctrl + Alt + Gui modifier, for use with QMK keyboard
; You need to run this to disable the annoying Ctrl+Alt+Gui+Shift Office shortcut:
; `REG ADD HKCU\Software\Classes\ms-officeapp\Shell\Open\Command /t REG_SZ /d rundll32`
; More info on that here: https://superuser.com/a/1484507
; Autohotkey quick reference: https://www.autohotkey.com/docs/Hotkeys.htm#Symbols
^!#a::Send ä
^!#+A::Send Ä
^!#s::Send ö
^!#+S::Send Ö
^!#f::Send ü
^!#+F::Send Ü
^!#`;::Send ß

; Quick reference: https://www.autohotkey.com/docs/commands/Send.htm#keynames
^!#e::Send {U+0323} ; Dot belọw (short stress)
^!#w::Send {U+0320} ; line below a̠u̠ a̱ e̱ (long stress)
^!#q::Send {U+0308} ; umlaut above -̈
