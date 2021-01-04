CodeVersion := "2021.01.04 094456", company := "MIT License"
;@Ahk2Exe-Let version = %A_PriorLine~U)^(.+"){1}(.+)".*$~$2%
;@Ahk2Exe-Let company = %A_PriorLine~U)^(.+"){3}(.+)".*$~$2%
;@Ahk2Exe-SetDescription Acronym software.
;@Ahk2Exe-SetVersion %U_version%
;@Ahk2Exe-SetCopyright Copyright (c) 2020`, Dom Pannone
;@Ahk2Exe-SetOrigFilename Alaskronym.ahk
;@Ahk2Exe-SetCompanyName %U_company%
