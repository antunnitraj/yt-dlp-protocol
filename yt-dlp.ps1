# Creating some variables
param($url)
$url = $url -replace "^yt-dlp://", ""
$thing = '"%(title)s.%(ext)s"'

# Initiating the form
Add-Type -AssemblyName System.Windows.Forms
$folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
$folderBrowser.Description = "Select a folder to save this media:"

# Handling the data
if ($folderBrowser.ShowDialog() -eq "OK") {
    $selectedFolder = $folderBrowser.SelectedPath
    Invoke-Expression -Command "$env:APPDATA\yt-dlp\yt-dlp.exe $url -o $thing --restrict-filenames -P $selectedFolder"
}