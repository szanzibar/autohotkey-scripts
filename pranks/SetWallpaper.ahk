; This will change the wallpaper and take effect immediately, then exit. Make sure to use a bmp file type only.
; This does not permanently change the wallpaper and will revert after a reboot.
; For maximum annoyance, put this in a schedule that runs every hour. Your victim's vain attempts to fix their wallpaper will quicky be overwritten.

#NoTrayIcon ; stealth mode

DllCall("SystemParametersInfo", UInt, 0x14, UInt, 0, Str, "C:\Users\steven.vandijk\Downloads\TrollFace.bmp", UInt, 2) 