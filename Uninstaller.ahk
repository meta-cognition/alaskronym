#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance, Force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#NoTrayIcon

#Include installer_file_references.ahk

MsgBox, 4, Alaskronym Uninstaller, Would you like to uninstall and remove Alaskronym? (press Yes or No)
IfMsgBox No
{   
    run, % executable_file_installed
    ExitApp
}
Loop, 10
{
    Process, Exist, Alaskronym.exe
    if (ErrorLevel != 0 )
    {
        Process, Close, Alaskronym.exe
        Sleep, 1000
        continue
    }
    break
}
FileRemoveDir, % install_directory, 1
FileDelete, % shortcut_file_installed
MsgBox, Alaskronym has been removed.


