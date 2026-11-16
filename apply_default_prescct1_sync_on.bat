@echo off
setlocal

set "APP=C:\Users\zxzxk\Downloads\annotation_app"
set "HERE=%~dp0"

if not exist "%APP%\docs\viewer.js" (
  echo [ERROR] %APP%\docs\viewer.js not found
  pause
  exit /b 1
)

if not exist "%APP%\_default_settings_backup" mkdir "%APP%\_default_settings_backup"

copy /Y "%APP%\docs\viewer.js" "%APP%\_default_settings_backup\viewer.js" >nul
copy /Y "%APP%\docs\index.html" "%APP%\_default_settings_backup\index.html" >nul

copy /Y "%HERE%docs\viewer.js" "%APP%\docs\viewer.js" >nul
copy /Y "%HERE%docs\index.html" "%APP%\docs\index.html" >nul

echo.
echo Default settings applied:
echo   - PreSCCT1_HE.ome loads automatically
echo   - Sync defaults to ON
echo.
echo Backup:
echo   %APP%\_default_settings_backup
echo.
echo Next:
echo   cd /d %APP%
echo   git add docs\viewer.js docs\index.html
echo   git commit -m "Set default slide and enable sync by default"
echo   git push
echo.
pause
