@echo off
pushd %~dp0
%SystemRoot%\SysWoW64\REG.exe query "HKLM\software\META" /v "META_PATH"
 
SET QUERY_ERRORLEVEL=%ERRORLEVEL%
 
IF %QUERY_ERRORLEVEL% == 0 (
    FOR /F "skip=2 tokens=2,*" %%A IN ('%SystemRoot%\SysWoW64\REG.exe query "HKLM\software\META" /v "META_PATH"') DO SET META_PATH=%%B)
)
IF %QUERY_ERRORLEVEL% == 1 (
    echo on
    echo "META tools not installed." >> _FAILED.txt
    echo "META tools not installed."
	popd
    exit /b %QUERY_ERRORLEVEL%
)

"%META_PATH%\bin\Python27\Scripts\python.exe" -E -m spice_viewer > log\viewer.log

popd