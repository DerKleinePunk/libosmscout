@echo off
SETLOCAL ENABLEEXTENSIONS
set LIBOSMBASEDIR=%~dp0
set LIBOSMBASEDIR=%LIBOSMBASEDIR:windows\=%
set QTDIR=D:/Tools/Qt/5.9.2/msvc2015
echo Attention no dirs with space are used Able !

echo %LIBOSMBASEDIR%
echo %QTDIR%

set BUILDDIR=%LIBOSMBASEDIR%\build

IF NOT EXIST "%BUILDDIR%" (
   mkdir %BUILDDIR%
)

IF "%PLATFORM%"=="" (
   set PLATFORM=x32
)

IF EXIST "marisa" (
   xcopy /R /F /Y /E /S marisa %BUILDDIR%\marisa\
   IF %ERRORLEVEL% NEQ 0 (
      echo Error copy files
      exit /b %ERRORLEVEL%
   )
)

cd %BUILDDIR%

echo enter build dir
echo start build > build_cmd.log

IF %PLATFORM%==x64 (
	wget http://xmlsoft.org/sources/win32/64bit/zlib-1.2.8-win32-x86_64.7z -O zlib-1.2.8-win32-x86_64.7z
	wget http://xmlsoft.org/sources/win32/64bit/iconv-1.14-win32-x86_64.7z -O iconv-1.14-win32-x86_64.7z
	wget http://xmlsoft.org/sources/win32/64bit/libxml2-2.9.3-win32-x86_64.7z -O libxml2-2.9.3-win32-x86_64.7z
	
	echo Unpacking library dependencies...
    7z x zlib-1.2.8-win32-x86_64.7z -ozlib -y >> build_cmd.log
    7z x iconv-1.14-win32-x86_64.7z -oiconv -y >> build_cmd.log
    7z x libxml2-2.9.3-win32-x86_64.7z -olibxml2 -y >> build_cmd.log
    echo ...done
) ELSE (
	IF NOT EXIST "mingwrt-5.2.0-win32-x86.7z" (
		wget http://xmlsoft.org/sources/win32/64bit/mingwrt-5.2.0-win32-x86.7z -O mingwrt-5.2.0-win32-x86.7z
		REM Runtime for the xml lib
	)
    IF NOT EXIST "zlib-1.2.8-win32-x86.7z" (
		wget http://xmlsoft.org/sources/win32/64bit/zlib-1.2.8-win32-x86.7z -O zlib-1.2.8-win32-x86.7z
	)
	IF NOT EXIST "iconv-1.14-win32-x86.7z" (
		wget http://xmlsoft.org/sources/win32/64bit/iconv-1.14-win32-x86.7z -O iconv-1.14-win32-x86.7z
	)
	IF NOT EXIST "libxml2-2.9.3-win32-x86.7z" (
		wget http://xmlsoft.org/sources/win32/64bit/libxml2-2.9.3-win32-x86.7z -O libxml2-2.9.3-win32-x86.7z
	)
	
	echo Unpacking library dependencies...
	
	IF NOT EXIST "mingwrt-5.2.0" (
	   7z x mingwrt-5.2.0-win32-x86.7z -omingwrt-5.2.0 -y >> build_cmd.log
	)
	
	IF NOT EXIST "zlib" (
	   7z x zlib-1.2.8-win32-x86.7z -ozlib -y >> build_cmd.log
	)
	
	IF NOT EXIST ".\zlip\lib\zlib.lib" (
	    REM https://stackoverflow.com/questions/9946322/how-to-generate-an-import-library-lib-file-from-a-dll
		dumpbin /exports .\zlib\bin\zlib1.dll > .\zlib\lib\zlib.txt
		echo dumpbin done
		echo LIBRARY zlib1 > .\zlib\lib\zlib.def
		echo EXPORTS >> .\zlib\lib\zlib.def
		REM for /f "usebackq tokens=4,* delims=_ " %%i in (`dumpbin /exports ".\libxml2\bin\libxml2-2.dll"`) do if %%i==xml echo %%i_%j >> .\libxml2\lib\libxml.def
		REM Todo filter the internal functions out
		for /f "skip=19 tokens=4" %%A in (.\zlib\lib\zlib.txt) do echo %%A >> .\zlib\lib\zlib.def
		lib /def:.\zlib\lib\zlib.def /out:.\zlib\lib\zlib.lib /machine:x86
	)
	
	IF NOT EXIST "iconv" (
	   7z x iconv-1.14-win32-x86.7z -oiconv -y >> build_cmd.log
	)
	
	IF NOT EXIST ".\iconv\lib\libiconv.lib" (
	    REM https://stackoverflow.com/questions/9946322/how-to-generate-an-import-library-lib-file-from-a-dll
		dumpbin /exports .\iconv\bin\libiconv-2.dll > .\iconv\lib\libiconv.txt
		echo LIBRARY libiconv-2 > .\iconv\lib\libiconv.def
		echo EXPORTS >> .\iconv\lib\libiconv.def
		REM for /f "usebackq tokens=4,* delims=_ " %%i in (`dumpbin /exports ".\libxml2\bin\libxml2-2.dll"`) do if %%i==xml echo %%i_%j >> .\libxml2\lib\libxml.def
		REM Todo filter the internal functions out
		for /f "skip=19 tokens=4" %%A in (.\iconv\lib\libiconv.txt) do echo %%A >> .\iconv\lib\libiconv.def
		lib /def:.\iconv\lib\libiconv.def /out:.\iconv\lib\libiconv.lib /machine:x86
	)
	
	IF NOT EXIST "libxml2" (
       7z x libxml2-2.9.3-win32-x86.7z -olibxml2 -y >> build_cmd.log
	)
    echo ...done
	
	IF NOT EXIST ".\libxml2\lib\libxml2.lib" (
	    REM https://stackoverflow.com/questions/9946322/how-to-generate-an-import-library-lib-file-from-a-dll
		dumpbin /exports .\libxml2\bin\libxml2-2.dll > .\libxml2\lib\libxml.txt
		echo LIBRARY libxml2-2 > .\libxml2\lib\libxml.def
		echo EXPORTS >> .\libxml2\lib\libxml.def
		REM for /f "usebackq tokens=4,* delims=_ " %%i in (`dumpbin /exports ".\libxml2\bin\libxml2-2.dll"`) do if %%i==xml echo %%i_%j >> .\libxml2\lib\libxml.def
		REM Todo filter the internal functions out
		for /f "skip=19 tokens=4" %%A in (.\libxml2\lib\libxml.txt) do echo %%A >> .\libxml2\lib\libxml.def
		lib /def:.\libxml2\lib\libxml.def /out:.\libxml2\lib\libxml2.lib /machine:x86
	)
)

