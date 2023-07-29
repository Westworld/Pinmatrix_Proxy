//%attributes = {}
#DECLARE($in : Blob)->$out : Blob

$insize:=BLOB size:C605($in)
If ($insize%3#0)
	ALERT:C41("wrong size in")
	return 
End if 

SET BLOB SIZE:C606($out; $insize/3*2)
$counter:=0

For ($i; 0; $insize-1; 3)
	$r:=$in{$i}
	$g:=$in{$i+1}
	$b:=$in{$i+2}
	
	$color:=ColorRGBtoInt($r; $g; $b)
	INTEGER TO BLOB:C548($color; $out; PC byte ordering:K22:3; $counter)
	
End for 