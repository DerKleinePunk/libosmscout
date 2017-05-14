@echo off
SETLOCAL ENABLEEXTENSIONS
echo Build cairo with VS2015 on windows

REM https://sites.google.com/site/slinavlee/

set basedir=%1

if "%basedir%"=="" (
	goto ExitError
)

cd %basedir%

IF NOT EXIST "cairo.tar.xz" (
   echo Downloading cairo source
   wget -o build_cmd.log -O cairo.tar.xz http://cairographics.org/releases/cairo-1.14.8.tar.xz
   IF %ERRORLEVEL% NEQ 0 (
	  echo Error Downloading cairo 
	  exit /b %ERRORLEVEL%
   )
)

IF NOT EXIST "pixman.tar.gz" (
   echo Downloading pixman source
   wget -o build_cmd.log -O pixman.tar.gz http://cairographics.org/releases/pixman-0.34.0.tar.gz
   IF %ERRORLEVEL% NEQ 0 (
	  echo Error Downloading pixman 
	  exit /b %ERRORLEVEL%
   )
)

IF NOT EXIST "libpng.tar.xz" (
   echo Downloading libpng source
   wget -o build_cmd.log -O libpng.tar.xz ftp://ftp.simplesystems.org/pub/libpng/png/src/libpng16/libpng-1.6.29.tar.xz
   IF %ERRORLEVEL% NEQ 0 (
	  echo Error Downloading libpng 
	  exit /b %ERRORLEVEL%
   )
)


IF NOT EXIST "cairo" (
   7z x cairo.tar.xz -so | 7z x -aoa -si -ttar -o"cairo"
   IF %ERRORLEVEL% NEQ 0 (
	  echo Error unzip cairo 
	  exit /b %ERRORLEVEL%
   )
)

IF NOT EXIST "pixman" (
   7z x pixman.tar.gz -so | 7z x -aoa -si -ttar -o"pixman"
   IF %ERRORLEVEL% NEQ 0 (
	  echo Error unzip pixman 
	  exit /b %ERRORLEVEL%
   )
)

IF NOT EXIST "libpng" (
   7z x libpng.tar.xz -so | 7z x -aoa -si -ttar -o"libpng"
   IF %ERRORLEVEL% NEQ 0 (
	  echo Error unzip libpng 
	  exit /b %ERRORLEVEL%
   )
)

cd pixman
IF EXIST "pixman-0.34.0" (
	cd pixman-0.34.0
	xcopy /R /F /Y /E /S *.* ..
	cd ..
	rmdir /S /Q pixman-0.34.0
)
cd ..

cd libpng
IF EXIST "libpng-1.6.29" (
	cd libpng-1.6.29
	xcopy /R /F /Y /E /S *.* ..
	cd ..
	rmdir /S /Q libpng-1.6.29
)
cd projects\vstudio
if NOT EXIST "UpgradeLog.htm" (
   devenv.exe /Upgrade vstudio.sln 
)
call msbuild vstudio.sln /p:Configuration=Release /p:Platform=Win32
cd ..\..
cd ..

cd cairo
IF EXIST "cairo-1.14.8" (
	cd cairo-1.14.8
	xcopy /R /F /Y /E /S *.* ..
	cd ..
	rmdir /S /Q cairo-1.14.8
)

IF NOT EXIST "msvc" (
	mkdir msvc
)

xcopy /F /R /Y %basedir%\..\windows\cairo-1.4.10-msvc\libcairo.sln .\msvc
IF %ERRORLEVEL% NEQ 0 (
  echo Error unzip ZLIB 
  exit /b %ERRORLEVEL%
)
 
xcopy /F /R /Y %basedir%\..\windows\cairo-1.4.10-msvc\cairo.rc .\msvc
IF %ERRORLEVEL% NEQ 0 (
  echo Error unzip ZLIB 
  exit /b %ERRORLEVEL%
)

xcopy /F /R /Y %basedir%\..\windows\cairo-1.4.10-msvc\libcairo.vcxproj .\msvc
IF %ERRORLEVEL% NEQ 0 (
  echo Error unzip ZLIB 
  exit /b %ERRORLEVEL%
)
xcopy /F /R /Y %basedir%\..\windows\cairo-1.4.10-msvc\resource.h .\msvc
IF %ERRORLEVEL% NEQ 0 (
  echo Error unzip ZLIB 
  exit /b %ERRORLEVEL%
)
xcopy /F /R /Y %basedir%\..\windows\cairo-1.4.10-msvc\cairo-features.h .\src\

goto noerror

:ExitError
echo build Failed
echo Check LIBOSMBASEDIR is set
echo lock at %basedir%\build_cmd.log

:noerror
echo cairo build done