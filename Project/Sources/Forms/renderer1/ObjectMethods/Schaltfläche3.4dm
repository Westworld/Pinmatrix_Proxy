var $ent : cs:C1710.FramesEntity
$ent:=ds:C1482.Frames.get(Num:C11(Form:C1466.ID))

$width:=Form:C1466.renderer.width
$height:=Form:C1466.renderer.height

$pixelsize:=2

$pixeldistance:=0



If (Undefined:C82(picturebuffer))
	ARRAY TEXT:C222(picturebuffer; $width*$height)
	For ($i; 1; $width*$height)
		picturebuffer{$i}:=""
	End for 
	
	svgRef:=SVG_New($width*($pixelsize+$pixeldistance)+100; $height*($pixelsize+$pixeldistance)+100; "DMD")
	objectRef:=SVG_New_rect(svgRef; 0; 0; \
		$width*($pixelsize+$pixeldistance)+100; $height*($pixelsize+$pixeldistance)+100; -1; -1; "black"; "black"; 0)
	
	
	$color:="black"
	For ($y; 1; $height)
		For ($x; 1; $width)
			$objectRef:=SVG_New_rect(svgRef; ($x*($pixelsize+$pixeldistance)); ($y*($pixelsize+$pixeldistance)); \
				$pixelsize; $pixelsize; -1; -1; $color; $color; 0)
			SVG_SET_ID($objectRef; String:C10($x)+"_"+String:C10($y))
			picturebuffer{(($y-1)*$width+$x)}:=$color
		End for 
	End for 
	MyPicture:=SVG_Export_to_picture(svgRef; 2)
End if 

$pos:=0

C_TEXT:C284($color)
For ($pos; 1; 16)
	$lum:=$pos/16
	$hslcolor:=cs:C1710.HSL.new(Form:C1466.renderer._hsl.H; Form:C1466.renderer._hsl.S; $lum*Form:C1466.renderer._hsl.L)
	$rgbcolor:=$hslcolor.HSLToRGB()
	$dotColor:=$rgbcolor.RGBlong
	
	$color:="rgb("+String:C10($rgbcolor.R)+","+String:C10($rgbcolor.G)+","+String:C10($rgbcolor.B)+")"
	SVG SET ATTRIBUTE:C1055(myPicture; String:C10($pos)+"_"+String:C10(1); "fill"; $color)
	
End for 


