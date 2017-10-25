@echo off
SETLOCAL ENABLEEXTENSIONS
echo Build protbuf with VS2015 on windows

set basedir=%1

if "%basedir%"=="" (
	goto ExitError
)

cd %basedir%

IF NOT EXIST "protobuf-cpp-3.4.1.tar.gz" (
	wget https://github.com/google/protobuf/releases/download/v3.4.1/protobuf-cpp-3.4.1.tar.gz -O protobuf-cpp-3.4.1.tar.gz >> build_cmd.log
	IF %ERRORLEVEL% NEQ 0 (
	  echo Error extract zlib
	  exit /b %ERRORLEVEL%
	)
	7z x protobuf-cpp-3.4.1.tar.gz -so | 7z x -aoa -si -ttar -o"protobuf-cpp"
	rem 7z x protobuf-cpp-3.1.0.tar.gz -oprotobuf-cpp -y >> build_cmd.log
	
	cd protobuf-cpp
	cd protobuf-3.4.1
	echo copy files to root build dir
	
	xcopy /R /F /Y /E /S *.* ..
	
	cd ..
	rmdir /S /Q protobuf-3.4.1
	
	REM in release this allready included
	REM git clone -b release-1.7.0 https://github.com/google/googlemock.git gmock
	REM cd gmock
	REM git clone -b release-1.7.0 https://github.com/google/googletest.git gtest
	
	cd cmake
	mkdir build 
	cd build
	mkdir release
	cd release
	
	cd %basedir%
)

cd protobuf-cpp\cmake\build

echo build protobuf release

if "%PLATFORM%"=="x64" (
	cmake -G "Visual Studio 14 2015 Win64" -DCMAKE_INSTALL_PREFIX=../../../protobuf .. 
) else (
	cmake -G "Visual Studio 14 2015" -DCMAKE_INSTALL_PREFIX=../../../protobuf ..
)

echo cmake result %ERRORLEVEL%

IF %ERRORLEVEL% NEQ 0 (
  echo Error cmake build files protobuf
  exit /b %ERRORLEVEL%
)

echo compiling release
cmake --build . --target install --config Release >> ../../../build_cmd.log

IF %ERRORLEVEL% NEQ 0 (
  echo Error cmake compiling protobuf
  exit /b %ERRORLEVEL%
)

echo compiling debug
cmake --build . --target install --config Debug >> ../../../build_cmd.log

IF %ERRORLEVEL% NEQ 0 (
  echo Error cmake compiling protobuf
  exit /b %ERRORLEVEL%
)

:ExitError
echo build Failed
echo Check LIBOSMBASEDIR is set
echo lock at %basedir%\build_cmd.log