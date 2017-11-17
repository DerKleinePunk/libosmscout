### Building with VS 2015 the lib

!Attention no dirs with space are used Able!

the start script is 
build_vs_2015.cmd

bevor you can build you need to install
wget
7z
cmake
must be call able from command line

Don't use the normal commandline you must use the VS Commandline "Open Visual Studio 2015 Tools Command Prompt" !!!

Default is build 32 Bit
set PLATFORM=x64 swich to 64 Bit (not Tested)

First build always failed edit cmakecache.txt and change PROTOBUF_LIBRARY_DEBUG to ... libprotobufd.lib (not libprotobuf.lib)

### Todo
QTDIR via Commandline hardcode in cmd
build dir via Commandline hardcode in cmd
run Tests
remove german text
say myfindprotobuf cmake to use debug lib in debug


https://github.com/DomAmato/Cairo-VS

Build at D:\Mine\OpenSource\libosmscout-own\windows>

build_vs_2015.cmd D:\Mine\OpenSource\libosmscout-own\build

wget
7z
cmake must be call able from command line


Install https://chocolatey.org/
Run Developer Command Prompt for VS2015 as administrator

check 7zip is in Path
check wget is in path
check cmake is in path

check CScript is installed (libxml)

-- 7 zip commandline Tools
choco install 7zip.commandline
-- wget download with http 
cinst -y wget -x86

https://www.nuget.org/api/v2/package/libiconv/1.14.0.11
https://www.nuget.org/api/v2/package/libxml2/2.7.8.7
https://www.nuget.org/api/v2/package/cairo/1.12.18

https://blog.nuget.org/20130426/native-support.html

### Multicore
https://stackoverflow.com/questions/2166425/how-to-structure-a-c-application-to-use-a-multicore-processor
http://www.bogotobogo.com/cplusplus/multithreaded4_cplusplus11.php
https://katyscode.wordpress.com/2013/08/17/c11-multi-core-programming-ppl-parallel-aggregation-explained/