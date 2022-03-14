; Written by Steven van Dijk in 2017-2018, originally with Pulover's macro creator, then later with notepad++ and autohotkey
; Automated almost all of our new laptop/new user manual setup primarily with UI automation

/*
 TO DO:
 jserver shortcut?
 */
 
 /*
 Known issues:
 Doesn't work if name has a space (Like mine). This could be fixed by detecting the login account instead of assuming it's first.last, but I'm too lazy to fix it right now.
 */

;-------------------------------------------------------------------------------
; run as administrator
If Not A_IsAdmin {
	Run, *RunAs %A_ScriptFullPath% ; Relaunches itself as admin.
	ExitApp
}
;-------------------------------------------------------------------------------



#NoEnv
SetWorkingDir %A_ScriptDir%
CoordMode, Mouse, Window
SendMode Input
#SingleInstance Force
SetTitleMatchMode 2
#WinActivateForce
SetControlDelay 1
SetWinDelay 0
SetKeyDelay -1
SetMouseDelay -1
SetBatchLines -1



; notes = variable to contain all notes that will be displayed by clicking the notes button on the gui
global notes := "IPv6: `nThis will disable ipv6 through a registry key and will take effect after a reboot. The ipv6 checkbox will still be checked in the adapter properties. To verify ipv6 is disabled, run ipconfig/all and there should be no ipv6 information listed.`n`n"

global errors := "" ;variable to contain all error messages. NOTE: always end each error with `n`n

global 64bit := "null" ; true if running on 64bit windows
global rBlueBeamVersion := 0 ; bluebeam version. 1 is standard, 2 is extreme

FileCreateDir, %A_ScriptDir%\data ; create data folder for configuration file
global confFile := A_ScriptDir . "\data\data.txt" ; path to configuration data file

; initial values of edit boxes
global FirstName:="John"
global LastName:="Johnson"
global Password:="hunter2"
global WorkTitle:="Chief Bee Watcher Watcher"
global OfficeKey:="XXXXX-XXXXX-XXXXX-XXXXX-XXXXX"
global sendMacsTo:="steven.vandijk@okland.com"
global LocalAdminPass:=""

; initial values of checkboxes
global cbAll:=1 ; Select all
global cbNetworkPriorityIPv6:= 1 ; sets network priority and disables ipv6
global cbRegisterOffice:=1 ; register office
global cbSetPower:=1
global cbSetWallpaper:=1
global cbSetupIE:=1
global cbSetupChrome:=1
global cbSetupFirefox:=1
global cbSetupSimpleHelp:=1
global cbCopySignatureTemplate:=1
global cbOutlookFirstSetup:=1
global cbOutlookSignature:=1
global cbSendMacs:=1
global cbInstallMimecastOutlook:=1
global cbSignInToMimecast:=1
global cbSetupSkype:=1
global cbInstallBluebeam:=1
global cbTesting:=1




;testing()
readData() ; read data from config file
newGetInputs() ; launch the gui to get inputs
;getInputs()
;check64Bit()

/*
testing()
{
	Gui, Add, Text,, First name:
	Gui, Add, Text,, Last name:
	Gui, Add, Edit, vFirstName ym  ; The ym option starts a new column of controls.
	Gui, Add, Edit, vLastName
	Gui, Add, Button, default, TestOK  ; The label ButtonTestOK (if it exists) will be run when the button is pressed.
	Gui, Show,, Simple Input Example
	return  ; End of auto-execute section. The script is idle until the user does something.

	;GuiClose:
	ButtonTestOK:
	Gui, Submit  ; Save the input from the user to each control's associated variable.
	MsgBox You entered "%FirstName% %LastName%".
	ExitApp
}
*/

readData() ; read data from config file and save to variables
{ 
	; this must always match the formatting saved in writeData()
	FileReadLine, FirstName, %confFile%, 1
	FileReadLine, LastName, %confFile%, 2
	FileReadLine, Password, %confFile%, 3
	FileReadLine, WorkTitle, %confFile%, 4
	FileReadLine, OfficeKey, %confFile%, 5
	FileReadLine, sendMacsTo, %confFile%, 6
} ; this is not written efficiently, as it opens the file 6 separate times. But it was the simplest to program.

writeData() ; write data entered into input gui to file
{
FileDelete, %confFile% ; delete existing file to write new data
FileAppend, ; write variables to confFile (data will be written to file with same format as here, one variable per line)
(
%FirstName%
%LastName%
%Password%
%WorkTitle%
%OfficeKey%
%sendMacsTo%
), %confFile% 
}

