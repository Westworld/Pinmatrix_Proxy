Case of 
	: (FORM Event:C1606.code=On Unload:K2:2)
		CALL WORKER:C1389("WebSocketServer"; "WebSocketServer"; "deINIT"; Form:C1466.data)
		
	: (FORM Event:C1606.code=On Load:K2:1)
		Form:C1466.data:=1
		CALL WORKER:C1389("WebSocketServer"; "WebSocketServer"; "INIT"; Form:C1466.data; Current form window:C827)
		
		
	: (FORM Event:C1606.code=On Timer:K2:25)
		
		CALL WORKER:C1389("WebSocketServer"; "WebSocketServer"; "SEND"; Form:C1466.data)
End case 