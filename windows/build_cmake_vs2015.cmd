@echo off
SETLOCAL ENABLEEXTENSIONS
set LIBOSMBASEDIR=%~dp0
set LIBOSMBASEDIR=%LIBOSMBASEDIR:windows\=%
echo %LIBOSMBASEDIR%

set BUILDDIR=%LIBOSMBASEDIR%\build

IF NOT EXIST "%BUILDDIR%" (
   mkdir %BUILDDIR%
)

rem call build_zlib_vs_2015.cmd %BUILDDIR%
wget http://xmlsoft.org/sources/win32/64bit/zlib-1.2.8-win32-x86_64.7z -O zlib-1.2.8-win32-x86.7z
wget http://xmlsoft.org/sources/win32/64bit/iconv-1.14-win32-x86_64.7z -O iconv-1.14-win32-x86.7z
7z x iconv-1.14-win32-x86.7z -oiconv -y
wget http://xmlsoft.org/sources/win32/64bit/libxml2-2.9.3-win32-x86_64.7z -O libxml2-2.9.3-win32-x86.7z

call build_protobuf_vs_2015.cmd %BUILDDIR%

cd %BUILDDIR%

rem Cmake only Seatch lib PNG when zlib is found !
REM lippng needs two config headers pnglibconf.h and pngconf.h

set CMAKE_INCLUDE_PATH=%BUILDDIR%\iconv\include;%BUILDDIR%\libxml2\include;%BUILDDIR%\protobuf\include;%BUILDDIR%\zlib\include;%BUILDDIR%\cairo-build\include;D:\Tools\Qt\5.8\msvc2015\include
set CMAKE_LIBRARY_PATH=%BUILDDIR%\iconv\lib;%BUILDDIR%\libxml2\lib;%BUILDDIR%\protobuf\lib;%BUILDDIR%\zlib\lib;%BUILDDIR%\cairo-build\lib;D:\Tools\Qt\5.8\msvc2015\lib
SET CMAKE_PROGRAM_PATH=%BUILDDIR%\protobuf\bin
SET CMAKE_PREFIX_PATH=D:\Tools\Qt\5.8\msvc2015

cmake -G "Visual Studio 14 2015" -DCMAKE_SYSTEM_VERSION=10.0.##### .. -DCMAKE_INSTALL_PREFIX=.\output -DOSMSCOUT_BUILD_IMPORT=OFF -DOSMSCOUT_BUILD_DOC_API=OFF -DOSMSCOUT_BUILD_TESTS=ON -DCAIRO_INCLUDE_DIR=%BUILDDIR%\cairo-build\include -DCAIRO_LIBRARY=%BUILDDIR%\cairo-build\lib
cmake --build . --target install