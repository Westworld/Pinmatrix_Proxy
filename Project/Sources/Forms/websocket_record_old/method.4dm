Case of 
		
	: (FORM Event:C1606.code=On Load:K2:1)
		Form:C1466.data:=1
		CALL WORKER:C1389("WebSocketServer"; "WebSocketServer"; "INIT_Record"; Form:C1466.data; Current form window:C827)
		
		
		
End case 