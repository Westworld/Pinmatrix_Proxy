Class constructor()
	This:C1470.reset()
	
Function reset()
	This:C1470.gameName:=""
	This:C1470.width:=128
	This:C1470.height:=32
	This:C1470.palette:=New collection:C1472
	This:C1470.frame:=Null:C1517
	//This.RGBcolor:=0x00EC843D
	This:C1470._rgb:=cs:C1710.RGB.new(0x00EC; 0x0084; 0x003D)
	This:C1470._hsl:=This:C1470._rgb.RGBToHSL()
	This:C1470.render:=False:C215
	
Function newData($frame : cs:C1710.FramesEntity)
	Case of 
		: ($frame.type="gameName")
			This:C1470.reset()
			This:C1470.setGameName($frame)
			This:C1470.render:=False:C215
			
		: ($frame.type="dimensions")
			This:C1470.setDimensions($frame)
			This:C1470.render:=False:C215
			
		: ($frame.type="color")
			This:C1470.setColor($frame)
			This:C1470.render:=False:C215
			
		: ($frame.type="palette")
			This:C1470.render:=False:C215
			TRACE:C157
			
		: ($frame.type="gray2planes")
			$planes:=This:C1470._getGrayPlanes($frame; 2)
			$frame:=This:C1470._joinPlanes(2; $planes)
			This:C1470.frame:=This:C1470._graytoRgb24($frame; 4)
			This:C1470.render:=True:C214
			
		: ($frame.type="gray4planes")
			$planes:=This:C1470._getGrayPlanes($frame; 4)
			$frame:=This:C1470._joinPlanes(4; $planes)
			This:C1470.frame:=This:C1470._graytoRgb24($frame; 16)
			This:C1470.render:=True:C214
			
		: ($frame.type="coloredGray4")
			$planes:=This:C1470._getColorPlanes($frame; 4)
			$frame:=This:C1470._joinPlanes(4; $planes)
/*
$text:=""
For ($y; 0; 8)
For ($x; 0; 256)
If (($x<128) && ($y>5))
$text+=String($frame[($y*256)+$x]; "&$")
End if 
End for 
$text+=Char(13)
End for 
$text:=Replace string($text; "$"; " ")
TEXT TO DOCUMENT(System folder(Desktop)+"export.txt"; $text)
*/
			
			
			This:C1470.frame:=This:C1470._graytoRgb24($frame; 16)
			This:C1470.render:=True:C214
			
		: ($frame.type="coloredGray2")
			$planes:=This:C1470._getColorPlanes($frame; 2)
			$frame:=This:C1470._joinPlanes(2; $planes)
			
			This:C1470.frame:=This:C1470._graytoRgb24($frame; 4)
			This:C1470.render:=True:C214
	End case 
	
	
	
Function setGameName($frame : cs:C1710.FramesEntity)
	$pos:=Length:C16($frame.type)
	C_BLOB:C604($sub)
	COPY BLOB:C558($frame.data; $sub; $pos+1; 0; BLOB size:C605($frame.data)-$pos-1)
	This:C1470.gameName:=Convert to text:C1012($sub; "UTF-8")
	
Function setDimensions($frame : cs:C1710.FramesEntity)
	$pos:=Length:C16($frame.type)
	If (BLOB size:C605($frame.data)>($pos+8))
		$offset:=$pos+1
		This:C1470.width:=BLOB to longint:C551($frame.data; PC byte ordering:K22:3; $offset)
		This:C1470.height:=BLOB to longint:C551($frame.data; PC byte ordering:K22:3; $offset)
	End if 
	
Function setColor($frame : cs:C1710.FramesEntity)
	$pos:=Length:C16($frame.type)
	C_BLOB:C604($sub)
	COPY BLOB:C558($frame.data; $sub; $pos+1; 0; 3)
	This:C1470._rgb:=cs:C1710.RGB.new($sub{2}; $sub{1}; $sub{0})
	This:C1470._hsl:=This:C1470._rgb.RGBToHSL()
	
	//ColorRGBtoInt($sub[2]; $sub[1]; $sub[0])
	
Function _getGrayPlanes($frame : cs:C1710.FramesEntity; $count : Integer)->$planes : Collection
	$offset:=16
	return This:C1470._getPlanes($frame; $count; $offset)
	
