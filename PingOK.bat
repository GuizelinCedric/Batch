@ECHO OFF
MODE CON:COLS=80 LINES=30
COLOR 02
TITLE "Autoriser PING et Administration a distance"
REM ============================================================================================
REM [        TITRE: Autoriser PING et Administration a distance
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
REM ### Configuration du firewall pour activer la réponse au ping et la réponse aux requêtes NetBIOS
netsh advfirewall firewall add rule name="_ICMPv4" protocol=icmpv4:any,any dir=in action=allow
netsh advfirewall firewall add rule name="_NetBIOS UDP Port 137" dir=in action=allow protocol=UDP localport=137
netsh advfirewall firewall add rule name="_NetBIOS UDP Port 137" dir=out action=allow protocol=UDP localport=137
netsh advfirewall firewall add rule name="_NetBIOS UDP Port 138" dir=in action=allow protocol=UDP localport=138
netsh advfirewall firewall add rule name="_NetBIOS UDP Port 138" dir=out action=allow protocol=UDP localport=138
netsh advfirewall firewall add rule name="_NetBIOS TCP Port 139" dir=in action=allow protocol=TCP localport=139
netsh advfirewall firewall add rule name="_NetBIOS TCP Port 139" dir=out action=allow protocol=TCP localport=139
netsh advfirewall firewall add rule name="_NetBIOS TCP Port 445" dir=in action=allow protocol=TCP localport=445
netsh advfirewall firewall add rule name="_RPC" dir=in action=allow protocol=TCP localport=RPC

REM ### Activation de l'administration à distance
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v AllowRemoteRPC /t reg_dword /d 1 /f

REM ### Désactivation de l'UAC pour les appels distants
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v LocalAccountTokenFilterPolicy /t reg_dword /d 1 /f

REM ### Autoriser les connexions à distance à une machine Windows
REG ADD "HKLM\System\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f