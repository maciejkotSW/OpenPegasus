
REM SET MSVC variables
call "C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC\Auxiliary\Build\vcvars64.bat"
REM call "C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC\Auxiliary\Build\vcvars64.bat"

REM Set debug to something if you want to compile in debug mode 
REM set PEGASUS_DEBUG=true
REM set PEGASUS_ROOT to top of source tree 
set PEGASUS_ROOT=C:\repos\OpenPegasus\pegasus

REM (Note: The '/' characters are intentional and required by the OpenPegasus build system). 
REM     Also the disk designator (C:) is required for at least some newer versions of the Microsoft
REM     compilers to avoid confusion between options and paths
REM set PEGASUS_HOME to where you want repository and executables, it can be the same as PEGASUS_ROOT
set PEGASUS_HOME=C:\repos\OpenPegasus\work64

set PEGASUS_PLATFORM=WIN64_X86_64_MSVC

REM set SSL
set PEGASUS_HAS_SSL=1
set OPENSSL_HOME=C:/OpenSSL64
set OPENSSL_BIN=%OPENSSL_HOME%\bin

REM set OPENSSL_VERSION_NUMBER=0x10100000L


set PEGASUS_ENABLE_SLP=false

set INCLUDE=%OPENSSL_HOME%\include;%INCLUDE%

set LIB=%OPENSSL_HOME%\lib;%LIB%
set LIBPATH=%OPENSSL_HOME%\lib;%LIB%

set path=%path%;%PEGASUS_HOME%\bin;%OPENSSL_HOME%\bin