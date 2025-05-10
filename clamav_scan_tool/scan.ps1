param (
    [string]$ScanTarget
)

$clamPath = "C:\Program Files\ClamAV\clamdscan.exe"
$outputTxt = "$env:TEMP\clamav_output.txt"
$outputHtml = "$env:USERPROFILE\Desktop\clamav_report.html"
$iconPath = Join-Path -Path $PSScriptRoot -ChildPath "assets"

$files = Get-ChildItem -Path $ScanTarget -Recurse -File
$total = $files.Count
$i = 0
"" | Set-Content $outputTxt

foreach ($file in $files) {
    $i++
    $percent = [math]::Round(($i / $total) * 100)
    Write-Progress -Activity "Scanning Files" -Status "$($file.Name)" -PercentComplete $percent
    Write-Host "Scanning: $($file.FullName)"

    $result = & "$clamPath" --fdpass --no-summary --infected "$($file.FullName)"
    if ($result) {
        Add-Content -Path $outputTxt -Value $result
        Write-Host "⚠️  Detected: $result" -ForegroundColor Red
    } else {
        Add-Content -Path $outputTxt -Value "$($file.FullName): OK"
    }
}

Write-Host "`nGenerating HTML report..."
$lines = Get-Content $outputTxt
$body = ""

foreach ($line in $lines) {
    if ($line -match "FOUND$") {
        $parts = $line -split ":"
        $filePath = $parts[0].Trim()
        $signature = ($parts[1] -replace "FOUND", "").Trim()
        if (Test-Path $filePath) {
            $hash = Get-FileHash -Algorithm SHA256 -Path $filePath | Select-Object -ExpandProperty Hash
            $vtLink = "https://www.virustotal.com/gui/file/$hash"
            $icon = "virus.png"
        } else {
            $hash = "File not found"
            $vtLink = "https://www.virustotal.com"
            $icon = "virus.png"
        }
        $clamLink = "https://www.clamav.net/about/signatures"
        $body += @"
<div class="card infected">
  <img src="assets/$icon" class="icon">
  <div>
    <strong>Infected:</strong> $filePath<br>
    Signature: <code>$signature</code><br>
    SHA256: <code>$hash</code><br>
    Links: <a href="$vtLink" target="_blank">VirusTotal</a>, 
    <a href="$clamLink" target="_blank">ClamAV</a>
  </div>
</div>
"@
    } else {
        $body += @"
<div class="card clean">
  <img src="assets/clean.png" class="icon">
  <div><strong>Clean:</strong> $line</div>
</div>
"@
    }
}

$style = @"
<style>
body { font-family:Segoe UI; background:#f9f9f9; padding:20px; }
.card { display:flex; align-items:center; background:#fff; padding:10px; margin:10px 0;
        border:1px solid #ddd; border-left:5px solid green; border-radius:8px;
        box-shadow:0 2px 4px rgba(0,0,0,0.1); }
.infected { border-left-color:red; }
.icon { width:40px; height:40px; margin-right:10px; }
code { background:#eee; padding:2px 4px; border-radius:4px; }
a { color:#007acc; text-decoration:none; }
a:hover { text-decoration:underline; }
</style>
"@

$html = "<html><head><title>ClamAV Scan Report</title>$style</head><body><h2>ClamAV Scan Report</h2>$body</body></html>"
$html | Set-Content -Path $outputHtml -Encoding UTF8

Write-Host "✅ HTML report saved to: $outputHtml"
