@echo off
setlocal enabledelayedexpansion

REM ============================================
REM  MP4 to MP3 Converter (with short names)
REM  Uses local ffmpeg.exe if present, else PATH,
REM  else auto-downloads a portable copy.
REM ============================================

set "SOURCE_DIR=%~dp0"
set "OUTPUT_DIR=%SOURCE_DIR%mp3_output"
set "FFMPEG=ffmpeg.exe"

REM ---- Editable settings ----
set "BITRATE=64k"
set "CHANNELS=1"
set "SAMPLERATE=22050"
REM ----------------------------

if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

REM 1) Local ffmpeg.exe next to this script
if exist "%SOURCE_DIR%ffmpeg.exe" (
    set "FFMPEG=%SOURCE_DIR%ffmpeg.exe"
    goto :ffmpeg_ready
)

REM 2) ffmpeg from system PATH
where ffmpeg >nul 2>nul
if not errorlevel 1 (
    goto :ffmpeg_ready
)

REM 3) Auto-download portable ffmpeg.exe
echo ffmpeg not found. Downloading a portable copy, please wait...
set "ZIPFILE=%SOURCE_DIR%ffmpeg_temp.zip"
set "EXTRACT_DIR=%SOURCE_DIR%ffmpeg_temp"

powershell -NoProfile -Command "$ProgressPreference='SilentlyContinue'; try { Invoke-WebRequest -Uri 'https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip' -OutFile '%ZIPFILE%' } catch { exit 1 }"
if errorlevel 1 (
    echo ERROR: Auto-download failed. Check your internet connection, or
    echo manually download ffmpeg.exe and place it in this folder.
    echo Download: https://www.gyan.dev/ffmpeg/builds/
    pause
    exit /b 1
)

echo Extracting...
powershell -NoProfile -Command "Expand-Archive -Path '%ZIPFILE%' -DestinationPath '%EXTRACT_DIR%' -Force"

for /r "%EXTRACT_DIR%" %%A in (ffmpeg.exe) do (
    copy "%%A" "%SOURCE_DIR%ffmpeg.exe" >nul
    goto :copied
)
:copied

del /q "%ZIPFILE%" >nul 2>nul
rmdir /s /q "%EXTRACT_DIR%" >nul 2>nul

if not exist "%SOURCE_DIR%ffmpeg.exe" (
    echo ERROR: Could not set up ffmpeg automatically.
    echo Please manually download and place ffmpeg.exe in this folder.
    pause
    exit /b 1
)

set "FFMPEG=%SOURCE_DIR%ffmpeg.exe"
echo ffmpeg is ready.
echo.

:ffmpeg_ready

echo Scanning for MP4 files in: %SOURCE_DIR%
echo Output will be saved to: %OUTPUT_DIR%
echo.

REM --- Write a temp PowerShell helper that does short-name generation + conversion ---
set "PSFILE=%TEMP%\mp4tomp3_%RANDOM%.ps1"

(
echo $folder = '%SOURCE_DIR%'
echo $outDir = '%OUTPUT_DIR%'
echo $ffmpeg = '%FFMPEG%'
echo $bitrate = '%BITRATE%'
echo $channels = '%CHANNELS%'
echo $samplerate = '%SAMPLERATE%'
echo $files = Get-ChildItem -Path $folder -Filter '*.mp4' -File
echo $used = @{}
echo $count = 0
echo foreach ($file in $files^) {
echo     $base = $file.BaseName
echo     $words = @($base -split '\s+' ^| Where-Object { $_ -ne '' }^)
echo     if ($words.Count -ge 2^) { $short = [string]$words[0] + '_' + [string]$words[1] }
echo     elseif ($words.Count -eq 1^) { $short = [string]$words[0] }
echo     else { $short = 'file' }
echo     $invalid = [IO.Path]::GetInvalidFileNameChars(^)
echo     foreach ($ch in $invalid^) { $short = $short.Replace([string]$ch,'_'^) }
echo     $final = $short
echo     $i = 1
echo     while ($used.ContainsKey(([string]$final^).ToLower(^)^) -or (Test-Path (Join-Path $outDir ($final+'.mp3'^)^)^)^) {
echo         $i++
echo         $final = $short + '_' + $i
echo     }
echo     $used[([string]$final^).ToLower(^)] = $true
echo     $outFile = Join-Path $outDir ($final + '.mp3'^)
echo     Write-Host ('Converting: ' + $file.Name + '  -^>  ' + $final + '.mp3'^)
echo     $argsList = @('-y','-i',('"'+$file.FullName+'"'^),'-vn','-map_metadata','-1','-id3v2_version','0','-write_id3v1','0','-acodec','libmp3lame','-b:a',$bitrate,'-ac',$channels,'-ar',$samplerate,('"'+$outFile+'"'^),'-loglevel','error'^)
echo     $psi = New-Object System.Diagnostics.ProcessStartInfo
echo     $psi.FileName = $ffmpeg
echo     $psi.Arguments = ($argsList -join ' '^)
echo     $psi.UseShellExecute = $false
echo     $proc = [System.Diagnostics.Process]::Start($psi^)
echo     $proc.WaitForExit(^)
echo     if ($proc.ExitCode -eq 0^) {
echo         Write-Host ('  -^> Done: ' + $final + '.mp3'^)
echo         $count++
echo     } else {
echo         Write-Host ('  -^> FAILED: ' + $file.Name^)
echo     }
echo }
echo Write-Host ''
echo Write-Host ($count.ToString(^) + ' of ' + $files.Count + ' file(s^) converted successfully.'^)
echo Write-Host ('Settings: ' + $bitrate + ' CBR, ' + $channels + ' channel(s^), ' + $samplerate + ' Hz, no tags'^)
) > "%PSFILE%"

powershell -NoProfile -ExecutionPolicy Bypass -File "%PSFILE%"
del "%PSFILE%" >nul 2>nul

echo.
pause
