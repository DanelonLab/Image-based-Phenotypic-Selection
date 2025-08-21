@ECHO OFF
setlocal enabledelayedexpansion

set NUM_XYFILES=5

rem Set direction to which Nis-Elements (OutProc) has exported capturetif.tif
C:
cd C:\darknet-master\build\darknet\x64

rem Create new numbered folder to save predictions.jpg and capture.jpg
set "resultsDir=C:\darknet-master\build\darknet\x64\results-predictions"
set /a folderCount=1
for /d %%F in ("%resultsDir%\*") do (
    set /a folderCount+=1
)
mkdir "%resultsDir%\!folderCount!"

rem Split multi-image tif file into separate images and auto-level
for /L %%k in (1, 1, %NUM_XYFILES%) do (
    magick convert capturetif%%k.tif -level 0,2000 +adjoin "capturetif%%k-ch.tif"

    rem Combine images into a single image (RGB)
    magick convert capturetif%%k-ch-1.tif capturetif%%k-ch-0.tif Blue.tif -combine capture%%k.tif

    rem Convert tiff to jpg
    magick convert capture%%k.tif -quality 100 data\capture%%k.jpg

    darknet_no_gpu.exe detector test foldername/obj.data foldername/yolov7-tiny.cfg foldername/yolov7-tiny_final.weights data/capture%%k.jpg -thresh 0.8 -dont_show -ext_output > xy%%k.txt

    rem Save predictions.jpg and original jpg image
    copy predictions.jpg "%resultsDir%\!folderCount!\predictions%%k.jpg"
    copy C:\darknet-master\build\darknet\x64\data\capture%%k.jpg "%resultsDir%\!folderCount!\jpg%%k.jpg"
)

rem Convert coordinates into format accepted by NIS-Elements software
for /L %%m in (1, 1, %NUM_XYFILES%) do (
    set input_file=xy%%m.txt
    set output_file=xy%%m_sh.txt

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
                if !ratio! geq 70 if !ratio! leq 130 if !area! geq 600 (
                    rem Calculate center x and y
                    set /A "center_x=!left_x! + (!width! / 2)"
                    set /A "center_y=!top_y! + (!height! / 2)"

                    rem Write the result to the output file
                    echo !type! !center_x! !center_y! >> "!output_file!"
                )
            )
        )
    )
)

rem Calculate nearest neighbours between frame 1 and all the other frames
set OUTPUT=output.txt
break > %OUTPUT%

set FILE1=xy1_sh.txt

for /F "tokens=1-3" %%a in (!FILE1!) do (
    set "class1=%%a"
    set "x1=%%b"
    set "y1=%%c"
    set "result=!class1!"

        for /L %%j in (2, 1, %NUM_XYFILES%) do (
                set FILE2=xy%%j_sh.txt
    		set "nearest="
    		set "nearestx="
    		set "nearesty="
    		set "min_distance="

                for /F "tokens=1-3" %%d in (!FILE2!) do (
                    set "class2=%%d"
                    set "x2=%%e"
                    set "y2=%%f"

                    set /a "distance=(x2-x1)*(x2-x1) + (y2-y1)*(y2-y1)"

                    if not defined min_distance (
                        set "min_distance=!distance!"
                        set "nearest=!class2!"
                        set "nearestx=!x2!"
                        set "nearesty=!y2!"
                    ) else if !distance! lss !min_distance! (
                        set "min_distance=!distance!"
                        set "nearest=!class2!"
                        set "nearestx=!x2!"
                        set "nearesty=!y2!"
                    )
                )

            if defined min_distance (
                if !min_distance! lss 400 (
                    set "result=!result! !nearest!"
                ) else (
                    set "result=!result! nf"
                    set "nearestx=!x1!"
                    set "nearesty=!y1!"
                )
            ) else (
                set "result=!result! nf"
                set "nearestx=!x1!"
                set "nearesty=!y1!"
            )
        )
set "result=!result! !nearestx! !nearesty!"
echo !result! >> %OUTPUT%
)

rem Detect dynamics: if membrane and lumen both occur for the same object. If the line contains both lumen and membrane, then error level is set to 0, otherwise it is set to 1.
set XY=xy.txt
break > %XY%

for /F "delims=" %%a in (output.txt) do (
    echo %%a | findstr /i /c:"lumen" | findstr /i /c:"membrane" > nul
    if !errorlevel! equ 0 (
        for /F "tokens=*" %%b in ("%%a") do (
            for %%c in (%%b) do (
                set "last1=!last2!"
                set "last2=%%c"
            )
            echo x=!last1! >> xy.txt
            echo y=!last2! >> xy.txt
        )
    )
)

rem Save coordinates for stimulation to folder
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
