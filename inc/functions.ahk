; Created by 		Cristófano Varacolaci
; For 			 	ObsessedDesigns Studios™, Inc.
; Version 			0.1.0.0
; Build 			16:30 2021.12.05
; ==================================================================================================================================
; Function:       variablesFromIni
; Description     read all variables in an ini and store in variables
; Usage:          variablesFromIni(_SourcePath, _VarPrefixDelim = "_")
; Parameters:
;  _SourcePath    	-  path to the ini file ["config/main.ini"]
;  _ValueDelim      -  This is the delimitator used for key 'delim' value function
;  _VarPrefixDelim 	-  This specifies the separator between section name and key name.
; 						All section names and key names are merged into single name.
; Return values:  
;     Variables from the ini, named after SECTION Delimiter KEY
; Change history:
;     1.2.00.00/2022.04.19
;     Updated to use SubStr() ad regExMatch() instead of deprecated functions
; Remarks:
; Change history:
;     1.1.00.00/2022.03.30
;     Added _ValueDelim
;     corrected an error, now it is working again
; Remarks:
; Change history:
;     1.1.00.00/2021.12.05
;     Added _ValueDelim
; Remarks:

variablesFromIni(_SourcePath, _ValueDelim = "=", _VarPrefixDelim = "_")
{
    Global
    if !FileExist(_SourcePath){
        MsgBox, 16, % "Error", % "The file " . _SourcePath . " does not esxist"
    } else {        
        Local FileContent, CurrentPrefix, CurrentVarName, CurrentVarContent, DelimPos
        FileRead, FileContent, %_SourcePath%
        If ErrorLevel = 0
        {
            Loop, Parse, FileContent, `n, `r%A_Tab%%A_Space%
            {
                If A_LoopField Is Not Space
                {
                    If (SubStr(A_LoopField, 1, 1) = "[")
                    {
                        RegExMatch(A_LoopField, "\[(.*)\]", ini_Section)
                        CurrentPrefix := ini_Section1
                    }
                    Else
                    {
                        DelimPos := InStr(A_LoopField, _ValueDelim)
                        CurrentVarName := SubStr(A_LoopField, 1, DelimPos - 1)
                        CurrentVarContent := SubStr(A_LoopField, DelimPos + 1)
                        %CurrentPrefix%%_VarPrefixDelim%%CurrentVarName% = %CurrentVarContent%
                        ;MsgBox, , Title, %CurrentPrefix%%_VarPrefixDelim%%CurrentVarName% = %CurrentVarContent%
                    }
                    
                }
            }
        }
    }
}
; ==================================================================================================================================
; Function:       Ini_write
; Description     writes a value into an ini file
; Usage:          Ini_write(inifile, section, key, value, [ifblank])
; Parameters:
;  inifile        -  path to the ini file ["config/main.ini"]
;  section        -  section of the ini to read the key from
;  key            -  the key to delete from the ini file
;  value          -  the value to write on
; Return values:  
;     True on success, fail otherwise
; Change history:
;     1.0.00.00/2016-08-13
; Remarks:
;     oresult -> operation result
Ini_write(inifile, section, key, value="", ifblank=false) {
	;ifblank means if the key doesn't exist
	Iniread, v,% inifile,% section,% key

	if ifblank && (v == "ERROR")
		IniWrite,% value,% inifile,% section,% key
   oresult := ErrorLevel ? False : True
	if !ifblank
		IniWrite,% value,% inifile,% section,% key
   oresult := ErrorLevel ? False : True
   Return oresult
}
; ==================================================================================================================================
; Function:       Ini_read
; Description     Reads a value from an ini file
; Usage:          Ini_read(inifile, section, key)
; Parameters:
;  inifile        -  path to the ini file ["config/main.ini"]
;  section        -  section of the ini to read the key from
;  key            -  the key to delete from the ini file
; Return values:  
;     value of the searched key
; Change history:
;     1.0.00.00/2016-08-13
; Remarks:
Ini_read(inifile, section, key){
	Iniread, v, % inifile,% section,% key, %A_space%
	if v = %A_temp%
		v := ""
	return v
}
; ==================================================================================================================================
; Function:       Ini_delete
; Description     Deletes value in an ini file
; Usage:          Ini_delete(inifile, section, key)
; Parameters:
;  inifile        -  path to the ini file ["config/main.ini"]
;  section        -  section of the ini to read the key from
;  key            -  the key to delete from the ini file
; Return values:  
;     True on success, fail otherwise
; Change history:
;     1.0.00.00/2016-08-13
; Remarks:
;     oresult -> operation result
Ini_delete(inifile, section, key){
	IniDelete, % inifile, % section, % key
   oresult := ErrorLevel ? False : True
   Return oresult
}
; ==================================================================================================================================
; Function:       Change_Icon
; Description     Set the icon to the tray depending if it's compiled or not
; Usage:          changeIcon(file)
; Parameters:
;  file           -  path to the icon file ["icons/icon.ico"]
; Return values:  
;     nothing
; Change history:
;     1.0.00.00/2016-08-13
; Remarks:
;     Nothing
Change_Icon(file){
	if A_IsCompiled or H_Compiled 		; H_Compiled is a user var created if compiled with ahk_h
		Menu, tray, icon, % A_AhkPath
	else
		Menu, tray, icon, % file
}


