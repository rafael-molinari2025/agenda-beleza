@echo off
title Belle-Agenda · Servidor Local
color 0B
echo.
echo  =============================================
echo   Belle-Agenda - Iniciando servidor local...
echo  =============================================
echo.
echo  Aguarde o navegador abrir automaticamente.
echo  Mantenha esta janela aberta enquanto usar.
echo.
cd /d "%~dp0"
start "" "http://localhost:3000/login.html"
npx --yes http-server . -p 3000 -c-1 --cors
pause
