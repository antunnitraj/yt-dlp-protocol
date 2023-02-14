# Creating some variables
param($url)
$thing = '"%(title)s.%(ext)s"'
$pwd = "$env:APPDATA\yt-dlp"

# Checking if argument is empty
if ($url -eq "yt-dlp:///") {
    exit
}

# Removing yt-dlp:// at the start of the argument
$url = $url -replace "^yt-dlp://", ""

# Checking if argument is url
if (-Not ($url.StartsWith('https://') -or $url.StartsWith('http://'))) {
    exit
}

# Checking and saving the file name of media
$fileName = Invoke-Expression -Command "$pwd\yt-dlp.exe $url --print filename -o $thing --restrict-filenames"
if(-not $fileName){
    exit 
}

# Printing the art
Write-Host @"
       _            _ _           ____
 _   _| |_       __| | |_ __ _   / / /
| | | | __|____ / _` | | '_ (_) / / / 
| |_| | ||_____| (_| | | |_) | / / /  
 \__, |\__|     \__,_|_| .__(_)_/_/   
 |___/                 |_| 

v0.1.2
A youtube-dl fork with additional features and fixes
Script made by Antun Nitraj on github.com/antunnitraj
-----------------------------------------------------------

"@

# Initiating the form
Add-Type -AssemblyName System.Windows.Forms
$folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
$folderBrowser.Description = "Select a folder to save this media:"

# Handling the data
if ($folderBrowser.ShowDialog() -eq "OK") {
    # Getting the selected path to save media to
    $selectedFolder = $folderBrowser.SelectedPath

    #Downloading the media
    Invoke-Expression -Command "$pwd\yt-dlp.exe $url -o $fileName --restrict-filenames -P $selectedFolder\"

    # Ask user if they want to fix their media?
    $action = Read-Host "Convert media with ffmpeg? (n/a - exit, 1 - mp3, 2 - mp4, 3 - default extension)"
    if (($action -eq "1") -or ($action -eq "2") -or ($action -eq "3")) {
        # Renaming the media to temp.(extension)
        $extension = [System.IO.Path]::GetExtension($fileName)
        $fileNameTemp = "temp$extension"
        Rename-Item -Path $selectedFolder\$fileName -NewName $fileNameTemp -Force

        # Converting using ffmpeg and deleting the temporary file
        $filenameWithoutExtension = [System.IO.Path]::GetFileNameWithoutExtension($fileName)
        $command = "$pwd\ffmpeg.exe -y -i $selectedFolder\$fileNameTemp $selectedFolder\$filenameWithoutExtension"
        if ($action -eq "1") {
            $command = "$pwd\ffmpeg.exe -y -i $selectedFolder\$fileNameTemp -vn $selectedFolder\$filenameWithoutExtension.mp3"
        }elseif ($action -eq "2") {
            $command = "$pwd\ffmpeg.exe -y -i $selectedFolder\$fileNameTemp $selectedFolder\$filenameWithoutExtension.mp4"
        }else {
            $command = "$command$extension"
        }
        Write-Host $command
        Invoke-Expression -Command $command
        Remove-Item -Path "$selectedFolder\$fileNameTemp"
    }
}
