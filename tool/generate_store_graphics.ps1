# Generates the Google Play graphics that are not screenshots:
#   - store/graphics/play-icon-512.png   (512x512, no alpha)
#   - store/graphics/feature-graphic.png (1024x500, no alpha)
#
# Run tool/generate_branding.ps1 first — this script reuses assets/branding/icon.png.
#
#   pwsh -File tool/generate_store_graphics.ps1

Add-Type -AssemblyName System.Drawing

$ErrorActionPreference = 'Stop'

$Root       = Resolve-Path (Join-Path $PSScriptRoot '..')
$IconSource = Join-Path $Root 'assets\branding\icon.png'
$FlameOnly  = Join-Path $Root 'assets\branding\splash.png'
$FontFile   = Join-Path $Root 'assets\fonts\Outfit-ExtraBold.ttf'
$FontMedium = Join-Path $Root 'assets\fonts\Outfit-Medium.ttf'
$OutDir     = Join-Path $Root 'store\graphics'

New-Item -ItemType Directory -Force $OutDir | Out-Null

foreach ($f in @($IconSource, $FlameOnly, $FontFile, $FontMedium)) {
  if (-not (Test-Path $f)) { throw "Missing required input: $f" }
}

$fonts = New-Object System.Drawing.Text.PrivateFontCollection
$fonts.AddFontFile($FontFile)
$fonts.AddFontFile($FontMedium)
$familyBold   = $fonts.Families[($fonts.Families | ForEach-Object { $_.Name }).IndexOf('Outfit')]
$familyBold   = $fonts.Families[0]
$familyMedium = if ($fonts.Families.Count -gt 1) { $fonts.Families[1] } else { $fonts.Families[0] }

function New-Graphics($bmp) {
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode     = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $g.PixelOffsetMode   = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
  $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
  return $g
}

# --- 1. Play icon: 512x512, flattened onto the brand background ------------
$src = [System.Drawing.Image]::FromFile($IconSource)
$icon = New-Object System.Drawing.Bitmap(512, 512,
  [System.Drawing.Imaging.PixelFormat]::Format24bppRgb)
$g = New-Graphics $icon
$g.Clear([System.Drawing.ColorTranslator]::FromHtml('#0B0B0F'))
$g.DrawImage($src, 0, 0, 512, 512)
$icon.Save((Join-Path $OutDir 'play-icon-512.png'),
  [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $icon.Dispose(); $src.Dispose()

# --- 2. Feature graphic: 1024x500 ------------------------------------------
# Play crops this on some surfaces, so the mark and wordmark stay well inside
# the middle band and nothing important touches the edges.
$fg = New-Object System.Drawing.Bitmap(1024, 500,
  [System.Drawing.Imaging.PixelFormat]::Format24bppRgb)
$g = New-Graphics $fg

$bgRect = New-Object System.Drawing.Rectangle(0, 0, 1024, 500)
$bgBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
  $bgRect,
  [System.Drawing.ColorTranslator]::FromHtml('#141018'),
  [System.Drawing.ColorTranslator]::FromHtml('#08080B'),
  20.0)
$g.FillRectangle($bgBrush, $bgRect)
$bgBrush.Dispose()

# Warm glow behind the flame.
$glowPath = New-Object System.Drawing.Drawing2D.GraphicsPath
$glowPath.AddEllipse(30, 20, 460, 460)
$glow = New-Object System.Drawing.Drawing2D.PathGradientBrush($glowPath)
$glow.CenterColor = [System.Drawing.Color]::FromArgb(70, 255, 90, 30)
$glow.SurroundColors = @([System.Drawing.Color]::FromArgb(0, 255, 90, 30))
$g.FillPath($glow, $glowPath)
$glow.Dispose(); $glowPath.Dispose()

# Flame mark, left third.
$flame = [System.Drawing.Image]::FromFile($FlameOnly)
$g.DrawImage($flame, 130, 55, 300, 300)
$flame.Dispose()

# Wordmark with the brand gradient.
$wordFont = New-Object System.Drawing.Font($familyBold, 82,
  [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
$wordRect = New-Object System.Drawing.RectangleF(470, 150, 520, 110)
$wordBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
  $wordRect,
  [System.Drawing.ColorTranslator]::FromHtml('#FFC24B'),
  [System.Drawing.ColorTranslator]::FromHtml('#FF3D1F'),
  25.0)
$g.DrawString('ExStreak', $wordFont, $wordBrush, 468, 148)
$wordBrush.Dispose(); $wordFont.Dispose()

# Tagline.
$tagFont = New-Object System.Drawing.Font($familyMedium, 30,
  [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)
$tagBrush = New-Object System.Drawing.SolidBrush(
  [System.Drawing.ColorTranslator]::FromHtml('#9E9EAC'))
$g.DrawString('Consistency beats intensity.', $tagFont, $tagBrush, 474, 252)
$g.DrawString('Daily training that adapts to you.', $tagFont, $tagBrush, 474, 292)
$tagBrush.Dispose(); $tagFont.Dispose()

$fg.Save((Join-Path $OutDir 'feature-graphic.png'),
  [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $fg.Dispose()

Write-Output "Store graphics written to $((Resolve-Path $OutDir).Path)"
Get-ChildItem $OutDir -Filter *.png | ForEach-Object {
  $img = [System.Drawing.Image]::FromFile($_.FullName)
  "  {0}  {1}x{2}  {3:N0} bytes" -f $_.Name, $img.Width, $img.Height, $_.Length
  $img.Dispose()
}