; WM_SYSCOMMAND(wParam)
; {
;    If ( wParam = 61472 ) {
;    SetTimer, OnMinimizeButton, -1
;    Return 0
;    }
; }

; OnMinimizeButton:
;   MinimizeGuiToTray( R, MENU )
; Return

; ==================================================================================================================================
; Function:       MinimizeGuiToTray
; Description     Makes the minimize button to send to tray
; Usage:          MinimizeGuiToTray( R, GUINAME )
; Parameters:
;  R           -  
;  GUINAME     -    GUI handler
; Return values:  
;     nothing
; Change history:
;     1.0.00.00/2022-06-26
; Remarks:
;     the GUI must contain  +LastFound +Owner and the mainUi MAINUI := WinExist() and OnMessage(0x112, "WM_SYSCOMMAND")
MinimizeGuiToTray( ByRef R, hGui ) {
  WinGetPos, X0,Y0,W0,H0, % "ahk_id " (Tray:=WinExist("ahk_class Shell_TrayWnd"))
  ControlGetPos, X1,Y1,W1,H1, TrayNotifyWnd1,ahk_id %Tray%
  SW:=A_ScreenWidth,SH:=A_ScreenHeight,X:=SW-W1,Y:=SH-H1,P:=((Y0>(SH/3))?("B"):(X0>(SW/3))
  ? ("R"):((X0<(SW/3))&&(H0<(SH/3)))?("T"):("L")),((P="L")?(X:=X1+W0):(P="T")?(Y:=Y1+H0):)
  VarSetCapacity(R,32,0), DllCall( "GetWindowRect",UInt,hGui,UInt,&R)
  NumPut(X,R,16), NumPut(Y,R,20), DllCall("RtlMoveMemory",UInt,&R+24,UInt,&R+16,UInt,8 )
  DllCall("DrawAnimatedRects", UInt,hGui, Int,3, UInt,&R, UInt,&R+16 )
  WinHide, ahk_id %hGui%
}

; ==================================================================================================================================
; Function:         GetDisplayBrightness
; Description       get the min, current and max brightness capabilities of the display
; Usage:            GetDisplayBrightness(MinBright, CurrBright, MaxBright)
; Parameters:
;                   Variables to store Minimum brightnes, current brightness and maximum brightness
; Return values:  
;                   MinBright   number
;                   CurrBright  number
;                   MaxBright   number
; Change history:
;       1.0.00.00/2022-06-26
; Remarks:
;       Nothing
GetDisplayBrightness(ByRef MinBright, ByRef CurrBright, ByRef MaxBright) {
   HMON := DllCall("User32.dll\MonitorFromWindow", "Ptr", 0, "UInt", 0x02, "UPtr")
   DllCall("Dxva2.dll\GetNumberOfPhysicalMonitorsFromHMONITOR", "Ptr", HMON, "UIntP", PhysMons, "UInt")
   VarSetCapacity(PHYS_MONITORS, (A_PtrSize + 256) * PhysMons, 0) ; PHYSICAL_MONITORS
   DllCall("Dxva2.dll\GetPhysicalMonitorsFromHMONITOR", "Ptr", HMON, "UInt", PhysMons, "Ptr", &PHYS_MONITORS, "UInt")
   HPMON := NumGet(PHYS_MONITORS, 0, "UPtr")
   DllCall("Dxva2.dll\GetMonitorBrightness", "Ptr", HPMON, "UIntP", MinBright, "UIntP", CurrBright, "UIntP", MaxBright, "UInt")
   DllCall("Dxva2.dll\DestroyPhysicalMonitors", "UInt", PhysMons, "Ptr", &PHYS_MONITORS, "UInt")
}

