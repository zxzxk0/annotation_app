@echo off
setlocal
set "APP=C:\Users\zxzxk\Downloads\annotation_app"
set "HERE=%~dp0"

if not exist "%APP%\docs\viewer.js" (
  echo [ERROR] %APP%\docs\viewer.js not found
  pause
  exit /b 1
)

if not exist "%APP%\_debug_backup" mkdir "%APP%\_debug_backup"
copy /Y "%APP%\docs\viewer.js" "%APP%\_debug_backup\viewer.js" >nul
copy /Y "%HERE%docs\viewer.js" "%APP%\docs\viewer.js" >nul

echo viewer.js replaced.
echo Backup: %APP%\_debug_backup\viewer.js
echo.
echo Next:
echo   cd /d %APP%
echo   git add docs\viewer.js
echo   git commit -m "Add chunked gene overlay renderer and debug stats"
echo   git push
pause
