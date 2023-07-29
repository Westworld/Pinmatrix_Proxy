Class constructor
	This:C1470.init:=False:C215
	
Function onOpen($WS : 4D:C1709.WebSocketConnection; $para : Object)
	This:C1470.counter:=1
	This:C1470.init:=False:C215
	//$WS.send("init")  // dmd-extensions/LibDmd/Output/Network/www/main.js. 187
	//$WS.send(String($WS.wss.handler.data))
	
Function onMessage($WS : 4D:C1709.WebSocketConnection; $para : Object)
	// display in form
	This:C1470.init:=True:C214
	
	
	
Function onTerminate($WS : 4D:C1709.WebSocketConnection; $para : Object)
	
Function onError($WS : 4D:C1709.WebSocketConnection; $para : Object)
	
	