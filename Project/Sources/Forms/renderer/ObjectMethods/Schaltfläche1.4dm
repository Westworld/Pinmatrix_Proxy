$ent:=ds:C1482.Frames.get(Form:C1466.ID)
If ($ent#Null:C1517)
	
	If ($ent.datasize#4112)
		ALERT:C41("falsche größe")
		return 
	End if 
	
	BLOB TO DOCUMENT:C526(System folder:C487(Desktop:K41:16)+"blob.raw"; $ent.data)
End if 
