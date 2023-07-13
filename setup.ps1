$Platform = "x64"
$pegasusPlatform = "WIN64_X86_64_MSVC";
$openSsl = "OpenSSL-Win64";
$binOutFolder = "bin-x64"
$libOutFolder = "lib-x64";

$startTime = (Get-Date);

    Pop-Location

    Write-Host "`nVisual Studio 2019 Command Prompt variables set" -ForegroundColor Blue
    # set PEGASUS variables

    $pegasusRoot = Join-Path -Path $env:GITHUB_WORKSPACE "pegasus";
    $pegasusHome = Join-Path -Path $env:GITHUB_WORKSPACE "work";
    $binPath = Join-Path -Path $pegasusHome -ChildPath "bin";
    $libPath = Join-Path -Path $pegasusHome -ChildPath "lib";
  
    $env:PEGASUS_ROOT = $pegasusRoot;
    $env:PEGASUS_HOME = $pegasusHome;
    $env:PEGASUS_PLATFORM = $pegasusPlatform;
    $env:PEGASUS_HAS_SSL = 0;
    $env:PEGASUS_ENABLE_SLP = "false";
    $env:PEGASUS_ENABLE_PROTOCOL_BINARY = "true";
#    $openssl_install = Join-Path -Path $Global:basePath $openSsl
#    $env:OPENSSL_HOME = $openssl_install;
#    $env:OPENSSL_COMMAND = "$openssl_install\bin\openssl.exe";
#    $env:OPENSSL_CONF= "$openssl_install\openssl.cnf";
#    $env:INCLUDE = "$openssl_install\include;$env:INCLUDE";
#    $env:PATH = "$env:Path;$openssl_install\bin;$binPath";
#    $env:OPENSSL_VERSION_NUMBER=0x10100000L;

    if ($DebugMode -eq $true) {
        $env:PEGASUS_DEBUG = "true";
        $binOutFolder = $binOutFolder + "-debug";
        $libOutFolder = $libOutFolder + "-debug";
    } 
    else {
        $binOutFolder = $binOutFolder + "-release";
        $libOutFolder = $libOutFolder + "-release";
    }

    Write-Host "`nPEGASUS variables set" -ForegroundColor Blue

    pushd $pegasusRoot

    $binOutPath = Join-Path -Path (Split-Path -Path $pegasusHome -Parent) -ChildPath "$binOutFolder";
    $libOutPath = Join-Path -Path (Split-Path -Path $pegasusHome -Parent) -ChildPath "$libOutFolder";

   Write-Host "liboutPath" $libOutPath;
   Write-Host "binOutPath" $binOutPath;
   Write-Host "pegasusHome" $pegasusHome;
   Write-Host "pegasusRoot" $pegasusRoot;
   Write-Host "binOutFolder" $binOutFolder;
   Write-Host "libOutFolder" $libOutFolder;
   Write-Host "binPath" $binPath;
   Write-Host "libPath" $libPath;

    # compile pegasus
    Write-Host "`nStart a new compilation" -ForegroundColor Yellow

    cmd /c "make buildmu"
    cmd /c "make buildclientlibs"

    popd

    $endTime = (Get-Date);
    $executionSeconds = ($endTime - $startTime).TotalSeconds;

    Write-Host "`nCompilation took $($executionSeconds)s";