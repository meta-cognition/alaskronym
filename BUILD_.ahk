ahk_bin				:= "C:\Program Files\AutoHotkey\Compiler\Unicode 64-bit.bin"

executable_icon		:= "C:\METACOGNITION\PROGRAMMING\soak\alaskronym\abc.ico"
executable_ahk		:= "Alaskronym.ahk"

installer_icon		:= "C:\METACOGNITION\PROGRAMMING\soak\open_icon_library-standard\icons\InstallIcon.ico"
installer_ahk		:= "Installer.ahk"

RunWait, Ahk2Exe.exe /in "%executable_ahk%" /icon "%executable_icon%" /bin "%ahk_bin%"
RunWait, Ahk2Exe.exe /in "%installer_ahk%" /icon "%installer_icon%" /bin "%ahk_bin%"