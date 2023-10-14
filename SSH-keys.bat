@echo off

title SSH-keygen script 1.0 by HalinalleFin
echo This script will generate SSH keys, and sends them to a linux server (optional)
echo.
echo.

:choice
set /P c=Continue [Y/N]? : 
if /I "%c%" EQU "Y" goto generate
if /I "%c%" EQU "N" exit
goto :choice


:generate
set /P filename="Enter file in which to save the key (id_rsa): " || set filename=id_rsa
set "ssh_dir=%USERPROFILE%\.ssh"
ssh-keygen -f "%ssh_dir%\%filename%" -N ""

:choice2
set /P c=Enable the ssh key in windows [Y/N]? : 
if /I "%c%" EQU "Y" goto enablekey
if /I "%c%" EQU "N" goto ask
goto :choice2

:enablekey
powershell -Command "Get-Service ssh-agent | Set-Service -StartupType Automatic"
powershell Start-Service ssh-agent
powershell Get-Service ssh-agent
ssh-add %ssh_dir%\%filename%
:ask

:choice
echo.
echo.
set /P c=Do you want to upload the keys to a linux server [Y/N]? : 
if /I "%c%" EQU "Y" goto uploadkey
if /I "%c%" EQU "N" exit
goto :choice


:uploadkey
echo.
echo This will upload the key to a remote server using SSH
echo Please enter server Username, IP and Port
echo.
set /P username="Server Username: "
set /P hostname="Server IP: "
set /P port="Server ssh Port: " || set port=22
echo.


echo Send using %username%@%hostname% -p %port%?
:choice2
set /P c=CONFIRM [Y/N]? : 
if /I "%c%" EQU "Y" goto send
if /I "%c%" EQU "N" goto uploadkey
goto :choice2


:send
powershell cat ~/.ssh/%filename%.pub | ssh %username%@%hostname% -p%port% "mkdir -p ~/.ssh && touch ~/.ssh/authorized_keys && chmod -R go= ~/.ssh && cat >> ~/.ssh/authorized_keys"
echo Done!
pause
exit
