@echo off
chcp 65001 >nul
title Instalação do Transcritor - Biblioteca do Senado Federal
color 07

setlocal
set "BASE_DIR=%~dp0"
set "BASE_DIR=%BASE_DIR:~0,-1%"
set "VENV_DIR=%BASE_DIR%\venv"
set "VENV_PYTHON=%VENV_DIR%\Scripts\python.exe"
set "TEMP_DIR=%BASE_DIR%\temp_bdsf"

:: Criar pasta temporária própria (evita AppData restrito)
if not exist "%TEMP_DIR%" mkdir "%TEMP_DIR%" 2>nul
set "TEMP=%TEMP_DIR%"
set "TMP=%TEMP_DIR%"

cls
echo ============================================================
echo   INSTALAÇÃO DO TRANSCRITOR DE ÁUDIO
echo   Biblioteca do Senado Federal - BDSF
echo ============================================================
echo.

:: ============================================================================
:: VERIFICAR SE PYTHON ESTÁ INSTALADO NO SISTEMA
:: ============================================================================
echo [1/4] Verificando Python no sistema...
where python >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo ❌ Python não encontrado no sistema.
    echo.
    echo SOLUÇÃO:
    echo   1. Baixe Python 3.10+ em: https://python.org/downloads
    echo   2. Execute o instalador
    echo   3. ✅ MARQUE "Add Python to PATH" durante a instalação
    echo   4. Clique em "Install Now"
    echo   5. Após instalado, execute este script novamente
    echo.
    pause
    exit /b 1
)
for /f "tokens=2*" %%a in ('python --version 2^>^&1') do set "PY_VER=%%a"
echo    ✅ Python %PY_VER% encontrado
echo.

:: ============================================================================
:: CRIAR AMBIENTE VIRTUAL SE NÃO EXISTIR
:: ============================================================================
echo [2/4] Criando ambiente virtual isolado...
if not exist "%VENV_DIR%" (
    python -m venv "%VENV_DIR%" >nul 2>&1
    if %errorlevel% neq 0 (
        echo    ❌ Falha ao criar ambiente virtual.
        echo    Execute este script como Administrador ou contate a TI.
        pause
        exit /b 1
    )
)
echo    ✅ Ambiente virtual criado em: %VENV_DIR%
echo.

:: ============================================================================
:: INSTALAR DEPENDÊNCIAS NO VENV
:: ============================================================================
echo [3/4] Instalando faster-whisper e dependências (~500 MB)...
echo    ⏳ Aguarde - download em andamento (requer internet)...
echo.

"%VENV_PYTHON%" -m pip install --upgrade pip --no-cache-dir --disable-pip-version-check -q
"%VENV_PYTHON%" -m pip install faster-whisper torch --no-cache-dir --disable-pip-version-check -q

if %errorlevel% neq 0 (
    echo    ⚠️  Tentativa alternativa (sem cache)...
    "%VENV_PYTHON%" -m pip install faster-whisper torch --no-deps --no-cache-dir -q
    "%VENV_PYTHON%" -m pip install ctranslate2 --no-cache-dir -q
    "%VENV_PYTHON%" -m pip install torch --index-url https://download.pytorch.org/whl/cpu --no-cache-dir -q
)

echo    ✅ faster-whisper instalado com sucesso
echo.

:: ============================================================================
:: VERIFICAR INSTALAÇÃO E FINALIZAR
:: ============================================================================
echo [4/4] Verificando instalação...
"%VENV_PYTHON%" -c "from faster_whisper import WhisperModel; print('✅ Ambiente BDSF configurado com sucesso!')" 2>nul
if %errorlevel% neq 0 (
    echo.
    echo ❌ FALHA NA VERIFICAÇÃO
    echo.
    echo Possíveis causas:
    echo   • Firewall corporativo bloqueando PyPI
    echo   • Conexão instável com internet
    echo   • Restrições de segurança do ambiente
    echo.
    echo Solução: Contate a Biblioteca Digital do Senado Federal
    echo.
    pause
    exit /b 1
)

:: Criar pastas de trabalho
if not exist "%BASE_DIR%\audios" mkdir "%BASE_DIR%\audios" >nul 2>&1
if not exist "%BASE_DIR%\transcricoes" mkdir "%BASE_DIR%\transcricoes" >nul 2>&1

:: Limpar pasta temporária
rmdir /s /q "%TEMP_DIR%" 2>nul

cls
echo ============================================================
echo   ✅ INSTALAÇÃO CONCLUÍDA COM SUCESSO!
echo   Biblioteca do Senado Federal - BDSF
echo ============================================================
echo.
echo RESUMO:
echo   • Ambiente virtual configurado em: %VENV_DIR%
echo   • faster-whisper instalado e validado
echo   • Pastas de trabalho preparadas
echo.
echo PRÓXIMOS PASSOS:
echo   1. Coloque seus áudios (.mp3, .wav) na pasta "audios"
echo   2. Execute "TRANSCREVER_BDSF.bat" para transcrever
echo   3. Os resultados serão salvos na pasta "transcricoes"
echo.
echo CARACTERÍSTICAS:
echo   ✅ 100%% offline após esta instalação
echo   ✅ Sem limites de tempo ou volume
echo   ✅ Totalmente privado — nada vai para a nuvem
echo   ✅ Autor identificado: "Biblioteca do Senado Federal"
echo.
echo NOTA: Esta instalação foi feita UMA ÚNICA VEZ.
echo       O uso diário NÃO requer administrador nem internet.
echo.
pause