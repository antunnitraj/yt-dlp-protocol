# Creating some variables
param($url)
$url = $url -replace "^yt-dlp://", ""
$thing = '"%(title)s.%(ext)s"'
$pwd = "$env:APPDATA\yt-dlp"

# Initiating the form
Add-Type -AssemblyName System.Windows.Forms
$folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
$folderBrowser.Description = "Select a folder to save this media:"

# Handling the data
if ($folderBrowser.ShowDialog() -eq "OK") {
    # Getting the selected path to save media to
    $selectedFolder = $folderBrowser.SelectedPath

    # Getting the name of media
    $fileName = Invoke-Expression -Command "$pwd\yt-dlp.exe $url --print filename -o $thing --restrict-filenames"

    #Downloading the media
    Invoke-Expression -Command "$pwd\yt-dlp.exe $url -o $fileName --restrict-filenames -P $selectedFolder\"

    # Ask user if they want to fix their media?
    $action = Read-Host "Fix media with ffmpeg? (y/N)"
    if ($action.ToLower() -eq "y") {
        # Renaming the media to temp.(extension)
        $extension = [System.IO.Path]::GetExtension($filename)
        $fileNameTemp = "temp$extension"
        Rename-Item -Path $selectedFolder\$fileName -NewName $selectedFolder\$fileNameTemp

        # Converting using ffmpeg and deleting the temporary file
        Invoke-Expression -Command "$pwd\ffmpeg.exe -y -i $selectedFolder\$fileNameTemp $selectedFolder\$fileName"
        Remove-Item -Path "$selectedFolder\$fileNameTemp"

        Write-Host "Fix done"
    } else {
        Write-Host "Skipping the fix"
    }
}