; Virtual desktop keyboard shortcuts

; Global conf
#SingleInstance, force
#UseHook

DetectHiddenWindows, On


; Desktop accessor
libVirtualDesktopAccessor := DllCall("LoadLibrary", "Str", "C:\Program Files\VirtualDesktopAccessor\VirtualDesktopAccessor.dll", "Ptr")

GetCurrentDesktopNumberProc := DllCall("GetProcAddress", Ptr, libVirtualDesktopAccessor, AStr, "GetCurrentDesktopNumber", "Ptr")
GoToDesktopNumberProc := DllCall("GetProcAddress", Ptr, libVirtualDesktopAccessor, AStr, "GoToDesktopNumber", "Ptr")
MoveWindowToDesktopNumberProc := DllCall("GetProcAddress", Ptr, libVirtualDesktopAccessor, AStr, "MoveWindowToDesktopNumber", "Ptr")


; Functions
GoToPrevDesktop() {
	global GetCurrentDesktopNumberProc
	current := DllCall(GetCurrentDesktopNumberProc, UInt)
	GoToDesktopNumber(current - 1)      
	return
}

GoToNextDesktop() {
	global GetCurrentDesktopNumberProc
	current := DllCall(GetCurrentDesktopNumberProc, UInt)
	GoToDesktopNumber(current + 1)    
	return
}

GoToDesktopNumber(num) {
	global GoToDesktopNumberProc
	DllCall(GoToDesktopNumberProc, Int, num)
	return
}

MoveCurrentWindowToDesktop(number) {
	global MoveWindowToDesktopNumberProc, GoToDesktopNumberProc
	WinGet, activeHwnd, ID, A
	DllCall(MoveWindowToDesktopNumberProc, UInt, activeHwnd, UInt, number)
	DllCall(GoToDesktopNumberProc, UInt, number)
}

GoAndMoveToNextDesktop() {
	global GetCurrentDesktopNumberProc
	current := DllCall(GetCurrentDesktopNumberProc, UInt)
	MoveCurrentWindowToDesktop(current + 1)      
	return
}

GoAndMoveToPrevDesktop() {
	global GetCurrentDesktopNumberProc
	current := DllCall(GetCurrentDesktopNumberProc, UInt)
	MoveCurrentWindowToDesktop(current - 1)      
	return
}


; Shortcuts
^!Right::GoToNextDesktop()
^!Left::GoToPrevDesktop()
^!+Right::GoAndMoveToNextDesktop()
^!+Left::GoAndMoveToPrevDesktop()
