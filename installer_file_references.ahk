EnvGet, A_LocalAppData, LocalAppData

install_directory 			:= A_LocalAppData "\alaskronym"
executable_file				:= "Alaskronym.exe"

executable_file_installed	:= install_directory "\" executable_file

shortcut_file_installed		:= A_Startup "\Alaskaronym.lnk"

default_acronyms			:= "acronyms.akr"
default_acronyms_installed	:= install_directory "\" default_acronyms

tray_icon			        := "abc.ico"
tray_icon_installed	        := install_directory "\" tray_icon

tutorial_file		        := "tutorial.txt"
tutorial_file_installed     := install_directory "\" tutorial_file

uninstaller_file			:= "Uninstaller.exe"
uninstaller_file_installed	:= install_directory "\" uninstaller_file