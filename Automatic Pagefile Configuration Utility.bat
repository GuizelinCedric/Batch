@ECHO OFF
MODE CON:COLS=80 LINES=30
COLOR 02
TITLE "Configuration automatique Pagefile"
REM ============================================================================================
REM [        TITLE:
REM [
REM [  DESCRIPTION:
REM [
REM [
REM [
REM [       AUTHOR:
REM [
REM [         DATE:
REM [
REM [      VERSION:
REM [
REM [ DEPENDENCIES:
REM [
REM [        NOTES:
REM [
REM ============================================================================================
: checkPriv
    NET FILE 1>NUL 2>NUL
    IF '%errorlevel%'=='0' ( GOTO gotPriv ) ELSE ( GOTO getPriv )
:getPriv
    IF '%1'=='ELEV' ( SHIFT & GOTO gotPriv )
    SETLOCAL DisableDelayedExpansion
    SET "batchPath=%~0"
    SETLOCAL EnableDelayedExpansion
    ECHO SET UAC = CreateObject^("Shell.Application"^) > "%temp%\OEgetPrivileges.vbs"
    ECHO UAC.ShellExecute "!batchPath!", "ELEV", "", "runas", 1 >> "%temp%\OEgetPrivileges.vbs"
    "%temp%\OEgetPrivileges.vbs"
    EXIT /B
:gotPriv
    SETLOCAL & PUSHD.
    CLS & ECHO.
:main
REM AUTHOR: JDDELLGUY (Spiceworks user)
REM CREDIT TO: CLP USMC (Spiceworks user) - For inspiring me to write a more efficient version of his Pagefile scripts.  The powershell command which actually changes the pagefile is a command from his script with only minor changes from me.
REM PURPOSE: This script will automatically set the pagefile size for the C: drive to exactly twice the size of the RAM in the computer.
REM NOTE: This script must be run as administrator in order for the powershell command which sets the pagefile size to succeed.
color 0b
echo.
echo   ____________________________________________
echo  /\     ______    ______    ______    __  __  \
echo  \ \   /\  __ \  /\  __ \  /\  ___\  /\ \/\ \  \
echo   \ \  \ \ \_\ \ \ \ \_\ \ \ \ \__/  \ \ \ \ \  \
echo    \ \  \ \  _  \ \ \  ___\ \ \ \     \ \ \ \ \  \
echo     \ \  \ \ \/\ \ \ \ \__/  \ \ \____ \ \ \_\ \  \
echo      \ \  \ \_\ \_\ \ \_\     \ \_____\ \ \_____\  \
echo       \ \  \/_/\/_/  \/_/      \/_____/  \/_____/   \
echo        \ \___________________________________________\
echo         \/___________________________________________/
echo.
echo        [A]utomatic [P]agefile [C]onfiguration [U]tility
echo   __________________________________________________________
echo  ^|                                                          ^|
echo  ^| Welcome to the Automatic Pagefile Configuration Utility! ^|
echo  ^| This tool will automatically configure the pagefile size ^|
echo  ^| to twice the amount of RAM in this computer.             ^|
echo  ^|                                                          ^|
echo  ^| If this script is not run as administrator it may fail.  ^|
echo  ^|__________________________________________________________^|
echo.
pause
cls
color f0
REM This line creates a variable named RAM_QUANTITY which holds a value equal to the amount of RAM in the computer per the systeminfo command
for /F "tokens=4" %%A in ('systeminfo ^|findstr /c:"Total Physical Memory:"') do (set RAM_QUANTITY=%%A)
REM This line removes any commas from the RAM_QUANTITY variable so that math can be performed on it
set RAM_QUANTITY=%RAM_QUANTITY:,=%
REM This line creates a variable named PAGEFILE_SIZE which holds a value equal to exactly double that of the RAM_QUANTITY variable
set /a PAGEFILE_SIZE=%RAM_QUANTITY%*2
REM This line creates a variable named FREE_SPACE which holds a value equal to the bytes free on the C: drive
for /f "tokens=3" %%A in ('dir C:\ ^|findstr /c:"bytes free"') do (set FREE_SPACE=%%A)
REM This line removes any commas from the FREE_SPACE variable so that math can be performed on it
set FREE_SPACE=%FREE_SPACE:,=%
REM This line converts the megabytes value of the PAGEFILE_SIZE variable to bytes and stores it as the PAGEFILE_SIZE_BYTES variable for
REM easy comparison with the FREE_SPACE variable.  The conversion is approximate.  It simply appends six 0's onto the end of the value.
REM I would prefer an exact calculated value, but a limitation on the maximum value of valid numbers when using the "set /a" command prevents
REM me from multiplying or dividing numbers of high values (which are likely to be found in modern computers) when using "set /a".
set PAGEFILE_SIZE_BYTES=%PAGEFILE_SIZE%000000
REM The following IF/ELSE lines compare PAGEFILE_SIZE_BYTES to FREE_SPACE.  If FREE_SPACE is greater than PAGEFILE_SIZE_BYTES then the script continues.  Otherwise a warning is displayed instead.
IF %FREE_SPACE% GTR %PAGEFILE_SIZE_BYTES% (
	goto :SET-PAGEFILE-SIZE
) ELSE (
	goto :FREE-SPACE-ERROR
)
:SET-PAGEFILE-SIZE
REM This line runs the actual command to set the pagefile size of the computer and sets the pagefile equal to the value held by the PAGEFILE_SIZE variable
start /wait /b powershell -command "Set-ItemProperty -Path 'registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management' -Name 'PagingFiles' -Value 'c:\pagefile.sys %PAGEFILE_SIZE% %PAGEFILE_SIZE%'"
cls
color 0a
echo          __
echo         / /  Pagefile has been successfully configured
echo        / /   to twice the size of the installed RAM.
echo   __  / /
echo  /\ \/ /     RAM QUANTITY..............%RAM_QUANTITY%000000 Bytes
echo  \ \__/      SPECIFIED PAGEFILE SIZE...%PAGEFILE_SIZE_BYTES% Bytes
echo   \/_/       FREE SPACE................%FREE_SPACE% Bytes
echo.
echo              This script will now close.
echo.
pause
goto :eof
:FREE-SPACE-ERROR
REM The following few lines display an error message which will result if there is not enough free space on C: to set a pagefile size equal to twice the quantity of RAM
cls
color 0c
echo.
echo    __    __  There is insufficient free disk space
echo   /\ \  / /  on the C: drive to create a pagefile
echo   \ \ \/ /   of the specified size.
echo    \ \  /    No changes have been made.
echo     \/  \
echo     / /\ \   RAM QUANTITY..............%RAM_QUANTITY%000000 Bytes
echo    /_/\ \_\  SPECIFIED PAGEFILE SIZE...%PAGEFILE_SIZE_BYTES% Bytes
echo   /_/  \/_/  FREE SPACE................%FREE_SPACE% Bytes
echo.
echo              This script will now abort.
echo.
pause