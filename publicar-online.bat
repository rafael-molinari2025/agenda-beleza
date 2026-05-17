@echo off
title Belle-Agenda · Publicar Online
color 0A
echo.
echo  =============================================
echo   Belle-Agenda - Publicar no Firebase
echo  =============================================
echo.
echo  PASSO 1: Vamos fazer login no Firebase.
echo  O navegador vai abrir automaticamente.
echo  Faca login com sua conta Google e clique em "Permitir".
echo.
pause
cd /d "%~dp0"
call npx firebase-tools login

echo.
echo  PASSO 2: Publicando o sistema online...
echo.
call npx firebase-tools deploy --project bella-agenda-226f0

echo.
echo  =============================================
echo   PRONTO! Sistema publicado!
echo.
echo   Acesse em qualquer dispositivo:
echo   https://bella-agenda-226f0.web.app
echo.
echo   Ou pelo link alternativo:
echo   https://bella-agenda-226f0.firebaseapp.com
echo  =============================================
echo.
pause
