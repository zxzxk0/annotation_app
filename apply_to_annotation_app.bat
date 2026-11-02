@echo off
setlocal
set "APP=C:\Users\zxzxk\Downloads\annotation_app"
set "HERE=%~dp0"

if not exist "%APP%\docs" (
  echo [ERROR] %APP%\docs not found
  pause
  exit /b 1
)

if not exist "%APP%\_patch_backup" mkdir "%APP%\_patch_backup"

copy /Y "%APP%\docs\viewer.js" "%APP%\_patch_backup\viewer.js" >nul
copy /Y "%APP%\docs\slides.json" "%APP%\_patch_backup\slides.json" >nul

copy /Y "%HERE%docs\viewer.js" "%APP%\docs\viewer.js" >nul
copy /Y "%HERE%docs\slides.json" "%APP%\docs\slides.json" >nul
copy /Y "%HERE%lock_generate_manifest_to_prescct1.py" "%APP%\lock_generate_manifest_to_prescct1.py" >nul

cd /d "%APP%"
python lock_generate_manifest_to_prescct1.py

echo.
echo [CHECK] slide count:
findstr /N /I "\"id\"" docs\slides.json
echo.
echo [CHECK] registered DZI references should be empty:
findstr /N /I "_registered.dzi" docs\slides.json
echo.
echo Done.
echo Next:
echo git add docs\viewer.js docs\slides.json generate_manifest.py
echo git commit -m "Fix PreSCCT1 overlay and keep single slide"
echo git push
pause
