//%attributes = {}
#DECLARE($r : Integer; $g : Integer; $b : Integer)->$color : Integer

If (Count parameters:C259=1)
	var $long32 : Integer
	
	$long32:=$r
	$b:=$long32 & 0x00FF
	$g:=($long32 & 0xFF00) >> 8
	$r:=($long32 & 0x00FF0000) >> 16
	
End if 


$color:=(($r & 0x00F8) << 8) | (($g & 0x00FC) << 3) | ($b >> 3)
return $color

var $red5; $green6; $blue5 : Integer
var $red5_shifted; $green6_shifted : Integer
/*
$red5:=Round($r/255*31; 0)
//Convert 8-bit green to 6-bit green.
$green6:=Round($g/255*63; 0)
//Convert 8-bit blue to 5-bit blue.
$blue5:=Round($b/255*31; 0)

//Shift the red value to the left by 11 bits.
$red5_shifted:=$red5 << 11
//#Shift the green value to the left by 5 bits.
$green6_shifted:=$green6 << 5

//#Combine the red, green, and blue values.
$rgb565:=$red5_shifted | $green6_shifted | $blue5

return $rgb565
*/