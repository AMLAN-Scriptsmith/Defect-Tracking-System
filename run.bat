@echo off
REM Defect Tracking System - One Command Startup
REM Usage: run.bat

setlocal enabledelayedexpansion

REM Set paths
set "JAVA_HOME=C:\Program Files\Java\jdk-21"
set "MAVEN_HOME=C:\Users\amlan\.maven\maven-3.9.14"
set "TOMCAT_HOME=C:\Users\amlan\Downloads\apache-tomcat-11.0.10-windows-x64\apache-tomcat-11.0.10"
set "PATH=%JAVA_HOME%\bin;%PATH%"

echo.
echo ============================================
echo  Defect Tracking System - Startup
echo ============================================
echo.

REM Kill any existing Java process on port 8080
echo [1/4] Stopping any existing server...
taskkill /F /IM java.exe >nul 2>&1
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
netstat -ano | findstr ":8080" >nul
if errorlevel 1 (
    if !retry_count! lss 5 (
        set /a retry_count=!retry_count!+1
        echo Waiting for port 8080... Attempt !retry_count!/5
        timeout /t 3 /nobreak >nul
        goto retry_port_check
    )
    echo.
    echo ERROR: Server failed to start on port 8080
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
for /f %%H in ('curl.exe -s -o NUL -w "%%{http_code}" http://localhost:8080/defect-tracking-system/health') do set "HTTP_CODE=%%H"

if "%HTTP_CODE%"=="200" goto app_ready

if %app_retry% lss 10 (
    set /a app_retry=%app_retry%+1
    echo Waiting for health endpoint... Attempt %app_retry%/10
    timeout /t 2 /nobreak >nul
    goto retry_app_check
)

echo.
echo ERROR: Tomcat started but app is not ready yet.
echo Last HTTP status from health endpoint: %HTTP_CODE%
echo You can retry in browser after 10-20 seconds:
echo   http://localhost:8080/defect-tracking-system/
exit /b 1

:app_ready
echo.
echo ============================================
echo  SUCCESS! Server is running
echo  URL: http://localhost:8080/defect-tracking-system/
echo ============================================
echo.
start "" "http://localhost:8080/defect-tracking-system/"
echo Browser opened.
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
