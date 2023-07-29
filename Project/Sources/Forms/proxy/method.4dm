If (FORM Event:C1606.code=On Load:K2:1)
	
	SET TIMER:C645(10)
	
End if 

If (FORM Event:C1606.code=On Timer:K2:25)
	$url:="ws://192.168.0.103:9090/dmd"
	
	If ((webSocketClient=Null:C1517) || (String:C10(webSocketClient.status)="closed"))
		LastName:=Null:C1517
		Lastdimensions:=Null:C1517
		LastColor:=Null:C1517
		// connection of the websocket client
		ON ERR CALL:C155("nothing")
		webSocketClient:=4D:C1709.WebSocket.new($url; cs:C1710.ProxyWSCConnectionHandler.new())
		ON ERR CALL:C155("")
		
	End if 
	
End if 