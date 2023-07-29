//%attributes = {}
#DECLARE($job : Text; $data : 4D:C1709.Blob; $message : Text)
var wss : 4D:C1709.WebSocketServer

Case of 
		
		
	: ($job="INIT")
		If (wss=Null:C1517)
			var $handler : cs:C1710.WSSHandler
			$handler:=cs:C1710.ProxyWSSHandler.new()
			$options:=New object:C1471("dataType"; "blob")
			wss:=4D:C1709.WebSocketServer.new($handler; $options)
		End if 
		
	: ($job="gameName")
		LastName:=$data
	: ($job="dimensions")
		Lastdimensions:=$data
	: ($job="color")
		LastColor:=$data
		
	: ($job="SEND")
		
		If ($message="rgb24")
			
			// convert to rgb16 und split left right
			$offset:=5+1+4
			$total:=BLOB size:C605($data)
			If ($total<((256*64*3)+$offset))
				ALERT:C41("data zu klein")
				return 
			End if 
			
			C_BLOB:C604($newdataL; $newdataR)
			
			$newoffset:=7
			
			$newoffsetLA:=0
			$newoffsetRA:=0
			TEXT TO BLOB:C554("rgb16A"; $newdataLA; Mac C string:K22:7; $newoffsetLA)
			TEXT TO BLOB:C554("rgb16A"; $newdataRA; Mac C string:K22:7; $newoffsetRA)
			SET BLOB SIZE:C606($newdataLA; 128*32*2+$newoffset; 0)
			SET BLOB SIZE:C606($newdataRA; 128*32*2+$newoffset; 0)
			$newoffsetLB:=0
			$newoffsetRB:=0
			TEXT TO BLOB:C554("rgb16B"; $newdataLB; Mac C string:K22:7; $newoffsetLB)
			TEXT TO BLOB:C554("rgb16B"; $newdataRB; Mac C string:K22:7; $newoffsetRB)
			SET BLOB SIZE:C606($newdataLB; 128*32*2+$newoffset; 0)
			SET BLOB SIZE:C606($newdataRB; 128*32*2+$newoffset; 0)
			
			For ($y; 0; 63)
				For ($x; 0; 255)
					$color:=ColorRGBtoInt($data[$offset+0]; $data[$offset+1]; $data[$offset+2])
					If ($x<128)
						If ($y<32)
							Worker_Proxy_Server_Blob_set(->$newdataLA; $x; $y; $newoffset; $color)
							//INTEGER TO BLOB($color; $newdataLA; PC byte ordering; $newoffsetLA)
						Else 
							Worker_Proxy_Server_Blob_set(->$newdataLB; $x; $y-32; $newoffset; $color)
							//INTEGER TO BLOB($color; $newdataLB; PC byte ordering; $newoffsetLB)
						End if 
					Else 
						If ($y<32)
							Worker_Proxy_Server_Blob_set(->$newdataRA; $x-128; $y; $newoffset; $color)
							//INTEGER TO BLOB($color; $newdataRA; PC byte ordering; $newoffsetRA)
						Else 
							Worker_Proxy_Server_Blob_set(->$newdataRB; $x-128; $y-32; $newoffset; $color)
							//INTEGER TO BLOB($color; $newdataRB; PC byte ordering; $newoffsetRB)
						End if 
					End if 
					$offset+=3
				End for 
			End for 
			
			// send left - right
			If (wss.connections.length>=1)
				wss.connections[0].send($newdataRA)
				DELAY PROCESS:C323(Current process:C322; 1)
				wss.connections[0].send($newdataRB)
			End if 
			If (wss.connections.length>=2)
				wss.connections[1].send($newdataRA)
				DELAY PROCESS:C323(Current process:C322; 1)
				wss.connections[1].send($newdataRB)
			End if 
			
		Else 
			
			If (wss#Null:C1517)
				For each ($conn; wss.connections)
					$conn.send($data)
				End for each 
			End if 
		End if 
		
End case 