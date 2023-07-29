$start:=18440

$ent:=ds:C1482.Frames.get($start)
CALL WORKER:C1389("WebSocketServer"; "WebSocketServer"; "SENDx"; 0; 0; $ent.data)
$start+=1
DELAY PROCESS:C323(Current process:C322; 5)

$ent:=ds:C1482.Frames.get($start)
CALL WORKER:C1389("WebSocketServer"; "WebSocketServer"; "SENDx"; 0; 0; $ent.data)
$start+=1
DELAY PROCESS:C323(Current process:C322; 5)


$offset:=7

C_BLOB:C604($newdataLA; $newdataRA; $newdataLB; $newdataRB)

$newoffsetLA:=0
$newoffsetRA:=0
TEXT TO BLOB:C554("rgb16A"; $newdataLA; Mac C string:K22:7; $newoffsetLA)
TEXT TO BLOB:C554("rgb16A"; $newdataRA; Mac C string:K22:7; $newoffsetRA)
SET BLOB SIZE:C606($newdataLA; 128*32*2+7; 0)
SET BLOB SIZE:C606($newdataRA; 128*32*2+7; 0)
$newoffsetLB:=0
$newoffsetRB:=0
TEXT TO BLOB:C554("rgb16B"; $newdataLB; Mac C string:K22:7; $newoffsetLB)
TEXT TO BLOB:C554("rgb16B"; $newdataRB; Mac C string:K22:7; $newoffsetRB)
SET BLOB SIZE:C606($newdataLB; 128*32*2+7; 0)
SET BLOB SIZE:C606($newdataRB; 128*32*2+7; 0)

For ($x; 1; 126)
	$newdataLB{($x*2)+$offset}:=(0xF800 & 0x00FF)
	$newdataLB{($x*2)+1+$offset}:=(0xF800 >> 8)
	
	$newdataLA{($x*2)+$offset}:=(0xF800 & 0x00FF)
	$newdataLA{($x*2)+1+$offset}:=(0xF800 >> 8)
End for 

/*
For ($x; 0; 127)
For ($y; 0; 63)

If (($x>0) && ($x<127))
If ($y<32)
$color:=ColorRGBtoInt(255; 0; 0)
Else 
$color:=ColorRGBtoInt(0; 0; 255)
End if 
Else 
$color:=0
End if 
If ($x<128)
If ($y<32)
INTEGER TO BLOB($color; $newdataLA; PC byte ordering; $newoffsetLA)
Else 
INTEGER TO BLOB($color; $newdataLB; PC byte ordering; $newoffsetLB)
End if 
Else 
If ($y<32)
INTEGER TO BLOB($color; $newdataRA; PC byte ordering; $newoffsetRA)
Else 
INTEGER TO BLOB($color; $newdataRB; PC byte ordering; $newoffsetRB)
End if 
End if 
$offset+=3
End for 

End for 
// send left - right
*/

//While (True)
CALL WORKER:C1389("WebSocketServer"; "WebSocketServer"; "SENDx"; 0; 0; $newdataLA)
DELAY PROCESS:C323(Current process:C322; 5)
CALL WORKER:C1389("WebSocketServer"; "WebSocketServer"; "SENDx"; 0; 0; $newdataLB)
DELAY PROCESS:C323(Current process:C322; 50)
//End while 