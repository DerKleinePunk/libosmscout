### Building with VS 2015 the lib

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
