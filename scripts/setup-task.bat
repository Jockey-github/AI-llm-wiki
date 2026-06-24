@echo off
chcp 65001 >nul
schtasks /create /tn "AI-Wiki-AutoPush" /tr "D:\AI\我的AI知识库\AI-llm-wiki\scripts\auto-push.bat" /sc daily /st 17:50 /f
pause
