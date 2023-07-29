Class extends Entity

exposed Function get datasize->$size : Integer
	$size:=BLOB size:C605(This:C1470.data)
	
exposed Function get type->$text : Text
	$pos:=This:C1470._getNull(This:C1470.data)
	If ($pos>0)
		C_BLOB:C604($start)
		COPY BLOB:C558(This:C1470.data; $start; 0; 0; $pos)
		$text:=Convert to text:C1012($start; "UTF-8")
	End if 
	
exposed Function get preview->$text : Text
	If (This:C1470.datasize<30)
		$text:=This:C1470.type
		$pos:=Length:C16($text)
		Case of 
			: ($text="gameName")
				C_BLOB:C604($sub)
				COPY BLOB:C558(This:C1470.data; $sub; $pos+1; 0; BLOB size:C605(This:C1470.data)-$pos-1)
				$text2:=Convert to text:C1012($sub; "UTF-8")
				$text:=$text+": "+$text2
				
			: ($text="dimensions")
				If (BLOB size:C605(This:C1470.data)>($pos+8))
					$offset:=$pos+1
					$x:=BLOB to longint:C551(This:C1470.data; PC byte ordering:K22:3; $offset)
					$y:=BLOB to longint:C551(This:C1470.data; PC byte ordering:K22:3; $offset)
					$text+=(": "+String:C10($x)+"/"+String:C10($y))
				Else 
					$text:="error dimensions???"
				End if 
				
			: ($text="color")
				C_BLOB:C604($sub)
				COPY BLOB:C558(This:C1470.data; $sub; $pos+1; 0; 3)
				$color:=ColorRGBtoInt($sub{2}; $sub{1}; $sub{0})
				$text:=$text+": "+String:C10($color; "&x")
				
			: ($text="palette")
				If (BLOB size:C605(This:C1470.data)>=28)
					$offset:=$pos+1
					$countcolors:=BLOB to longint:C551(This:C1470.data; PC byte ordering:K22:3; $offset)
					$color_col:=New collection:C1472
					For ($i; 1; $Countcolors)
						$color:=BLOB to longint:C551(This:C1470.data; PC byte ordering:K22:3; $offset)
						$color_col.push($color)
					End for 
					
					$text+=JSON Stringify:C1217($color_col)
				Else 
					$text:="error dimensions???"
				End if 
				
		End case 
		
		
	Else 
		$pos:=This:C1470._getNull(This:C1470.data)
		If ($pos>0)
			C_BLOB:C604($start)
			COPY BLOB:C558(This:C1470.data; $start; 0; 0; $pos)
			$text:=Convert to text:C1012($start; "UTF-8")
			$text:=$text
			$pos+=1
			$stamp:=BLOB to longint:C551(This:C1470.data; PC byte ordering:K22:3; $pos)
			$text+=(" stamp: "+String:C10($stamp))
			
		Else 
			$text:="very large"
		End if 
	End if 
	
exposed Function get digest->$text : Text
	C_BLOB:C604($blob)
	Case of 
		: (BLOB size:C605(This:C1470.data)>=4112)
			COPY BLOB:C558(This:C1470.data; $blob; 16; 0; 4096)
			$hash:=Generate digest:C1147($blob; MD5 digest:K66:1)
			$text:=Substring:C12($hash; 1; 10)
			
		: (BLOB size:C605(This:C1470.data)>2048)
			COPY BLOB:C558(This:C1470.data; $blob; 16; 0; 2048)
			$hash:=Generate digest:C1147($blob; MD5 digest:K66:1)
			$text:=Substring:C12($hash; 1; 10)
			
		Else 
			$text:="-"
	End case 
	
Function _getNull($data : Blob)->$pos : Integer
	$pos:=0
	For ($i; 0; BLOB size:C605($data)-1)
		If ($data{$i}=0)
			return $i
		End if 
	End for 
	return -1