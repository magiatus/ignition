# Ignition — Ein-Klick-Planet-Host.
# Legt dieses Skript neben die entpackten Server-Dateien (dort wo der Ordner "Ignition\"
# mit Binaries\Win64\Ignition.exe liegt), dazu deine world.json (+ optional world.lua),
# und starte es per Rechtsklick -> "Mit PowerShell ausfuehren" (oder start-planet.bat doppelklicken).
#
# Es oeffnet den UDP-Port (einmalig, mit Admin-Rechten) und startet deinen Planeten headless.

param(
  [int]$Port = 7777,
  [int]$Seed = 0,                    # 0 = Seed/Deskriptor aus world.json
  [string]$WorldConfig = "",         # leer = world.json neben der Exe
  [string]$WorldScript = ""          # leer = world.lua neben der Exe (falls vorhanden)
)

$ErrorActionPreference = "Stop"
$here = Split-Path -Parent $MyInvocation.MyCommand.Path

# 1) Server-Exe finden (die INNERE Exe, nicht der Bootstrapper).
$exe = Get-ChildItem -Path $here -Recurse -Filter "Ignition.exe" -ErrorAction SilentlyContinue |
       Where-Object { $_.FullName -match "Binaries\\Win64\\Ignition\.exe$" } |
       Select-Object -First 1 -ExpandProperty FullName
if (-not $exe) {
  Write-Host "FEHLER: Ignition\Binaries\Win64\Ignition.exe nicht gefunden." -ForegroundColor Red
  Write-Host "Lege dieses Skript in den entpackten Server-Ordner." -ForegroundColor Yellow
  Read-Host "Enter zum Schliessen"; exit 1
}

# 2) Welt-Dateien.
if (-not $WorldConfig) { $wc = Join-Path $here "world.json" } else { $wc = $WorldConfig }
if (-not (Test-Path $wc)) {
  Write-Host "FEHLER: world.json nicht gefunden ($wc)." -ForegroundColor Red
  Write-Host "Nimm eine Vorlage aus dem Starter-Kit: https://github.com/magiatus/ignition/tree/main/worlds" -ForegroundColor Yellow
  Read-Host "Enter zum Schliessen"; exit 1
}
if (-not $WorldScript) {
  $ws = Join-Path $here "world.lua"
  if (-not (Test-Path $ws)) { $ws = "" }
} else { $ws = $WorldScript }

# 3) Firewall-Regel (braucht Admin -> bei Bedarf selbst elevieren, nur fuer diesen Schritt).
$ruleName = "Ignition UDP $Port"
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
if (-not (Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue)) {
  if ($isAdmin) {
    New-NetFirewallRule -DisplayName $ruleName -Direction Inbound -Action Allow -Protocol UDP -LocalPort $Port | Out-Null
    Write-Host "Firewall: UDP $Port geoeffnet." -ForegroundColor Green
  } else {
    Write-Host "Oeffne Firewall-Port $Port (einmalig, Admin-Abfrage) ..." -ForegroundColor Yellow
    Start-Process powershell -Verb RunAs -Wait -ArgumentList @(
      "-NoProfile","-Command",
      "New-NetFirewallRule -DisplayName '$ruleName' -Direction Inbound -Action Allow -Protocol UDP -LocalPort $Port | Out-Null"
    )
  }
}

# 4) Start (headless). Fenster bleibt offen = Server laeuft; schliessen = Server stoppt.
$argList = @("/Game/PlanetTest?listen", "-nullrhi", "-nosound", "-unattended", "-log",
          "-Port=$Port", "-WorldConfig=`"$wc`"")
if ($Seed -ne 0) { $argList += "-PlanetSeed=$Seed" }
if ($ws)         { $argList += "-WorldScript=`"$ws`"" }

Write-Host ""
Write-Host "  IGNITION-PLANET STARTET" -ForegroundColor Cyan
Write-Host "  Welt : $wc"
if ($ws) { Write-Host "  Lua  : $ws" }
Write-Host "  Port : UDP $Port"
Write-Host "  Trag deine Adresse ins Verzeichnis ein: PR gegen planets.json"
Write-Host "  (Fenster offen lassen = laeuft. Zum Beenden schliessen.)" -ForegroundColor DarkGray
Write-Host ""

& $exe @args