; ==================================================================================================================================
; Function:         SetDisplayBrightness
; Description       Sets the desired brightness to the display
; Usage:            SetDisplayBrightness(Brightness)
; Parameters:
;                   brightness
; Return values:  
;                   Brightness
; Change history:
;       1.0.00.00/2022-06-26
; Remarks:
;       nothing
SetDisplayBrightness(Brightness) {
   Static MinBright := "", CurrBright := "", MaxBright := ""
   HMON := DllCall("User32.dll\MonitorFromWindow", "Ptr", 0, "UInt", 0x02, "UPtr")
   DllCall("Dxva2.dll\GetNumberOfPhysicalMonitorsFromHMONITOR", "Ptr", HMON, "UIntP", PhysMons, "UInt")
   VarSetCapacity(PHYS_MONITORS, (A_PtrSize + 256) * PhysMons, 0) ; PHYSICAL_MONITORS
   DllCall("Dxva2.dll\GetPhysicalMonitorsFromHMONITOR", "Ptr", HMON, "UInt", PhysMons, "Ptr", &PHYS_MONITORS, "UInt")
   HPMON := NumGet(PHYS_MONITORS, 0, "UPtr")
   DllCall("Dxva2.dll\GetMonitorBrightness", "Ptr", HPMON, "UIntP", MinBright, "UIntP", CurrBright, "UIntP", MaxBright, "UInt")
   If Brightness Is Not Integer
      Brightness := CurrBright
   If (Brightness < MinBright)
      Brightness := MinBright
   If (Brightness > MaxBright)
      Brightness := MaxBright
   DllCall("Dxva2.dll\SetMonitorBrightness", "Ptr", HPMON, "UInt", Brightness, "UInt")
   DllCall("Dxva2.dll\DestroyPhysicalMonitors", "UInt", PhysMons, "Ptr", &PHYS_MONITORS, "UInt")

   Return Brightness
}

; ==================================================================================================================================
; All following functions are GUI triggered so the execution must be broken
; to not execute them at file loading time.
Goto, ABOUTUI
;---- [GUI exclusive functions]

; ==================================================================================================================================
; LAUCH ADJUSTMENTS WHEN SCHEDULE IS ON
RESTART:
    variablesFromIni(CONFIGURATION_FILE)
    GetDisplayBrightness(MinBright, CurrBright, MaxBright)
    TIME_NOW        := Object()
    TIME_NOW.HH     := A_Hour
    TIME_NOW.MM     := A_Min
    TIME_NOW.SS     := A_Sec
    TIME_NOW.Sec    := (TIME_NOW.HH * 3600) + (TIME_NOW.MM * 60) + TIME_NOW.SS

    SchTime             := Object()
    SchTime.DayHH       := SubStr(SCHEDULE_daytime, 1, 2)
    SchTime.DayMM       := SubStr(SCHEDULE_daytime, 3, 2)
    SchTime.DaySS       := (SchTime.DayHH * 3600) + (SchTime.DayMM * 60)
    SchTime.NightHH     := SubStr(SCHEDULE_nighttime, 1, 2)
    SchTime.NightMM     := SubStr(SCHEDULE_nighttime, 3, 2)
    SchTime.NightSS     := (SchTime.NightHH * 3600) + (SchTime.NightMM * 60)

    FFSeconds := SCHEDULE_falloff
    FFMinutes := Floor(SCHEDULE_falloff / 60)

    TTFalloff := 0 ;time to falloff
    Goto, SCHEDULER
Return

SCHEDULER:

    if (OPTIONS_schedule) 
    {
        if (SchTime.DaySS > SchTime.NightSS)
        {
            if (TIME_NOW.Sec > SchTime.DaySS)
            {
                ;day
                SetDisplayBrightness(SCHEDULE_daybrightness)
                TTFalloff := 86400 - TIME_NOW.Sec + SchTime.NightSS
                ;MsgBox, % 86400 - TIME_NOW.Sec + SchTime.NightSS
                ;MsgBox, 1
            } else {
                ;night
                SetDisplayBrightness(SCHEDULE_nightbrightness)
                TTFalloff := SchTime.DaySS - TIME_NOW.Sec
                ;MsgBox, % SchTime.DaySS - TIME_NOW.Sec
                ;MsgBox, 2
            }
        } Else {
            if (TIME_NOW.Sec > SchTime.NightSS)
            {
                ;night
                SetDisplayBrightness(SCHEDULE_nightbrightness)
                TTFalloff := 86400 - TIME_NOW.Sec + SchTime.DaySS
                ;MsgBox, % 86400 - TIME_NOW.Sec + SchTime.DaySS
                ;MsgBox, 3
            } else if (TIME_NOW.Sec > SchTime.DaySS) 
                {
                    ;day
                    SetDisplayBrightness(SCHEDULE_daybrightness)
                    TTFalloff := SchTime.NightSS - TIME_NOW.Sec
                    ;MsgBox, % SchTime.NightSS - TIME_NOW.Sec
                    ;MsgBox, 4
                } else if (TIME_NOW.Sec < SchTime.DaySS)
                    {
                        ;night
                        SetDisplayBrightness(SCHEDULE_nightbrightness)
                        TTFalloff := SchTime.DaySS - TIME_NOW.Sec
                        ;MsgBox, 5
                    }
        }

        SetTimer, SLEEPER, % TTFalloff * 1000
    }

