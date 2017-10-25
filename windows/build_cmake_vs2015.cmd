@echo off
SETLOCAL ENABLEEXTENSIONS
set LIBOSMBASEDIR=%~dp0
set LIBOSMBASEDIR=%LIBOSMBASEDIR:windows\=%
set QTDIR=D:/Tools/Qt/5.9.2/msvc2015
echo %LIBOSMBASEDIR%
echo %QTDIR%

set BUILDDIR=%LIBOSMBASEDIR%\build

IF NOT EXIST "%BUILDDIR%" (
   mkdir %BUILDDIR%
)

IF "%PLATFORM%"=="" (
   set PLATFORM=x32
)

cd %BUILDDIR%

echo enter build dir

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
	IF NOT EXIST "zlib" (
	   7z x zlib-1.2.8-win32-x86.7z -ozlib -y >> build_cmd.log
	)
	IF NOT EXIST "iconv" (
	   7z x iconv-1.14-win32-x86.7z -oiconv -y >> build_cmd.log
	)
	IF NOT EXIST "libxml2" (
       7z x libxml2-2.9.3-win32-x86.7z -olibxml2 -y >> build_cmd.log
	)
    echo ...done
)

call %LIBOSMBASEDIR%windows/build_protobuf_vs_2015.cmd %BUILDDIR%

rem Cmake only Seatch lib PNG when zlib is found !
REM lippng needs two config headers pnglibconf.h and pngconf.h

set CMAKE_INCLUDE_PATH=%BUILDDIR%\iconv\include;%BUILDDIR%\libxml2\include;%BUILDDIR%\protobuf\include;%BUILDDIR%\zlib\include;
set CMAKE_LIBRARY_PATH=%BUILDDIR%\iconv\lib;%BUILDDIR%\libxml2\lib;%BUILDDIR%\protobuf\lib;%BUILDDIR%\zlib\lib;
SET CMAKE_PROGRAM_PATH=%BUILDDIR%\protobuf\bin

if "%PLATFORM%"=="x64" (
	cmake -G "Visual Studio 14 2015 Win64" -DCMAKE_SYSTEM_VERSION=10.0.##### .. -DCMAKE_INSTALL_PREFIX=.\output -DOSMSCOUT_BUILD_DOC_API=OFF -DOSMSCOUT_BUILD_TESTS=ON -DQTDIR=%QTDIR% -DCMAKE_PREFIX_PATH=%QTDIR%/lib/cmake
) else (
	cmake -G "Visual Studio 14 2015" -DCMAKE_SYSTEM_VERSION=10.0.##### .. -DCMAKE_INSTALL_PREFIX=.\output -DOSMSCOUT_BUILD_DOC_API=OFF -DOSMSCOUT_BUILD_TESTS=ON -DQTDIR=%QTDIR% -DCMAKE_PREFIX_PATH=%QTDIR%/lib/cmake
)
cmake --build . --target install --config Debug
cmake --build . --target install --config Release