#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance, Force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Include compiler_directives.ahk


Menu, Tray, Icon, abc.ico
Menu, Tray, NoStandard
Menu, Tray, Add, Uninstall, Uninstall
Menu, Tray, Add, Tutorial, Tutorial

; need to add tutoarial and uninstall labels. 
; need to add tutorial file to install
; need to creat uninstall script.

Menu, Tray, Add, ,
Menu, Tray, Add, Settings, Settings
Menu, Tray, Add, ,
Menu, Tray, Add, Exit, ExitApp
Menu, Tray, Default, Settings
Menu, Tray, Click, 1

; Create object for dual hotstrings
acronym_object := {}

acronym_file    := A_ScriptDir "\acronyms.akr" 
hide_file       := A_ScriptDir "\hide_on_startup.0" 
file_seperator := "{_*&*_}"

GoSub, MainGUI

return
;=====================================================================================	
MainGUI:
    ; Right Click LV_Menu
    Menu, ContextMenu, Add, Delete, AcronymDelete
    Gui, Font, , Verdana
    Gui, Add, Button,    x10 y10 w100 h30 gAcronymAdd , Add
    Gui, Add, Button,   x120 y10 w100 h30 gAcronymDelete, Delete
    Gui, Add, Button,   x600 y10 w100 h30 gImportLV, Import List
    Gui, Add, Button,   x710 y10 w100 h30 gExportLV , Export List
    Gui, Add, ListView,  x10 y50 w800 h600 vacronym_listview gAcronymListView Sort, INITIATOR|CONVERTS TO...|EXPANDS TO...
    gosub, OpenLV
    gosub, ProcessLV
    Gui, Add, Button,   x710 y660 w100 h30 gGuiClose, Done
    Gui, Font, S10 CDefault, Verdana
    Gui, Add, Text, x12 y657 w600 h40 , Alaskronym is free and open source software released under MIT License.`r`nAlaskronym was written by Dom Pannone.
    Gui -MinimizeBox 
    Gui, Font, S8 CDefault, Verdana
    ifexist, % hide_file
    {
        Gui, Add, CheckBox, x230 y10 w190 h30 gHideToggle vhide_at_startup checked, Hide this window at startup.
    }
    IfNotExist, % hide_file
    {
        Gui, Add, CheckBox, x230 y10 w190 h30 gHideToggle vhide_at_startup, Hide this window at startup.
        Gui, Show, w820 h700, Alaskronym - The Alaskan acronym helper program.
    }
return
;=====================================================================================	
ImportGUI:
    Gui +Disabled
    Gui, 3:New, +Owner1
    Gui, 3:Font, , Verdana
    Gui, 3:Add, ListView, Checked x10 y10 w800 h600 vacronym_listview gAcronymListView Sort, |WILL OVERWRITE?|INITIATOR|CONVERTS TO...|EXPANDS TO...
    Gui, 3:Add, Button,    x10 y620 w100 h30 gCheckAll , Check All
    Gui, 3:Add, Button,   x600 y620 w100 h30 Default gImportChecked, Import
    Gui, 3:Add, Button,   x710 y620 w100 h30  g3GuiClose, Cancel
    Gui, 3:Font, S10 CDefault, Verdana
    Gui, 3:Add, Text, x120 y625 w400 h40 , Only CHECKED items will be imported.
    Gui 3:-MinimizeBox 
    Loop, Read, % import_target
    {
        col_array := StrSplit(A_LoopReadLine, file_seperator) 
        Gui, 1:Default
        overwrite := ""
        check := "check"
        Loop % LV_GetCount() 
        {
            LV_GetText(col_1, A_Index, 1)
            if (col_array[1] = col_1)
            {
                overwrite := "YES!"
                check := ""
            }
        }
        Gui, 3:Default
        LV_Add(check, , overwrite, col_array[1], col_array[2], col_array[3]) 
    }
    LV_ModifyCol(2, "Center")
    LV_ModifyCol(3,"Sort")
    Gui, 3:Show, w820 h660, Alaskronym - IMPORT
return
;=====================================================================================	
ExitApp:
    ExitApp
return
;=====================================================================================	
Settings:
    Gui, Show, w820 h700, Alaskronym - The Alaskan acronym helper program.
