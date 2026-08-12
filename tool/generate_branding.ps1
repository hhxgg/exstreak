# Generates the ExStreak branding source images from code.
#
# The launcher icon, adaptive layers and splash art are all derived from one
# flame path plus the palette in lib/theme/app_colors.dart, so re-skinning the
# app means editing the constants at the top of this file and re-running:
#
#   pwsh -File tool/generate_branding.ps1
#   dart run flutter_launcher_icons
#   dart run flutter_native_splash:create
#
# Requires Windows (System.Drawing). Output lands in assets/branding/.

Add-Type -AssemblyName System.Drawing

$ErrorActionPreference = 'Stop'

# ---------------------------------------------------------------- palette ---
$BackgroundHex   = '#0B0B0F'
$GradientTopHex  = '#FFC24B'
$GradientBotHex  = '#FF3D1F'
$InnerTopHex     = '#FFE9A8'
$InnerBotHex     = '#FF7A2F'

$OutDir = Join-Path $PSScriptRoot '..\assets\branding'
New-Item -ItemType Directory -Force $OutDir | Out-Null

function ConvertFrom-Hex([string]$hex) {
  $hex = $hex.TrimStart('#')
  return [System.Drawing.Color]::FromArgb(
    255,
    [Convert]::ToInt32($hex.Substring(0, 2), 16),
    [Convert]::ToInt32($hex.Substring(2, 2), 16),
    [Convert]::ToInt32($hex.Substring(4, 2), 16)
  )
}

# Flame silhouette, expressed in a 100x100 design box.
# Outer body: a teardrop with a licked tip and a wide, rounded base.
function New-FlamePath([single]$size, [single]$offsetX, [single]$offsetY, [bool]$inner) {
  $p = New-Object System.Drawing.Drawing2D.GraphicsPath
  $s = { param($x, $y) New-Object System.Drawing.PointF(
      ($offsetX + $x * $size / 100.0), ($offsetY + $y * $size / 100.0)) }

  if (-not $inner) {
    $pts = @(
      (& $s 53 2),
      (& $s 68 18), (& $s 72 31), (& $s 70 42),   # upper-right shoulder
      (& $s 69 50), (& $s 76 52), (& $s 79 62),   # right flank bulges out
      (& $s 84 75), (& $s 77 91), (& $s 63 97),   # lower right
      (& $s 55 100), (& $s 43 100), (& $s 35 97), # rounded base
      (& $s 21 91), (& $s 14 74), (& $s 20 61),   # lower left
      (& $s 24 52), (& $s 31 53), (& $s 31 44),   # left notch — the lick
      (& $s 31 32), (& $s 25 26), (& $s 31 13),   # upper-left curl
      (& $s 38 21), (& $s 45 21), (& $s 53 2)     # back to the tip
    )
  } else {
    $pts = @(
      (& $s 55 37),
      (& $s 67 50), (& $s 69 60), (& $s 67 69),
      (& $s 65 81), (& $s 58 89), (& $s 50 93),
      (& $s 42 89), (& $s 36 81), (& $s 35 69),
      (& $s 34 59), (& $s 44 49), (& $s 55 37)
    )
  }

  # First point is the start; the rest are bezier triplets.
  for ($i = 1; $i -lt $pts.Count; $i += 3) {
    $p.AddBezier($pts[$i - 1], $pts[$i], $pts[$i + 1], $pts[$i + 2])
  }
  $p.CloseFigure()
  return $p
}

