EnvGet, A_LocalAppData, LocalAppData

install_directory 			:= A_LocalAppData "\alaskronym"
executable_file				:= "Alaskronym.exe"

executable_file_installed	:= install_directory "\" executable_file

shortcut_file_installed		:= A_Startup "\Alaskaronym.lnk"

default_acronyms			:= "acronyms.akr"
default_acronyms_installed	:= install_directory "\" default_acronyms

tray_icon			        := "abc.ico"
tray_icon_installed	        := install_directory "\" tray_icon

MsgBox, 4,, Would you like to install Alaskronym? (press Yes or No)
IfMsgBox No
    ExitApp

FileRemoveDir, % install_directory, 1
FileCreateDir, % install_directory

FileInstall, Alaskronym.exe, % executable_file_installed
FileInstall, abc.ico, % tray_icon_installed
FileInstall, default_acronyms.akr, % default_acronyms_installed

FileCreateShortcut, % executable_file_installed, % shortcut_file_installed

Run, % executable_file_installed

