//%attributes = {}
#DECLARE($job : Text; $value : Integer; $form : Integer; $data : Blob)
var wss : 4D:C1709.WebSocketServer

Case of 
	: ($job="Deinit")
		//CLOSE DOCUMENT(moviehandle)
		
	: ($job="INIT_Record")
		If (wss=Null:C1517)
			var $handler : cs:C1710.WSSHandler
			$handler:=cs:C1710.WSSHandler.new($value; $form)
			$options:=New object:C1471("dataType"; "blob")
			wss:=4D:C1709.WebSocketServer.new($handler; $options)
		End if 
		
		
	: ($job="INIT")
		If (wss=Null:C1517)
			var $handler : cs:C1710.WSSHandler
			$handler:=cs:C1710.WSSHandler.new()
			$options:=New object:C1471("dataType"; "blob")
			wss:=4D:C1709.WebSocketServer.new($handler; $options)
		End if 
		windowform:=$form
		job:=$value
		
		
	: ($job="SENDx")
		
		If (wss#Null:C1517)
			For each ($conn; wss.connections)
				
				$conn.send($data)
				
			End for each 
		End if 
		
		
	: ($job="SEND")
		
		$ent:=ds:C1482.Frames.get(job)
		If (BLOB size:C605($ent.data)>(256*64*3))
			Worker_Proxy_Server("send"; $ent.data; "rgb24")
			If (job<18449)
				job+=1
			End if 
		Else 
			
			If (wss#Null:C1517)
				For each ($conn; wss.connections)
					//If ($conn.handler.init)
					$conn.send($ent.data)
					If (job<18453)
						job+=1
					End if 
					//End if 
				End for each 
			End if 
		End if 
		
End case 