Class constructor
	
Function onOpen($WS : 4D:C1709.WebSocketConnection; $para : Object)
	// new client connects, send what we have
	If (LastName#Null:C1517)
		$WS.send(LastName)
		If (LastDimensions#Null:C1517)
			$WS.send(LastDimensions)
			If (LastColor#Null:C1517)
				$WS.send(LastColor)
			End if 
		End if 
	End if 
	
	
Function onMessage($WS : 4D:C1709.WebSocketConnection; $para : Object)
	
	
Function onTerminate($WS : 4D:C1709.WebSocketConnection; $para : Object)
	
Function onError($WS : 4D:C1709.WebSocketConnection; $para : Object)
	
	