newGetInputs()
{
	;setup gui
	Gui, New, , Input
	Gui, Add, Text,, `nPress f8 at any time to stop.`n
	
	;InputBoxes
	Gui, Add, Edit, x10 w150 vFirstName, %FirstName%
	Gui, Add, Text, x+5, First Name
	Gui, Add, Edit, x10 w150 vLastName, %LastName%
	Gui, Add, Text, x+5, Last Name
	Gui, Add, Edit, x10 w150 vPassword, %Password%
	Gui, Add, Text, x+5, Password
	Gui, Add, Edit, x10 w150 vWorkTitle, %WorkTitle%
	Gui, Add, Text, x+5, Work Title (For email signature)
	Gui, Add, Edit, x10 w200 vOfficeKey, %OfficeKey%
	Gui, Add, Text, x+5, Office Key
	Gui, Add, Edit, x10 w200 vsendMacsTo, %sendMacsTo%
	Gui, Add, Text, x+5, Person to send the mac info to.
	Gui, Add, Edit, x10 w150 vLocalAdminPass, %LocalAdminPass%
	Gui, Add, Text, x+5, Local Administrator Password for editing Registry
	
	;Checkboxes
	Gui, Add, Text, ys section, Parts to run: ;ys starts new column for checkboxes
	Gui, Add, Checkbox, y+20 gCheckAll vcbAll, Select All
	Gui, Add, Checkbox, y+20 vcbNetworkPriorityIPv6, Set ethernet network interface as highest priority and disable IPv6.
	Gui, Add, Checkbox, vcbSetWallpaper, Set Wallpaper. (Takes effect after reboot)
	Gui, Add, Checkbox, vcbSetPower, Set power profile to High performance and never sleep.
	Gui, Add, Checkbox, vcbRegisterOffice, Register Office.
	Gui, Add, Checkbox, vcbSetupIE, Set up Internet Explorer.
	Gui, Add, Checkbox, vcbSetupChrome, Set up Chrome.
	Gui, Add, Checkbox, vcbSetupFirefox, Set up Firefox.
	Gui, Add, Checkbox, vcbSetupSimpleHelp, Install SimpleHelp and put in queue.
	Gui, Add, Checkbox, vcbCopySignatureTemplate, Copy Outlook Signature template into outlook profile.
	Gui, Add, Checkbox, vcbOutlookFirstSetup, Initial Outlook Setup *** New 10/25/2017 *** Since this breaks so often, it will only launch outlook  
	Gui, Add, Text,, and put in the password when the password prompt appears. Everything else on this step will need to be done manually.
	Gui, Add, Checkbox, vcbOutlookSignature, Finish setting up Outlook signature and setting as default.
	Gui, Add, Checkbox, vcbSendMacs, Export mac address info to csv and email.
	Gui, Add, Checkbox, vcbInstallMimecastOutlook, Install Mimecast For Outlook msi.
	Gui, Add, Checkbox, vcbSignInToMimecast, Relaunch Outlook and sign in to Mimecast. (Make sure user has LargeFileSend profile).
	Gui, Add, Checkbox, vcbSetupSkype, Set up Skype.
	Gui, Add, Checkbox, vcbInstallBluebeam, Install Bluebeam.
	Gui, Add, Radio, x+5 Checked vrBlueBeamVersion, Standard
	Gui, Add, Radio, x+5, Extreme
	;Gui, Add, Checkbox, xs y+40 vcbTesting, Test function. Should only be visible for debugging.
	
	
	;Assign checkbox default values
	GuiControl, , cbAll, %cbAll%
	GuiControl, , cbNetworkPriorityIPv6, %cbNetworkPriorityIPv6%
	GuiControl, , cbSetWallpaper, %cbSetWallpaper%
	GuiControl, , cbSetPower, %cbSetPower%
	GuiControl, , cbRegisterOffice, %cbRegisterOffice%
	GuiControl, , cbSetupIE, %cbSetupIE%
	GuiControl, , cbSetupChrome, %cbSetupChrome%
	GuiControl, , cbSetupFirefox, %cbSetupFirefox%
	GuiControl, , cbSetupSimpleHelp, %cbSetupSimpleHelp%
	GuiControl, , cbCopySignatureTemplate, %cbCopySignatureTemplate%
	GuiControl, , cbOutlookFirstSetup, %cbOutlookFirstSetup%
	GuiControl, , cbOutlookSignature, %cbOutlookSignature%
	GuiControl, , cbSendMacs, %cbSendMacs%
	GuiControl, , cbInstallMimecastOutlook, %cbInstallMimecastOutlook%
	GuiControl, , cbSignInToMimecast, %cbSignInToMimecast%
	GuiControl, , cbSetupSkype, %cbSetupSkype%
	GuiControl, , cbInstallBluebeam, %cbInstallBluebeam%
	GuiControl, , cbTesting, %cbTesting%
	
	;Buttons
	Gui, Add, Button, y+40 default, Run  ; The label ButtonInputOK (if it exists) will be run when the button is pressed.
	Gui, Add, Button, x+0, Close
	Gui, Add, Button, x+0, Notes
	Gui, Show, , Input
	return
	
	ButtonNotes:
	MsgBox, 0, , %notes%
	return
	
	GuiClose:
	ButtonClose: ;closing the window or clicking close will exit without doing anything
	ExitApp
	
	ButtonRun:
	Gui, Submit ; save variables
	myRun()
	Gui, Show, , Input
	return
}

CheckAll() ; This sets all checkboxes to whatever cbAll is. (Checked or unchecked)
{
	GuiControlGet, Checked,,cbAll
	GuiControl, , cbNetworkPriorityIPv6, %Checked%
	GuiControl, , cbSetPower, %Checked%
	GuiControl, , cbSetWallpaper, %Checked%
	GuiControl, , cbRegisterOffice, %Checked%
	GuiControl, , cbSetupIE, %Checked%
	GuiControl, , cbSetupChrome, %Checked%
	GuiControl, , cbSetupFirefox, %Checked%
	GuiControl, , cbSetupSimpleHelp, %Checked%
	GuiControl, , cbCopySignatureTemplate, %Checked%
	GuiControl, , cbOutlookFirstSetup, %Checked%
	GuiControl, , cbOutlookSignature, %Checked%
	GuiControl, , cbSendMacs, %Checked%
	GuiControl, , cbInstallMimecastOutlook, %Checked%
	GuiControl, , cbSignInToMimecast, %Checked%
	GuiControl, , cbSetupSkype, %Checked%
	GuiControl, , cbInstallBluebeam, %Checked%
	GuiControl, , cbTesting, %Checked%
}

