@echo off
REM Defect Tracking System - One Command Startup
REM Usage: run.bat

setlocal enabledelayedexpansion

REM Set paths
set "JAVA_HOME=C:\Program Files\Java\jdk-21"
set "MAVEN_HOME=C:\Users\amlan\.maven\maven-3.9.14"
set "TOMCAT_HOME=C:\Users\amlan\Downloads\apache-tomcat-11.0.10-windows-x64\apache-tomcat-11.0.10"
set "APP_PORT=8081"
set "PATH=%JAVA_HOME%\bin;%PATH%"

echo.
echo ============================================
echo  Defect Tracking System - Startup
echo ============================================
echo.

REM Kill any existing Java process on port 8080
echo [1/4] Stopping any existing server...
taskkill /F /IM java.exe >nul 2>&1
taskkill /F /IM javaw.exe >nul 2>&1
timeout /t 2 /nobreak >nul

REM Build project
echo [2/4] Building project...
cd /d "%~dp0"
call "%MAVEN_HOME%\bin\mvn.cmd" clean package -q
if errorlevel 1 (
    echo ERROR: Build failed!
    exit /b 1
)

REM Deploy to Tomcat
echo [3/4] Deploying to Tomcat...
copy /Y "target\defect-tracking-system.war" "%TOMCAT_HOME%\webapps\" >nul
if errorlevel 1 (
    echo ERROR: Deployment failed!
    exit /b 1
)

REM Start Tomcat
echo [4/4] Starting Tomcat...
set "CATALINA_HOME=%TOMCAT_HOME%"
set "CATALINA_BASE=%TOMCAT_HOME%"
call "%TOMCAT_HOME%\bin\startup.bat"

echo.
echo ============================================
echo  Server Starting...
echo  Waiting 6 seconds for startup...
echo ============================================
echo.
timeout /t 6 /nobreak >nul

REM Test if server is running (with retry)
set "retry_count=0"
:retry_port_check
netstat -ano | findstr ":%APP_PORT%" >nul
if errorlevel 1 (
    if !retry_count! lss 5 (
        set /a retry_count=!retry_count!+1
        echo Waiting for port %APP_PORT%... Attempt !retry_count!/5
        timeout /t 3 /nobreak >nul
        goto retry_port_check
    )
    echo.
    echo ERROR: Server failed to start on port %APP_PORT%
    echo.
    echo Troubleshooting:
    echo - Another Java/Tomcat process may be running
    echo - Run: taskkill /F /IM java.exe
    echo - Then try again
    exit /b 1
)

REM Validate web app endpoint readiness
set "app_retry=0"
:retry_app_check
set "HTTP_CODE="
for /f %%H in ('curl.exe -s -o NUL -w "%%{http_code}" http://localhost:%APP_PORT%/defect-tracking-system/') do set "HTTP_CODE=%%H"

if "%HTTP_CODE%"=="200" goto app_ready
if "%HTTP_CODE%"=="302" goto app_ready
if "%HTTP_CODE%"=="401" goto app_ready
if "%HTTP_CODE%"=="403" goto app_ready

if %app_retry% lss 10 (
    set /a app_retry=%app_retry%+1
    echo Waiting for app endpoint... Attempt %app_retry%/10
    timeout /t 2 /nobreak >nul
    goto retry_app_check
)

echo.
echo WARNING: App endpoint did not report ready yet.
echo Last HTTP status: %HTTP_CODE%
echo Opening browser anyway. If page is not ready yet, wait 10-20 seconds and refresh.

:app_ready
echo.
echo ============================================
echo  Opening browser
echo  URL: http://localhost:%APP_PORT%/defect-tracking-system/
echo ============================================
echo.
start "" "http://localhost:%APP_PORT%/defect-tracking-system/"
echo Browser open request sent.
echo.
echo Demo Accounts:
echo   Admin:    admin@dts.com / admin123
echo   Tester:   tester@dts.com / test123
echo   Developer: dev@dts.com / dev123
echo   PM:       pm@dts.com / pm123
echo.
echo To stop the server, press Ctrl+C in the Tomcat window or:
echo   taskkill /F /IM java.exe
echo.
exit /b 0
