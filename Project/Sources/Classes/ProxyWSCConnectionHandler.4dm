Class constructor
	/// Web socket client connection handler
	This:C1470.dataType:="blob"
	
Function onMessage($ws : 4D:C1709.WebSocket; $event : Object)
	
	receive+=1
	C_BLOB:C604($blob)
	$pos:=This:C1470._getNull($event.data)
	If ($pos>0)
		C_BLOB:C604($start)
		COPY BLOB:C558($event.data; $start; 0; 0; $pos)
		$message:=Convert to text:C1012($start; "UTF-8")
	End if 
	
	$size:=BLOB size:C605($event.data)
	If ($size>2048)
		COPY BLOB:C558($event.data; $blob; 17; 0; $size-17)
		$hash:=Generate digest:C1147($blob; MD5 digest:K66:1)
	Else 
		$hash:="-"
	End if 
	If ((BLOB size:C605($blob)<50) | ($hash#hash))
		hash:=$hash
		Case of 
			: ($message="gamename")
				COPY BLOB:C558($event.data; $start; $pos+1; 0; BLOB size:C605($event.data)-($pos+1))
				name:=Convert to text:C1012($start; "UTF-8")
				CALL WORKER:C1389("Worker_Proxy_Server"; "Worker_Proxy_Server"; $message; $event.data)
			: ($message="dimensions")
				
				COPY BLOB:C558($event.data; $start; $pos+1; 0; BLOB size:C605($event.data)-($pos+1))
				dimension:=Convert to text:C1012($start; "UTF-8")
				CALL WORKER:C1389("Worker_Proxy_Server"; "Worker_Proxy_Server"; $message; $event.data)
			: ($message="color")
				CALL WORKER:C1389("Worker_Proxy_Server"; "Worker_Proxy_Server"; $message; $event.data)
		End case 
		// send to all clients
		CALL WORKER:C1389("Worker_Proxy_Server"; "Worker_Proxy_Server"; "send"; $event.data; $message)
		send+=1
	Else 
		duplicate+=1
	End if 
	
	
Function onError($ws : 4D:C1709.WebSocket; $event : Object)
	ALERT:C41("Error: "+String:C10($event.errors[0].message))
	
Function onTerminate($ws : 4D:C1709.WebSocket; $event : Object)
	
	
Function onOpen($ws : 4D:C1709.WebSocket; $event : Object)
	CONVERT FROM TEXT:C1011("init"; "UTF-8"; $blob)
	$ws.send($blob)
	
	
Function _getNull($data : Blob)->$pos : Integer
	$pos:=0
	For ($i; 0; BLOB size:C605($data)-1)
		If ($data{$i}=0)
			return $i
		End if 
	End for 
	return -1
	