function New-Canvas([int]$px, [System.Drawing.Color]$fill, [bool]$transparent) {
  $bmp = New-Object System.Drawing.Bitmap($px, $px,
    [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
  if ($transparent) {
    $g.Clear([System.Drawing.Color]::Transparent)
  } else {
    $g.Clear($fill)
  }
  return @{ Bitmap = $bmp; Graphics = $g }
}

function Add-Flame($g, [single]$size, [single]$x, [single]$y, $topColor, $botColor, $innerTop, $innerBot, [bool]$mono) {
  $outer = New-FlamePath $size $x $y $false
  $rect = New-Object System.Drawing.RectangleF($x, $y, $size, $size)

  if ($mono) {
    $brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $g.FillPath($brush, $outer)
    $brush.Dispose()
  } else {
    $brush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
      $rect, $topColor, $botColor, 90.0)
    $g.FillPath($brush, $outer)
    $brush.Dispose()

    $inner = New-FlamePath $size $x $y $true
    $innerRect = New-Object System.Drawing.RectangleF(
      ($x + $size * 0.3), ($y + $size * 0.3), ($size * 0.4), ($size * 0.65))
    $innerBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
      $innerRect, $innerTop, $innerBot, 90.0)
    $g.FillPath($innerBrush, $inner)
    $innerBrush.Dispose()
    $inner.Dispose()
  }
  $outer.Dispose()
}

$bg       = ConvertFrom-Hex $BackgroundHex
$gradTop  = ConvertFrom-Hex $GradientTopHex
$gradBot  = ConvertFrom-Hex $GradientBotHex
$innerTop = ConvertFrom-Hex $InnerTopHex
$innerBot = ConvertFrom-Hex $InnerBotHex

# --- 1. Full-bleed launcher icon (legacy + iOS style) -----------------------
$c = New-Canvas 1024 $bg $false
$flame = 660
Add-Flame $c.Graphics $flame (([single](1024 - $flame)) / 2) 190 $gradTop $gradBot $innerTop $innerBot $false
$c.Bitmap.Save((Join-Path $OutDir 'icon.png'), [System.Drawing.Imaging.ImageFormat]::Png)
$c.Graphics.Dispose(); $c.Bitmap.Dispose()

# --- 2. Adaptive foreground -------------------------------------------------
# Android crops adaptive layers to the inner ~66%, so the mark stays small.
$c = New-Canvas 1024 $bg $true
$flame = 470
Add-Flame $c.Graphics $flame (([single](1024 - $flame)) / 2) 265 $gradTop $gradBot $innerTop $innerBot $false
$c.Bitmap.Save((Join-Path $OutDir 'icon_foreground.png'), [System.Drawing.Imaging.ImageFormat]::Png)
$c.Graphics.Dispose(); $c.Bitmap.Dispose()

# --- 3. Adaptive monochrome (themed icons, Android 13+) ---------------------
$c = New-Canvas 1024 $bg $true
Add-Flame $c.Graphics $flame (([single](1024 - $flame)) / 2) 265 $gradTop $gradBot $innerTop $innerBot $true
$c.Bitmap.Save((Join-Path $OutDir 'icon_monochrome.png'), [System.Drawing.Imaging.ImageFormat]::Png)
$c.Graphics.Dispose(); $c.Bitmap.Dispose()

# --- 4. Splash mark ---------------------------------------------------------
$c = New-Canvas 640 $bg $true
$flame = 460
Add-Flame $c.Graphics $flame (([single](640 - $flame)) / 2) 90 $gradTop $gradBot $innerTop $innerBot $false
$c.Bitmap.Save((Join-Path $OutDir 'splash.png'), [System.Drawing.Imaging.ImageFormat]::Png)
$c.Graphics.Dispose(); $c.Bitmap.Dispose()

# --- 5. Android 12 splash icon ---------------------------------------------
# The system masks this to a circle of 2/3 the canvas, so keep art well inside.
$c = New-Canvas 1152 $bg $true
$flame = 470
Add-Flame $c.Graphics $flame (([single](1152 - $flame)) / 2) 330 $gradTop $gradBot $innerTop $innerBot $false
$c.Bitmap.Save((Join-Path $OutDir 'splash_android12.png'), [System.Drawing.Imaging.ImageFormat]::Png)
$c.Graphics.Dispose(); $c.Bitmap.Dispose()

Write-Output "Branding written to $((Resolve-Path $OutDir).Path)"
Get-ChildItem $OutDir -Filter *.png | ForEach-Object { "  $($_.Name)  $($_.Length) bytes" }
