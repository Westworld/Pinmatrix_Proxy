$ent:=ds:C1482.Frames.get(Form:C1466.ID)
If ($ent#Null:C1517)
	
	If (($ent.datasize<2064))
		ALERT:C41("falsche größe")
		return 
	End if 
	
	$width:=256
	$height:=64
	
	$frame:=$width*$height*3
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
	
	
	
	
	$pictup:=RenderFrame($ent)
	//If (False)
	//$pictdown:=RenderFrame($ent; 1)
	
	//mynewpicture:=$pictup/$pictdown
	//Else 
	//mynewpicture:=mypicture
	//End if 
End if 