myRun() ; runs each function if corrisponding checkbox is checked.
{
	writeData() ; write data to config file
	check64Bit()
	if (cbNetworkPriorityIPv6 = 1) 
		setNetworkPriorityIPv6()
	if (cbSetPower = 1) 
		setPower()
	if (cbSetWallpaper = 1) 
		setWallpaper()
	if (cbRegisterOffice = 1) 
		registerOffice()
	if (cbSetupIE = 1) 
		setupIE()
	if (cbSetupChrome = 1) 
		setupChrome()
	if (cbSetupFirefox = 1) 
		setupFirefox()
	if (cbSetupSimpleHelp = 1) 
		setupSimpleHelp()
	if (cbCopySignatureTemplate = 1) 
		copySignatureTemplate()
	if (cbOutlookFirstSetup = 1) 
		outlookFirstSetup()
	if (cbOutlookSignature = 1) 
		outlookSignature()
	if (cbSendMacs = 1) 
		sendMacs()
	if (cbInstallMimecastOutlook = 1) 
		installMimecastOutlook()
	if (cbSignInToMimecast = 1) 
		signInToMimecast()
	if (cbSetupSkype = 1) 
		setupSkype()
	if (cbInstallBluebeam = 1) 
		installBluebeam()
	if (cbTesting = 1)
		Testing()
		
	RunWait %comspec% /c RUNDLL32.EXE user32.dll, UpdatePerUserSystemParameters ;Sometimes this will reset the wallpaper, sometimes you just need to reboot
	
	if errors = 
		MsgBox, 0, , Complete
	else ; display error messages
		MsgBox, 0, , Completed with errors:`n`n %errors%
		
	errors:="" ; reset errors
}

Testing()
{
	
}

installBluebeam()
{
	; if LocalAdmin is empty, save error and return
	if LocalAdminPass = 
	{
		errors:= errors . "Unable to install Bluebeam. Local Admin Password not set.`n`n"
		return
	}
	RunAs, Administrator, %LocalAdminPass% ; run as local administrator
	if rBlueBeamVersion = 1
		RunWait %comspec% /c "C:\Apps\Bluebeam\Revu-Latest\Install Standard (run as local admin).bat" ; install standard
	else if rBluebeamVersion = 2
		RunWait %comspec% /c "C:\Apps\Bluebeam\Revu-Latest\Install Extreme (run as local admin).bat" ; install extreme
	else
		errors:= errors . "Unable to install Bluebeam. Something wrong with Radio buttons.`n`n"
	RunAs ; resume normal run behavior
	
	Run, explorer.exe
}

setWallpaper()
{
	getSID = wmic useraccount where name="%FirstName%.%LastName%" get sid > c:\Apps\Macros\SID.txt ; command to get SID and export to text file
	RunWait %comspec% /c %getSID% ;export SID to text file
	Sleep, 500
	FileReadLine, userSID, c:\Apps\Macros\SID.txt, 2 ;get SID from exported text file
	Sleep, 500
	userSID = %userSID% ;reassigning variable trims whitespace
	
	if userSID =
	{
		errors:= errors . "Unable to set Wallpaper. Failed to get userID, using username: " . FirstName . "." . LastName . ".`n`n"
	}
	else ;SID found, now assign wallpaper.
	{
	
		RunAs, Administrator, %LocalAdminPass%
		try
		{
			;MsgBox REG ADD "HKEY_USERS\%userSID%\Control Panel\Desktop" /v WallPaper /t REG_SZ /d "C:\Apps\Wallpapers\OklandWallpaper_1.bmp" ;/f
			RunWait, REG ADD "HKEY_USERS\%userSID%\Control Panel\Desktop" /v WallPaper /t REG_SZ /d "C:\Apps\Wallpapers\OklandWallpaper_1.bmp" /f
			Sleep, 1000
			
		}
		catch
		{
			errors:= errors . "Unable to set Wallpaper. Unable to write to Registry. Local admin password is probably wrong.`n`n"
		}
		RunAs  ; Reset to normal behavior.
		Sleep, 500
	}
}

check64Bit() 
{
	IfExist, C:\Program Files (x86)\Google\Chrome\Application\chrome.exe
	{
		64bit := "true"
	}
	Else
	{
		64bit := "false"
	}
}

setNetworkPriorityIPv6()
{
	RunWait, C:\apps\Network\Local Area Connection top priority.bat, C:\apps\Network  ; Sets local area connection to first priority using commandline tool
	Sleep, 500
	RunAs, Administrator, %LocalAdminPass%
	;Information for disabling ipv6 taken from https://support.microsoft.com/en-us/help/929852/how-to-disable-ipv6-or-its-components-in-windows
	try
	{
		Run, REG ADD HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters /v DisabledComponents /t REG_DWORD /d 0xff /f
	}
	catch
	{
		errors:= errors . "Unable to disable IPv6. Unable to write to Registry. Local admin password is probably wrong.`n`n"
	}
	RunAs  ; Reset to normal behavior.
	Sleep, 500
}

