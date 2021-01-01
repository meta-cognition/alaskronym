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

RunWait, Ahk2Exe.exe /in "%executable_ahk%" /icon "%executable_icon%" /bin "%ahk_bin%"
RunWait, Ahk2Exe.exe /in "%uninstaller_ahk%" /icon "%uninstaller_icon%" /bin "%ahk_bin%"
RunWait, Ahk2Exe.exe /in "%installer_ahk%" /icon "%installer_icon%" /bin "%ahk_bin%"

FileDelete, Alaskronym.exe
FileDelete, Uninstaller.exe
