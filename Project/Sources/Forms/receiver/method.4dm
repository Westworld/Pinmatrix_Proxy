If (FORM Event:C1606.code=On Load:K2:1)
	Form:C1466.messages:=New collection:C1472
	Form:C1466.hash:=""
	Form:C1466.connect:=False:C215
	SET TIMER:C645(10)
End if 

If (FORM Event:C1606.code=On Timer:K2:25)
	If (Form:C1466.connect=False:C215)
		var $url : Text
		
		// url of the websocket server
		$url:="ws://192.168.0.103:9090/dmd"
		
		If ((Form:C1466.webSocket=Null:C1517) || (String:C10(Form:C1466.webSocket.status)="closed"))
			// connection of the websocket client
			ON ERR CALL:C155("nothing")
			Form:C1466.webSocket:=4D:C1709.WebSocket.new($url; cs:C1710.WSCConnectionHandler.new())
			ON ERR CALL:C155("")
			
			//If (Form.webSocket#Null)
			//Form.connect:=True
			//Form.webSocket.send("init")
			//End if 
			
			
		End if 
	End if 
End if 

If (False:C215)
	SET TIMER:C645(0)
End if 