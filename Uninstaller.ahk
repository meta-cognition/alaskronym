#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance, Force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#NoTrayIcon

EnvGet, A_LocalAppData, LocalAppData

install_directory 			:= A_LocalAppData "\alaskronym"
executable_file				:= "Alaskronym.exe"

executable_file_installed	:= install_directory "\" executable_file

shortcut_file_installed		:= A_Startup "\Alaskaronym.lnk"

default_acronyms			:= "acronyms.akr"
default_acronyms_installed	:= install_directory "\" default_acronyms

tray_icon			        := "abc.ico"
tray_icon_installed	        := install_directory "\" tray_icon

MsgBox, 4,, Would you like to uninstall and remove Alaskronym? (press Yes or No)
IfMsgBox No
{   
    run, Alaskronym.exe
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


