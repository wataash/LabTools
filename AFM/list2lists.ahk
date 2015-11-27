list2lists(L, max_length)
{
	Llen := L.MaxIndex()
	If (Llen == "")
		throw Exception("Not a list")
	
	num_lists := Ceil(Llen/max_length)
	;~ last_list_length := Mod(Llen, max_length)
	
	res := []
	Loop % num_lists
		res.Insert([])
	
	for i, val_L in L
	{
		i_list := Ceil(i/max_length)       ; e.g. 1,1,1,2,2,2,...
		i_val := Mod(i-1, max_length) + 1  ; e.g. 1,2,3,1,2,3,...
		res[i_list][i_val] := val_L
	}
}