Return

GUICLOSE_ABOUT:
	Gui About:Destroy
Return

TABSRESIZE:
    GUI Settings:Submit, NoHide
    if (TabsVar == "Settings ") {
        GUI,Settings: Show, w220 h230, Settings
    } else if (TabsVar == " Scheduler ") {
        GUI,Settings: Show, w220 h327, Scheduler
    } else 
        GUI,Settings: Show,  w220 h230, Hotkeys
Return

CURRBRIGHTNESS:
    GUI Settings:Submit, NoHide
    SetDisplayBrightness(SBrightness)
    GuiControl, Settings:, CBLabel, % "BRIGHTNESS: " SBrightness
    GUI,Settings: Show
Return

SCHEDULE:
    GUI Settings:Submit, NoHide
    if (CBScheduler) {
        Ini_write(CONFIGURATION_FILE, "OPTIONS", "schedule", 1)
    } else 
        Ini_write(CONFIGURATION_FILE, "OPTIONS", "schedule", 0)
Return

DBRIGHTNESS:
    GUI Settings:Submit, NoHide
    GuiControl, Settings:, DBLabel, % "Day Time Brightness: " DTbrightness
    GUI,Settings: Show
Return


NBRIGHTNESS:
   GUI Settings:Submit, NoHide
   GuiControl, Settings:, NBLabel, % "Night Time Brightness: " NTbrightness
   GUI,Settings: Show
Return

SAVESCHEDULE:
    GUI Settings:Submit
    DayTimeHH := ((DayTimeHH < 10) ?  (DayTimeHH := "0" DayTimeHH) : DayTimeHH)
    DayTimeMM := ((DayTimeMM < 10) ?  (DayTimeMM := "0" DayTimeMM) : DayTimeMM)

    NightTimeHH := ((NightTimeHH < 10) ?  (NightTimeHH := "0" NightTimeHH) : NightTimeHH)
    NightTimeMM := ((NightTimeMM < 10) ?  (NightTimeMM := "0" NightTimeMM) : NightTimeMM)

    DayTime := DayTimeHH DayTimeMM
    NightTime := NightTimeHH NightTimeMM

    Ini_write(CONFIGURATION_FILE, "SCHEDULE", "daytime", DayTime)
    Ini_write(CONFIGURATION_FILE, "SCHEDULE", "nighttime", NightTime)
    Ini_write(CONFIGURATION_FILE, "SCHEDULE", "falloff", FalloffMM * 60)
    Ini_write(CONFIGURATION_FILE, "SCHEDULE", "daybrightness", DTbrightness)
    Ini_write(CONFIGURATION_FILE, "SCHEDULE", "nightbrightness", NTbrightness)
    Gosub, RESTART
Return

HOTKEYS:
    GUI Settings:Submit, NoHide
    if (CBHotkeys) {
        Ini_write(CONFIGURATION_FILE, "OPTIONS", "hotkeys", 1)
    } else 
        Ini_write(CONFIGURATION_FILE, "OPTIONS", "hotkeys", 0)
Return

AUTOSTART:
    GUI Settings:Submit, NoHide
    if (CBAutoStart) {
        RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run, % PROGNAME, % A_AhkPath
    } else
        RegDelete, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run, % PROGNAME
Return

SLEEPER:
    SetTimer, SLEEPER, Off
    SetTimer, FALLOFF, 1000
Return

FALLOFF:
    if (FFcount <= FFSeconds)
    {     
        if (CurrBright > NTbrightness)
        {
            FFBrightness := DTbrightness - NTbrightness
            BrightnessControl := Floor(NTbrightness + ((((FFSeconds - FFcount) * (100 / FFSeconds)) * FFBrightness) / 100))
            ;Tooltip, % "Seconds: " FFcount "`n-Brightness: " NTbrightness + ((((FFSeconds - FFcount) * (100 / FFSeconds)) * FFBrightness) / 100)
        } else {
            FFBrightness := DTbrightness - NTbrightness
            BrightnessControl := Floor(NTbrightness + (((FFcount * (100 / FFSeconds)) * FFBrightness) / 100))
            ;Tooltip,  % "Seconds: " FFcount "`n-Brightness: " NTbrightness + (((FFcount * (100 / FFSeconds)) * FFBrightness) / 100)
        }
        SetDisplayBrightness(BrightnessControl)
        
        FFcount++
    } else {
        SetTimer, FALLOFF, Off
        ;Tooltip, 
        FFcount := 0
        Goto, RESTART
    }
    
Return
