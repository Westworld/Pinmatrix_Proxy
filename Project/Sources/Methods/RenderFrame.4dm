//%attributes = {}
#DECLARE($ent : cs:C1710.FramesEntity; $part : Integer)->$mypicture : Picture


$width:=256
$height:=64

$frame:=$width*$height*4
$pixelsize:=2

$pixeldistance:=0

$total:=BLOB size:C605($ent.data)
$typ:=$ent.preview
$bits:=1
Case of 
	: ($typ="gray2planes@")
		$bits:=2
	: ($typ="gray4planes@")
		$bits:=4
	: ($typ="coloredGray4@")
		$bits:=4
	: ($typ="rgb24@")
		$offset:=6+1+4
		If ($total<(256*32*3+$offset))
			ALERT:C41("zu kleines blob?")
			return 
		End if 
		
		$pos:=$offset-1
		For ($y; 1; $height)
			For ($x; 1; $width)
				// format bgr
				var $blue; $green; $red : Integer
				$blue:=$ent.data[$pos+2]
				$green:=$ent.data[$pos+1]
				$red:=$ent.data[$pos+0]
				$pos+=3
				C_TEXT:C284($color)
				$color:="rgb("+String:C10($red)+","+String:C10($green)+","+String:C10($blue)+")"
				SVG SET ATTRIBUTE:C1055(myPicture; String:C10($x)+"_"+String:C10($y); "fill"; $color)
			End for 
		End for 
		
		$MyPicture:=MyPicture
		
		return 
	Else 
		ALERT:C41("unknown panel")
		return 
End case 


C_BLOB:C604($up; $down)
C_BLOB:C604($input)

If ($part>$bits)
	$part:=1
End if 

Form:C1466.palettes:=New collection:C1472

$offset:=16
If ($typ="color@")
	$offset:=17
	$countpalettes:=0
	$countpalettes:=BLOB to longint:C551($ent.data; PC byte ordering:K22:3; $offset)
	Form:C1466.palettes:=New collection:C1472
	For ($i; 1; $countpalettes)
		$colorrgb:=BLOB to longint:C551($ent.data; PC byte ordering:K22:3; $offset)
		Form:C1466.palettes.push($colorrgb)
	End for 
End if 

$start:=($part*2048)+$offset

If ((($total-$offset)/$bits)#2048)
	ALERT:C41("wrong bitmap size?")
End if 

If (Form:C1466.palettes.length=0)
	If ($part=0)
		COPY BLOB:C558($ent.data; $up; $start; 0; 2048)
	Else 
		COPY BLOB:C558($ent.data; $up; $start; 0; 2048)
	End if 
	
	SET BLOB SIZE:C606($input; $frame)
	$target:=0
	For ($i; 0; BLOB size:C605($up)-1)
		$byte:=$up{$i}
		For ($bit; 0; 7)
			$on:=$byte ?? $bit
			If ($on)
				$input{$target+1}:=255
			End if 
			$target+=4
		End for 
	End for 
	
	C_PICTURE:C286(MyPicture)
	$framepos:=1
	
	
Else 
	SET BLOB SIZE:C606($input; $frame)
	For ($pane; 1; $bits)
		$start:=(($pane-1)*2048)+$offset
		COPY BLOB:C558($ent.data; $up; $start; 0; 2048)
		$target:=0
		For ($i; 0; BLOB size:C605($up)-1)
			$byte:=$up{$i}
			For ($bit; 0; 7)
				$on:=$byte ?? $bit
				If ($on)
					$targetold:=$target
					$old:=BLOB to longint:C551($input; PC byte ordering:K22:3; $targetold)
					If ($old=0)
						$targetold:=$target
						LONGINT TO BLOB:C550(Form:C1466.palettes[$pane]; $input; PC byte ordering:K22:3; $targetold)
					Else 
						//TRACE
						$targetold:=$target
						LONGINT TO BLOB:C550(Form:C1466.palettes[$pane]; $input; PC byte ordering:K22:3; $targetold)
					End if 
					
				End if 
				$target+=4
			End for 
		End for 
	End for 
	
End if 



If (BLOB size:C605($input)=$frame)
	
	$pos:=0
	For ($y; 1; $height)
		For ($x; 1; $width)
			// format bgr
			var $blue; $green; $red : Integer
			$blue:=$input[$pos+3]
			$green:=$input[$pos+2]
			$red:=$input[$pos+1]
			$pos+=4
			C_TEXT:C284($color)
			$color:="rgb("+String:C10($red)+","+String:C10($green)+","+String:C10($blue)+")"
			
			//SVG GET ATTRIBUTE(myPicture; String($x)+"_"+String($y); "fill"; $oldcolor)
			
			//If (picturebuffer{(($y-1)*$width+$x)}#$color)
			SVG SET ATTRIBUTE:C1055(myPicture; String:C10($x)+"_"+String:C10($y); "fill"; $color)
			//picturebuffer{(($y-1)*$width+$x)}:=$color
			//End if 
		End for 
	End for 
	
	$MyPicture:=MyPicture
	//CONVERT PICTURE($MyPicture; ".png")
	//SET PICTURE TO PASTEBOARD($MyPicture)
	//For ($i; 1; $width*$height)
	//picturebuffer{$i}:=""
	//End for 
	
End if 
