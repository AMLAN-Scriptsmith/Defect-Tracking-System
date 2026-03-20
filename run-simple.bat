@echo off
REM Simple Defect Tracking System Startup - Step by step

setlocal enabledelayedexpansion

set "JAVA_HOME=C:\Program Files\Java\jdk-21"
set "MAVEN_HOME=C:\Users\amlan\.maven\maven-3.9.14"
set "TOMCAT_HOME=C:\Users\amlan\Downloads\apache-tomcat-11.0.10-windows-x64\apache-tomcat-11.0.10"
set "PATH=%JAVA_HOME%\bin;%PATH%"

echo.
echo ============================================
echo  DTS - Simple Startup
echo ============================================
echo.

REM Step 1: Kill existing Java
echo Step 1: Killing any old Java processes...
taskkill /F /IM java.exe >nul 2>&1
taskkill /F /IM javaw.exe >nul 2>&1
timeout /t 3 /nobreak >nul

echo Step 2: Building project...
cd /d "%~dp0"
call "%MAVEN_HOME%\bin\mvn.cmd" clean package -q
if errorlevel 1 (
    echo ERROR during build!
    pause
    exit /b 1
)
echo Build OK

echo Step 3: Copying WAR file...
copy /Y "target\defect-tracking-system.war" "%TOMCAT_HOME%\webapps\" >nul
echo WAR deployed

echo Step 4: Starting Tomcat (this opens in new window)...
echo.
echo Tomcat window will open - wait for startup message
echo.
timeout /t 2 /nobreak >nul

set "CATALINA_HOME=%TOMCAT_HOME%"
set "CATALINA_BASE=%TOMCAT_HOME%"
start cmd /k "%TOMCAT_HOME%\bin\startup.bat"

echo.
echo Waiting for app readiness...
set "app_retry=0"
:retry_app_check
set "HTTP_CODE="
for /f %%H in ('curl.exe -s -o NUL -w "%%{http_code}" http://localhost:8080/defect-tracking-system/index.jsp') do set "HTTP_CODE=%%H"
if "%HTTP_CODE%"=="200" goto app_ready
if "%HTTP_CODE%"=="302" goto app_ready

if %app_retry% lss 15 (
    set /a app_retry=%app_retry%+1
    echo Waiting... Attempt %app_retry%/15
    timeout /t 2 /nobreak >nul
    goto retry_app_check
)

echo.
echo ERROR: App endpoint is not ready. Last HTTP code: %HTTP_CODE%
echo Check the Tomcat window for startup errors.
pause
exit /b 1

:app_ready

echo.
echo ============================================
echo  Opening browser...  
echo ============================================
echo.

REM Open in default browser
start http://localhost:8080/defect-tracking-system/

echo.
echo Browser opened! You should see the app now.
echo.
echo If blank/error page shows:
echo  - Wait 5 more seconds and refresh (F5)
echo  - Check Tomcat window for errors
echo.
pause
