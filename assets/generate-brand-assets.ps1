Add-Type -AssemblyName System.Drawing
$root = Split-Path $PSScriptRoot -Parent
$outDir = Join-Path $root 'assets'
$cream = [System.Drawing.ColorTranslator]::FromHtml('#F4F4F1')
$ink = [System.Drawing.ColorTranslator]::FromHtml('#101014')
$violet = [System.Drawing.ColorTranslator]::FromHtml('#7657FF')
function New-Canvas($width, $height) {
  $bmp = [System.Drawing.Bitmap]::new($width,$height)
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = 'AntiAlias'
  $g.TextRenderingHint = 'AntiAliasGridFit'
  return @($bmp,$g)
}
function Draw-Text($g,$text,$size,$weight,$color,$x,$y) {
  $font = [System.Drawing.Font]::new('Century Gothic',$size,$weight,[System.Drawing.GraphicsUnit]::Pixel)
  $brush = [System.Drawing.SolidBrush]::new($color)
  $g.DrawString($text,$font,$brush,$x,$y)
  $font.Dispose(); $brush.Dispose()
}
$canvas = New-Canvas 1200 630
$bmp,$g = $canvas
$g.Clear($cream)
$purpleBrush = [System.Drawing.SolidBrush]::new($violet)
$g.FillRectangle($purpleBrush,0,0,1200,12)
Draw-Text $g 'adsrunner' 44 Bold $ink 76 54
$g.FillEllipse($purpleBrush,295,88,12,12)
Draw-Text $g 'Your brand. Your ads.' 70 Bold $ink 70 179
Draw-Text $g 'One workspace.' 76 Bold $violet 70 265
Draw-Text $g 'Build your brand. Create ad images with AI.' 28 Regular $ink 76 390
Draw-Text $g 'Review campaigns and connected accounts.' 28 Regular $ink 76 433
Draw-Text $g 'BRAND SETUP  /  AI IMAGES  /  CAMPAIGN OVERVIEW' 19 Bold $ink 78 552
$bmp.Save((Join-Path $outDir 'og-image.png'),[System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $bmp.Dispose(); $purpleBrush.Dispose()
foreach($size in @(32,180,256)) {
  $bmp,$g = New-Canvas $size $size
  $g.Clear($violet)
  Draw-Text $g 'a' ($size * 0.94) Bold ([System.Drawing.Color]::White) ($size * 0.08) (-$size * 0.18)
  $name = if($size -eq 180){'apple-touch-icon.png'} elseif($size -eq 32){'favicon-32.png'} else {'favicon-256.png'}
  $bmp.Save((Join-Path $outDir $name),[System.Drawing.Imaging.ImageFormat]::Png)
  $g.Dispose(); $bmp.Dispose()
}
# A PNG-compressed ICO with 32px and 256px entries.
$images = @([IO.File]::ReadAllBytes((Join-Path $outDir 'favicon-32.png')), [IO.File]::ReadAllBytes((Join-Path $outDir 'favicon-256.png')))
$stream = [IO.File]::Create((Join-Path $root 'favicon.ico'))
$writer = [IO.BinaryWriter]::new($stream)
$writer.Write([uint16]0); $writer.Write([uint16]1); $writer.Write([uint16]2)
$offset = 38
for($i=0;$i -lt 2;$i++) {
  $dim = if($i -eq 0){32}else{0}
  $writer.Write([byte]$dim); $writer.Write([byte]$dim); $writer.Write([byte]0); $writer.Write([byte]0)
  $writer.Write([uint16]1); $writer.Write([uint16]32)
  $writer.Write([uint32]$images[$i].Length); $writer.Write([uint32]$offset)
  $offset += $images[$i].Length
}
foreach($bytes in $images){$writer.Write([byte[]]$bytes)}
$writer.Dispose(); $stream.Dispose()
