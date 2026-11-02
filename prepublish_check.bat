@echo off
setlocal EnableExtensions EnableDelayedExpansion

set "SRC=C:\Users\zxzxk\Downloads\annotation_app\docs\data\cosmx_tiles"
set "DST=C:\Users\zxzxk\Downloads\Pathology_Demo\docs\data\cosmx_tiles"

echo.
echo Copying registered transforms...
echo SRC: %SRC%
echo DST: %DST%
echo.

for /d %%D in ("%SRC%\*") do (
    set "SLIDE=%%~nxD"
    set "TF=%%D\transform_registered.json"

    if exist "!TF!" (
        if exist "%DST%\!SLIDE!" (
            copy /Y "!TF!" "%DST%\!SLIDE!\transform_registered.json" >nul
            echo [UPDATED] !SLIDE!
        ) else (
            echo [SKIP - no target folder] !SLIDE!
        )
    )
)

echo.
echo Done.
pause