registerOffice()
{
	IfExist, c:\Program Files (x86)\Microsoft Office\Office16\OSPP.VBS  ; office 2016 64 bit windows
	{
		RunWait, cscript "c:\Program Files (x86)\Microsoft Office\Office16\OSPP.VBS" /inpkey:%OfficeKey%  ; Activate office
		Sleep, 500
		RunWait, cscript "c:\Program Files (x86)\Microsoft Office\Office16\OSPP.VBS" /act  ; Activate office
		Sleep, 500
	}
	IfExist, c:\Program Files\Microsoft Office\Office16\OSPP.VBS ; office 2016 32 bit windows
	{
		RunWait, cscript "c:\Program Files\Microsoft Office\Office16\OSPP.VBS" /inpkey:%OfficeKey%  ; Activate office
		Sleep, 500
		RunWait, cscript "c:\Program Files\Microsoft Office\Office16\OSPP.VBS" /act  ; Activate office
		Sleep, 500
	}
	IfExist, c:\Program Files (x86)\Microsoft Office\Office15\OSPP.VBS  ; office 2015 64 bit windows
	{
		RunWait, cscript "c:\Program Files (x86)\Microsoft Office\Office15\OSPP.VBS" /inpkey:%OfficeKey%  ; Activate office
		Sleep, 500
		RunWait, cscript "c:\Program Files (x86)\Microsoft Office\Office15\OSPP.VBS" /act  ; Activate office
		Sleep, 500
	}
	IfExist, c:\Program Files\Microsoft Office\Office15\OSPP.VBS ; office 2015 32 bit windows
	{
		RunWait, cscript "c:\Program Files\Microsoft Office\Office15\OSPP.VBS" /inpkey:%OfficeKey%  ; Activate office
		Sleep, 500
		RunWait, cscript "c:\Program Files\Microsoft Office\Office15\OSPP.VBS" /act  ; Activate office
		Sleep, 500
	}
		IfExist, c:\Program Files (x86)\Microsoft Office\Office14\OSPP.VBS  ; office 2010 64 bit windows
	{
		RunWait, cscript "c:\Program Files (x86)\Microsoft Office\Office14\OSPP.VBS" /inpkey:%OfficeKey%  ; Activate office
		Sleep, 500
		RunWait, cscript "c:\Program Files (x86)\Microsoft Office\Office14\OSPP.VBS" /act  ; Activate office
		Sleep, 500
	}
	IfExist, c:\Program Files\Microsoft Office\Office14\OSPP.VBS ; office 2010 32 bit windows
	{
		RunWait, cscript "c:\Program Files\Microsoft Office\Office14\OSPP.VBS" /inpkey:%OfficeKey%  ; Activate office
		Sleep, 500
		RunWait, cscript "c:\Program Files\Microsoft Office\Office14\OSPP.VBS" /act  ; Activate office
		Sleep, 500
	}
}

setPower()
{
	RunWait, powercfg /S 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c  ; Set high performance power scheme
	Sleep, 500
	RunWait, powercfg -x -standby-timeout-ac 0  ; Sleep mode off when plugged in
	Sleep, 500
}

setupIE()
{
	Run, "C:\Program Files\Internet Explorer\iexplore.exe"
	Sleep, 500
	WinWaitActive, ahk_class IEFrame ; wait for main window
	Sleep, 4000
	WinWait, ahk_class #32770, , 20 ;wait up to 20 seconds for initial startup screen
	Sleep, 500
	WinClose, ahk_class #32770 ; close startup screen
	Sleep, 500
	WinWaitActive, ahk_class IEFrame ahk_exe iexplore.exe
	Sleep, 10000 ;wait for page to load and become responsive
	Send, {Alt}
	Sleep, 500
	Send, {t}
	Sleep, 500
	Send, {o}
	Sleep, 500
	Send, {Backspace}
	Sleep, 500
	SendRaw, employee.okland.com  ; Set homepage in IE
	Sleep, 500
	Send, {Shift Down}{Tab}{Shift Up}
	Sleep, 500
	Send, {Right}
	Sleep, 500
	Send, {Tab}
	Sleep, 500
	Send, {Right}
	Sleep, 500
	Send, {Right}
	Sleep, 500
	Send, {Right}
	Sleep, 500
	Send, {Alt Down}{s}{Alt Up}
	Sleep, 500
	Send, {Alt Down}{s}{Alt Up}
	Sleep, 500
	Send, {Alt Down}{d}{Alt Up}
	Sleep, 500
	SendRaw, https://okvpn.okland.com  ; Set okvpn as trusted site
	Sleep, 500
	Send, {Alt Down}{a}{Alt Up}
	Sleep, 500
	SendRaw, http://intraweb.okland.com  ; Set intraweb as trusted site
	Sleep, 500
	Send, {Alt Down}{a}{Alt Up}
	Sleep, 500
	Send, {Shift Down}{Alt Down}{c}{Alt Up}{Shift Up}
	Sleep, 500
	Send, {Shift Down}{Alt Down}{c}{Alt Up}{Shift Up}
	Sleep, 500
	Send, {PgDn 20}
	Sleep, 100
	Send, {Up}
	Sleep, 500
	Send, {Space}  ; Set to use currennt username and password on trusted sites
	Sleep, 500
	Send, {Enter 3}
	Sleep, 500
	Send, {Alt Down}{F4}{Alt Up} ; close internet explorer
	Sleep 500
	WinWaitActive, ahk_class #32770, , 5 ; wait 5 seconds for the confirm to close multiple tabs
	If ErrorLevel ;if winwait timed out
	{
		ErrorLevel = 0 ; reset errorlevel
		;keep going
	}
	Else
		Send, {Enter}
}

