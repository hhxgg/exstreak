# ---------------------------------------------------------------------------
# Turn raw device captures into Play-Console-ready phone screenshots.
#
# Two things need fixing about a raw capture:
#
#  1. Aspect ratio. Play rejects screenshots taller than 2:1, and modern phones
#     are taller than that (the test device is 1080x2340, or 2.17:1). Play also
#     asks for 9:16 at >=1080px on the short side for an app to be eligible for
#     promotional placement.
#  2. System chrome. The status bar carries the tester's battery level and
#     whatever notification icons happened to be showing; the navigation bar is
#     the launcher's, not the app's. Neither belongs in a store listing.
#
# So each capture is cropped to the app's own content, scaled to fit a
# 1080x1920 canvas and centred on the app background. Nothing of the app is
# cropped - the whole screen stays visible.
# ---------------------------------------------------------------------------
param(
    [string]$InDir = 'D:\ExStreak\store\graphics\screenshots\src',
    [string]$OutDir = 'D:\ExStreak\store\graphics\screenshots',
    [int]$Width = 1080,
    [int]$Height = 1920,
    # Device chrome to drop, in source pixels.
    [int]$CropTop = 80,
    [int]$CropBottom = 120,
    # Matches AppColors.dark background / the splash colour.
    [string]$Background = '#0B0B0F'
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

if (-not (Test-Path $OutDir)) { New-Item -ItemType Directory -Force -Path $OutDir | Out-Null }

$bg = [System.Drawing.ColorTranslator]::FromHtml($Background)

Get-ChildItem -Path $InDir -Filter '*.png' | Sort-Object Name | ForEach-Object {
    $src = [System.Drawing.Image]::FromFile($_.FullName)
    try {
        $cw = $src.Width
        $ch = $src.Height - $CropTop - $CropBottom
        if ($ch -le 0) { throw "$($_.Name): crop removes the whole image" }

        $cropped = New-Object System.Drawing.Bitmap($cw, $ch, [System.Drawing.Imaging.PixelFormat]::Format24bppRgb)
        $gc = [System.Drawing.Graphics]::FromImage($cropped)
        try {
            $srcRect = New-Object System.Drawing.Rectangle(0, $CropTop, $cw, $ch)
            $gc.DrawImage($src, (New-Object System.Drawing.Rectangle(0, 0, $cw, $ch)), $srcRect, [System.Drawing.GraphicsUnit]::Pixel)
        }
        finally { $gc.Dispose() }

        # Fit inside the canvas, preserving aspect ratio.
        #
        # Both ratios are cast to double first: PowerShell hands back an Int32
        # when a division comes out even (1080/1080), which makes [Math]::Min
        # bind to its (int, int) overload and round the other ratio to 1 -
        # silently cropping the image instead of scaling it.
        $scale = [Math]::Min([double]$Width / [double]$cw, [double]$Height / [double]$ch)
        $w = [int][Math]::Round($cw * $scale)
        $h = [int][Math]::Round($ch * $scale)
        $x = [int](($Width - $w) / 2)
        $y = [int](($Height - $h) / 2)

        # 24bpp: Play does not accept an alpha channel in screenshots.
        $canvas = New-Object System.Drawing.Bitmap($Width, $Height, [System.Drawing.Imaging.PixelFormat]::Format24bppRgb)
        $g = [System.Drawing.Graphics]::FromImage($canvas)
        try {
            $g.Clear($bg)
            $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
            $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
            $g.DrawImage($cropped, $x, $y, $w, $h)
        }
        finally { $g.Dispose() }

        $canvas.Save((Join-Path $OutDir $_.Name), [System.Drawing.Imaging.ImageFormat]::Png)
        $canvas.Dispose(); $cropped.Dispose()

        Write-Output ("{0}  {1}x{2} -> {3}x{4}" -f $_.Name, $src.Width, $src.Height, $Width, $Height)
    }
    finally { $src.Dispose() }
}
