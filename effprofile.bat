@ECHO OFF
MODE CON:COLS=80 LINES=30
COLOR 02
TITLE "Effacement des profils anciens"
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
rem delprof2.exe /r /u
rem pause
%logonserver%\netlogon\scripts\Delprof2.exe /ed:admin* /ed:install* /d:60 /u
pause