setupFirefox() ; 10/25/2017 works with version 56.0.1
{
	If 64bit = true
	{
		Run, "C:\Program Files (x86)\Mozilla Firefox\firefox.exe"  ; START chrome setup
		Sleep, 500
	}
	Else
	{
		Run, "C:\Program Files\Mozilla Firefox\firefox.exe"  ; START chrome setup
		Sleep, 500
	}
	
	WinWaitActive, Import Wizard ahk_class MozillaDialogClass, , 10 ; wait for Firefox Import Wizard dialog to open, 10 second timeout
	If ErrorLevel ;if winwait timed out
	{
		ErrorLevel = 0 ; reset errorlevel
		; just keep going
	}
	Else ; window popped up
	{
		Send, {Alt Down}{d}{Alt Up} ; Select Don't import anything
		Sleep, 500
		Send, {Enter} ; 
		Sleep, 500
	}
	
	WinWait, ahk_class MozillaWindowClass ; wait for main window to be open
	
	WinWaitActive, Default Browser ahk_class MozillaDialogClass, , 10 ; wait for firefox Default Browser dialog to open, 10 second timeout
	If ErrorLevel ;if winwait timed out
	{
		ErrorLevel = 0 ; reset errorlevel
		; just keep going
	}
	Else ; window popped up
	{
		Send, {Shift Down}{Tab}{Shift Up} ; move to "Always perform this check when starting firefox" checkbox
		Sleep, 500
		Send, {Space} ; uncheck
		Sleep, 500
		Send, {Tab}
		Sleep, 500
		Send, {Tab} ; tab to "Not Now" button
		Sleep, 500
		Send, {Enter} 
		Sleep, 500
	}
	
	WinWaitActive, ahk_class MozillaWindowClass ; wait for window to open and be active
	Sleep, 5000
	Send, {Control Down}{t}{Control Up}
	Sleep, 2000
	SendRaw, about:config
	Sleep, 500
	Send, {Enter}
	Sleep, 500
	Send, {Enter}
	Sleep, 500
	SendRaw, ntlm-auth.trusted
	Sleep, 1000
	Send, {Tab}
	Sleep, 500
	Send, {Enter}
	Sleep, 500
	SendRaw, http://intraweb.okland.com
	Sleep, 500
	Send, {Enter}
	Sleep, 2000	
	Send, {Alt}
	Sleep, 500
	Send, {T}
	Sleep, 500
	Send, {O}
	Sleep, 3000
	Send, {Tab 4}
	Sleep, 500
	;Send, {Up 3} 10/25/2017 Firefox keeps changing, commenting this part out.
	;Sleep, 500
	;Send, {Tab}
	;Sleep, 500
	SendRaw, employee.okland.com  ; Set homepage to employee.okland.com
	Sleep, 500
	Send, {Tab}
	Sleep, 5000
	Send, {Alt Down}{F4}{Alt Up}
	Sleep 500
	WinWaitActive, ahk_class MozillaDialogClass, , 3 ; wait 3 seconds for the confirm to close multiple tabs
	If ErrorLevel ;if winwait timed out
	{
		ErrorLevel = 0 ; reset errorlevel
		return ;keep going
	}
	Else
		Send, {Enter}
}

setupChrome() ; 10/25/2017 works with version 62.0.3202.62
{
	If 64bit = true
	{
		Run, "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"  ; START chrome setup
		Sleep, 500
	}
	Else
	{
		Run, "C:\Program Files\Google\Chrome\Application\chrome.exe"  ; START chrome setup
		Sleep, 500
	}

	WinWaitActive, ahk_class Chrome_WidgetWin_1
	Sleep, 3000
	Send, {Control Down}{t}{Control Up}
	Sleep, 2000
	SendRaw, chrome://settings
	Sleep, 500
	Send, {Enter}
	Sleep, 500
	Sleep, 5000
	SendRaw, on startup
	Sleep, 500
	Send, {Tab 2}
	Sleep, 500
	;Send, {Enter} ; expand "on startup" settings *EDIT 10/25/2017* Chrome keeps changing! commenting this out
	;Sleep, 1000
	;Send, {Tab 2}
	;Sleep, 1000
	Send, {Down 2}
	Sleep, 500
	Send, {Tab}
	Sleep, 500
	Send, {Enter}
	Sleep, 500
	SendRaw, employee.okland.com  ; Set homepage to employee.okland.com
	Sleep, 1000
	Send, {Enter}
	Sleep, 1000
	Sleep, 2000
	WinClose, ahk_class Chrome_WidgetWin_1  
	Sleep, 500
} ; END setupChrome()

setupSimpleHelp()
{
	If 64bit = true
	{
		Run, C:\apps\SimpleHelp\Okland Support-windows64-online.exe  ; START install simple help
		Sleep, 500
	}
	Else
	{
		Run, C:\apps\SimpleHelp\Okland Support-windows32-online.exe  ; START install simple help
		Sleep, 500
	}
	WinWait, Remote Support Session ahk_class com.aem.shelp.common.CommonStandalone$1
	Sleep, 500
	Sleep, 5000
	Loop
	{
		CoordMode, Pixel, Window
		ImageSearch, FoundX, FoundY, 0, 0, 1920, 1080, C:\Apps\Macros\Screenshots\Screen_20170202084648.png
		CenterImgSrchCoords("C:\Apps\Macros\Screenshots\Screen_20170202084648.png", FoundX, FoundY)
		If ErrorLevel = 0
			Click, %FoundX%, %FoundY% Left, 1  ; This screenshot works with different resolutions
		Sleep, 500
	}
	Until ErrorLevel = 0
	SendRaw, %FirstName% %LastName%
	Sleep, 500
	Send, {Enter}
	Sleep, 500
	WinMinimize, ahk_class com.aem.shelp.common.CommonStandalone$1  ; END install simple help. (Still needs persistent client)
	Sleep, 500
} ; END setupSimpleHelp()

