@ECHO OFF

rem ********************************************************************
rem *                                                                  *
rem * Description A quick batch utility for extracting data from       *
rem * Doom2.wad for use in Doom.wad, to enable Terra9's textures to    *
rem * show up correctly.                                               *
rem *                                                                  *
rem * Author: David A. Cummings                                        *
rem * Contact: davidandrewcummings@hotmail.co.uk                       *
rem *                                                                  *
rem *                                                                  *
rem ********************************************************************

:ENTER
SET DOOMDIR="input"
SET DOOM2DIR="input"
SET "SETDOOMDIR="
SET OUTPUTDIR="output"

IF "%1"=="/o" ( SET OUTPUTDIR="%2" )
IF "%1"=="/h" ( GOTO HELP_ME )
IF "%1"=="/?" ( GOTO HELP_ME )

ECHO:
ECHO ****************************************
ECHO *                                      *
ECHO *        TEXTURE CONCATENATOR          *
ECHO *                                      *
ECHO *                                      *
ECHO ****************************************

:DIRMEN
ECHO:
ECHO Set path(s) to iwad(s)? (Leave blank for default.)
ECHO Default path is .\input
ECHO:
SET /p SETDOOMDIR="[S]ingle, [M]ultiple: "
ECHO:
IF /i "%SETDOOMDIR%"=="S" GOTO SETDIRSAME
IF /i "%SETDOOMDIR%"=="s" GOTO SETDIRSAME
IF /i "%SETDOOMDIR%"=="M" GOTO SETDIRDIFF
IF /i "%SETDOOMDIR%"=="m" GOTO SETDIRDIFF
IF /i "%SETDOOMDIR%"=="" GOTO STAGE

:SETDIRSAME
SET /p DOOMDIRS=Path to Doom IWads: 
SET DOOMDIR="%DOOMDIRS%"
SET DOOM2DIR="%DOOMDIRS%"
GOTO STAGE

:SETDIRDIFF
SET /p DOOMDIR=Path to DOOM.WAD: 
SET /p DOOM2DIR=Path to DOOM2.WAD: 
GOTO STAGE

:STAGE
if exist temp\ rd /s /q temp
mkdir temp
deutex -overwrite -dir temp -doom2 "%DOOM2DIR%" -flats -patches -extract "%DOOM2DIR%\doom2.wad" > NUL
IF %errorlevel%==2 GOTO TidyUp
del temp\wadinfo.txt > NUL
deutex -overwrite -dir temp -doom "%DOOMDIR%" -textures -extract "%DOOMDIR%\doom.wad" > NUL
IF %errorlevel%==2 GOTO TidyUp
mkdir temp\graphics
copy input\data\textures\terra1.txt temp\textures > NUL
IF %errorlevel%==1 GOTO TidyUp
copy input\data\graphics\* temp\graphics > NUL
IF %errorlevel%==1 GOTO TidyUp
copy input\data\patches\* temp\patches > NUL
IF %errorlevel%==1 GOTO TidyUp

:CREATE
deutex -overwrite -dir temp -doom "%DOOMDIR%" -build input\data\terrainfo.txt temp\temp.wad > NUL
deutex -doom "%DOOMDIR%" -join input\data\terra.wad temp\temp.wad > NUL
IF NOT EXIST %OUTPUTDIR% mkdir "%OUTPUTDIR%"
copy input\data\terra.wad %OUTPUTDIR% > NUL
copy input\data\terra.deh %OUTPUTDIR% > NUL

:CLEANUP
rd /s /q temp
ECHO ***WARNING*** This will destroy all data inside the input directory.
SET /p RmInput="Delete data input directory (Y/N)? "
ECHO:
IF /i "%RmInput%"=="Y" GOTO DESTROY
IF /i "%RmInput%"=="y" GOTO DESTROY
GOTO EXIT_SUCCESS

:DESTROY
rd /s /q input
GOTO EXIT_SUCCESS

:TIDYUP
rd /s /q temp

:EXIT_ERROR
ECHO User Wad could not be created, error level: %errorlevel%
EXIT /b

:EXIT_SUCCESS
ECHO:
ECHO Success! Terra Familiar is now complete.
EXIT /b

:HELP_ME
ECHO:
ECHO ****************************************
ECHO *                                      *
ECHO *      Texture Concatenator Help       *
ECHO *                                      *
ECHO *                                      *
ECHO ****************************************
ECHO:
ECHO /o (dir)    -    specify output directory (.\output is default.)
ECHO /h or /?    -    show this message
EXIT /b

:EOF
