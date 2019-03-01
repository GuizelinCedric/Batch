@ECHO OFF
MODE CON:COLS=80 LINES=30
COLOR 02
TITLE "Nettoyage poste"
REM ============================================================================================
REM [        TITRE:
REM [
REM [  DESCRIPTION:
REM [
REM [
REM [
REM [       AUTEUR:
REM [
REM [         DATE:
REM [
REM [      VERSION:
REM [
REM [  DEPENDENCES:
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
Set cmddism=dism
Set cmdreg=reg
if defined PROCESSOR_ARCHITEW6432 Set cmddism=%SystemRoot%\Sysnative\cmd.exe /c Dism
if defined PROCESSOR_ARCHITEW6432 Set cmdreg=%SystemRoot%\sysnative\reg.exe
 
ver | find "10.0" > nul
if %ERRORLEVEL% == 0 goto Windows10
Goto NoWindows10
 
:Windows10
REM Stop Windows Update Service...
net stop "windows update"
REM  Efface Windows Update Cache...
del /q "C:\Windows\SoftwareDistribution\*"
FOR /D %%p IN ("C:\Windows\SoftwareDistribution\*.*") DO rmdir "%%p" /s /q
REM Restart Windows Update Service...
net start  "windows update"
REM Demarrage Service Pack Clean up...
%cmddism% /online /Cleanup-Image /analyzecomponentstore
REM La commande permet de nettoyer les anciennes versions des composants remplacés.
%cmddism% /online /Cleanup-Image /StartComponentCleanup
REM Vous pouvez aussi nettoyer les copies des différents service packs installés sur votre système.
%cmddism% /online /Cleanup-Image /SPSuperseded
REM La commande provoque la réparation du magasin de packages.
%cmddism% /online /Cleanup-Image /RestoreHealth
REM Le commutateur /ResetBase permet de retirer la base des composants obsolètes
%cmddism% /online /Cleanup-Image /StartComponentCleanup /ResetBase

:NoWindows10
del c:\windows\temp\*.* /S /Q
REM Installation cleanmgr si serveur 2008
REM DISM /Online /Enable-Feature /featurename:InkSupport
REM DISM /Online /Enable-Feature:DesktopExperience
REM 
%cmdreg% ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Active Setup Temp Folders" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
%cmdreg% ADD "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\BranchCache"  /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
%cmdreg% ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Content Indexer Cleaner" /v StateFlags0777 /d 2 /t REG_DWORD /f
%cmdreg% ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Compress old files" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
%cmdreg% ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Content Indexer Cleaner" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
%cmdreg% ADD "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\D3D Shader Cache"  /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
%cmdreg% ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Downloaded Program Files" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
%cmdreg% ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\GameStatisticsFiles" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
%cmdreg% ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\GameUpdateFiles" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
%cmdreg% ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Internet Cache Files" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
%cmdreg% ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Memory Dump Files" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
%cmdreg% ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Microsoft_Event_Reporting_2.0_Temp_Files" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
%cmdreg% ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Offline Pages Files" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
%cmdreg% ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Old ChkDsk Files" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
%cmdreg% ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Previous Installations" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
%cmdreg% ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Recycle Bin" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
%cmdreg% ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Remote Desktop Cache Files" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
%cmdreg% ADD "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\RetailDemo Offline Content" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
%cmdreg% ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\ServicePack Cleanup" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
%cmdreg% ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Setup Log Files" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
%cmdreg% ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\System error memory dump files" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
%cmdreg% ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\System error minidump files" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
%cmdreg% ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Temporary Files" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
%cmdreg% ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Temporary Setup Files" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
%cmdreg% ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Temporary Sync Files" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
%cmdreg% ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Thumbnail Cache" /v StateFlags0777 /d 2 /t REG_DWORD /f
%cmdreg% ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Update Cleanup" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
%cmdreg% ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Upgrade Discarded Files" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
%cmdreg% ADD "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\User file versions" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
%cmdreg% ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\WebClient and WebPublisher Cache" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
%cmdreg% ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Defender" /v StateFlags0777 /d 2 /t REG_DWORD /f
%cmdreg% ADD "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Error Reporting Files" /v StateFlags0777 /d 2 /t REG_DWORD /f
%cmdreg% ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Error Reporting Archive Files" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
%cmdreg% ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Error Reporting Queue Files" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
%cmdreg% ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Error Reporting System Archive Files" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
%cmdreg% ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Error Reporting System Queue Files" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
%cmdreg% ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows ESD installation files" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
%cmdreg% ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Upgrade Log Files" /v "StateFlags0777" /t REG_DWORD /d 00000002 /f
REM Creation Tache
SCHTASKS /Create /TN "Nettoyage 70J Profil" /TR cleanmgr.exe" /SAGERUN:777" /SC DAILY /MO 70 /ST 12:00 /RU SYSTEM /F
REM Execution Nettoyage
cleanmgr /sagerun:777