turnOffProset() ; not working
{
	/*
	Send, {LWin Down}  ; Tell windows to manage wireless instead of proset.  I can't get itt to see the icon, and I suspect it's a premissionn thing and this won't work at all.
	Sleep, 500
	Send, {b}
	Sleep, 500
	Send, {LWin Up}
	Sleep, 500
	Send, {Space}
	Sleep, 500
	Sleep, 3000
	Loop
	{
		CoordMode, Pixel, Client
		ImageSearch, FoundX, FoundY, 0, 0, 1920, 1080, C:\Apps\Macros\Screenshots\Screen_20170202094506.png
		CenterImgSrchCoords("C:\Apps\Macros\Screenshots\Screen_20170202094506.png", FoundX, FoundY)
		If ErrorLevel = 0
			Click, %FoundX%, %FoundY% Right, 1
		Sleep, 500
	}
	Until ErrorLevel = 0
	Send, {Up 2}
	Sleep, 500
	Send, {Enter 2}
	Sleep, 500
	Loop, 5
	{
		CoordMode, Pixel, Window
		ImageSearch, FoundX, FoundY, 0, 0, 1920, 1080, C:\Apps\Macros\Screenshots\Screen_20170202092339.png
		CenterImgSrchCoords("C:\Apps\Macros\Screenshots\Screen_20170202092339.png", FoundX, FoundY)
		If ErrorLevel = 0
			Click, %FoundX%, %FoundY%, 0
		If ErrorLevel
			Break
		Sleep, 500
	}
	*/
} ; END turnOffProset()

copySignatureTemplate()
{
	FileCreateDir, C:\Users\%FirstName%.%LastName%\AppData\Roaming\Microsoft\Signatures\  ; Create sub folder for signature template
	Sleep, 500
	FileCopy, C:\apps\Microsoft\Signature\*, C:\Users\%FirstName%.%LastName%\AppData\Roaming\Microsoft\Signatures  ; Copy in signature template
	Sleep, 500
	FileCreateDir, C:\Users\%FirstName%.%LastName%\AppData\Roaming\Microsoft\Signatures\Default_files\  ; Create sub folder for signature template
	Sleep, 500
	FileCopy, C:\apps\Microsoft\Signature\Default_files\*, C:\Users\%FirstName%.%LastName%\AppData\Roaming\Microsoft\Signatures\Default_files\  ; Finish copying signature template files
	Sleep, 500
}

outlookFirstSetup() ; New outlook setup function 10/25/2017, moving a lot of stuff to user interaction because the automated steps break too much.
{
	If 64bit = true
	{
		Run, "C:\Program Files (x86)\Microsoft Office\root\Office16\OUTLOOK.EXE"  ; Outlook setup 
		Sleep, 500
	}
	Else
	{
		Run, "C:\Program Files\Microsoft Office\root\Office16\OUTLOOK.EXE"  ; Outlook setup 
		Sleep, 500
	}
	
	SoundPlay *-1  ; Notify the user to take over
	
	; User interaction
	
	WinWait, Windows Security ; Wait for prompt to enter password
	Sleep, 500
	WinActivate, Windows Security ; Activating window, because starting windows 10 the window doesn't pop up active.
	Sleep, 2000  ; Waiting for the Finish Button to activate
	SendRaw, %Password%
	
	SoundPlay *-1 ; Notify the user to take over
	
	WinWait, ahk_class rctrl_renwnd32 ; Outlook window is now open
	Sleep, 500
	
}

/* outlookFirstSetup() ; Trying to make this work with outlook is such a cluster because outlook changes so often.
{

	If 64bit = true
	{
		Run, "C:\Program Files (x86)\Microsoft Office\root\Office16\OUTLOOK.EXE"  ; Outlook setup 
		Sleep, 500
	}
	Else
	{
		Run, "C:\Program Files\Microsoft Office\root\Office16\OUTLOOK.EXE"  ; Outlook setup 
		Sleep, 500
	}
	WinWait, ahk_class MsoSplash, , 10
	Sleep, 333
	Sleep, 10000
	IfWinActive, First things first. ahk_class NUIDialog
	{
		Send, {Alt Down}{a}{Alt Up}
		
	}
	Sleep, 3000
	IfWinActive, Connect Outlook to Office 365 ahk_class NUIDialog
	{
		Send, {Tab}  ; Deselect Outlook on phone
		Sleep, 500
		Send, {Space}
		Sleep, 500
		Send, {Enter}
		Sleep, 500
		Send, {Shift Down}{Tab}{Shift Up}
		Sleep, 500
		Send, {Enter}
		Sleep, 500
	}
	IFWinActive, Welcome to Outlook ahk_class NUIDialog
	{
		Sleep, 500
		Send, {Enter}
	}
	Else
	{
		WinWait, ahk_class #32770
		Sleep, 500
		Send, {Enter}
		Sleep, 500
		WinWait, ahk_class #32770
		Sleep, 500
		Send, {Enter}
		Sleep, 500
		Sleep, 10000
		Send, {Alt Down}{n}{Alt Up}
		Sleep, 500
	}
	WinWait, Windows Security ; Wait for prompt to enter password
	Sleep, 500
	WinActivate, Windows Security ; Activating window, because starting windows 10 the window doesn't pop up active.
	Sleep, 2000  ; Waiting for the Finish Button to activate
	SendRaw, %Password%
	Sleep, 500
	Send, {Tab}
	Sleep, 500
	Send, {Space}
	Sleep, 500
	Send, {Enter}
	Sleep, 500
	Sleep, 10000  ; Waiting for the Finish Button to activate
	IfWinActive, Add Account ahk_class #32770
	{
		Send, {Shift Down}{Tab}{Shift Up}{Alt Down}{s}{Alt Up}{Space}
		Send, {Enter}  ; Finish Outlook account setup
		Sleep, 500
	}
	IfWinActive, Welcome to Outlook ahk_class NUIDialog
	{
		Send, {Shift Down}{Tab}{Shift Up}{Space}{Shift Down}{Tab}{Shift Up}
		Send, {Enter}  ; Finish Outlook account setup
		Sleep, 500
	}
	WinWait, ahk_class MsoSplash, , 10
	Sleep, 333
	Sleep, 10000
	IfWinActive, Microsoft Outlook ahk_class #32770
	{
		Send, {Enter}
		Sleep, 500
	}
	WinWait, First things first. ahk_class NUIDialog, , 10
	Sleep, 500
	Send, {Alt Down}{a}{Alt Up}
	Sleep, 500
	WinWaitClose, First things first. ahk_class NUIDialog, , 10
	Sleep, 500
	Sleep, 10000
	IfWinActive, Microsoft Outlook ahk_class #32770
	{
		Send, {Enter}
		Sleep, 500
		Send, {Shift Down}{Alt Down}{c}{Alt Up}{Shift Up}
		Sleep, 500
	}
	Sleep, 5000
	WinWait, ahk_class rctrl_renwnd32
	Sleep, 500
	WinWait, ShareFile Login, , 5
	Sleep, 500
	WinClose, ShareFile Login
	Sleep, 500
} ;end outlook first launch
*/

