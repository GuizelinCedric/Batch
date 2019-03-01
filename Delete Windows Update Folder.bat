@echo off
CD C:\
taskkill /F /im setup.exe
taskkill /F /im ose00000.exe
taskkill /F /im msiexec.exe

net stop wuauserv

PowerShell.exe Remove-Item C:\Windows\SoftwareDistribution\* -Force -Recurse

net start wuauserv