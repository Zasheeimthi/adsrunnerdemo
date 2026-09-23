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
# Shared geometric lowercase a, identical at every size.
function Draw-Mark($g,$x,$y,$size) {
  $state = $g.Save()
  $g.TranslateTransform($x,$y)
  $g.ScaleTransform(($size/64),($size/64))
  $white = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::White)
  $purple = [System.Drawing.SolidBrush]::new($violet)
  $g.FillRectangle($purple,0,0,64,64)
  $g.FillEllipse($white,13,14,36,36)
  $g.FillRectangle($white,43,15,8,34)
  $g.FillEllipse($purple,22,22,20,20)
  $white.Dispose(); $purple.Dispose(); $g.Restore($state)
}
foreach($size in @(16,32,180,256,1200)) {
  $bmp,$g = New-Canvas $size $size
  Draw-Mark $g 0 0 $size
  $name = switch($size){16 {'favicon-16.png'} 32 {'favicon-32.png'} 180 {'apple-touch-icon.png'} 256 {'favicon-256.png'} 1200 {'og-square-v3.png'}}
  $bmp.Save((Join-Path $outDir $name),[System.Drawing.Imaging.ImageFormat]::Png)
  $g.Dispose(); $bmp.Dispose()
}
$bmp,$g = New-Canvas 1200 630
$g.Clear($cream)
Draw-Mark $g 80 180 240
Draw-Text $g 'adsrunner' 92 Bold $ink 365 187
$purpleBrush = [System.Drawing.SolidBrush]::new($violet)
$g.FillEllipse($purpleBrush,829,270,20,20)
Draw-Text $g 'Your ads. One workspace.' 38 Bold $ink 371 325
$bmp.Save((Join-Path $outDir 'og-wide-v3.png'),[System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $bmp.Dispose(); $purpleBrush.Dispose()
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
