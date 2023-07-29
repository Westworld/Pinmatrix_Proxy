//%attributes = {"publishedWeb":true}
C_TEXT:C284($1)

// new received data is stored in storage, so available for next call
// also send to form, to display if (not mandatory) the form is opened

If ($1#"")
	$newdata:=Substring:C12($1; 2)
	If ($newdata#"")
		CALL FORM:C1391(Num:C11(Storage:C1525.web.form); Formula from string:C1601("Form.data := "+$newdata))
		If (Storage:C1525.web=Null:C1517)
			Use (Storage:C1525)
				Storage:C1525.web:=New shared object:C1526("data"; $newdata)
			End use 
		Else 
			Use (Storage:C1525.web)
				Storage:C1525.web.data:=$newdata
			End use 
		End if 
	End if 
End if 

$answer:=New object:C1471("data"; String:C10(Storage:C1525.web.data))
$text:=JSON Stringify:C1217($answer)
CONVERT FROM TEXT:C1011($text; "UTF-8"; $blob)
WEB SEND BLOB:C654($blob; "application/json")
