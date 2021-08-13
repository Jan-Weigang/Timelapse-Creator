setlocal enabledelayedexpansion
@echo off

]2;Timelapse Creator by Jan Weigang

Rem 	|----	Set Basic Variables	----|

mode con: cols=120 lines=25

set dirfull=_Full Video
set dirproxy=_Proxy Video
set dirgifs=GIFs

set profile=2
set crf=18
set keyframes=1
set hcontainer=mov
set pcontainer=mov
set maxsize=15



echo %cd%\%dirfull%\NUL

if not exist "%dirfull%\" mkdir "%dirfull%"
if not exist "%dirproxy%\" mkdir "%dirproxy%"
if not exist "%dirgifs%\" mkdir "%dirgifs%"


Rem 	|----	Detect Images	----|


:images

set imagetype=png
set name=UNDEFINED
set fps=25

for %%A in (*.png) do (
    set "name=%%~nA.png"
    set imagetype=png
    goto continue
)


for %%A in (*.jpg) do (
    set "name=%%~nA.jpg"
    set imagetype=jpg
    goto continue
)

if name EQU UNDEFINED (
    echo [91mNo images found! Exiting...[0m
    goto end
)





:continue

set name=%name:~0,-8%

echo.&cls
echo - - - - - [36mTimelapse Creator[0m by [36mJan Weigang[0m - - - - - 
echo.
echo Found the following %imagetype%s: [96m%name%[0m
echo.




Rem 	|----	Menu and Codec	----|

:menu

set codec=prores
set height=2160
set custom=n
set bitrate=100

echo.
echo [97mPick Preset (press number to continue)[0m:
echo.
echo      1. [96mProres 4k[0m
echo      2. [96mh264 1080[0m
echo      3. [96mh265 1080[0m
echo.
echo      5. Custom Video
echo.
echo      0. GIFs
echo.
echo [30m


choice /C 12350 /N
if %ERRORLEVEL% EQU 5 (
    set codec=gif
    set height=360
    goto presetcontinue
)
if %ERRORLEVEL% EQU 4 (
    set custom=y
    set width=3840
    goto presetcontinue
)
if %ERRORLEVEL% EQU 3 (
    set codec=h265
    set height=1080
    goto presetcontinue
)
if %ERRORLEVEL% EQU 2 (
    set codec=h264
    set height=1080
    goto presetcontinue
)
if %ERRORLEVEL% EQU 1 (
    set codec=prores
    set height=2160
    goto presetcontinue
)

:presetcontinue

echo [0m
if %custom% EQU y goto custommenu




Rem 	|----  Preset Framerate  ----|


:framerate

set /P fps=[97mPlease enter the framerate:[0m 

set "var="&for /f "delims=0123456789" %%i in ("%fps%") do set var=%%i
if defined var (
	echo [91mEntered Value is not numeric[0m
	goto framerate
)

goto process

Rem     Going to Process unless GIFs are selected as preset







Rem 	TODO: Custom Menu

Rem 	|----	Custom Menu	----|

:custommenu

set /A ratio = %width% / %height%

echo.&cls
echo - - - - - [36mTimelapse Creator[0m by [36mJan Weigang[0m - - - - - 
echo.
echo.
echo [97mPick setting to change (press number to continue)[0m:
echo.
echo      1. Codec:         [96m%codec%[0m
echo      2. Resolution:    [96m%height%p[0m
echo      3. Framerate:     [96m%fps% fps[0m
echo.
echo      4. Width/Aspect   [36m%width% px[0m
echo.

if %codec% EQU gif echo      [90m- - %codec% settings: - -[0m

Rem |--- Prores Settings ---|
if %codec% EQU prores echo      5. Container:     [36m%pcontainer%[0m
if %codec% EQU prores echo      6. Profile (0-5): [36m%profile%[0m

Rem |--- h264 Settings ---|
if %codec% EQU h264 echo      5. Container:     [36m%hcontainer%[0m
if %codec% EQU h264 echo      6. CRF (0-51):    [36m%crf%[0m
if %codec% EQU h264 echo      7. Bitrate:       [36m%bitrate% Mbit[0m
if %codec% EQU h264 echo      8. Keyframe:      [36mevery %keyframes% second(s)[0m

Rem |--- h265 Settings ---|
if %codec% EQU h265 echo      5. Container:     [36m%hcontainer%[0m
if %codec% EQU h265 echo      6. CRF (0-51):    [36m%crf%[0m
if %codec% EQU h265 echo      7. Bitrate:       [36m%bitrate% Mbit[0m
if %codec% EQU h265 echo      8. Keyframe:      [36mevery %keyframes% second(s)[0m

Rem |--- Prores Settings ---|

if %codec% EQU gif echo      9. Max-Size:      [36m%maxsize% MB[0m


echo.
echo.
echo      0. Start rendering
echo [30m


choice /C 1234567890 /N
if %ERRORLEVEL% EQU 10 goto process
if %ERRORLEVEL% EQU 9 goto pickfilesize
if %ERRORLEVEL% EQU 8 goto pickkeyframes
if %ERRORLEVEL% EQU 7 goto pickbitrate
if %ERRORLEVEL% EQU 6 goto pickquality
if %ERRORLEVEL% EQU 5 goto pickcontainer
if %ERRORLEVEL% EQU 4 goto pickwidth
if %ERRORLEVEL% EQU 3 goto pickfps
if %ERRORLEVEL% EQU 2 goto pickheight
if %ERRORLEVEL% EQU 1 goto pickcodec


Rem 	|----	Custom Menu - prompts	----|

Rem   1 Codec, 2 Height, 3 FPS, 4 Width, 5 Container, 6 Profile / CRF, 7 Bitrate, 8 Keyframes (sekunden), 9 Filesize (GIF), 0 Start


:pickcodec
echo [0m

echo.&cls
echo - - - - - [36mTimelapse Creator[0m by [36mJan Weigang[0m - - - - - 
echo.
echo.
echo [97mPick codec (press number to continue)[0m:
echo.
echo      1. [96mprores[0m
echo      2. [96mh264[0m
echo      3. [96mh265%[0m
echo      4. [96mGIF[0m
echo.
echo [30m

choice /C 1234 /N
if %ERRORLEVEL% EQU 4 set codec=gif
if %ERRORLEVEL% EQU 3 set codec=h265
if %ERRORLEVEL% EQU 2 set codec=h264
if %ERRORLEVEL% EQU 1 set codec=prores

echo [0m

goto custommenu



Rem - - - - - - - - - - - - Custom height:

:pickheight
echo [0m

set /P height=[97mPlease enter y-resolution:[0m 

set "var="&for /f "delims=0123456789" %%i in ("%height%") do set var=%%i
if defined var (
	echo [91mEntered Value is not numeric[0m
	goto pickheight
)

set /A width=%height% * 16 / 9

goto custommenu



Rem - - - - - - - - - - - - Custom FPS:

:pickfps
echo [0m

set /P fps=[97mPlease enter the framerate:[0m 

set "var="&for /f "delims=0123456789" %%i in ("%fps%") do set var=%%i
if defined var (
	echo [91mEntered Value is not numeric[0m
	goto pickfps
)

goto custommenu



Rem - - - - - - - - - - - - Custom Bitrate:

:pickbitrate
echo [0m

set /P bitrate=[97mPlease enter the bitrate:[0m 

set "var="&for /f "delims=0123456789" %%i in ("%bitrate%") do set var=%%i
if defined var (
	echo [91mEntered Value is not numeric[0m
	goto pickbitrate
)

goto custommenu



Rem - - - - - - - - - - - - Custom Width:

:pickwidth
echo [0m

echo [93mWarning: [33mPicking Width (instead of height) changes the aspect ratio. Set height first.[0m
echo Current Value: [36m%width% px[0m
echo.
echo.

set /P width=[97mPlease enter x-dimension:[0m 

set "var="&for /f "delims=0123456789" %%i in ("%width%") do set var=%%i
if defined var (
	echo [91mEntered Value is not numeric[0m
	goto pickwidth
)

goto custommenu





Rem - - - - - - - - - - - - Custom Container:

:pickcontainer
echo [0m

echo.&cls
echo - - - - - [36mTimelapse Creator[0m by [36mJan Weigang[0m - - - - - 
echo.
echo.
echo [97mPick codec (press number to continue)[0m:
echo.
echo      1. [96mmov[0m
if %codec% EQU prores (
     echo      2. [96mmkv[0m
) else (
     echo      2. [96mmp4[0m
)

echo.
echo [30m

choice /C 12 /N
if %ERRORLEVEL% EQU 2 (
     if %codec% EQU prores (
	set pcontainer=mkv
     ) else (
	set hcontainer=mp4
     )
)
if %ERRORLEVEL% EQU 1 (
     if %codec% EQU prores (
	set pcontainer=mov
     ) else (
	set hcontainer=mov
     )
)

echo [0m

goto custommenu



Rem - - - - - - - - - - - - Custom Quality:

:pickquality
echo [0m

if %codec% EQU prores echo Current Value: [36m%profile%[0m
if %codec% NEQ prores echo Current Value: [36m%crf%[0m
echo.

if %codec% EQU prores set /P profile=[97mPlease enter profile:[0m 
if %codec% NEQ prores set /P crf=[97mPlease enter crf value:[0m 

set "var="&for /f "delims=0123456789" %%i in ("%profile%") do set var=%%i
if defined var (
	echo [91mEntered Value is not numeric[0m
	goto pickquality
)

set "var="&for /f "delims=0123456789" %%i in ("%crf%") do set var=%%i
if defined var (
	echo [91mEntered Value is not numeric[0m
	goto pickquality
)

goto custommenu




Rem - - - - - - - - - - - - Custom  keyframes:

:pickkeyframes
echo [0m

echo Current Value: Keyframe every [36m%keyframes% second(s)[0m
echo.
echo.

set /P keyframes=[97mPlease enter seconds:[0m 

set "var="&for /f "delims=0123456789" %%i in ("%keyframes%") do set var=%%i
if defined var (
	echo [91mEntered Value is not numeric[0m
	goto pickkeyframes
)

goto custommenu



Rem - - - - - - - - - - - - Custom filesize (gif):

:pickfilesize
echo [0m

echo Current Value: [36m%maxsize% MB[0m
echo.
echo.

set /P maxsize=[97mPlease enter maximum filesize for short gif:[0m 

set "var="&for /f "delims=0123456789" %%i in ("%maxsize%") do set var=%%i
if defined var (
	echo [91mEntered Value is not numeric[0m
	goto pickfilesize
)

goto custommenu






Rem 	|------------------------------     Start of Process	------------------------------------|

:process



if %custom% EQU n set /A width = %height% * 16 / 9

if %codec% EQU gif goto processgifs

if %custom% EQU n set /A bitrate = (%bitrate% + (%fps% * 2)) * %height% / 2160

set /A keyfps=%fps%*%keyframes%

echo.&cls
echo - - - - - [36mTimelapse Creator[0m by [36mJan Weigang[0m - - - - - 
echo.
echo Settings:
echo.
echo Codec:       [96m%codec%[0m
echo Dimensions:  [96m%width% x %height% p %fps%[0m
echo Bitrate:     [96m%bitrate% Mbit[0m


Rem 	|----	Video Creation	----|

:full

echo.
echo.
echo Creating [96m%codec% %height%p video with %fps% fps...[93m
echo.

if %codec% EQU prores (
    ffmpeg.exe ^
	-framerate %fps% -i %name%%%04d.%imagetype% -s %width%x%height% -pix_fmt yuv422p10le ^
	-c:v %codec% -profile:v 2 -alpha_bits 0 -loglevel error -stats ^
	-filter:v "crop=%width%:%height%:exact=1,setsar=1"^
	"%dirfull%\%name%%codec%_%fps%.mov"
)

if %codec% EQU h264 (
    ffmpeg.exe ^
	-framerate %fps% -i %name%%%04d.%imagetype% -s %width%x%height% -pix_fmt yuv420p ^
	-c:v libx264 -quality good -g %keyfps% -b:v %bitrate%M -loglevel error -stats ^
	-filter:v "crop=%width%:%height%:exact=1,setsar=1"^
	"%dirfull%\%name%%codec%_%fps%.mov"
)

if %codec% EQU h265 (
    ffmpeg.exe ^
	-framerate %fps% -i %name%%%04d.%imagetype% -s %width%x%height% -pix_fmt yuv420p ^
	-c:v libx265 -quality good -g %keyfps% -b:v %bitrate%M -loglevel error -stats ^
	-x265-params log-level=error ^
	-filter:v "crop=%width%:%height%:exact=1,setsar=1"^
	"%dirfull%\%name%%codec%_%fps%.mov"
)

echo [93mDone.[0m

:proxy

echo.
echo.

if %codec% EQU prores (
    echo Creating [96m%codec% 720p proxy with %fps% fps...[93m
    echo.

    ffmpeg.exe ^
	-i %name%%%04d.%imagetype% -s 1280x720 -pix_fmt yuv422p10le -framerate %fps% ^
	-c:v %codec% -profile:v 2 -alpha_bits 0 -loglevel error -stats ^
	"%dirproxy%\%name%%codec%_%fps%.mov"
)

if %codec% EQU prores echo [93mDone.[0m

goto end

Rem ------------------------------



Rem 	|----	 GIF Creation	----|

:processgifs

echo.
echo.
echo Creating [96mFull Length GIF...[93m
echo.

ffmpeg.exe -i %name%%%04d.%imagetype% -s %width%x%height% -pix_fmt rgb8 -framerate %fps% -c:v gif ^
    -loglevel error -stats ^
    "%dirgifs%\%name%%height%p%fps%_full.gif"

echo [93mDone.[0m

echo.
echo.
echo Creating [96mShort GIF (15MB)...[93m
echo.

ffmpeg.exe -i %name%%%04d.%imagetype% -s %width%x%height% -pix_fmt rgb8 -framerate %fps% -c:v gif -fs %maxsize%M ^
    -loglevel error -stats ^
    "%dirgifs%\%name%%height%p%fps%_short.gif"

echo [93mDone.[0m

echo.
echo.

goto end

Rem ------------------------------



:end

echo.
echo.

if %ERRORLEVEL% NEQ 0 (
    echo [93mFound an [91merror[93m and paused.[0m
    pause
)


echo.
echo Finished.
timeout /t 5



endlocal
