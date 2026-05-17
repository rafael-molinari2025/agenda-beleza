@echo off
title Belle-Agenda · Deploy Firebase
color 0A
echo.
echo  =============================================
echo   Belle-Agenda - Deploy Firebase Hosting
echo  =============================================
echo.
echo  Este script vai:
echo   1. Fazer login no Firebase (abre o navegador)
echo   2. Publicar o sistema online
echo.
pause

echo.
echo  [1/2] Fazendo login no Firebase...
call npx firebase-tools login

echo.
echo  [2/2] Publicando no Firebase Hosting...
call npx firebase-tools deploy --project bella-agenda-226f0

echo.
echo  =============================================
echo   PRONTO! Sistema publicado com sucesso.
echo   URL: https://bella-agenda-226f0.web.app
echo  =============================================
echo.
pause
