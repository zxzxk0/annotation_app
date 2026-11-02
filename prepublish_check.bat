@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================
REM Pathogene / annotation_app
REM Sync newly generated transform_registered.json -> docs
REM ============================================================

set "ROOT=C:\Users\zxzxk\Downloads\annotation_app"
set "SRC=%ROOT%\data\cosmx_tiles"
set "DST=%ROOT%\docs\data\cosmx_tiles"
set "BACKUP=%ROOT%\_transform_backup"
set "MANIFEST=%ROOT%\generate_manifest.py"

echo.
echo ============================================================
echo annotation_app transform update
echo ============================================================
echo ROOT: %ROOT%
echo SRC : %SRC%
echo DST : %DST%
echo.

if not exist "%ROOT%" (
    echo [ERROR] annotation_app not found.
    pause
    exit /b 1
)

if not exist "%SRC%" (
    echo [ERROR] Source cosmx_tiles not found:
    echo %SRC%
    pause
    exit /b 1
)

if not exist "%DST%" (
    echo [ERROR] docs cosmx_tiles not found:
    echo %DST%
    pause
    exit /b 1
)

REM ------------------------------------------------------------
REM Backup current docs transforms
REM ------------------------------------------------------------

if not exist "%BACKUP%" mkdir "%BACKUP%"

echo [1/4] Backing up current docs transforms...

for /d %%D in ("%DST%\*") do (

    set "SLIDE=%%~nxD"

    if exist "%%D\transform_registered.json" (

        if not exist "%BACKUP%\!SLIDE!" (
            mkdir "%BACKUP%\!SLIDE!"
        )

        copy /Y ^
        "%%D\transform_registered.json" ^
        "%BACKUP%\!SLIDE!\transform_registered.json" >nul

        echo   BACKUP !SLIDE!
    )
)

REM ------------------------------------------------------------
REM Copy new transforms from data -> docs
REM ------------------------------------------------------------

echo.
echo [2/4] Updating docs transforms...

set /a UPDATED=0
set /a MISSING=0

for /d %%D in ("%SRC%\*") do (

    set "SLIDE=%%~nxD"
    set "TF=%%D\transform_registered.json"
    set "DOCSDIR=%DST%\!SLIDE!"

    if exist "!TF!" (

        if exist "!DOCSDIR!" (

            copy /Y ^
            "!TF!" ^
            "!DOCSDIR!\transform_registered.json" >nul

            echo   UPDATED !SLIDE!
            set /a UPDATED+=1

        ) else (

            echo   [SKIP] no docs folder: !SLIDE!
        )

    ) else (

        echo   [NO TRANSFORM] !SLIDE!
        set /a MISSING+=1
    )
)

REM ------------------------------------------------------------
REM Validate transforms
REM ------------------------------------------------------------

echo.
echo [3/4] Checking docs transform files...

for /d %%D in ("%DST%\*") do (

    if exist "%%D\transform_registered.json" (
        echo   OK %%~nxD
    )
)

REM ------------------------------------------------------------
REM Regenerate slides.json / manifest
REM ------------------------------------------------------------

echo.
echo [4/4] Updating manifest...

if exist "%MANIFEST%" (

    cd /d "%ROOT%"

    python generate_manifest.py

    if errorlevel 1 (
        echo.
        echo [WARNING] generate_manifest.py returned an error.
    ) else (
        echo   Manifest updated.
    )

) else (

    echo [WARNING] generate_manifest.py not found.
)

echo.
echo ============================================================
echo DONE
echo Updated transforms: %UPDATED%
echo Missing transforms: %MISSING%
echo Backup folder:
echo %BACKUP%
echo ============================================================
echo.

pause