outlookSignature()
{
	IfWinExist, ahk_class rctrl_renwnd32 ;activate outlook if it's already open
	{
		WinActivate, ahk_class rctrl_renwnd32
	}
	Else ;else launch outlook
	{
		If 64bit = true
		{
			Run, "C:\Program Files (x86)\Microsoft Office\root\Office16\OUTLOOK.EXE"  ; Outlook setup 
			Sleep, 500
		}
		Else
		{
			Run, "C:\Program Files\Microsoft Office\root\Office16\OUTLOOK.EXE"  ; Outlook setup 
			Sleep, 500
		}
	}

	WinWaitActive, ahk_class rctrl_renwnd32 ; Wait for Outlook main screen
	Sleep, 5000
	Send, {Control Down}{n}{Control Up}  ; New email for Signature
	Sleep, 500
	WinWait, Untitled - Message (HTML)  ahk_class rctrl_renwnd32
	Sleep, 3000
	Send, {Alt}
	Sleep, 500
	Send, {n}
	Sleep, 500
	Send, {a}
	Sleep, 500
	Send, {s 2}
	Sleep, 500
	WinActivate, ahk_class bosa_sdm_Mso96
	Sleep, 500
	Send, {Shift Down}{Tab}{Shift Up}
	Sleep, 500
	Send, {Down}
	Sleep, 500
	Send, {Control Down}{b}{Control Up}
	Sleep, 500
	SendRaw, %FirstName% %LastName%
	Sleep, 500
	Send, {Control Down}{b}{Control Up}
	Sleep, 500
	Send, {Space} ; manually sending space before the pipe |
	Sleep, 500
	SendRaw, | %WorkTitle%
	Sleep, 500
	Send, {Alt Down}{f}{Alt Up}
	Sleep, 500
	Send, {Down}
	Sleep, 500
	Send, {Alt Down}{m}{Alt Up}
	Sleep, 500
	Send, {Down}
	Sleep, 500
	Send, {Enter 2}
	Sleep, 500
	WinClose, Untitled - Message (HTML)  ahk_class rctrl_renwnd32
	Sleep, 500
	WinMinimize, ahk_class rctrl_renwnd32
	Sleep, 500
} ; END set up signature	

sendMacs()
{
	Sleep, 500
	RunWait %comspec% /c "getmac /V /NH /FO csv > C:\apps\macs.csv"
	Sleep, 500
	Sleep, 5000
	
	IfWinExist, ahk_class rctrl_renwnd32 ;activate outlook if it's already open
	{
		WinActivate, ahk_class rctrl_renwnd32
	}
	Else ;else launch outlook
	{
		If 64bit = true
		{
			Run, "C:\Program Files (x86)\Microsoft Office\root\Office16\OUTLOOK.EXE"  ; Outlook setup 
			Sleep, 500
		}
		Else
		{
			Run, "C:\Program Files\Microsoft Office\root\Office16\OUTLOOK.EXE"  ; Outlook setup 
			Sleep, 500
		}
	}
	
	WinWaitActive, ahk_class rctrl_renwnd32
	Sleep,1000
	Send, {Control Down}{n}{Control Up}  ; New email for sending macs.csv
	Sleep,1000
	WinWait, Untitled - Message (HTML)  ahk_class rctrl_renwnd32
	Sleep,1000
	SendRaw, %sendMacsTo% ;recipient of macs.csv
	Sleep,1000
	Send, {Alt Down}{u}{Alt Up}
	Sleep,1000
	SendRaw, MacSheet
	Sleep,1000
	Send, {Alt}
	Sleep,1000
	Send, {h}
	Sleep,1000
	Send, {a}
	Sleep,1000
	Send, {f}
	Sleep,1000
	Send, {b}
	Sleep,1000
	WinWait, ahk_class #32770
	Sleep,1000
	SendRaw, c:\apps\macs.csv  ; Attach macs.csv
	Sleep,1000
	Send, {Enter}
	Sleep,1000
	Send, {Alt Down}{s}{Alt Up}  ; Send macs.csv
	Sleep, 10000
	WinClose, ahk_class rctrl_renwnd32
} ;finish sending mac info

installMimecastOutlook()
{ ;need to check make sure outlook is closed
	Sleep, 5000
	RunWait, C:\apps\MimecastOutlookPlugin\MimecastForOutlook.msi /passive /norestart
	Sleep, 5000
}

