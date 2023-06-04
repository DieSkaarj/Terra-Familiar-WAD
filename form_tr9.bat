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
set DOOMDIR="input"
set DOOM2DIR="input"
set "SETDOOMDIR="
set "CleanUp="
echo:
echo ****************************************
echo *                                      *
echo *     TERRA9 TEXTURE CONCATENATOR      *
echo *                                      *
echo *                                      *
echo ****************************************

:DIRMEN
echo:
echo Default path is .\input
echo Set path(s) to iwad(s)? (Leave blank for default.)
echo:
set /p SETDOOMDIR="[S]ingle, [M]ultiple: "
IF /i "%SETDOOMDIR%"=="S" GOTO SETDIRSAME
IF /i "%SETDOOMDIR%"=="s" GOTO SETDIRSAME
IF /i "%SETDOOMDIR%"=="M" GOTO SETDIRDIFF
IF /i "%SETDOOMDIR%"=="m" GOTO SETDIRDIFF
IF /i "%SETDOOMDIR%"=="" GOTO STAGE

:SETDIRSAME
set /p DOOMDIRS=Path to Doom IWads: 
set DOOMDIR="%DOOMDIRS%"
set DOOM2DIR="%DOOMDIRS%"
GOTO STAGE

:SETDIRDIFF
set /p DOOMDIR=Path to DOOM.WAD: 
set /p DOOM2DIR=Path to DOOM2.WAD: 
GOTO STAGE

:STAGE
if exist temp\ rd /s /q temp
mkdir temp
deutex -overwrite -dir temp -doom2 "%DOOM2DIR%" -flats -patches -extract "%DOOM2DIR%\doom2.wad" > NUL
if %errorlevel%==2 GOTO TidyUp
del temp\wadinfo.txt > NUL
deutex -overwrite -dir temp -doom "%DOOMDIR%" -textures -extract "%DOOMDIR%\doom.wad" > NUL
if %errorlevel%==2 GOTO TidyUp
mkdir temp\graphics
copy input\data\textures\terra9.txt temp\textures > NUL
if %errorlevel%==1 GOTO TidyUp
copy input\data\graphics\* temp\graphics > NUL
if %errorlevel%==1 GOTO TidyUp
copy input\data\patches\* temp\patches > NUL
if %errorlevel%==1 GOTO TidyUp

:CREATE
deutex -overwrite -dir temp -doom "%DOOMDIR%" -build input\data\terra9.txt temp\temptex.wad > NUL
deutex -doom "%DOOMDIR%" -join input\data\terra9.wad temp\temptex.wad > NUL
copy input\data\terra9.wad output\ > NUL
copy input\data\terra9.deh output\ > NUL

:CLEANUP
rd /s /q temp
set /p RmInput="Delete Terra9 input directory (Y/N)? "
IF /i "%RmInput%"=="Y" GOTO DESTROY
IF /i "%RmInput%"=="y" GOTO DESTROY
GOTO EXIT_SUCCESS

:DESTROY
rd /s /q input
GOTO EXIT_SUCCESS

:TIDYUP
rd /s /q temp

:EXIT_ERROR
echo User Wad could not be created, error level: %errorlevel%
GOTO EOF

:EXIT_SUCCESS

echo:
echo Success! Terra9 is now complete.
echo Thanks for using this utility, now go have fun!
exit /b

:EOF
