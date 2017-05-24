:: OBS: baixar o 7zip.exe e colocar na mesma pasta do .bat
:: Colocar na mesma pasta em que sem encontra o arquivo .fdb que vai ser feito o backup
:: Criar tarefa no windows para executar automaticamente
::Nome da Base sem o .FDB
SET NOME-DA-BASE=ILUXBASE
::Deletar arquivos backups antigos (ex: S/N) ?
SET deletar=S
:: Numero de dias para manter os backups antigos? (ex: 5)
SET dias=5

:::::::::::::::::::::::::::::::::::::

:: Não alterar nada daqui para baixo.
@ECHO OFF
:: hora
set y=%time:~3,2%
set w=%time:~-11,2%
set H=%w%-%y%
:: data
SET dia=%DATE:~0,2%
SET mes=%DATE:~3,2%
SET ano=%DATE:~6,6%
SET data=%dia%-%mes%-%ano%

@TITLE BackUp Base - Firebird - Rodrigo Motta
@MODE CON:COLS=50 LINES=13
@COLOR 1F
setlocal enableextensions
cd /d "%~dp0"
set local=%~dp0
set pasta=%local%Backup
:: sufixo nome do arquivo
set file=-%data%-%H%
:MENU
if EXIST %NOME-DA-BASE%.fdb goto cont
@echo ## %date% %time% ## -  Nome da base errado. - ( %NOME-DA-BASE%.fdb ) >> log_backup.txt
exit

:cont
cls
net stop FirebirdGuardianDefaultInstance
net stop FirebirdServerDefaultInstance
taskkill /f /im Synchronizer.exe
taskkill /f /im fb_inet_server.exe
ping 127.0.0.1 -n 5
ren %NOME-DA-BASE%.fdb %NOME-DA-BASE%_.fdb
:compactar
:COMPS
cls
copy %NOME-DA-BASE%_.fdb %NOME-DA-BASE%_Backup.fdb /y
ren %NOME-DA-BASE%_.fdb %NOME-DA-BASE%.fdb
net start FirebirdGuardianDefaultInstance
net start FirebirdServerDefaultInstance
cls
7za a -t7z %pasta%\%NOME-DA-BASE%_Backup%file%.7z %NOME-DA-BASE%_Backup.fdb
del %NOME-DA-BASE%_Backup.fdb /q
:FIM
@echo ## %date% %time% ## -  Backup efetuado com sucesso. - ( %NOME-DA-BASE%_Backup%file%.7z ) >> log_backup.txt
::exit
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
IF %deletar% EQU S goto delete
IF %deletar% EQU s goto delete
exit
:delete
FOR /F "TOKENS=1* DELIMS=/" %%A IN ('date/t') DO SET nowDay=%%A
FORFILES /S /p %pasta% /d -%dias% /C "CMD /C echo @FILE @FDATE" >> %pasta%\%nowDay%.log
FORFILES /S /p %pasta% /d -%dias% /c "CMD /C DEL @FILE /Q"
exit