signInToMimecast()
{
	If 64bit = true
	{
		Run, "C:\Program Files (x86)\Microsoft Office\root\Office16\OUTLOOK.EXE"  ; Outlook setup 
		Sleep, 500
	}
	Else
	{
		Run, "C:\Program Files\Microsoft Office\root\Office16\OUTLOOK.EXE"  ; Outlook setup 
		Sleep, 500
	}
	WinWait, ahk_class rctrl_renwnd32
	Sleep, 500
	WinWait, ShareFile Login, , 5
	Sleep, 500
	WinClose, ShareFile Login
	Sleep, 500
	Sleep, 10000
	IfWinActive, Windows Security Alert
	{
		Send, {Alt Down}{a}{Alt Up}
		Sleep, 500
	}
	Sleep, 15000
	IfWinActive, Windows Security Alert
	{
		Send, {Alt Down}{a}{Alt Up}
		Sleep, 500
	}
	Sleep, 3000
	
	IfExist, C:\Program Files\Bluebeam Software\Bluebeam Revu ; if bluebeam is installed
	{ ; bluebeam plugin changes the alt command to the mimecast plugin
		Send, {Alt} 
		Sleep, 500
		Send, {Y}
		Sleep, 500
		Send, {2}
		Sleep, 500
		Send, {Y}
		Sleep, 500
		Send, {1}
		Sleep, 500
	}
	Else ; no bluebeam plugin
	{
		Send, {Alt}
		Sleep, 500
		Send, {Y}
		Sleep, 500
		Send, {Y}
		Sleep, 500
		Send, {1}
		Sleep, 500
	}
	
	
	
	/*
	Loop ; look for red pixel (mimecast alert from tray)
	{
		CoordMode, Pixel, Client
		PixelSearch, FoundX, FoundY, 0, 0, 1920, 1080, 0xFF0000, 0, Fast RGB
		If ErrorLevel = 0
			Click, %FoundX%, %FoundY% Left, 1
		Sleep, 500
	}
	Until ErrorLevel = 0
	*/
	WinWaitActive, Mimecast for Outlook
	Sleep, 500
	WinMaximize, Mimecast for Outlook
	Sleep, 500
	Loop
	{
		CoordMode, Pixel, Window
		PixelSearch, FoundX, FoundY, 23, 24, 1210, 651, 0xEF6421, 0, Fast RGB
		If ErrorLevel = 0
			Click, %FoundX%, %FoundY% Left, 1
		Sleep, 500
	}
	Until ErrorLevel = 0
	Sleep, 5000
	CoordMode, Pixel, Window
	PixelSearch, FoundX, FoundY, 34, 20, 1270, 916, 0xEF6421, 0, Fast RGB ; find orange button
	If ErrorLevel = 0
		Click, %FoundX%, %FoundY%, 0
	Sleep, 500
	If ErrorLevel = 0  ; If found, it needs username and password. Else, it needs just the password
	{
		Click, Rel 10, 10 Left, 1 ; move down to the right to click button
		Sleep, 10
		Sleep, 5000
		
		Send, {Shift Down}{Tab}{Shift Up} 
		Sleep, 500
		Send, {Shift Down}{Tab}{Shift Up}
		Sleep, 500
		Send, {Shift Down}{Tab}{Shift Up}
		Sleep, 500
		Send, {Shift Down}{Tab}{Shift Up}
		Sleep, 500
		Send, {Shift Down}{Tab}{Shift Up} ; 5 shift tabs should get the cursor to the username box.
		Sleep, 500
		
		SendRaw, %firstname%.%lastname% ; single sign on
		Sleep, 500
		Send, {Tab}
		Sleep, 500
		SendRaw, %Password%
		Sleep, 500
		Send, {Enter}
		Sleep, 500
	}
	Else
	{
		SendRaw, %Password%
		Sleep, 500
		Send, {Enter}
		Sleep, 500
	}
	Sleep, 10000
	WinClose, Mimecast for Outlook
	Sleep, 500
}

setupSkype()
{
	If 64bit = true
	{
		Run, "C:\Program Files (x86)\Microsoft Office\root\Office16\lync.exe"  ; START skype setup
		Sleep, 500
	}
	Else
	{
		Run, "C:\Program Files\Microsoft Office\root\Office16\lync.exe"  ; START skype setup
		Sleep, 500
	}
	WinWait, Skype for Business  ahk_class CommunicatorMainWindowClass
	Sleep, 500
	Sleep, 10000
	WinClose, Quick Tips ahk_class NUIDialog
	Sleep, 500
	Sleep, 10000
	IfWinExist, First things first. ahk_class NUIDialog
	{
		Send, {Alt Down}{a}{Alt Up}
		Sleep, 500
	}
	/*
	WinClose, Accounts ahk_class NUIDialog
	Sleep, 333
	*/
	WinWaitActive, Skype for Business  ahk_class CommunicatorMainWindowClass
	Sleep, 500
	Sleep, 3000
	Send, {Tab 3}
	Sleep, 500
	SendRaw, %FirstName%.%LastName%@okland.com
	Sleep, 500
	Send, {Enter}
	Sleep, 500
	WinWait, Help Make Skype for Business Better! ahk_class NUIDialog
	Sleep, 500
	Send, {Alt Down}{n}{Alt Up}
	Sleep, 500
	WinMinimize, Skype for Business Basic ahk_class CommunicatorMainWindowClass  ; END skype setup
	Sleep, 500	
}

CenterImgSrchCoords(File, ByRef CoordX, ByRef CoordY)
{
	static LoadedPic
	LastEL := ErrorLevel
	Gui, Pict:Add, Pic, vLoadedPic, %File%
	GuiControlGet, LoadedPic, Pict:Pos
	Gui, Pict:Destroy
	CoordX += LoadedPicW // 2
	CoordY += LoadedPicH // 2
	ErrorLevel := LastEL
}

F8::ExitApp ; f8 hotkey to kill

F12::Pause ; f12 hotkey to pause

Esc::Return ; TESTING trying to exit back to gui.
