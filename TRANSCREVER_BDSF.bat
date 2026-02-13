@echo off
chcp 65001 >nul
title Transcritor Áudio - Biblioteca do Senado Federal
color 07

:MENU
cls
echo ============================================================
echo   TRANSCRITOR DE ÁUDIO - BIBLIOTECA DO SENADO FEDERAL
echo ============================================================
echo.
echo   [1] Transcrever SOMENTE 1 ARQUIVO
echo   [2] Transcrever TODOS OS ARQUIVOS
echo   [3] Sair
echo.
choice /c 123 /n /m "Escolha uma opção (1, 2 ou 3): "

if errorlevel 3 exit
if errorlevel 2 goto TODOS
if errorlevel 1 goto UM

:UM
cls
echo ============================================================
echo   TRANSCREVER 1 ARQUIVO
echo ============================================================
echo.
echo Coloque seu áudio na pasta "audios" e digite o nome:
echo   Exemplo: lei.mp3
echo.
set /p ARQ="Nome do arquivo: "
if not exist "audios\%ARQ%" (
    echo.
    echo ❌ Arquivo nao encontrado: %ARQ%
    echo Verifique o nome e tente novamente.
    pause
    goto MENU
)
echo.
echo ⏳ Transcrevendo... Aguarde (pode demorar alguns minutos)
venv\Scripts\python.exe transcrever.py "audios\%ARQ%"
echo.
echo ✅ Concluido! Verifique a pasta "transcricoes"
pause
goto MENU

:TODOS
cls
echo ============================================================
echo   TRANSCREVER TODOS OS ARQUIVOS
echo ============================================================
echo.
echo Serão transcritos TODOS os arquivos da pasta "audios".
echo.
choice /c SN /n /m "Deseja continuar? (S/N): "
if errorlevel 2 goto MENU
echo.
echo ⏳ Processando... Aguarde (pode demorar varios minutos)
venv\Scripts\python.exe transcrever_todos.py
echo.
echo ✅ Concluido! Verifique a pasta "transcricoes"
pause
goto MENU