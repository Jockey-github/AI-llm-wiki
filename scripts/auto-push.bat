@echo off
chcp 65001 >nul
setlocal

set "REPO_DIR=D:\AI\我的AI知识库\AI-llm-wiki"
set "LOG_FILE=%REPO_DIR%\scripts\push.log"

echo [%date% %time%] === Auto Push Start === >> "%LOG_FILE%"

cd /d "%REPO_DIR%"
if errorlevel 1 (
    echo [%date% %time%] ERROR: Cannot cd to repo dir >> "%LOG_FILE%"
    goto :end
)

:: Check if there are any changes
git status --porcelain > nul 2>&1
for /f %%i in ('git status --porcelain') do (
    goto :has_changes
)

echo [%date% %time%] No changes detected, skip push. >> "%LOG_FILE%"
goto :end

:has_changes
:: Stage all changes
git add -A

:: Commit with timestamp
set "MSG=auto-sync: %date:~0,4%-%date:~5,2%-%date:~8,2% %time:~0,2%:%time:~3,2%"
git commit -m "%MSG%"

if errorlevel 1 (
    echo [%date% %time%] ERROR: Commit failed >> "%LOG_FILE%"
    goto :end
)

:: Push to remote
git push origin main

if errorlevel 1 (
    echo [%date% %time%] ERROR: Push failed >> "%LOG_FILE%"
    goto :end
)

echo [%date% %time%] Push success: %MSG% >> "%LOG_FILE%"

:end
echo [%date% %time%] === Auto Push End === >> "%LOG_FILE%"
endlocal
