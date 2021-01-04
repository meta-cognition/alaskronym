#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance, Force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#NoTrayIcon

ahk_bin				:= "\Program Files\AutoHotkey\Compiler\Unicode 64-bit.bin"

executable_icon		:= ".\abc.ico"
executable_ahk		:= ".\Alaskronym.ahk"

installer_icon		:= ".\InstallIcon.ico"
installer_ahk		:= ".\Installer.ahk"

uninstaller_icon	:= ".\edit-delete-2.ico"
uninstaller_ahk		:= ".\Uninstaller.ahk"

FileDelete, .\compiler_directives.ahk

version = %A_Now%
version := SubStr(version, 1, 4) . "." . SubStr(version, 5, 2)  . "." . SubStr(version, 7, 2) . " " 
	. SubStr(version, 9, 2) . SubStr(version, 11, 2) . SubStr(version, 13, 2) 

rn := "`r`n"
version_company := "CodeVersion := """ version """, company := ""MIT License""" rn

FileAppend,  % version_company, .\compiler_directives.ahk

FileAppend, % ";@Ahk2Exe-Let version = `%A_PriorLine~U)^(.+""){1}(.+)"".*$~$2`%" rn, .\compiler_directives.ahk
FileAppend, % ";@Ahk2Exe-Let company = `%A_PriorLine~U)^(.+""){3}(.+)"".*$~$2`%" rn, .\compiler_directives.ahk
FileAppend, % ";@Ahk2Exe-SetDescription Acronym software." rn, .\compiler_directives.ahk
FileAppend, % ";@Ahk2Exe-SetVersion `%U_version`%" rn, .\compiler_directives.ahk
FileAppend, % ";@Ahk2Exe-SetCopyright Copyright (c) 2020``, Dom Pannone" rn, .\compiler_directives.ahk
FileAppend, % ";@Ahk2Exe-SetOrigFilename Alaskronym.ahk" rn, .\compiler_directives.ahk
FileAppend, % ";@Ahk2Exe-SetCompanyName `%U_company`%" rn, .\compiler_directives.ahk

RunWait, Ahk2Exe.exe /in "%executable_ahk%" /icon "%executable_icon%" /bin "%ahk_bin%"
RunWait, Ahk2Exe.exe /in "%uninstaller_ahk%" /icon "%uninstaller_icon%" /bin "%ahk_bin%"
RunWait, Ahk2Exe.exe /in "%installer_ahk%" /icon "%installer_icon%" /bin "%ahk_bin%"

FileDelete, Alaskronym.exe
FileDelete, Uninstaller.exe

FileGetVersion, old_version, .\_builds\alaskronym_installer_current.exe
FileMove, .\_builds\alaskronym_installer_current.exe, % ".\_builds\alaskronym_installer_" old_version ".exe"
FileMove, .\Installer.exe, .\_builds\alaskronym_installer_current.exe
