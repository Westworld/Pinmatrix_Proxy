Class constructor
	/// Web socket client connection handler
	This:C1470.dataType:="blob"
	
Function onMessage($ws : 4D:C1709.WebSocket; $event : Object)
	C_BLOB:C604($blob)
	If (BLOB size:C605($event.data)>2048)
		COPY BLOB:C558($event.data; $blob; 16; 0; BLOB size:C605($event.data)-16)
		$hash:=Generate digest:C1147($blob; MD5 digest:K66:1)
	Else 
		$hash:="-"
	End if 
	If ((BLOB size:C605($blob)<50) | ($hash#Form:C1466.hash))
		If (Form:C1466#Null:C1517)
			Form:C1466.hash:=$hash
		End if 
		$ent:=ds:C1482.Frames.new()
		$ent.TSmilli:=Milliseconds:C459
		$ent.data:=$event.data
		$ent.save()
		If (Form:C1466.messages#Null:C1517)
			Form:C1466.messages.push(New object:C1471("milli"; $ent.TSMilli; "size"; String:C10(BLOB size:C605($blob))))
		End if 
	End if 
	
Function onError($ws : 4D:C1709.WebSocket; $event : Object)
	
	ALERT:C41("Error: "+String:C10($event.errors[0].message))
	
Function onTerminate($ws : 4D:C1709.WebSocket; $event : Object)
	If (Form:C1466.messages#Null:C1517)
		Form:C1466.messages.push({color: "red"; size: "The websocket server is closed!!"; milli: "Server"})
		Form:C1466.connect:=False:C215
	End if 
	
Function onOpen($ws : 4D:C1709.WebSocket; $event : Object)
	If (Form:C1466.messages#Null:C1517)
		Form:C1466.messages.push({color: "red"; size: "The websocket server is opened!!"; milli: "Server"})
		Form:C1466.connect:=True:C214
		CONVERT FROM TEXT:C1011("init"; "UTF-8"; $blob)
		$ws.send($blob)
	End if 
	