;;; Play your target's least favorite song. For bonus set this on a schedule to restart every few minutes.
; Make sure to have the mp3 copied in advance to the running directory

;;;;; Header Stuff ;;;;;
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force ; If you edit the script and run again, it will replace the previous one without asking.
#NoTrayIcon ; stealth mode
Sendlevel 100
;;;;; End Header ;;;;;

SoundSetWaveVolume, 100
SoundPlay, hotelcalifornia.mp3