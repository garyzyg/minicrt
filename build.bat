PUSHD .
FOR %%I IN (C:\WinDDK\7600.16385.1) DO CALL %%I\bin\setenv.bat %%I fre %Platform% WIN7 no_oacr
POPD

IF %_BUILDARCH%==x86 SET Lib=%Lib%\Crt\i386;%DDK_LIB_DEST%\i386;%Lib%
IF %_BUILDARCH%==AMD64 SET Lib=%Lib%\Crt\amd64;%DDK_LIB_DEST%\amd64;%Lib%

SET Include=%Include%;%CRT_INC_PATH%

PUSHD .

MD omaha
CD omaha
git init
git remote add origin https://github.com/google/omaha.git
git fetch --depth 1 origin 5d4cfe7d3e05aa87f547de869f6728f83f21bc93
git checkout FETCH_HEAD

CD omaha\third_party\minicrt

git apply %~dp0\minicrt-5d4cfe7.diff
ECHO #include "config.h">> libctiny.h
FOR /F "DELIMS=" %%I IN ('CD %~dp0 ^& DIR /B *.h *.c *.cc *.cpp') DO MKLINK %%I %~dp0\%%I

%BUILD_MAKE_PROGRAM% /f %~dp0\Makefile Platform=%Platform%
MOVE *.lib %~dp0

POPD
