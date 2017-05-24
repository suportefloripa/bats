@echo off
color 27
setlocal enabledelayedexpansion
title Mostrando PING
set /p IP=IP ou Nome do PC: 
set log=%IP%.txt
set delay=0
if exist %log% del /q %log%
:loop
set pingline=1
for /f "tokens=1-26 delims=" %%A in ('ping -n 1 %IP%') do (
	if !pingline! equ 2 (
		set logline=!date! !time! "%%A"
		set logview=%%A
		echo !logline! >> %log%
		echo !logview!
		)
	set /a pingline+=1
	)
ping -n %delay% localhost >nul
goto loop