@echo off
CD C:\
taskkill /F /im setup.exe
taskkill /F /im ose00000.exe
taskkill /F /im msiexec.exe
net stop wuauserv
PowerShell.exe Remove-Item C:\Windows\SoftwareDistribution\* -Force -Recurse
net start wuauservcd C:\windows\system32
for /f %%s in ('dir /b *.dll') do regsvr32 /s %%s, C:\Windows\system32
Dism /Online /Cleanup-Image /StartComponentCleanup > %USERPROFILE%\Desktop\componentcleanup.txt
Dism /online /Cleanup-Image /StartComponentCleanup /ResetBase
Dism /online /Cleanup-Image /SPSuperseded
if exist "%USERPROFILE%\Desktop\install.wim" (goto :opt1) ELSE (goto :opt2)
:opt1
echo off
echo A windows image file (wim) has been detected on your desktop.  Input the wim index number which is associated with currently running operating system.
set /p userinp= ^> Enter Your Option:
echo on
dism /Online /Cleanup-Image /restorehealth /source:wim:%USERPROFILE%\Desktop\install.wim:%userinp% > %USERPROFILE%\Desktop\restorehealth.txt
goto :rest
:opt2
dism /Online /Cleanup-Image /restorehealth > %USERPROFILE%\Desktop\restorehealth.txt
goto :rest
:rest
sfc /scannow > %USERPROFILE%\Desktop\sfc.txt
chkdsk C: > %USERPROFILE%\Desktop\chkdsk.txt