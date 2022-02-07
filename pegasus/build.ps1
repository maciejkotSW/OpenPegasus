function BuildOpenPegasus 
{
    param(
        [Parameter(Position = 0, Mandatory = 0)]
        [string]$Platform = "x86",
        [Parameter(Position = 1, Mandatory = 0)]
        [switch]$DebugMode = $true
    )

    #Set 32 vs 64 variables
    $vs2019bat = "vcvars32.bat";
    $pegasusPlatform = "WIN32_IX86_MSVC";
    $openSsl = "OpenSSL-Win32";
    $binOutFolder = "bin-x86";
    $libOutFolder = "lib-x86";

    if ($Platform -eq "x64") {
        $vs2019bat = "vcvars64.bat";
        $pegasusPlatform = "WIN64_X86_64_MSVC";
        $openSsl = "OpenSSL-Win64";
        $binOutFolder = "bin-x64"
        $libOutFolder = "lib-x64";
    }

    $vsPath = "C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools";
    $toolsPath = Join-Path $vsPath "VC\Auxiliary\Build"
    $startTime = (Get-Date);

    # set vs2019 variables
    Push-Location "$toolsPath"

    cmd /c "$($vs2019bat)&set" |
    ForEach-Object {
        if ($_ -match "=") {
            $kv = $_.split("=");
            set-item -force -path "ENV:\$($kv[0])" -value "$($kv[1])";
        }
    }

    Pop-Location

    Write-Host "`nVisual Studio 2019 Command Prompt variables set" -ForegroundColor Blue

    # set PEGASUS variables
    
    $pegasusRoot = Join-Path $psScriptRoot "\..\pegasus" -Resolve;
    $pegasusHome = Join-Path -Path (Split-Path $pegasusRoot -Parent) -ChildPath "work";
    $binPath = Join-Path -Path $pegasusHome -ChildPath "bin";
    $libPath = Join-Path -Path $pegasusHome -ChildPath "lib";
    $openSsl = "C:\OpenSSL"

    $env:PEGASUS_ROOT = "$($pegasusRoot)\";
    $env:PEGASUS_HOME = $pegasusHome;
    $env:PEGASUS_PLATFORM = $pegasusPlatform;
    $env:PEGASUS_HAS_SSL = 1;
    $env:PEGASUS_ENABLE_SLP = "false";
    $env:PEGASUS_ENABLE_PROTOCOL_BINARY = "true";
    $env:OPENSSL_HOME = $openSsl;
    $env:OPENSSL_COMMAND = "$openSsl\bin\openssl.exe";
#    $env:OPENSSL_CONF="$openssl\openssl.cnf";
    $env:INCLUDE = "$openSsl\include;$env:INCLUDE";
    $env:PATH = "$env:Path;$openSsl\bin;$binPath"

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

    # clean up from the previous compilations
    $muPath = Join-Path -Path (Join-Path -Path (Join-Path -Path (Join-Path -Path $pegasusRoot -ChildPath "src") -ChildPath "utils") -ChildPath "mu") -ChildPath "mu.exe";

    pushd $pegasusRoot

    if (Test-Path -Path $muPath) {
        Write-Host "`nFound Previous compilation. Cleaning..." -ForegroundColor Yellow
        cmd /c "make clean"
    }

    if (Test-Path -Path $pegasusHome) {
        Get-ChildItem -Path $pegasusHome | select -ExpandProperty Name | foreach {
            Write-Host "`nRemoving $_ folder" -ForegroundColor Blue
            Remove-Item (Join-Path -Path $pegasusHome -ChildPath $_) -Force -Recurse
        }
    }

    $binOutPath = Join-Path -Path (Split-Path -Path $pegasusHome -Parent) -ChildPath "$binOutFolder";
    $libOutPath = Join-Path -Path (Split-Path -Path $pegasusHome -Parent) -ChildPath "$libOutFolder";

    if (Test-Path -Path $binOutPath) {
        Write-Host "`nRemoving $binOutPath folder" -ForegroundColor Blue
        Remove-Item $binOutPath -Force -Recurse
    }

    if (Test-Path -Path $libOutPath) {
        Write-Host "`nRemoving $libOutPath folder" -ForegroundColor Blue
        Remove-Item $libOutPath -Force -Recurse
    }

    # compile pegasus
    Write-Host "`nStart a new compilation" -ForegroundColor Yellow

    cmd /c "make buildmu"
    cmd /c "make all"

    popd

    $endTime = (Get-Date);
    $executionSeconds = ($endTime - $startTime).TotalSeconds;

    Write-Host "`nCompilation took $($executionSeconds)s";



    $fileNamesToCopy = "pegcommon","pegclient"
    
    #Setup target folders
    $SRMDir = Split-Path $pegasusRoot -Parent;
    $binSRMDestinationFolder = Join-Path -Path $SRMDir -ChildPath "bin";
    $libSRMDestinationFolder = Join-Path -Path $SRMDir -ChildPath "lib";
    $SRMSMISIncludeDir = Join-Path -Path (Join-Path -Path $SRMDir -ChildPath "include") -ChildPath "Pegasus"
    $clientIncludeSRMDestinationFolder = Join-Path -Path $SRMSMISIncludeDir -ChildPath "Client"
    $commonIncludeSRMDestinationFolder = Join-Path -Path $SRMSMISIncludeDir -ChildPath "Common"

	New-Item $binSRMDestinationFolder -ItemType 'directory' -force
	New-Item $libSRMDestinationFolder -ItemType 'directory' -force
	New-Item $clientIncludeSRMDestinationFolder -ItemType 'directory' -force
	New-Item $commonIncludeSRMDestinationFolder -ItemType 'directory' -force

    # copy dlls and pdbs directly to the folder used by SRM.SMIS project
    $fileNamesToCopy | ForEach-Object   {
        Copy-Item -Path "$binPath\$_.dll" -Destination "$binSRMDestinationFolder\" -Force
        Copy-Item -Path "$binPath\$_.pdb" -Destination "$binSRMDestinationFolder\" -Force
        Copy-Item -Path "$libPath\$_.lib" -Destination "$libSRMDestinationFolder\" -Force
    }

    # copy includes directly to the folder used by SRM.SMIS project

    $clientIncludes = Join-Path -Path (Join-Path -Path (Join-Path -Path $pegasusRoot -ChildPath "src") -ChildPath "Pegasus") -ChildPath "Client"
    $commonIncludes = Join-Path -Path (Join-Path -Path (Join-Path -Path $pegasusRoot -ChildPath "src") -ChildPath "Pegasus") -ChildPath "Common"

    Copy-Item "$clientIncludes\*.h" $clientIncludeSRMDestinationFolder -Force
    Copy-Item "$commonIncludes\*.h" $commonIncludeSRMDestinationFolder -Force
}

function Get-LatestMsvcBuildTools 
{
    if (-not (Test-Path $Global:vswhereToolLocation -EA 0)) {
        Write-Error "vshwere tool binary not found, expected at $Global:vswhereToolLocation"
        return
    }

    return Invoke-CommandLine $Global:vswhereToolLocation "-requires" "Microsoft.VisualStudio.Component.VC.Tools.x86.x64" "-property" "installationPath" "-latest" "-products" "*"
}

BuildOpenPegasus