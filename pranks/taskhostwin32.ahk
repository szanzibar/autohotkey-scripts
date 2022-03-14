; Fun with hotstrings! Your target types in the specified word to trigger an action. In this case, ALT+F4 or an annoying sound.

;;;;; Header Stuff ;;;;;
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force ; If you edit the script and run again, it will replace the previous one without asking.
#NoTrayIcon ; stealth mode
;;;;; End Header ;;;;;

; Alt+F4 Hotstrings
::ticket::{Alt Down}{F4}{Alt Up} ; working on a new ticket? Not anymore.
::steven::{Alt Down}{F4}{Alt Up} ; Now whenever someone types my name to send a chat or email, BAM! Alt+F4
::bing::{Alt Down}{F4}{Alt Up} ; "Why does my browser keep crashing every time I want to bing something?"
; you get the idea

; Less destructive option
::targets.username:: ; <- remember to put in actual username
Send targets.username ; Hotstrings replace the typed text, this puts it back
SoundPlay, %A_WorkingDir%\Error.mp3 ; Something loud and annoying. Make sure to copy the file to the working directory first.
; You can even use built in system beeps/errors. See https://www.autohotkey.com/docs/commands/SoundPlay.htm for more info.
return
