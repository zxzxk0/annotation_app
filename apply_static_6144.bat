@echo off
setlocal

set "APP=C:\Users\zxzxk\Downloads\annotation_app"
set "HERE=%~dp0"

if not exist "%APP%\docs\viewer.js" (
  echo [ERROR] %APP%\docs\viewer.js not found
  pause
  exit /b 1
)

if not exist "%APP%\_static_6144_backup" mkdir "%APP%\_static_6144_backup"

copy /Y "%APP%\docs\viewer.js" "%APP%\_static_6144_backup\viewer.js" >nul
copy /Y "%HERE%docs\viewer.js" "%APP%\docs\viewer.js" >nul

echo.
echo Static gene overlay upgraded to 6144px width.
echo Backup:
echo %APP%\_static_6144_backup\viewer.js
echo.
echo Next:
echo   cd /d %APP%
echo   git add docs\viewer.js
echo   git commit -m "Increase gene overlay static resolution to 6144"
echo   git push
echo.
pause
