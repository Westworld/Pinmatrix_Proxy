$start:=1

For ($i; 1; 3)
	
	$ent:=ds:C1482.Frames.get($start)
	CALL WORKER:C1389("WebSocketServer"; "WebSocketServer"; "SENDx"; 0; 0; $ent.data)
	$start+=1
	DELAY PROCESS:C323(Current process:C322; 5)
	
End for 

TRACE:C157

$ent:=ds:C1482.Frames.get($start)
CALL WORKER:C1389("WebSocketServer"; "WebSocketServer"; "SENDx"; 0; 0; $ent.data)
$start+=1

$ent:=ds:C1482.Frames.get($start)
CALL WORKER:C1389("WebSocketServer"; "WebSocketServer"; "SENDx"; 0; 0; $ent.data)
$start+=1