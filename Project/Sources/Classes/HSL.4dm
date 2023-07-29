// https://www.programmingalgorithms.com/algorithm/hsl-to-rgb/cpp/

Class constructor($h : Integer; $s : Real; $l : Real)
	This:C1470.H:=$h
	This:C1470.S:=$s
	This:C1470.L:=$l
	
	
Function _HueToRGB($v1 : Real; $v2 : Real; $vh : Real)->$result : Real
	If ($vH<0)
		$vh+=1
	End if 
	If ($vH>1)
		$vh-=1
	End if 
	
	If ((6*$vH)<1)
		return ($v1+($v2-$v1)*6*$vH)
	End if 
	
	If ((2*$vH)<1)
		return ($v2)
	End if 
	
	If ((3*$vH)<2)
		return ($v1+($v2-$v1)*((2/3)-$vH)*6)
	End if 
	return $v1
	
	
	
Function HSLToRGB()->$rgb : cs:C1710.RGB
	If (This:C1470.S=0)
		$val:=Int:C8(This:C1470.L*255)
		$rgb:=cs:C1710.RGB.new($val; $val; $val)
	Else 
		$rgb:=cs:C1710.RGB.new(0; 0; 0)
		var $v1; $v2 : Real
		$hue:=This:C1470.H/360
		$v2:=(This:C1470.L<0.5) ? (This:C1470.L*(1+This:C1470.S)) : ((This:C1470.L+This:C1470.S)-(This:C1470.L*This:C1470.S))
		$v1:=(2*This:C1470.L)-$v2
		$rgb.R:=Int:C8(255*This:C1470._HueToRGB($v1; $v2; $hue+(1/3)))
		$rgb.G:=Int:C8(255*This:C1470._HueToRGB($v1; $v2; $hue))
		$rgb.B:=Int:C8(255*This:C1470._HueToRGB($v1; $v2; $hue-(1/3)))
	End if 
	