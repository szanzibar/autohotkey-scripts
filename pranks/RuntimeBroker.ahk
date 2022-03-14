; Keystrokes will be typed with a 300 ms delay for 5 seconds every 30 minutes
; The infrequency will hopefully prevent the victim from knowing they are being pranked and 
; make them think their keyboard is dying.

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance, force
#MaxThreadsPerHotkey, 10
#InstallKeybdHook ;This is to record time since last keypress in A_TimeIdlePhysical
#NoTrayIcon ; Stealth mode
; #Warn  ; Enable warnings to assist with detecting common errors.
;SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;Thread, NoTimers


SetKeyDelay, 300 ; delay for the 'Send' command

Suspend, On ;keystrokes back to normal
Loop { ;Delay keystrokes at least every 30 minutes
    Loop { ; TODO: Make sure computer is not idle
        Sleep 1000
        ;MsgBox, %A_TimeIdlePhysical%
    } Until A_TimeIdlePhysical<1000 ; computer hasn't been idle within the last 1 second
    Suspend, Off
    Sleep, 5000 ;delayed keystrokes for 5 seconds
    Suspend, On ;keystrokes back to normal
    Sleep, 1000*60*30 ;ms * sec * minutes 
}

$a::Send a
$b::Send b
$c::Send c
$d::Send d
$e::Send e
$f::Send f
$g::Send g
$h::Send h
$i::Send i
$j::Send j
$k::Send k
$l::Send l
$m::Send m
$n::Send n
$o::Send o
$p::Send p
$q::Send q
$r::Send r
$s::Send s
$t::Send t
$u::Send u
$v::Send v
$w::Send w
$x::Send x
$y::Send y
$z::Send z
$1::Send 1
$2::Send 2
$3::Send 3
$4::Send 4
$5::Send 5
$6::Send 6
$7::Send 7
$8::Send 8
$9::Send 9
$0::Send 0
$.::Send .
$,::Send {,}
$'::Send {'}
$?::Send {?}
$space::Send {Space}
$enter::Send {enter}
$;::Send {;}

