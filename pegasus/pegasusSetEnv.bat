
REM SET MSVC variables
call "C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC\Auxiliary\Build\vcvars32.bat"
REM call "C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC\Auxiliary\Build\vcvars64.bat"

REM Set debug to something if you want to compile in debug mode 
REM set PEGASUS_DEBUG=true
REM set PEGASUS_ROOT to top of source tree 
set PEGASUS_ROOT=C:\repos\OpenPegasus\pegasus

REM (Note: The '/' characters are intentional and required by the OpenPegasus build system). 
REM     Also the disk designator (C:) is required for at least some newer versions of the Microsoft
REM     compilers to avoid confusion between options and paths
REM set PEGASUS_HOME to where you want repository and executables, it can be the same as PEGASUS_ROOT
set PEGASUS_HOME=C:\repos\OpenPegasus\work

REM set PEGASUS_PLATFORM=WIN64_X86_64_MSVC
set PEGASUS_PLATFORM=WIN32_IX86_MSVC

REM set SSL
set PEGASUS_HAS_SSL=1

REM set OPENSSL_HOME=C:\OpenSSL
set OPENSSL_HOME=C:\OpenSSL102

REM set OPENSSL_VERSION_NUMBER=0x10100000L
set OPENSSL_VERSION_NUMBER=0x10000000L

set PEGASUS_ENABLE_SLP=false
rem set OPENSSL_HOME=C:\work5\smis\OpenPegasus\OpenSSL-Win64

rem set INCLUDE=C:\OpenSSL\include;%INCLUDE%
set INCLUDE=C:\OpenSSL102\include;%INCLUDE%

rem set LIB=%OPENSSL_HOME%\lib;%LIB%
rem set LIBPATH=%OPENSSL_HOME%\lib;%LIB%

set path=%path%;%PEGASUS_HOME%\bin;%OPENSSL_HOME%\bin