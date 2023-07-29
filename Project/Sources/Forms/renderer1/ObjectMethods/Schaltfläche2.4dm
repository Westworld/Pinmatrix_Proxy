var $ent : cs:C1710.FramesEntity
$ent:=ds:C1482.Frames.get(Num:C11(Form:C1466.ID))

var $frame : cs:C1710.renderer
If (Form:C1466.renderer=Null:C1517)
	Form:C1466.renderer:=cs:C1710.renderer.new()
End if 

Form:C1466.renderer.newData($ent)

If (Form:C1466.renderer.render)
	
	$width:=Form:C1466.renderer.width
	$height:=Form:C1466.renderer.height
	
	$pixelsize:=2
	
	$pixeldistance:=0
	
	$input:=Form:C1466.renderer.frame
	
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
	For ($y; 1; $height)
		For ($x; 1; $width)
			// format bgr
			var $blue; $green; $red : Integer
			$blue:=$input[$pos+2]
			$green:=$input[$pos+1]
			$red:=$input[$pos]
			$pos+=4
			C_TEXT:C284($color)
			$color:="rgb("+String:C10($red)+","+String:C10($green)+","+String:C10($blue)+")"
			If ($red#0)
				
			End if 
			SVG SET ATTRIBUTE:C1055(myPicture; String:C10($x)+"_"+String:C10($y); "fill"; $color)
			
		End for 
	End for 
	
End if 

Form:C1466.ID+=1
