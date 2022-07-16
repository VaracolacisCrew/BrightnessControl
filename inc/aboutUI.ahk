ABOUTUI: ;BREAKS THE EXECUTION OF THE FUNCTIONS FILES AND ALLOWS TO HAVE UI FUNCTIONS IN THE FUNCTIONS FILES

MENU:
	Menu, Tray, DeleteAll
	Menu, Tray, NoStandard
	Menu, Tray, Add, % PROGNAME WinName, ABOUT
	Menu, Tray, Add, &Settings, SETTINGS
	Menu, Tray, Default, &Settings
	Menu, Tray, Add,
	Menu, Tray, Add, &About...,ABOUT
	Menu, Tray, Add, &Exit, END
	Menu, Tray, Tip, % PROGNAME VERSION
    Gosub, MAIN
Return

;[SETTINGS]
SETTINGS:
	variablesFromIni(CONFIGURATION_FILE)
	GetDisplayBrightness(MinBright, CurrBright, MaxBright)
	;Gosub, RESTART
	GUI,Settings: Destroy ;prevent the double variable problems with Gui creation
	GUI,Settings: -MinimizeBox -MaximizeBox -DPIScale
	GUI,Settings: Add, Tab%TabsNumber%, x0 y0 w220 h340 gTabsResize vTabsVar, % TabsLabels

	GUI,Settings: Tab, 1
	GUI,Settings: Add, Text, x10 y30 w200 h23 +0x200 +0x1 vCBLabel, % "BRIGHTNESS: " CurrBright
	GUI,Settings: Add, Slider, x10 y55 w200 h32 gCurrBrightness vSBrightness +Tooltip, % CurrBright

	GUI,Settings: Add, GroupBox, x10 y100 w200 h120, Options
	GUI,Settings: Add, CheckBox, x40 y125 w140 h23 gSchedule vCBScheduler, Use Scheduler
	GUI,Settings: Add, CheckBox, x40 y155 w140 h23 gHotkeys vCBHotkeys, Use Hotkeys
	GUI,Settings: Add, CheckBox, x40 y185 w140 h23 gAutoStart vCBAutoStart, Start with Windows

	GUI,Settings: Tab, 2
	;group schedule
	GUI,Settings: Add, GroupBox, x10 y30 w200 h105, Schedule

	GUI,Settings: Add, Text, x20 y55 w75 h23, Day Time:
	GUI,Settings: Add, Edit, x100 y53 w44 h19 +Number +0x2, 24
	GUI,Settings: Add, UpDown, vDayTimeHH Range0-23, 1
	GUI,Settings: Add, Edit, x150 y53 w44 h19 +Number +0x2, 59
	GUI,Settings: Add, UpDown, vDayTimeMM Range0-59, 1

	GUI,Settings: Add, Text, x20 y80 w75 h23, Night Time:
	GUI,Settings: Add, Edit, x100 y79 w44 h19 +Number +0x2, 24
	GUI,Settings: Add, UpDown, vNightTimeHH Range0-23, 1
	GUI,Settings: Add, Edit, x150 y79 w44 h19 +Number +0x2, 59
	GUI,Settings: Add, UpDown, vNightTimeMM Range0-59, 1

	GUI,Settings: Add, Text, x20 y105 w75 h23, Falloff:
	GUI,Settings: Add, Edit, x100 y104 w60 h17 +Number +0x2 vFalloffMM, 120
	GUI,Settings: Add, Text, x165 y105 w30 h23 +0x2, mins

	;group min and max brightness
	GUI,Settings: Add, GroupBox, x10 y150 w200 h135, Brightness

	GUI,Settings: Add, Text, x20 y175 w180 h23 +0x1 vDBLabel, % "Day Time Brightness: " DTbrightness
	GUI,Settings: Add, Slider, x20 y195 w180 h25 +Tooltip gDBrightness vDTbrightness, % DTbrightness

	GUI,Settings: Add, Text, x20 y230 w180 h23 +0x1 vNBLabel, % "Night Time Brightness: " NTbrightness
	GUI,Settings: Add, Slider, x20 y250 w180 h25 +Tooltip gNBrightness vNTbrightness, % NTbrightness

	GUI,Settings: Add, Button, x150 y290 w60 h30 gSaveSchedule, Save
	GUI,Settings: Tab

    if (OPTIONS_schedule) {
		GuiControl, Settings:, CBScheduler, 1
	}
	if (OPTIONS_Hotkeys) {
		GuiControl, Settings:, CBHotkeys, 1
	}
	RegRead, AutoStart, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run, % PROGNAME
	if (AutoStart) {
		GuiControl, Settings:, CBAutoStart, 1
	}
	
	GuiControl, Settings:Text, DayTimeHH, % SchTime.DayHH
	GuiControl, Settings:Text, DayTimeMM, % SchTime.DayMM

	GuiControl, Settings:Text, NightTimeHH, % SchTime.NightHH
	GuiControl, Settings:Text, NightTimeMM, % SchTime.NightMM

	GuiControl, Settings:Text, FalloffMM, % FFMinutes
	
	GUI,Settings: Show, w220 h230, Settings
Return

; [ABOUT]
ABOUT:
	GUI, ABOUT:Font, s13 w600 c0x333333, Segoe UI
	GUI, ABOUT:Add, Text, x9 y3 w200 h28 +0x200, % PROGNAME
	GUI, ABOUT:Font
	GUI, ABOUT:Font, s8 c0x333333, Segoe UI
	GUI, ABOUT:Add, Text, x28 y26 w165 h23 +0x200, % ODESIGNS
	GUI, ABOUT:Font
	GUI, ABOUT:Font, s9 c0x333333
	GUI, ABOUT:Add, Text, x30 y50 w120 h23 +0x200, % "File Version:`t" VERSION
	GUI, ABOUT:Add, Text, x30 y70 w160 h23 +0x200, % "Release Date:`t" RELEASEDATE
	GUI, ABOUT:Font
	GUI, ABOUT:Font, s9 c0x808080, Segoe UI
	GUI, ABOUT:Add, Link, x46 y100 w171 h23, % "<a href=""" PROGNAME """>" AUTHOR "</a>"
	GUI, ABOUT:Font
	GUI, ABOUT:Add, Button, x83 y123 w44 h23 gAboutClose, &OK

	GUI, ABOUT:Show, w210 h150, % "About"
Return

ABOUTCLOSE:
	GUI, ABOUT:Destroy
Return
