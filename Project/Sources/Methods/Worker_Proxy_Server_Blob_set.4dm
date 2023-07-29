//%attributes = {}
#DECLARE($pointer : Pointer; $x : Integer; $y : Integer; $offset : Integer; $color : Integer)

$pointer->{($x*2)+($y*128*2)+$offset}:=($color & 0x00FF)
$pointer->{($x*2)+($y*128*2)+$offset+1}:=($color >> 8)
