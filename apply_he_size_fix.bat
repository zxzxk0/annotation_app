@echo off
setlocal

set "APP=C:\Users\zxzxk\Downloads\annotation_app"
set "HERE=%~dp0"

if not exist "%APP%\docs\viewer.js" (
  echo [ERROR] %APP%\docs\viewer.js not found
  pause
  exit /b 1
)

if not exist "%APP%\_he_size_fix_backup" mkdir "%APP%\_he_size_fix_backup"

copy /Y "%APP%\docs\viewer.js" "%APP%\_he_size_fix_backup\viewer.js" >nul
copy /Y "%HERE%docs\viewer.js" "%APP%\docs\viewer.js" >nul

echo.
echo H&E original-size fix applied.
echo Backup:
echo %APP%\_he_size_fix_backup\viewer.js
echo.
echo Next:
echo   cd /d %APP%
echo   git add docs\viewer.js
echo   git commit -m "Fix H&E original size for gene overlay"
echo   git push
echo.
pause
