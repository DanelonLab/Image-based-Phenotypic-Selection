@ECHO OFF
setlocal enabledelayedexpansion

rem Set direction to which Nis-Elements (OutProc) has exported capturetif.tif
C:
cd C:\darknet-master\build\darknet\x64

rem Split multi-image tif file into separate images and auto-level
magick convert capturetif.tif -auto-level +adjoin "capturetif-ch.tif"

rem Combine images into a single image (RGB)
magick convert capturetif-ch-1.tif capturetif-ch-0.tif Blue.tif -combine capture.tif

rem Convert tiff to jpeg
magick convert capture.tif data\capture.jpg

rem Run YOLO
darknet_no_gpu.exe detector test foldername/obj.data foldername/yolov7-tiny.cfg foldername/yolov7-tiny_final.weights data/capture.jpg -thresh 0.8 -dont_show -ext_output > output.txt

rem Create new numbered folder and save predictions.jpg and capture.jpg
set "resultsDir=C:\darknet-master\build\darknet\x64\results-predictions"
set /a folderCount=1
for /d %%F in ("%resultsDir%\*") do (
    set /a folderCount+=1
)
mkdir "%resultsDir%\!folderCount!"
copy predictions.jpg "%resultsDir%\!folderCount!\predictions.jpg"
copy "data\capture.jpg" "%resultsDir%\!folderCount!\jpg.jpg"

rem Convert coordinates into format accepted by NIS-Elements software
set input_file=output.txt
set output_file=xy.txt

rem Create or clear the output file
echo. > "!output_file!"

rem Read the input file line by line
for /F "usebackq tokens=*" %%a in ("!input_file!") do (
    rem Process only lines that contain the '%' character
    echo %%a | find "%%" > nul
    if !errorlevel! neq 1 (
        set line=%%a
        rem Extract type and coordinates using substring operations
        for /F "tokens=1-10 delims=:,() " %%b in ("!line!") do (
            set type=%%b
            set left_x=%%e
            set top_y=%%g
            set width=%%i
            set height=%%k

            rem Calculate center x and y if the ratio is within the desired range
            set /A "ratio = (!width! * 100) / !height!"
            set /A "area = !width! * !height!"

            rem Set conditions for the width-length-ratio and area of the bounding box
            rem The ratio is width/height * 100. Example: 'if !ratio! geq 70 if !ratio! leq 130' means 'if width/height is identical to or between 0.7 and 1.3'.
            rem The area of the bounding box is in squared pixels.
            if !ratio! geq 1 if !ratio! leq 10000 if !area! geq 1 (
                rem Calculate center x and y
                set /A "center_x=!left_x! + (!width! / 2)"
                set /A "center_y=!top_y! + (!height! / 2)"

                rem Write the result to the output file
                echo !type! !center_x! !center_y! >> "!output_file!"
            )
        )
    )
)

copy xy.txt "%resultsDir%\!folderCount!\xy.txt"

rem Record (accumulated) number of stimulations in count.txt file
set /a "half_lines=0"
for /f %%a in ('find /c /v "" ^< xy.txt') do set /a "half_lines=%%a/2"
if exist count.txt (
    set /p "count=" < count.txt
    set /a "count+=half_lines"
) else (
    set /a "count=half_lines"
)
echo %count% > count.txt

endlocal