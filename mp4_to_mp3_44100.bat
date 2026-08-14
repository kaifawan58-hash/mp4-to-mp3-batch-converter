@echo off
setlocal enabledelayedexpansion

REM ============================================
REM   Universal Media to MP3 Converter
REM   Supports: MP4, MKV, AVI, MOV, WEBM, WAV, M4A, FLAC, WMA
REM   Auto-downloads ffmpeg if missing
REM
REM   Created by: Saif Awan
REM ============================================

echo ============================================
echo   Universal Media to MP3 Converter
echo   Created by Saif Awan
echo ============================================
echo.

set "SOURCE_DIR=%~dp0"
set "OUTPUT_DIR=%SOURCE_DIR%mp3_output"
set "FFMPEG=ffmpeg.exe"

if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

REM ---- 1) Locate or fetch ffmpeg ----
if exist "%SOURCE_DIR%ffmpeg.exe" (
    set "FFMPEG=%SOURCE_DIR%ffmpeg.exe"
    goto :ffmpeg_ready
)
where ffmpeg >nul 2>nul
if not errorlevel 1 goto :ffmpeg_ready

echo ffmpeg not found. Downloading a portable copy, please wait...
set "ZIPFILE=%SOURCE_DIR%ffmpeg_temp.zip"
set "EXTRACT_DIR=%SOURCE_DIR%ffmpeg_temp"
powershell -NoProfile -Command "$ProgressPreference='SilentlyContinue'; try { Invoke-WebRequest -Uri 'https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip' -OutFile '%ZIPFILE%' } catch { exit 1 }"
if errorlevel 1 (
    echo ERROR: Auto-download failed. Place ffmpeg.exe in this folder manually.
    pause
    exit /b 1
)
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
    pause
    exit /b 1
)
set "FFMPEG=%SOURCE_DIR%ffmpeg.exe"
echo ffmpeg is ready.
echo.

:ffmpeg_ready

REM ---- 2) Choose input type ----
echo ============================================
echo   Select the file type to convert to MP3:
echo ============================================
echo   1. MP4
echo   2. MKV
echo   3. AVI
echo   4. MOV
echo   5. WEBM
echo   6. WAV
echo   7. M4A
echo   8. FLAC
echo   9. WMA
echo ============================================
set /p "TYPECHOICE=Enter choice number: "

if "%TYPECHOICE%"=="1" set "EXT=mp4"
if "%TYPECHOICE%"=="2" set "EXT=mkv"
if "%TYPECHOICE%"=="3" set "EXT=avi"
if "%TYPECHOICE%"=="4" set "EXT=mov"
if "%TYPECHOICE%"=="5" set "EXT=webm"
if "%TYPECHOICE%"=="6" set "EXT=wav"
if "%TYPECHOICE%"=="7" set "EXT=m4a"
if "%TYPECHOICE%"=="8" set "EXT=flac"
if "%TYPECHOICE%"=="9" set "EXT=wma"

if not defined EXT (
    echo Invalid choice.
    pause
    exit /b 1
)

REM ---- 3) Bitrate menu ----
echo.
echo ============================================
echo   Bitrate (affects file size + audio quality)
echo ============================================
echo   1. 32 kbps  - Smallest size, noticeably muffled/low quality. OK for speech only.
echo   2. 64 kbps  - Small size, acceptable for speech/podcasts, weak for music.
echo   3. 96 kbps  - Balanced, decent for music on small devices.
echo   4. 128 kbps - Standard "good enough" quality, most common choice.
echo   5. 192 kbps - Clearly better music quality, bigger file size.
echo   6. 320 kbps - Best MP3 quality possible, largest file size.
echo ============================================
set /p "BRCHOICE=Enter choice number: "
if "%BRCHOICE%"=="1" set "BITRATE=32k"
if "%BRCHOICE%"=="2" set "BITRATE=64k"
if "%BRCHOICE%"=="3" set "BITRATE=96k"
if "%BRCHOICE%"=="4" set "BITRATE=128k"
if "%BRCHOICE%"=="5" set "BITRATE=192k"
if "%BRCHOICE%"=="6" set "BITRATE=320k"
if not defined BITRATE set "BITRATE=64k"

REM ---- 4) Channels menu ----
echo.
echo ============================================
echo   Channels (affects file size + sound width)
echo ============================================
echo   1. Mono (1)   - Half the file size, sounds "flat"/centered, fine for speech.
echo   2. Stereo (2) - Full left/right separation, fuller sound, bigger file size.
echo ============================================
set /p "CHCHOICE=Enter choice number: "
if "%CHCHOICE%"=="1" set "CHANNELS=1"
if "%CHCHOICE%"=="2" set "CHANNELS=2"
if not defined CHANNELS set "CHANNELS=1"

REM ---- 5) Sample rate menu ----
echo.
echo ============================================
echo   Sample Rate (affects audio detail/brightness)
echo ============================================
echo   1. 16000 Hz - Very low, telephone-quality, speech only.
echo   2. 22050 Hz - Low, small file, noticeably duller highs, OK for speech/lectures.
echo   3. 32000 Hz - Moderate, acceptable for casual music listening.
echo   4. 44100 Hz - Standard CD quality, recommended for music.
echo   5. 48000 Hz - Studio/video standard, slightly bigger than 44100.
echo ============================================
set /p "SRCHOICE=Enter choice number: "
if "%SRCHOICE%"=="1" set "SAMPLERATE=16000"
if "%SRCHOICE%"=="2" set "SAMPLERATE=22050"
if "%SRCHOICE%"=="3" set "SAMPLERATE=32000"
if "%SRCHOICE%"=="4" set "SAMPLERATE=44100"
if "%SRCHOICE%"=="5" set "SAMPLERATE=48000"
if not defined SAMPLERATE set "SAMPLERATE=22050"

REM ---- 6) Short filenames ----
echo.
set /p "SHORTCHOICE=Shorten output file names? (Y/N): "
if /I "%SHORTCHOICE%"=="Y" (set "SHORTNAMES=1") else (set "SHORTNAMES=0")

echo.
echo Scanning for .%EXT% files in: %SOURCE_DIR%
echo Output will be saved to: %OUTPUT_DIR%
echo Settings: %BITRATE% CBR, %CHANNELS% channel(s), %SAMPLERATE% Hz, no tags
echo.

REM ---- 7) Write and run temp PowerShell helper ----
set "PSFILE=%TEMP%\mediatomp3_%RANDOM%.ps1"

(
echo $folder = '%SOURCE_DIR%'
echo $outDir = '%OUTPUT_DIR%'
echo $ffmpeg = '%FFMPEG%'
echo $bitrate = '%BITRATE%'
echo $channels = '%CHANNELS%'
echo $samplerate = '%SAMPLERATE%'
echo $ext = '%EXT%'
echo $shortNames = '%SHORTNAMES%'
echo $files = Get-ChildItem -Path $folder -Filter ('*.' + $ext^) -File
echo $used = @{}
echo $count = 0
echo foreach ($file in $files^) {
echo     $base = $file.BaseName
echo     if ($shortNames -eq '1'^) {
echo         $words = @($base -split '\s+' ^| Where-Object { $_ -ne '' }^)
echo         if ($words.Count -ge 2^) { $short = [string]$words[0] + '_' + [string]$words[1] }
echo         elseif ($words.Count -eq 1^) { $short = [string]$words[0] }
echo         else { $short = 'file' }
echo     } else {
echo         $short = $base
echo     }
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
