@echo off
for /F "tokens=2 delims=	 " %%a in (%1) do if %%a == Complete echo %1 > AltQuickTemp.Csv & goto :_File
for /F "tokens=1-12 delims=	 " %%a in (%1) do if %%f == Confirmed @call :File %%a %%b %%c %%d %%e %%f %%g %%h %%i %%j %%k %%m
for /F "tokens=1-14 delims=	 " %%a in (%1) do (
if %%b == buy @call :File %%a %%b %%c %%d %%e %%f %%g %%h %%i %%j %%k %%l %%m
if %%b == sell @call :File %%a %%b %%c %%d %%e %%f %%g %%h %%i %%j %%k %%l %%m
)
for /F "tokens=2,6 delims=	 " %%a in (AltQuickTemp.Csv) do (
if %%a == buy goto :TradeHistory
if %%a == sell goto :TradeHistory
if %%b == Confirmed goto :Deposits
)

goto :eof
::--------------------------------------------------------------------
:File
setlocal
set data=%*
echo %data:	=,% >> AltQuickTemp.Csv
endlocal
goto :eof
::--------------------------------------------------------------------
:_File
Setlocal EnableDelayedExpansion
set File=AltQuickTemp.Csv
for /F "tokens=6 delims=\" %%a in (%File%) do set _File=%%a

set count=0
for /f "tokens=* delims=" %%a in (%_File%) do (
  set /a "count=!count!+1"
 if [!count!] == [1] set outcheck=%%a
 if [!count!] == [2] set outcheck2=%%a
 if [!count!] == [3] set outcheck3=%%a
 if [!count!] == [3] echo !outcheck! !outcheck2! !outcheck3! > AltQuickTemp.txt 
)
:loop
set File=AltQuickTemp.Csv
for /F "tokens=6 delims=\" %%a in (%File%) do set _File=%%a
set "cmd=findstr /R /N "^^" %_file% | find /C ":""
for /f %%a in ('!cmd!') do set lines=%%a
set "cmd=findstr /R /N "^^" AltQuickTemp.Txt | find /C ":""
for /f %%a in ('!cmd!') do set _lines=%%a
if %_lines% == 1 set /a skip=3
if %_lines% geq 2 set /A skip=%skip%+3

