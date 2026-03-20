# Defect Tracking System - One Command Startup
# Usage: .\run.ps1

$JAVA_HOME = "C:\Program Files\Java\jdk-21"
$MAVEN_HOME = "C:\Users\amlan\.maven\maven-3.9.14"
$TOMCAT_HOME = "C:\Users\amlan\Downloads\apache-tomcat-11.0.10-windows-x64\apache-tomcat-11.0.10"
$env:JAVA_HOME = $JAVA_HOME
$env:Path = "$JAVA_HOME\bin;$env:Path"

Write-Host "`n============================================"
Write-Host " Defect Tracking System - Startup"
Write-Host "============================================`n"

# Kill existing Java
Write-Host "[1/4] Stopping any existing server..."
Stop-Process -Name java -Force -ErrorAction SilentlyContinue
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
& cmd /c "$TOMCAT_HOME\bin\startup.bat"

Write-Host "`n============================================"
Write-Host " Server Starting..."
Write-Host " Waiting 6 seconds for startup..."
Write-Host "============================================`n"
Start-Sleep -Seconds 6

# Verify port
$port = netstat -ano | Select-String ":8080"
if (!$port) {
    Write-Host "`nERROR: Server failed to start on port 8080"
    exit 1
}

Write-Host "`n============================================"
Write-Host " SUCCESS! Server is running"
Write-Host " URL: http://localhost:8080/defect-tracking-system/"
Write-Host "============================================`n"
Write-Host "Demo Accounts:"
Write-Host "  Admin:     admin@dts.com / admin123"
Write-Host "  Tester:    tester@dts.com / test123"
Write-Host "  Developer: dev@dts.com / dev123"
Write-Host "  PM:        pm@dts.com / pm123"
Write-Host "`nTo stop: Close Tomcat window or run: Stop-Process -Name java -Force`n"
