@echo off
SETLOCAL ENABLEEXTENSIONS
echo Build protbuf with VS2015 on windows

set basedir=%1
set config=%2

if "%basedir%"=="" (
   goto ExitError
)

if "%config%"=="" (
   echo config not set
   goto ExitError
)

cd %basedir%

IF NOT EXIST "protobuf-cpp-3.2.0.tar.gz" (
	wget https://github.com/google/protobuf/releases/download/v3.2.0/protobuf-cpp-3.2.0.tar.gz -O protobuf-cpp-3.2.0.tar.gz >> build_cmd.log
	IF %ERRORLEVEL% NEQ 0 (
	  echo Error extract zlib
	  exit /b %ERRORLEVEL%
	)
)

IF NOT EXIST "protobuf-cpp" (
  7z x protobuf-cpp-3.2.0.tar.gz -so | 7z x -aoa -si -ttar -o"protobuf-cpp"
  
  cd protobuf-cpp
  cd protobuf-3.2.0
  echo copy files to root build dir

  xcopy /R /F /Y /E /S *.* ..

  cd ..
  rmdir /S /Q protobuf-3.2.0
  
  cd cmake
  mkdir build 
)

cd %basedir%

cd protobuf-cpp\cmake\build

echo build protobuf
rem google say static build is better but libosmscout do not support it at the moment
if "%PLATFORM%"=="x64" (
	cmake -G "Visual Studio 14 2015 Win64" -DCMAKE_INSTALL_PREFIX=../../../protobuf -Dprotobuf_MSVC_STATIC_RUNTIME=OFF .. >> ../../../build_cmd.log
) else (
	cmake -G "Visual Studio 14 2015" -DCMAKE_INSTALL_PREFIX=../../../protobuf -Dprotobuf_MSVC_STATIC_RUNTIME=OFF .. >> ../../../build_cmd.log
)

echo cmake result %ERRORLEVEL%

IF %ERRORLEVEL% NEQ 0 (
  echo Error cmake build files protobuf
  exit /b %ERRORLEVEL%
)

if "%config%" == "Release" (
  echo compiling release
  cmake --build . --target install --config Release >> ../../../build_cmd.log
)

IF %ERRORLEVEL% NEQ 0 (
  echo Error cmake compiling protobuf
  exit /b %ERRORLEVEL%
)

if "%config%" == "Debug" (
  echo compiling debug
  cmake --build . --target install --config Debug >> ../../../build_cmd.log
)

IF %ERRORLEVEL% NEQ 0 (
  echo Error cmake compiling protobuf
  exit /b %ERRORLEVEL%
)

exit /b %ERRORLEVEL%
 
:ExitError
echo build Failed
echo Check LIBOSMBASEDIR is set
echo lock at %basedir%\build_cmd.log