; This will count mouse clicks and periodically decrease and increase the mouse sensitivity to drive your target insane.

/* 
This counts clicks and messes with the mouse speed when your clickCount gets over the clickThreshold.
When your clickCount gets over the clickThreshold, the clickThreshold is decreased so that the mouse settings are changed after fewer mouse clicks.
When the clickThreshold gets down to 10, it resets back to max, the clickResetThreshold. Then the cycle repeats.
The idea is for the behavior to feel random so your target thinks their mouse is dying and doesn't realize they are being pranked.
*/

;;;;; Header Stuff ;;;;;
#NoTrayIcon ; No tray icon so it runs hidden
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance force ; If you edit the script and run again, it will replace the previous one without asking.

SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;;;;; End Header ;;;;;

; Variables:
global clickCount:= 0 ; clickCount counts clicks. Initialize to 0.
global clickResetThreshold:=150 ;threshold to reset to after getting to zero (max)
global clickThreshold = clickResetThreshold ; set initial clickThreshold to clickResetThreshold (max)

Menu, Tray, Tip, Clickcount: %clickcount%`, clickThreshold: %clickThreshold% ; initial values viewable by hovering over tray icon (remove #NoTrayIcon to see)

;Left mouse button hotkey
~LButton::
clickCount+=1 ; increase click count
Menu, Tray, Tip, Clickcount: %clickcount%`, clickThreshold: %clickThreshold% ; display updated values by hovering over tray icon (remove #NoTrayIcon to see)
If clickCount > %clickThreshold% ;only messes with the mouse if we've reached the clickThreshold
{
	clickCount := 0 ; resets clickcount
	If clickThreshold > 100 ; if the clickThreshold is over 10, decrease.
	{
		clickThreshold-=2 ; decrease clickThreshold. Mouse madness will happen sooner next time.
	}
	Else ; if clickThreshold is 10 or lower, reset to clickResetThreshold. 
	{ 
		clickThreshold:=clickResetThreshold ; reset click Threshold to max. Mouse madness will happen less frequently now. (and slowly increase in frequency)
	}
	
	Menu, Tray, Tip, Clickcount: %clickcount%`, clickThreshold: %clickThreshold% ; display updated values by hovering over tray icon (remove #NoTrayIcon to see)

	SPI_GETMOUSESPEED = 0x70 ; Constants for the DLL call
	SPI_SETMOUSESPEED = 0x71

	Sleep 1000 ;1 second delay after the last click
	; Retrieve the current speed so that it can be restored later:
	DllCall("SystemParametersInfo", UInt, SPI_GETMOUSESPEED, UInt, 0, UIntP, OrigMouseSpeed, UInt, 0)
	Sleep 1000
	; Now set the mouse to the slower speed specified in the next-to-last parameter (the range is 1-20, 10 is default):
	DllCall("SystemParametersInfo", UInt, SPI_SETMOUSESPEED, UInt, 0, Ptr, 1, UInt, 0)
	Sleep 1000
	; Now set the mouse speed to be really fast
	DllCall("SystemParametersInfo", UInt, SPI_SETMOUSESPEED, UInt, 0, Ptr, 20, UInt, 0)
	Sleep 1500
	; And back to original
	DllCall("SystemParametersInfo", UInt, 0x71, UInt, 0, Ptr, OrigMouseSpeed, UInt, 0)
}
return
