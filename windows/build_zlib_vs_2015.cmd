@echo off
SETLOCAL ENABLEEXTENSIONS
echo Build zlib with VS2015 on windows

REM https://www.cairographics.org/end_to_end_build_for_win32/

set basedir=%1

if "%basedir%"=="" (
	goto ExitError
)

cd %basedir%

IF NOT EXIST "zlib.tar.gz" (
   echo Downloading ZLIB source
   wget -o build_cmd.log -O zlib.tar.gz http://www.zlib.net/zlib-1.2.11.tar.gz
   IF %ERRORLEVEL% NEQ 0 (
	  echo Error Downloading ZLIB 
	  exit /b %ERRORLEVEL%
   )
)

IF NOT EXIST "zlib" (
   7z x zlib.tar.gz -so | 7z x -aoa -si -ttar -o"zlib"
   IF %ERRORLEVEL% NEQ 0 (
	  echo Error unzip ZLIB 
	  exit /b %ERRORLEVEL%
   )
)

cd zlib
if NOT EXIST "bin" (
   mkdir bin
)

if NOT EXIST "lib" (
   mkdir lib
)

if NOT EXIST "include" (
   mkdir include
)

cd zlib-1.2.11\contrib\masmx86
IF %ERRORLEVEL% NEQ 0 (
  echo Error unzip ZLIB 
  exit /b %ERRORLEVEL%
)
   
ml /coff /Zi /c /safeseh /Flmatch686.lst match686.asm
ml /coff /Zi /c /safeseh /Flinffas32.lst inffas32.asm
cd ..\vstudio
if NOT EXIST "vc14" (
	mkdir vc14
	cd vc11
    xcopy /R /F /Y /E /S *.* ..\vc14
	cd ..\vc14
	devenv.exe /Upgrade zlibvc.sln
	cd ..
)
cd vc14
if NOT EXIST "UpgradeLog.htm" (
   devenv.exe /Upgrade zlibvc.sln 
)

REM Todo .def remove version. find better way
xcopy /F /R /Y %basedir%\..\windows\zlibvc.def .

call msbuild zlibvc.sln /p:Configuration=Release /p:Platform=Win32 /p:PreBuildEventUseInBuild=false
IF %ERRORLEVEL% NEQ 0 (
  echo Error building release zlib
  exit /b %ERRORLEVEL%
)

call msbuild zlibvc.sln /p:Configuration=Debug /p:Platform=Win32 /p:PreBuildEventUseInBuild=false
IF %ERRORLEVEL% NEQ 0 (
  echo Error building debug zlib
  exit /b %ERRORLEVEL%
)

REM rename and move so cmake can find it
copy /b /y x86\ZlibDllRelease\zlibwapi.dll %basedir%\zlib\bin\zlib1.dll
copy /b /y x86\ZlibDllRelease\zlibwapi.pdb %basedir%\zlib\bin\zlib1.pdb
copy /b /y x86\ZlibDllRelease\zlibwapi.lib %basedir%\zlib\lib\zlib.lib
copy /b /y %basedir%\zlib\zlib-1.2.8\zconf.h %basedir%\zlib\include\zconf.h
copy /b /y %basedir%\zlib\zlib-1.2.8\zlib.h %basedir%\zlib\include\zlib.h

goto noerror

:ExitError
echo build Failed
echo Check LIBOSMBASEDIR is set
echo lock at %basedir%\build_cmd.log

:noerror
echo zlib build