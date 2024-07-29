@echo OFF

setlocal ENABLEEXTENSIONS
setlocal ENABLEDELAYEDEXPANSION
set KEY_NAME="HKEY_CURRENT_USER\SOFTWARE\Space Wizards\Robust"
set VALUE_NAME=Hwid
set HASHFILE="%TMP%\hash.txt"

FOR /F "usebackq skip=2 tokens=1-3" %%A IN (`REG QUERY %KEY_NAME% /v %VALUE_NAME% 2^>nul`) DO (
    set ValueName=%%A
    set ValueType=%%B
    set OLDHWID=%%C
)

if not defined ValueName (
	echo %KEY_NAME%\%VALUE_NAME% not found.
	goto :EOF:

)

echo Current HWID: %OLDHWID%
set RNG=%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%

@echo|set /p="OLDHWID" > %HASHFILE%
set count=1
FOR /F "usebackq skip=1 tokens=1" %%A IN (`certutil -hashfile %HASHFILE% SHA256 2^>nul`) DO (
  SET hash!count!=%%A
  SET /a count=!count!+1
)
del %HASHFILE%

REG ADD %KEY_NAME% /f /v %VALUE_NAME% /t REG_BINARY /d %hash1%
echo New HWID: %hash1%

