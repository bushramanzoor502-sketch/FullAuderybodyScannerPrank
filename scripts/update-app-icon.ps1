Add-Type -AssemblyName System.Drawing

$root   = Join-Path $PSScriptRoot ".."
$source = Join-Path $root "..\FullAuderyBodyScannerXray-UtilEdge\design\app_icon_source.png"
$iconsDir = Join-Path $root "assets\img\icons"

$src = [System.Drawing.Image]::FromFile($source)
$size = 192

function Resize-Square([System.Drawing.Image]$img, [int]$sz) {
    $bmp = New-Object System.Drawing.Bitmap $sz, $sz, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.DrawImage($img, 0, 0, $sz, $sz)
    $g.Dispose()
    return $bmp
}

function Resize-Round([System.Drawing.Image]$img, [int]$sz) {
    $square = Resize-Square $img $sz
    $bmp = New-Object System.Drawing.Bitmap $sz, $sz, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $path.AddEllipse(0, 0, $sz, $sz)
    $g.SetClip($path)
    $g.DrawImage($square, 0, 0, $sz, $sz)
    $g.Dispose()
    $square.Dispose()
    return $bmp
}

$square = Resize-Square $src $size
$square.Save((Join-Path $iconsDir "app_icon.png"), [System.Drawing.Imaging.ImageFormat]::Png)
$square.Dispose()

$round = Resize-Round $src $size
$round.Save((Join-Path $iconsDir "launcher_round.png"), [System.Drawing.Imaging.ImageFormat]::Png)
$round.Dispose()

$src.Dispose()
Write-Host "Done."
