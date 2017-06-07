@echo off
SETLOCAL ENABLEEXTENSIONS
set LIBOSMBASEDIR=%~dp0
set LIBOSMBASEDIR=%LIBOSMBASEDIR:windows\=%
echo %LIBOSMBASEDIR%

set BUILDDIR=%LIBOSMBASEDIR%\build

IF NOT EXIST "%BUILDDIR%" (
   mkdir %BUILDDIR%
)

call build_zlib_vs_2015.cmd %BUILDDIR%
call build_protobuf_vs_2015.cmd %BUILDDIR%

cd %BUILDDIR%

set CMAKE_INCLUDE_PATH=%BUILDDIR%\libiconv\include;%BUILDDIR%\libxml2\include;%BUILDDIR%\protobuf\include;%BUILDDIR%\zlib\include;%BUILDDIR%\cairo-build\include;D:\Tools\Qt\5.8\msvc2015\include
set CMAKE_LIBRARY_PATH=%BUILDDIR%\libxml2\lib;%BUILDDIR%\protobuf\lib;%BUILDDIR%\zlib\lib;%BUILDDIR%\cairo-build\lib;D:\Tools\Qt\5.8\msvc2015\lib
SET CMAKE_PROGRAM_PATH=%BUILDDIR%\protobuf\bin

cmake -G "Visual Studio 14 2015" -DCMAKE_SYSTEM_VERSION=10.0.##### ..
cmake --build .