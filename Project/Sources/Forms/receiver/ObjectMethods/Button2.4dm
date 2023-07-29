var $url : Text

// url of the websocket server
$url:="ws://192.168.0.103:9090/dmd"

If (Form:C1466.webSocket=Null:C1517)
	// connection of the websocket client
	Form:C1466.webSocket:=4D:C1709.WebSocket.new($url; cs:C1710.WSCConnectionHandler.new())
	
	If (Form:C1466.webSocket#Null:C1517)
		//Form.connect:=True
		//Form.webSocket.send("init")
	Else 
		// Error if connection cannot be established
		Form:C1466.messages.push({color: "red"; size: "The websocket server is not started!!"; milli: "Error"})
	End if 
End if 

