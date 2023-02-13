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

v0.1.0
A youtube-dl fork with additional features and fixes
Installer made by Antun Nitraj on github.com/antunnitraj
-----------------------------------------------------------

"@

# Let user appreciate the art
Start-Sleep -Seconds 1

# Testing if folder exists and if not make it
if (-not (Test-Path $folderPath)) {
    New-Item -ItemType Directory -Path $folderPath | Out-Null
    Write-Host "Created directory: $folderPath"
} else {
    Write-Host "Directory already exists: $folderPath"
}

# Downloading yt-dlp
Write-Host "Downloading yt-dlp to: $folderPath\yt-dlp.exe"
Invoke-WebRequest -Uri "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe" -OutFile "$folderPath\yt-dlp.exe"

# Downloading ffmpeg
Write-Host "Downloading ffmpeg to: $folderPath\ffmpeg.zip"
Invoke-WebRequest -Uri "https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-lgpl-shared.zip" -OutFile "$folderPath\ffmpeg.zip"
Write-Host "Unzipping ffmpeg.zip"
Expand-Archive -Path "$folderPath\ffmpeg.zip" -DestinationPath "$folderPath"
Write-Host "Copying ffmpeg binraies to: $folderPath"
Copy-Item -Path "$folderPath\ffmpeg-master-latest-win64-lgpl-shared\bin\*" -Destination "$folderPath\" -Recurse
Write-Host "Removing ffmpeg-master-latest-win64-lgpl-shared\ and ffmpeg.zip"
Remove-Item "$folderPath\ffmpeg-master-latest-win64-lgpl-shared" -Recurse | Out-Null
Remove-Item "$folderPath\ffmpeg.zip" -Recurse | Out-Null

# Downloading script
Write-Host "Downloading script to: $folderPath\yt-dlp.ps1"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/antunnitraj/yt-dlp-protocol/main/yt-dlp.ps1" -OutFile "$folderPath\yt-dlp.ps1"
Write-Host "Downloads finished successfully!"

# Creating the custom yt-dlp protocol
New-Item -Path "Registry::HKEY_CURRENT_USER\SOFTWARE\Classes\$protocolName\shell\open\" -Name "command" -Force | Out-Null
New-ItemProperty -Path "Registry::HKEY_CURRENT_USER\SOFTWARE\Classes\$protocolName" -Name "(Default)" -Value "URL: $protocolName Protocol" -Force | Out-Null
New-ItemProperty -Path "Registry::HKEY_CURRENT_USER\SOFTWARE\Classes\$protocolName" -Name "URL Protocol" -Force | Out-Null
New-ItemProperty -Path "Registry::HKEY_CURRENT_USER\SOFTWARE\Classes\$protocolName\shell\open\command" -Name "(Default)" -Value "powershell $folderPath\yt-dlp.ps1 %1" -Force | Out-Null
Write-Host "Created protocol: $protocolName"

# The installer is done
Write-Host "Installer has finished successfully!"