title Building protobuf debug
call %LIBOSMBASEDIR%windows/build_protobuf_vs_2015.cmd %BUILDDIR% Debug

echo protobuf build result %ERRORLEVEL%

IF %ERRORLEVEL% NEQ 0 (
  echo Error build protobuf debug
  exit /b %ERRORLEVEL%
)

title Building protobuf release
call %LIBOSMBASEDIR%windows/build_protobuf_vs_2015.cmd %BUILDDIR% Release

echo protobuf build result %ERRORLEVEL%

IF %ERRORLEVEL% NEQ 0 (
  echo Error build protobuf release
  exit /b %ERRORLEVEL%
)

rem Cmake only Seatch lib PNG when zlib is found !
REM lippng needs two config headers pnglibconf.h and pngconf.h
rem find a way for marisa debug lib without an new path
SET MARISA_ROOT=%BUILDDIR%\marisa

set CMAKE_INCLUDE_PATH=%BUILDDIR%\iconv\include;%BUILDDIR%\libxml2\include;%BUILDDIR%\protobuf\include;%BUILDDIR%\zlib\include
set CMAKE_LIBRARY_PATH=%BUILDDIR%\iconv\lib;%BUILDDIR%\libxml2\lib;%BUILDDIR%\protobuf\lib;%BUILDDIR%\zlib\lib;
SET CMAKE_PROGRAM_PATH=%BUILDDIR%\protobuf\bin;%BUILDDIR%\libxml2\bin

if "%PLATFORM%"=="x64" (
    title Building osmscout 64
	cmake -G "Visual Studio 14 2015 Win64" -DCMAKE_SYSTEM_VERSION=10.0.##### .. -DCMAKE_INSTALL_PREFIX=.\output -DOSMSCOUT_BUILD_DOC_API=OFF -DOSMSCOUT_BUILD_TESTS=ON -DQTDIR=%QTDIR% -DCMAKE_PREFIX_PATH=%QTDIR%/lib/cmake >> build_cmd.log
) else (
    title Building osmscout 32
	cmake -G "Visual Studio 14 2015" -DCMAKE_SYSTEM_VERSION=10.0.##### .. -DCMAKE_INSTALL_PREFIX=.\output -DOSMSCOUT_BUILD_DOC_API=OFF -DOSMSCOUT_BUILD_TESTS=ON -DQTDIR=%QTDIR% -DCMAKE_PREFIX_PATH=%QTDIR%/lib/cmake >> build_cmd.log
)
title compiling osmscout debug
cmake --build . --target install --config Debug >> build_cmd.log

IF %ERRORLEVEL% NEQ 0 (
  echo Error build osmscout debug
  title error
  exit /b %ERRORLEVEL%
)

title compiling osmscout release
cmake --build . --target install --config Release >> build_cmd.log

IF %ERRORLEVEL% NEQ 0 (
  echo Error build osmscout release
  title error
  exit /b %ERRORLEVEL%
)

rem Todo
rem mingwrt-5.2.0 to Output
rem copy marisa h to output to Output
rem build map data
rem copy OSMScout2 to Output
rem doku how to start OSMScout2 
rem path to D:\Tools\Qt\5.9.2\msvc2015\bin
rem set OSMSCOUT_LOG=DEBUG
rem ..\build\output\bin\OSMScout2 D:\Mine\OpenSource\libosmscout-own\maps\hessen D:\Mine\OpenSource\libosmscout-own\stylesheets\standard.oss