Function _getColorPlanes($frame : cs:C1710.FramesEntity; $count : Integer)->$planes : Collection
	$offset:=17
	$countpalettes:=0
	$countpalettes:=BLOB to longint:C551($frame.data; PC byte ordering:K22:3; $offset)
	This:C1470.palettes:=New collection:C1472
	
	$text:=""
	
	For ($i; 1; $countpalettes)
		$color:=BLOB to longint:C551($frame.data; PC byte ordering:K22:3; $offset)
		This:C1470.palettes.push($color)
		$color2:=ColorRGBtoInt($color)
		$text:=$text+"color: "+String:C10($color; "&$")+" 16bit: "+String:C10($color2; "&$")+Char:C90(13)
	End for 
	$text:=Replace string:C233($text; "$"; " ")
	//TEXT TO DOCUMENT(System folder(Desktop)+"export.txt"; $text)
	
	return This:C1470._getPlanes($frame; $count; $offset)
	
Function _getPlanes($frame : cs:C1710.FramesEntity; $bits : Integer; $offset : Integer)->$planes : Collection
	$planes:=New collection:C1472
	$rest:=BLOB size:C605($frame.data)-$offset
	$planeSize:=$rest/$bits
	If ($planeSize#2048)
		TRACE:C157
	End if 
	
	var $up : Blob
	For ($pane; 1; $bits)
		$start:=(($pane-1)*$planeSize)+$offset
		COPY BLOB:C558($frame.data; $up; $start; 0; $planeSize)
		$planes.push($up)
	End for 
	
Function _joinPlanes($bitlength : Integer; $planes : Collection)->$frame : Blob
	SET BLOB SIZE:C606($frame; This:C1470.width*This:C1470.height; 0)
	//$planesize:=$planes[0].size/$bitlength
	$shouldbe:=This:C1470.width*This:C1470.height/8
	If ($planes[0].size#$shouldbe)
		ALERT:C41("planesize error")
	End if 
	
	For ($bytePos; 0; (This:C1470.width*This:C1470.height/8)-1)
		For ($bitPos; 7; 0; -1)
			For ($planePos; 0; $bitlength-1)
				$plane:=$planes[$planePos]
				var $bit : Integer
				$bit:=This:C1470._isBitSet($plane[$bytePos]; $bitPos) ? 1 : 0
				$byte:=$frame{$bytePos*8+$bitPos}
				$byte:=$byte | ($bit << $planePos)
				$frame{$bytePos*8+$bitPos}:=$byte
			End for 
		End for 
	End for 
	
Function _isBitSet($byte : Integer; $pos : Integer)->$set : Boolean
	return (($byte & (1 << $pos))#0)
	
Function _graytoRgb24($frame : Blob; $paletteOrNumColors : Variant)->$rgbFrame : Blob
	SET BLOB SIZE:C606($rgbFrame; This:C1470.width*This:C1470.height*4; 0)
	$pos:=0
	var $dotcolor : Integer
	$dotColor:=0
	var $palette : Collection
	If (This:C1470.palettes.length>0)
		$palette:=This:C1470.palettes
	Else 
		$palette:=New collection:C1472
		For ($i; 0; $paletteOrNumColors-1)
			var $lum; $numColors : Real
			$lum:=$i/($paletteOrNumColors-1)
			$hslcolor:=cs:C1710.HSL.new(This:C1470._hsl.H; This:C1470._hsl.S; $lum*This:C1470._hsl.L)
			$rgbcolor:=$hslcolor.HSLToRGB()
			$dotColor:=$rgbcolor.RGBlong
			$palette.push($dotColor)
		End for 
	End if 
	
	For ($y; 0; This:C1470.height-1)
		For ($x; 0; This:C1470.width-1)
			If ($palette#Null:C1517)
				$dotColor:=$palette[$frame{($y*This:C1470.width)+$x}]
				If ($dotcolor#0)
					
				End if 
				
			Else 
				var $lum; $numColors : Real
				$colorcode:=Num:C11($frame[y*This:C1470.width+$x])
				$numColors:=$paletteOrNumColors
				$lum:=$colorcode/$numColors
				$hslcolor:=cs:C1710.HSL.new(This:C1470._hsl.H; This:C1470._hsl.S; $lum*This:C1470._hsl.L)
				$rgbcolor:=$hslcolor.HSLToRGB()
				$dotColor:=$rgbcolor.RGBlong
			End if 
			LONGINT TO BLOB:C550($dotColor; $rgbFrame; PC byte ordering:K22:3; $pos)
			
		End for 
	End for 
	
	