return
;=====================================================================================	
Uninstall:
    uninstaller_spawn := A_Temp "\Uninstaller_" a_Now ".exe"
    FileCopy, Uninstaller.exe, % uninstaller_spawn
    run, % uninstaller_spawn
    exitapp
return
;=====================================================================================	
Tutorial:
    temp_tutorial_file := A_Temp "\tutorial_" A_now ".txt"
    FileCopy, tutorial.txt, % temp_tutorial_file
    cmd := "notepad """ temp_tutorial_File """"
    Run, % cmd, % A_Temp
return
;=====================================================================================	
; 2 entry points for add edit...
; Entry label AcronymAdd clears col_x vars before building GUI...
AcronymAdd:
    col_1 :=
    col_2 :=
    col_3 :=
; no return for this label is intentional to allow continuation below...
; Build add/edit GUI...
AddEdit:
    Suspend, On
    Gui +Disabled
    Gui, 2:New, +Owner1
    Gui, 2:Font, , Verdana
    Gui, 2:-MinimizeBox 
    Gui, 2:Add, Edit, x10 y40  w520 h20 vcol_1, % col_1
    Gui, 2:Add, Edit, x10 y100 w520 h20 vcol_2, % col_2
    Gui, 2:Add, Edit, x10 y160 w520 h20 vcol_3, % col_3
    Gui, 2:Add, Text, x10 y20  w520 h20 , INITIATOR - should be all lowercase`, the keys that trigger the following sequences...
    Gui, 2:Add, Text, x10 y80  w520 h20 , CONVERTS TO - typically the above INITIATOR acronym, but in all caps.
    Gui, 2:Add, Text, x10 y140 w520 h20 , EXPANDS TO - text that will be typed if the acronym is expanded with [spacebar] x 2.
    Gui, Add, Button, x320 y190 w100 h30 Default gDoSave, Save
    Gui, Add, Button, x430 y190 w100 h30 g2GuiClose, Cancel
    Gui, Show, w540 h230, Add/Edit
return
;=====================================================================================	
; If a ListView item is right-clicked....
GuiContextMenu:
    if ( A_GuiControl = "acronym_listview" && A_GuiEvent = "RightClick" )
    {
        Menu, ContextMenu, Show
    }
return
;=====================================================================================	
; If a ListView item is double-clicked...
AcronymListView:
    if (A_GuiEvent = "DoubleClick")
    {
        lv_mode := "edit"
        lv_row	:= A_EventInfo
        LV_GetText(col_1, lv_row, 1)
        LV_GetText(col_2, lv_row, 2)
        LV_GetText(col_3, lv_row, 3)
        gosub AddEdit
    }
return
;=====================================================================================	
; Delete a ListView Item...
AcronymDelete:
    i := 0  
    Loop 
    {
        i := LV_GetNext(0)
        if (i = 0)
        {
            break
        }
        LV_GetText(col_1, i, 1)
        Hotstring( ":CB0Xo:" . col_1, , "Off")
        acronym_object.delete(col_1)
        LV_Delete(i)
    }
    gosub, SaveApply
return
;=====================================================================================	
; When main gui is closed...
GuiClose:
    gui, hide
    gosub, SaveApply
return
;=====================================================================================	
2GuiClose:
    lv_mode :=
    Gui, 1:-Disabled	
    Gui, 2:Destroy
    Gui, 1:Default
    Suspend, Off
return
;=====================================================================================	
3GuiClose:
    Gui, 1:-Disabled	
    Gui, 3:Destroy
    Gui, 1:Default
return
;=====================================================================================	
DoSave:
    Gui, 2:Submit, NoHide
    if (lv_mode = "edit")
    {
        if ( col_1 != "")
        {
            Gui, 2:+Disabled
            Gui, 1:Default
            LV_Modify(lv_row,  , col_1, col_2, col_3)
            GoSub, SaveApply
            Gui, 1:-Disabled
            Gui, 2:Destroy
            lv_mode :=	
            Suspend, Off
            return
        }
        MsgBox, 48, INITIATOR cannot be blank., Please type an intitiator letters/keys.
        return		
    }
    if ( col_1 != "")
    {
        Gui, 1:Default
        Loop % LV_GetCount()
        {
            LV_GetText(current_col_1, A_Index, 1)
            if (current_col_1 = col_1)
            {
                MsgBox, 52, INITIATOR already exists, This INITIATOR already exists. REPLACE and OVERWRITE?
                IfMsgBox, No
                {
                    return
                }
                Gui, 2:+Disabled
                Gui, 1:Default
                LV_Modify(A_Index, , col_1, col_2, col_3)
                GoSub, SaveApply
                Gui, 1:-Disabled
                Gui, 2:Destroy
                Suspend, Off
                return
            }
        }
        Gui, 2:+Disabled
        Gui, 1:Default
        LV_Add( , col_1, col_2, col_3)
        GoSub, SaveApply
        Gui, 1:-Disabled
        Gui, 2:Destroy	
        Suspend, Off
        return
    }
    MsgBox, 48, INITIATOR cannot be blank., Please type an intitiator letters/keys.
return
;=============================================================================
OpenLV:
    Loop, Read, % acronym_file 
    {
        col_array := StrSplit(A_LoopReadLine, file_seperator)   
        LV_Add( , col_array[1], col_array[2], col_array[3])                      
    }                                                            
return
;=====================================================================================
SaveApply:
    GoSub, SaveLV
    GoSub, ProcessLV
return
;=====================================================================================	
SaveLV:    
    LV_ModifyCol(1,"Sort")
    FileDelete % acronym_file
    Loop % LV_GetCount() 
    {
        LV_GetText(col_1, A_Index, 1)
        LV_GetText(col_2, A_Index, 2)
        LV_GetText(col_3, A_Index, 3)
        output_line := col_1 file_seperator col_2 file_seperator col_3 "`r`n"
        FileAppend, % output_line, % acronym_file
    }
return
;=====================================================================================
ProcessLV:
    Gui, 1:Default
    Loop % LV_GetCount() 
    {
        LV_GetText(col_1, A_Index, 1)
        LV_GetText(col_2, A_Index, 2)
        LV_GetText(col_3, A_Index, 3)
        create_dual_hotstring(col_1, col_2, col_3)
    }
Return	
;==============================================================================
ExportLV:
    Gui, +Disabled
    MsgBox, 64, Exporting List..., Exporting list file to "Documents" folder. `r`nA window should open with the file selected.
    export_target := A_MyDocuments "\AcronymExport_" A_Now ".akr"
    FileCopy, % acronym_file, % export_target
    Run %COMSPEC% /c explorer.exe /select`, "%export_target%",, Hide
    Gui, -Disabled
return
;=====================================================================================	
ImportLV:
    FileSelectFile, import_target, ,% A_MyDocuments, Select a ".akr" file that you or someone exported, *.akr
    if (import_target != "")
    {
        GoSub, ImportGUI
    }
return
;=====================================================================================	
CheckAll:
    gui, 3:default
    Loop % LV_GetCount() 
    {
        lv_modify(A_Index, "check")
    }
return
;=====================================================================================	
ImportChecked:
    i := 0
    col_overwrite := ""
    Loop
    {
        gui, 3:default
        i := LV_GetNext(i, "Checked")
        if (i = 0)
        {
            break
        }
        LV_GetText(col_overwrite,	A_Index, 2)
        LV_GetText(col_1, 			A_Index, 3)
        LV_GetText(col_2, 			A_Index, 4)
        LV_GetText(col_3, 			A_Index, 5)
        Gui, 1:Default
        if (col_overwrite = "YES!") 
        {
            Loop % LV_GetCount()
            {
                LV_GetText(current_col_1, A_Index, 1)
                if (current_col_1 = col_1)
                {
                    LV_Modify(A_Index, , col_1, col_2, col_3)
                    break
                }
            }
            continue
        }
        LV_Add( , col_1, col_2, col_3)		
    }
    gosub, 3GuiClose
    gosub, SaveApply
return
;=====================================================================================	
HideToggle:
    Gui, Submit, NoHide
    if (hide_at_startup) 
    {
        FileAppend, hide, % hide_file
    }
    else
    {
        FileDelete, % hide_file
    }
Return
;=====================================================================================	
; Function to create dual, expandable and collapsable hotstrings
; 	create_dual_hotstring("[sequence]","[propercase]", "[full acronym]")
create_dual_hotstring(dh_activationtext, dh_replacementtext, dh_fulltext) ; Dual Hotstring, dh_
{
    global
    acronym_object.insert( dh_activationtext , { text: dh_replacementtext, fulltext: dh_fulltext } )  
    Hotstring( ":CB0Xo:" . dh_activationtext, Func("acronym_function"), On )
}
;this functions runs when dual hotstrings are activated
acronym_function() {
    global
    ; Evaluate end character. 
    ; note: Chr(27) is Escape, Chr(10) is Enter
    ; msgbox % Ord(A_EndChar)
    if ( A_EndChar = "." || A_EndChar = " " || A_EndChar = "," || A_EndChar = Chr(10) )
    {
        ThisHotKeyParts := StrSplit( A_ThisHotKey, ":" )
        acronym_key := ThisHotkeyParts[3]
        SendBackspace(StrLen(acronym_key))
        ; Below is to count our own input for hotstrings with special commands like {tab} or {return}
        ih := InputHook("V")
        ih.Start()
        ; If A_EndChar is a period or comma, then we will not be expanding further.
        If ( A_EndChar != " " )
        {
            ; [period/comma/enter]
            ; Send the lookup from the acronym_object as well as A_EndChar.
            Send, % acronym_object[acronym_key].text . A_EndChar
            ; Single character input, if escape, we undo.
            Input, 2ndEndChar, L1
            if ( 2ndEndChar = Chr(27) )
            {	
                ; [period/comma/enter][escape]
                SendBackspace(StrLen(acronym_object[acronym_key].text . A_EndChar))
                SendRaw, % substr(A_ThisHotkey, 8) 
                SendElevated(A_EndChar)
                return
            }
            ; [period/comma/enter][{other}]
            ; if 2ndEndChar was not escape, send it.
            ; elevate SendLevel for this final character so it can feedback to this script.		
            SendElevated(2ndEndChar)
            return
        }
        ; If here, A_EndChar must be SPACE, and we have the possibility of expanding to full text and several complex outcomes.
        ; Send replacement text (likely the acronym in all CAPS)
        Send, % acronym_object[acronym_key].text . A_EndChar
        ; Stop counting characters sent.
        ih_count_1 := StrLen(ih.input)
        ih.stop()
        ; Single character input, if escape, we undo.
        Input, 2ndEndChar, L1
        if ( 2ndEndChar = Chr(27) )
        {	
            SendBackspace(ih_count_1)
            SendRaw, % substr(A_ThisHotkey, 8) . A_EndChar
            return
        }
        ; If they've pressed space for a second time, we now expand the hotstring.
        if ( 2ndEndChar = A_Space )
        {	
            ; [space][space]
            if (acronym_object[acronym_key].fulltext = "" )
            {
                return
            }
            SendBackspace(ih_count_1)
            ih := InputHook("V")
            ih.Start()
            Send, % acronym_object[acronym_key].fulltext	
            ih_count_2 := StrLen(ih.input)
            ih.stop()
            ; Now here's where it gets complicated, we want them to be able to escape all the way back to the top.
            ; Check for an escape press
            Input, 3rdEndChar, L1
            if ( 3rdEndChar = Chr(27) )
            {	
                ; [space][space][escape]
                SendBackspace(ih_count_2)
                Send, % acronym_object[acronym_key].text . A_EndChar 
                Input, 4thEndChar, L1
                if ( 4thEndChar = Chr(27) )
                {	
                    ; [space][space][escape][escape]
                    SendBackspace(ih_count_1)
                    ; Initiator can't have special characters or keystrokes, SendRaw
                    SendRaw, % substr(A_ThisHotkey, 8)
                    SendElevated(A_EndChar)
                    return
                }
                ; [space][space][escape][{other}]
                SendElevated(4thEndChar)
                return
            }
            ; [space][space][{other}]
            SendElevated(3rdEndChar)
            return
        }
        else 
        {
            SendElevated(2ndEndChar)
            return
        }
    }
    send, % A_EndChar
}
;=====================================================================================	
; allows script to detect it's own sends as part of a hotstring
SendElevated(char) {
    Hotstring("Reset")
    SendLevel, 1
    Send, % char
    SendLevel, 0
}
;=====================================================================================	
; for readability
SendBackspace(i)
{
    Loop % i
    {
        Send, `b
    }
}



