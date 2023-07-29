If (FORM Event:C1606.code=On Load:K2:1)
	Form:C1466.data:=Random:C100%100
	
	If (Storage:C1525.web=Null:C1517)
		Use (Storage:C1525)
			Storage:C1525.web:=New shared object:C1526("data"; Form:C1466.data; "form"; Current form window:C827)
		End use 
	Else 
		Use (Storage:C1525.web)
			Storage:C1525.web.data:=Form:C1466.data
			Storage:C1525.web.form:=Current form window:C827
		End use 
	End if 
End if 