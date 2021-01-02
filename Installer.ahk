#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance, Force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#NoTrayIcon

#Include installer_file_references.ahk

MsgBox, 4, Alaskronym Installer, Would you like to install Alaskronym? (press Yes or No)
IfMsgBox No
    ExitApp

FileRemoveDir, % install_directory, 1
FileCreateDir, % install_directory

FileInstall, Alaskronym.exe, % executable_file_installed
FileInstall, abc.ico, % tray_icon_installed
FileInstall, default_acronyms.akr, % default_acronyms_installed
FileInstall, tutorial.txt, % tutorial_file_installed
FileInstall, Uninstaller.exe, % uninstaller_file_installed

FileCreateShortcut, % executable_file_installed, % shortcut_file_installed

Run, % executable_file_installed

