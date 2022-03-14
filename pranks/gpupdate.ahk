; When your prank war starts spiraling out of control and your target retaliates with group policies from hell,
; replace your gpupdate.exe with one compiled from this script
; Your target will remotely run gpupdate /Force which will simply activate this executable and not update your group policy

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; TODO: return the expected responses from the various gpupdate commands