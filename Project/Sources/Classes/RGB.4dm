// https://www.programmingalgorithms.com/algorithm/hsl-to-rgb/cpp/


Class constructor($r : Integer; $g : Integer; $b : Integer)
	This:C1470.R:=$r
	This:C1470.G:=$g
	This:C1470.B:=$b
	
Function get RGBlong->$result : Integer
	$result:=(This:C1470.R << 16)+(This:C1470.G << 8)+This:C1470.B
	
	//Function Equals($rgb : cs.RGB)->Bool
	//return (This.R=$rgb.R) && (This.G=$rgb.G) && (This.B=$rgb.B)
	
Function _min($a : Real; $b : Real)->$result : Real
	$result:=($a<$b) ? $a : $b
Function _max($a : Real; $b : Real)->$result : Real
	$result:=($a>$b) ? $a : $b
	
	
Function RGBToHSL()->$hsl : cs:C1710.HSL
	
	$hsl:=cs:C1710.HSL.new()
	
	var $r; $g; $b : Real
	$r:=This:C1470.R/255
	$g:=This:C1470.G/255
	$b:=This:C1470.B/255
	
	$min:=This:C1470._min(This:C1470._min($r; $g); $b)
	$max:=This:C1470._max(This:C1470._max($r; $g); $b)
	$delta:=$Max-$Min
	
	$hsl.L:=($Max+$Min)/2
	
	If ($delta=0)
		$hsl.H:=0
		$hsl.S:=0
	Else 
		$hsl.S:=($hsl.L<=0.5) ? ($delta/($Max+$Min)) : ($delta/(2-$Max-$Min))
		
		If ($r=$Max)
			$hue:=(($g-$b)/6)/$delta
		Else 
			If ($g=$Max)
				$hue:=(1/3)+(($b-$r)/6)/$delta
			Else 
				$hue:=(2/3)+(($r-$g)/6)/$delta
			End if 
		End if 
		
		If ($hue<0)
			$hue+=1
		End if 
		If ($hue>1)
			$hue-=1
		End if 
		
		$hsl.H:=Int:C8($hue*360)
	End if 
	return $hsl
	