# Defect Tracking System - One Command Startup
# Usage: .\run.ps1

$JAVA_HOME = "C:\Program Files\Java\jdk-21"
$MAVEN_HOME = "C:\Users\amlan\.maven\maven-3.9.14"
$TOMCAT_HOME = "C:\Users\amlan\Downloads\apache-tomcat-11.0.10-windows-x64\apache-tomcat-11.0.10"
$APP_PORT = 8081
$env:JAVA_HOME = $JAVA_HOME
$env:Path = "$JAVA_HOME\bin;$env:Path"

Write-Host "`n============================================"
Write-Host " Defect Tracking System - Startup"
Write-Host "============================================`n"

# Kill existing Java
Write-Host "[1/4] Stopping any existing server..."
Stop-Process -Name java -Force -ErrorAction SilentlyContinue
Stop-Process -Name javaw -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2

# Build
Write-Host "[2/4] Building project..."
Set-Location (Split-Path $MyInvocation.MyCommand.Path)
& "$MAVEN_HOME\bin\mvn.cmd" clean package -q
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Build failed!"
    exit 1
}

# Deploy
Write-Host "[3/4] Deploying to Tomcat..."
Copy-Item -Path ".\target\defect-tracking-system.war" -Destination "$TOMCAT_HOME\webapps\" -Force
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Deployment failed!"
    exit 1
}

# Start Tomcat
Write-Host "[4/4] Starting Tomcat..."
$env:CATALINA_HOME = $TOMCAT_HOME
$env:CATALINA_BASE = $TOMCAT_HOME
& "$TOMCAT_HOME\bin\startup.bat"

Write-Host "`n============================================"
Write-Host " Server Starting..."
Write-Host " Waiting 6 seconds for startup..."
Write-Host "============================================`n"
Start-Sleep -Seconds 6

# Verify port
$port = netstat -ano | Select-String ":$APP_PORT"
if (!$port) {
    Write-Host "`nERROR: Server failed to start on port $APP_PORT"
    exit 1
}

# Probe app endpoint; do not fail hard if startup is still in progress.
$url = "http://localhost:$APP_PORT/defect-tracking-system/"
$ready = $false
for ($i = 1; $i -le 10; $i++) {
    try {
        $resp = Invoke-WebRequest -Uri $url -Method Get -MaximumRedirection 0 -TimeoutSec 3 -UseBasicParsing -ErrorAction Stop
        if ($resp.StatusCode -in @(200, 302, 401, 403)) {
            $ready = $true
            break
        }
    } catch {
        if ($_.Exception.Response -and [int]$_.Exception.Response.StatusCode -in @(200, 302, 401, 403)) {
            $ready = $true
            break
        }
    }

    Write-Host "Waiting for app endpoint... Attempt $i/10"
    Start-Sleep -Seconds 2
}

Write-Host "`n============================================"
if ($ready) {
    Write-Host " SUCCESS! Server is running"
} else {
    Write-Host " WARNING: App may still be starting"
}
Write-Host " URL: $url"
Write-Host "============================================`n"

Start-Process $url
Write-Host "Browser open request sent.`n"

Write-Host "Demo Accounts:"
Write-Host "  Admin:     admin@dts.com / admin123"
Write-Host "  Tester:    tester@dts.com / test123"
Write-Host "  Developer: dev@dts.com / dev123"
Write-Host "  PM:        pm@dts.com / pm123"
Write-Host "`nTo stop: Close Tomcat window or run: Stop-Process -Name java -Force`n"