set count=0
FOR /F "tokens=* skip=%skip%" %%a IN (%_file%) do (
  set /a "count=!count!+1"
 if [!count!] == [1] set outcheck=%%a
 if [!count!] == [2] set outcheck2=%%a
 if [!count!] == [3] set outcheck3=%%a
 if [!count!] == [3] echo !outcheck! !outcheck2! !outcheck3! >> AltQuickTemp.Txt
 if [!count!] == [3] goto :loop
)
goto :withdrawals
::--------------------------------------------------------------------
:TradeHistory
Setlocal EnableDelayedExpansion
set File=AltQuickTemp.Csv
echo Date,Sent Amount,Sent Currency,Received Amount,Received Currency,Fee Amount,Fee Currency,Net Worth Amount,Net Worth Currency,Label,Description,TxHash > AltQuickTradeHistory.Csv
Set BTC=BTC
FOR /F "delims=" %%L in (%File%) DO (
	set "line=%%L,,,,,,,,"
	set "line=#!line:,=, !"
	for /F "tokens=1-8,10-13 delims=, " %%a in ("!line!") DO (
	set "_A=%%a"
	if %%b == buy (set "_E=%%f")
	if %%b == sell (set "_E=%%e")
	if %%b == buy (set "_C=BTC")
	if %%b == sell (set "_C=%%c")
	if %%b == buy (set "_D=%%e")
	if %%b == sell (set "_D=%%d")
	if %%b == buy (set "_F=%%e")
	if %%b == sell (set "_F=%%f")
	if %%b == buy (set "_G=%%g")
	if %%b == sell (set "_G=%%g")
	if %%b == buy (set "_H=%%h")
	if %%b == sell (set "_H=%%h")
	if %%b == buy (set "BTC=%%c")
	set "_I=%%i"
	if %%j == Jan (set "_J=01")
	if %%j == Feb (set "_J=02")
	if %%j == Mar (set "_J=03")
	if %%j == Apr (set "_J=04")
	if %%j == May (set "_J=05")
	if %%j == Jun (set "_J=06")
	if %%j == Jul (set "_J=07")
	if %%j == Aug (set "_J=08")
	if %%j == Sep (set "_J=09")
	if %%j == Oct (set "_J=10")
	if %%j == Nov (set "_J=11")
	if %%j == Dec (set "_J=12")
	set "_K=%%k"
	set "_L=%%l"
	echo !_K!-!_J!-!_I! !_L!,!_E!,!_C!,!_F!,!BTC!,!_G!,!_H!,,,,,!_A! >> AltQuickTradeHistory.Csv
))
del AltQuickTemp.Csv
exit /b
::--------------------------------------------------------------------
:Deposits
Setlocal EnableDelayedExpansion
Set File=AltQuickTemp.Csv
echo Date,Sent Amount,Sent Currency,Received Amount,Received Currency,Fee Amount,Fee Currency,Net Worth Amount,Net Worth Currency,Label,Description,TxHash > AltquickDeposits.Csv
FOR /F "Tokens=1,2,3,4,5,8,9,10,11 delims=, " %%a in (%File%) DO (
	set "_A=%%a,"
	if %%a == 42 (set "_A=%%a,")
	if %%a == BTC-Bech32 (set "_A=%%a,")
	if %%a == BTC-Legacy (set "_A=%%a,")
	if %%a == AVAX (set "_A=%%a,")
	if %%a == BCH (set "_A=%%a,")
	if %%a == TBTC (set "_A=%%a,")
	if %%a == CLAM (set "_A=%%a,")
	if %%a == CURE (set "_A=%%a,")
	if %%a == DASH (set "_A=%%a,")
	if %%a == DGB (set "_A=%%a,")
	if %%a == DOGE (set "_A=%%a,")
	if %%a == ETH (set "_A=%%a,")	
	if %%a == FLO (set "_A=%%a,")
	if %%a == FBTC (set "_A=%%a,")
	if %%a == FREE (set "_A=%%a,")
	if %%a == GAP (set "_A=%%a,")
	if %%a == LTC (set "_A=%%a,")
	if %%a == MAZA (set "_A=%%a,")
	if %%a == XMR (set "_A=%%a,")
	if %%a == NMC (set "_A=%%a,")
	if %%a == PART (set "_A=%%a,")
	if %%a == QTUM (set "_A=%%a,")
	if %%a == RHOM (set "_A=%%a,")
	if %%a == WOW (set "_A=%%a,")
	if %%a == ZEC (set "_A=%%a,")
	set "_C=%%c"
	set "_D=%%d,"
	if %%d == 0.00000000 (set "_D=,")
	if %%d == 0.00000000 (set "_B=,")
	if %%d == 0.00000000 (set "_B=,")
	set "_E=%%e"
	set "_F=%%f"
	set "_G=%%g"
	if %%g == Jan (set "_G=01")
	if %%g == Feb (set "_G=02")
	if %%g == Mar (set "_G=03")
	if %%g == Apr (set "_G=04")
	if %%g == May (set "_G=05")
	if %%g == Jun (set "_G=06")
	if %%g == Jul (set "_G=07")
	if %%g == Aug (set "_G=08")
	if %%g == Sep (set "_G=09")
	if %%g == Oct (set "_G=10")
	if %%g == Nov (set "_G=11")
	if %%g == Dec (set "_G=12")
	set "_H=%%h"
	set "_I=%%i"

	echo !_H!-!_G!-!_F! !_I!,!_D!!_B!!_C!,!_A!,!_B!,,,,!_E! >> AltQuickDeposits.Csv
)
del AltQuickTemp.Csv
exit /b
::--------------------------------------------------------------------
:Withdrawals
Setlocal EnableDelayedExpansion
Set File=AltQuickTemp.Txt
echo Date,Sent Amount,Sent Currency,Received Amount,Received Currency,Fee Amount,Fee Currency,Net Worth Amount,Net Worth Currency,Label,Description,TxHash > AltquickWithdrawals.Csv
FOR /F "Tokens=1,2,3,4,5,8,9,10,11,12 delims=	 " %%a in (%File%) DO (
	set "_A=%%a,"
	set "_B=%%b"
	set "_C=%%c"
	set "_D=%%d"
	set "_E=%%e"
	set "_F=%%f"
	set "_G=%%g"
	set "_H=%%h"
	if %%h == Jan (set "_H=01")
	if %%h == Feb (set "_H=02")
	if %%h == Mar (set "_H=03")
	if %%h == Apr (set "_H=04")
	if %%h == May (set "_H=05")
	if %%h == Jun (set "_H=06")
	if %%h == Jul (set "_H=07")
	if %%h == Aug (set "_H=08")
	if %%h == Sep (set "_H=09")
	if %%h == Oct (set "_H=10")
	if %%h == Nov (set "_H=11")
	if %%h == Dec (set "_H=12")
	set "_I=%%i"
	set "_J=%%j"

	echo !_I!-!_H!-!_G! !_J!,!_C!,!_A!,,!_D!,!_A!,,,,!_B! >> AltQuickWithdrawals.Csv
)
del AltQuickTemp.Txt
goto :eof
:----------------------------------------------------------------------------------