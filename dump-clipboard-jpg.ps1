Add-Type -Assembly PresentationCore
$img = [Windows.Clipboard]::GetImage()
if ($img -eq $null) {
    Write-Host "Clipboard contains no image."
    Exit
}

$file = "{0}\clipboard-{1}.jpg" -f [Environment]::GetFolderPath('MyPictures'),((Get-Date -f s) -replace '[-T:]','')
Write-Host ("`n Found picture. {0}x{1} pixel. Saving to {2}`n" -f $img.PixelWidth, $img.PixelHeight, $file)

$stream = [IO.File]::Open($file, "OpenOrCreate")
$encoder = New-Object Windows.Media.Imaging.JpegBitmapEncoder
$encoder.QualityLevel = 90
$encoder.Frames.Add([Windows.Media.Imaging.BitmapFrame]::Create($img))
$encoder.Save($stream)
$stream.Dispose()

& explorer.exe /select,$file