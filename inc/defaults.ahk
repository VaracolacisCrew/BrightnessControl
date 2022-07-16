/*
**************************
PROGRAM VARIABLES GLOBALS
**************************
*/
global PROGNAME 			:= "MAIN"
global VERSION 				:= "1.0.0.0"
global RELEASEDATE 			:= "Julio 15, 2022"
global AUTHOR 				:= "Cristófano Varacolaci"
global ODESIGNS 			:= "obsessedDesigns Studios™, Inc."
global AUTHOR_PAGE 			:= "http://obsesseddesigns.com"
global AUTHOR_MAIL 			:= "cristo@obsesseddesigns.com"

global DATA_FOLDER			:= A_ScriptDir "\Data\"
global CONFIGURATION_FILE	:= "brightness.ini"

global H_Compiled := RegexMatch(Substr(A_AhkPath, Instr(A_AhkPath, "\", 0, 0)+1), "iU)^(MAIN).*(\.exe)$") && (!A_IsCompiled) ? 1 : 0
global mainIconPath := H_Compiled || A_IsCompiled ? A_AhkPath : "Data\icons\main.ico"

INI_VARIABLES:
    ;read ini file for VARIABLES
    variablesFromIni(CONFIGURATION_FILE)

    PROGNAME := SYSTEM_name
    PROGNAME := ((!PROGNAME) ? ("MAIN") : (SYSTEM_name))

    VERSION := SYSTEM_version
    VERSION := ((!VERSION) ? ("1.0.0.0") : (VERSION))

    ini_LANG := SYSTEM_lang
    ini_LANG := ((!ini_LANG) ? ("english") : (ini_LANG))


if !FileExist(CONFIGURATION_FILE) {
    FileAppend, % "[SYSTEM]`nname=" . PROGNAME . "`nversion=" . VERSION . "`nlang=" . ini_LANG, % CONFIGURATION_FILE
    RunWait, brightness.ini, A_ScriptDir
    Goto, INI_VARIABLES
}

;---- [Initilization]
Change_Icon(mainIconPath)

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
FFcount := 1

global MinBright := 0
global MaxBright := 0
global CurrBright := 0
global DTbrightness := SCHEDULE_daybrightness
global NTbrightness := SCHEDULE_nightbrightness
TabsNumber := 2
TabsLabels := "Settings | Scheduler "

GetDisplayBrightness(MinBright, CurrBright, MaxBright)