/*
Copyright (c) 2015 Wataru Ashihara <expllion@gmail.com>

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU Affero General Public License as published by the Free
Software Foundation, either version 3 of the License, or (at your option) any
later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License along
with this program. If not, see <http://www.gnu.org/licenses/>.
*/

#Include <Yunit\Yunit>
#Include <Yunit\Window>
#Include <Yunit\StdOut>

#Include list2lists.ahk
Yunit.Use(YunitStdOut, YunitWindow).Test(List2listsTestSuite)

class List2listsTestSuite
{
	; == operator between two objects doesn't work.
	; [1] == [1] returns 0.
	
	divisible()
	{
		L := [1,2,3,4,5,6,7,8,9,10,11,12]
		dbg := list2lists(L, 1)
		dbg2 := [[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12]]
		Yunit.assert(dbg == dbg2)
		Yunit.assert(list2lists(L, 2) == [[1,2],[3,4],[5,6],[7,8],[9,10],[11,12]])
		Yunit.assert(list2lists(L, 3) == [[1,2,3],[4,5,6],[7,8,9],[10,11,12]])
		Yunit.assert(list2lists(L, 4) == [[1,2,3,4],[5,6,7,8],[9,10,11,12]])
		Yunit.assert(list2lists(L, 6) == [[1,2,3,4,5,6],[7,8,9,10,11,12]])
		Yunit.assert(list2lists(L, 12) == [[1,2,3,4,5,6,7,8,9,10,11,12]])
	}
	
	;~ indivisible()
	;~ {
	;~ }
	
	Test_Complex()
	{
		Yunit.assert(list2lists([1], 10) == [[1]])
		Yunit.assert(list2lists([["a","b"], 2, "c", [1,[2,3]], 555], 2)
						== [[["a","b"], 2], ["c", [1,[2,3]]], 555])
	}
	
	class TestArgList
	{
		scalar()
		{
			this.ExpectedException := Exception("Not a list")
			list2lists(0, 1)
		}
	}
	
	class TestArgLength
	{
		
		zero()
		{
			this.ExpectedException := Exception("Invalid length")
			list2lists([1,2], 0)
		}
		
		negative()
		{
			this.ExpectedException := Exception("Invalid length")
			list2lists([1,2], -1)
		}
		
		float_num()
		{
			this.ExpectedException := Exception("Invalid length")
			list2lists([1,2], 0.1)
		}

		string()
		{
			this.ExpectedException := Exception("Invalid length")
			list2lists([1,2], "string")
		}
	}
}
