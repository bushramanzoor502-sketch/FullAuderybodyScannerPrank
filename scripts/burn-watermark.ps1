Add-Type -AssemblyName System.Drawing

$dir = Join-Path $PSScriptRoot "..\assets\img\art"
$files = Get-ChildItem $dir -File | Where-Object { $_.Extension -match '^\.(png|jpe?g)$' }

foreach ($f in $files) {
    Write-Host "Watermarking $($f.Name) ..."

    $src = [System.Drawing.Image]::FromFile($f.FullName)
    $bmp = New-Object System.Drawing.Bitmap $src.Width, $src.Height, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $bmp.SetResolution($src.HorizontalResolution, $src.VerticalResolution)

    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
    $g.DrawImage($src, 0, 0, $src.Width, $src.Height)
    $src.Dispose()

    $fontSize = [Math]::Max(13, [Math]::Round($bmp.Width / 20))
    $font  = New-Object System.Drawing.Font("Arial", $fontSize, [System.Drawing.FontStyle]::Bold)
    $text  = "FULL AUDERY  ·  UtilEdge"

    # Two brushes so the mark reads on both light and dark parts of the artwork.
    $brushLight = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(40, 255, 255, 255))
    $brushDark  = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(22, 0, 0, 0))

    $textSize = $g.MeasureString($text, $font)
    $stepX = $textSize.Width + 70
    $stepY = $textSize.Height + 90
    $diag  = [Math]::Sqrt([double]$bmp.Width * $bmp.Width + [double]$bmp.Height * $bmp.Height)

    $g.TranslateTransform($bmp.Width / 2.0, $bmp.Height / 2.0)
    $g.RotateTransform(-22)

    $y = -$diag
    while ($y -lt $diag) {
        $x = -$diag
        while ($x -lt $diag) {
            $g.DrawString($text, $font, $brushDark, [single]($x + 1), [single]($y + 1))
            $g.DrawString($text, $font, $brushLight, [single]$x, [single]$y)
            $x += $stepX
        }
        $y += $stepY
    }
    $g.ResetTransform()
    $g.Dispose()

    $ext = $f.Extension.ToLower()
    if ($ext -eq ".png") {
        $bmp.Save($f.FullName, [System.Drawing.Imaging.ImageFormat]::Png)
    }
    else {
        $jpegCodec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq "image/jpeg" }
        $encParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
        $encParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, [int64]92)
        $bmp.Save($f.FullName, $jpegCodec, $encParams)
    }
    $bmp.Dispose()
    $font.Dispose(); $brushLight.Dispose(); $brushDark.Dispose()
}

Write-Host "Done: $($files.Count) file(s) watermarked in place."
