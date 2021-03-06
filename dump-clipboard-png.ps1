Add-Type -Assembly PresentationCore
$img = [Windows.Clipboard]::GetImage()
if ($img -eq $null) {
    Write-Host "Clipboard contains no image."
    Exit
}

$fcb = new-object Windows.Media.Imaging.FormatConvertedBitmap($img, [Windows.Media.PixelFormats]::Rgb24, $null, 0)
$file = "{0}\clipboard-{1}.png" -f [Environment]::GetFolderPath('MyPictures'),((Get-Date -f s) -replace '[-T:]','')
Write-Host ("`n Found picture. {0}x{1} pixel. Saving to {2}`n" -f $img.PixelWidth, $img.PixelHeight, $file)

$stream = [IO.File]::Open($file, "OpenOrCreate")
$encoder = New-Object Windows.Media.Imaging.PngBitmapEncoder
$encoder.Frames.Add([Windows.Media.Imaging.BitmapFrame]::Create($fcb))
$encoder.Save($stream)
$stream.Dispose()

& explorer.exe /select,$file
