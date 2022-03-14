; Randomly remove letters from the clipboard

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Persistent
#SingleInstance, force
;#NoTrayIcon
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

global letters := "abcdefghijklmnopqrstuvwxyzaeiou1234567890"
global lettersLength := StrLen(letters)

OnClipboardChange("ClipFuck")

ClipFuck()
{
    Random, randomPos, 1, lettersLength ; random number between 1 and length of letters string
    replaceLetter := SubStr(letters, randomPos, 1) ; grab letter at randomPos location in letters string
    Clipboard := StrReplace(Clipboard, replaceLetter, "",, Limit := 1) ;replace the randomly chosen letter with blank
    TrayTip, %replaceLetter%, %Clipboard% 
    Sleep 20 ; Just changed the clipboard, prevent a never ending onclipboardchange loop
}
