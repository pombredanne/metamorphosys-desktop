:: Formal verification using HybridSal
echo off
FOR /F "skip=2 tokens=2,*" %%A IN ('%SystemRoot%\SysWoW64\REG.exe query "HKLM\software\META" /v "META_PATH"') DO "%%B\bin\Python27\Scripts\Python.exe" scripts\CyberComp_runner.py
