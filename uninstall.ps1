# Creating some variables
$protocolName = "yt-dlp"
$folderPath = "$env:APPDATA\yt-dlp"

# Clearing the screen
Clear-Host

# Printing the art
Write-Host @"

       _            _ _           ____
 _   _| |_       __| | |_ __ _   / / /
| | | | __|____ / _` | | '_ (_) / / / 
| |_| | ||_____| (_| | | |_) | / / /  
 \__, |\__|     \__,_|_| .__(_)_/_/   
 |___/                 |_| 

A youtube-dl fork with additional features and fixes
Uninstaller made by Antun Nitraj on github.com/antunnitraj
-----------------------------------------------------------

"@

# Let user appreciate the art
Start-Sleep -Seconds 1

# Testing if folder exists and delete it
if (Test-Path $folderPath) {
    Remove-Item $folderPath -Recurse | Out-Null
    Write-Host "Removed directory: $folderPath"
} else {
    Write-Host "Directory already removed: $folderPath"
}

# Removing the custom yt-dlp protocol
if (Test-Path "Registry::HKEY_CURRENT_USER\SOFTWARE\Classes\$protocolName") {
    Remove-Item -Path "Registry::HKEY_CURRENT_USER\SOFTWARE\Classes\$protocolName" -Force -Recurse | Out-Null
    Write-Host "Removed protocol: $protocolName"
} else {
    Write-Host "Protocol already removed: $folderPath"
}

# The uninstaller is done
Write-Host "Uninstaller has finished successfully!"
