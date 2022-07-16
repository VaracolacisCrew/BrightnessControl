; Created by 		Cristófano Varacolaci 
; For 			 	ObsessedDesigns Studios™, Inc.
; Version 			1.0.0
; Build             11:00 2022.07.15

/*
**********************
; OPTIMIZATIONS
**********************
*/
;http://ahkscript.org/boards/viewtopic.php?f=6&t=6413
SetWorkingDir, %A_ScriptDir%
#NoEnv
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000
#KeyHistory 0
;Process, Priority, , H ;if unstable, comment or remove this line
SetBatchLines, -1
SetKeyDelay, -1, -1, Play
SetMouseDelay, -1
SetDefaultMouseSpeed, 0
SetWinDelay, -1
SetControlDelay, -1
SendMode Input
SetTitleMatchMode 2
SetTitleMatchMode Fast
FileEncoding, UTF-8

/*
**********************
 	INCLUDES
**********************
*/

; Defafults & functions
#Include, inc\defaults.ahk
#Include, inc\functions.ahk
#Include, inc\aboutUI.ahk

/*
**********************
; INITIALIZATION
**********************
*/
#SingleInstance, Force
#Persistent
DetectHiddenText, on
DetectHiddenWindows, On
CoordMode, Mouse, Screen
OnExit, END
