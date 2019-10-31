@echo off

setlocal

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

if '%errorlevel%' NEQ '0' (

    echo 관리 권한을 요청하는 중...

    goto UACPrompt

) else ( goto gotAdmin )

:UACPrompt

    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"

    set params = %*:"=""

    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"



    rem del "%temp%\getadmin.vbs"

    exit /B



:gotAdmin
echo 클라우드플레어 DoH를 실행합니다.
start cmd /k C:\Users\khske\cloudflared proxy-dns

:HOME
:: str 변수 초기화
set str=
cls
echo.
echo dhcp) DHCP 자동할당 
echo ip) 수동IP설정 (부산고등학교)
echo.
@set /p c=메뉴를 선택하십시오: 

if "%c%"=="dhcp" goto SETDHCP
if "%c%"=="ip" goto SETIP

:SETDHCP
cls
echo.
echo wi-Fi 어댑터 IP설정을 DHCP로 설정합니다.
echo.
netsh interface ip set address "Wi-Fi" dhcp
echo.
echo 설정하였습니다.
echo.
pause
echo.
goto HOME


:SETIP
cls
echo.
echo Wi-Fi 어댑터 IP설정을 수동으로 설정합니다.
echo.
set /p str=IP입력 10.122.106.xxx: 
if "%str%" == "" goto SETIP
echo.
echo 설정IP: 10.122.106.%str% (부산고등학교 학사)
echo.
netsh interface ipv4 set address name="Wi-Fi" source=static address=10.122.106.%str% mask=255.255.255.0 gateway=10.122.106.1 gwmetric=1
echo 설정하였습니다.
echo.
pause
echo.
goto HOME
