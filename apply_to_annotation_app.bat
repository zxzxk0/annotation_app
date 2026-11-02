@echo off
setlocal
set "APP=C:\Users\zxzxk\Downloads\annotation_app"
set "HERE=%~dp0"

if not exist "%APP%\docs" (
  echo [ERROR] annotation_app docs folder not found.
  pause
  exit /b 1
)

if not exist "%APP%\_gene_fix_backup" mkdir "%APP%\_gene_fix_backup"

copy /Y "%APP%\docs\viewer.js" "%APP%\_gene_fix_backup\viewer.js" >nul
copy /Y "%APP%\docs\slides.json" "%APP%\_gene_fix_backup\slides.json" >nul

copy /Y "%HERE%docs\viewer.js" "%APP%\docs\viewer.js" >nul
copy /Y "%HERE%docs\slides.json" "%APP%\docs\slides.json" >nul
copy /Y "%HERE%make_gene_json.py" "%APP%\make_gene_json.py" >nul

cd /d "%APP%"

echo.
echo [1/2] Rebuilding gene JSON files...
python make_gene_json.py
if errorlevel 1 (
  echo [ERROR] JSON rebuild failed.
  pause
  exit /b 1
)

echo.
echo [2/2] Ready to commit.
echo.
echo git add docs\viewer.js docs\slides.json docs\data\gene_expression\PreSCCT1_HE.ome make_gene_json.py
echo git commit -m "Rebuild gene polygons and fix static renderer"
echo git push
echo.
pause
