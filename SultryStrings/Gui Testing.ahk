#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Gui, Add, Text, x10 y10 w200 h30 , String 1
Gui, Add, Edit, x10 y40 w200 h30 gUpdateEdit3 vEdit1, aaa
Gui, Add, Text, x10 y90 w180 h30 , String 2
Gui, Add, Edit, x10 y130 w200 h30 gUpdateEdit3 vEdit2, bbb
Gui, Add, Text, x10 y180 w200 h30 , Result
Gui, Add, Edit, x10 y210 w320 h30 vEdit3,   aaabbb                                                                   ;Here will show "aaabbb" (String 1 + String 2)
 
Gui, Show, w332 h280, Untitled GUI
return
 
UpdateEdit3:
;Gui, Submit, NoHide
GuiControl,,Edit3, % Edit1 Edit2
return
 
GuiClose:
ExitApp