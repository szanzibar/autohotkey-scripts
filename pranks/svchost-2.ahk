; remaps ctrl C to Ctrl V and vice versa to just be super annoying

;;;;; Header Stuff ;;;;;
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force ; If you edit the script and run again, it will replace the previous one without asking.
#NoTrayIcon ; stealth mode
Sendlevel 100
;;;;; End Header ;;;;;


$^c::Send ^v
$^v::Send ^c
;LButton::RButton
;RButton::Lbutton
;WheelDown::WheelUp
;WheelUP::WheelDown

:?*b0:gg::s

