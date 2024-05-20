#Requires AutoHotkey v2.0
#SingleInstance Force
#Include Chrome.ahk
#Include JSON.ahk

; Chrome library: https://github.com/G33kDude/Chrome.ahk
; Chrome ported to v2 from here: https://github.com/thqby/ahk2_lib/blob/master/Chrome.ahk

myURL := "https://photos.google.com/share/AF1QipPIAdCcVmE_Lst59IK-Xyq_OC-RxSuw0pMtYyAM88sgEkewF2mo9PUSrnmFXj2AKg"
ChromeProfilePath := A_AppData "\Google\Chrome\User Data"
ChromeInstance := Chrome(,,,, ChromeProfilePath)
PageInstance := ChromeInstance.NewPage()
PageInstance.Call("Page.navigate", {url: myURL})
PageInstance.WaitForLoad()
PageInstance.Evaluate("document.querySelector('span > div > div > div > div:nth-child(2) > a').click()")
PageInstance.WaitForLoad()

WinActivate "ahk_exe chrome.exe"

WinGetPos ,,&W, &H, "ahk_exe chrome.exe"
while !((W >= A_ScreenWidth ) & (H >= A_ScreenHeight))
	{
		JS := "document.querySelector('div > div > div > span >div > div > div[aria-label=`"More options`"]')"
		while PageInstance.Evaluate(JS)["subtype"] = "null"
			Sleep 500
		PageInstance.Evaluate("document.querySelector('div > div > div > span >div > div > div[aria-label=`"More options`"]').click()")

		JS := "document.querySelector('body > div > div > div > span:nth-child(1)')"
		while PageInstance.Evaluate(JS)["subtype"] = "null"
			Sleep 100

		Send('{Enter}')

		Sleep 5000
		
		WinGetPos ,,&W, &H, "ahk_exe chrome.exe"
	}

ExitApp
