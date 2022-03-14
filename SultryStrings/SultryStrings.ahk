#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance, force

; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Global dynamictxtPath := A_ScriptDir . "\SultryStrings data\dynamic.txt"
Global hotstringsPath := A_ScriptDir . "\SultryStrings data\hotstrings.txt"
Global multilineMacros := A_ScriptDir . "\SultryStrings data\multilineMacros.txt"
Global activeWinID
Global notes := "eh=Edit hotstrings, em=Edit macros`n"
Global readHotStrings := "`nOther hotkeys in use (em to view/edit): " ; strings read and parsed from multilineMacros.txt to be displayed in gui
Global FilterString := "" ; Holds contents of filter edit field
Global ModifiedReadFile := ""
Global ReadableReadFile := ""
Global ReadFile := ""

txtTohotstrings()
parseMultlineMacros()

;spawnGui()

#include *i %A_ScriptDir%\SultryStrings data\dynamic.txt ;can't use variable name of path since #includes are processed first
#include *i %A_ScriptDir%\SultryStrings data\multilineMacros.txt ;include multiline macros
Reload

;;;;; Hotkey ;;;;;
#if
#+k:: ;hotkey to bring up main window
activeWinID := WinActive("A")
spawnGui()
;MsgBox, %activeWinID%
return
^BS:: send, ^+{left}{delete}

#+o::
txtTohotstrings()
Reload
return

#+i::
WinClose, SultryStrings ahk_class AutoHotkeyGUI
return

; a function to convert hotstring pairs from SultryStrings.ini to functional hotstrings in dynamic.txt
txtTohotstrings() {
    FileDelete, %dynamictxtPath%
    FileAppend, #If WinActive("SultryStrings ahk_class AutoHotkeyGUI") `n, %dynamictxtPath% ; only trigger hotstrings when display window active

    Loop, Read, %hotstringsPath%
    {
        StringSplit, MySplit, A_LoopReadLine, "="
        FileAppend, 
(
:*b0:%MySplit1%::
Gosub, Prestuff
Send, %MySplit2%
Gosub, Poststuff
Return


)
        , %dynamictxtPath%
    }
}

parseMultlineMacros() {
    
    Loop, read, %multilineMacros%
    {
        RegExMatch(A_LoopReadLine, "^[:].*[:](.*):{2}", MatchText)
        if (MatchText1 != "") {
            readHotStrings := readHotStrings . MatchText1 . ", "
        }
    }
}

spawnGui() {
    FileRead, ReadFile, %hotstringsPath% ;read hotstrings.text and save to "ReadFile" variable
    ;Add space between each line of hotstrings.text
    StringReplace, ReadableReadFile, ReadFile, `r`n, `r`n`r`n, All
    Gui, New, , SultryStrings
    GUi, Add, Text,,%Notes%
    Gui, Add, Edit, vscroll +wrap h600 w1200 readonly, %ReadableReadFile% ;contents of hotstrings.text in a scrollable box
    Gui, Add, Text, w1200, %readHotStrings%
    Gui, Add, Edit, vFilterString gUpdateFilter 
    Gui, Show
    ControlFocus, Edit2, SultryStrings
    WinActivate, SultryStrings
}

UpdateFilter:
Gui, Submit, NoHide
GuiControlGet, FilterString
;MsgBox %FilterString%
ModifiedReadFile := ""
;FilterString := "db"
Loop, Parse, ReadFile, `n, `r
{
    ;MsgBox % FilterString A_LoopField
    IfInString, A_LoopField, %FilterString%
    {
        ModifiedReadFile = %ModifiedReadFile%%A_LoopField%`r`n`r`n
        ;MsgBox %ModifiedReadFile%
    }
    ;
}
GuiControl,,Edit1, % ModifiedReadFile
return

GuiEscape:
Gui, Hide
return

Prestuff:
WinActivate ahk_id %activeWinID%
return

Poststuff:
WinClose, SultryStrings ahk_class AutoHotkeyGUI
return