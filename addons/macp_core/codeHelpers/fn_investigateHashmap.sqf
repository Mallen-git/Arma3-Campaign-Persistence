/*
	Author: Mallen

	Description:
		Provides the unit requested their current loadout based on the servers knowledge

	Parameter(s):
		0: HASHMAP - Hashmap of all keys that would constitute a hashmap and whether that hashmaps children are also all hashmaps
		1: HASHMAP - The hashmap to investigate
		2: BOOL - (Optional, default false) Whether all of the items in the hashmap are themselves hashmaps

	Returns:
		None

	Examples:
		[_hashmapIdentifiers, _newHashmap, _childrenHashmaps] call macp_core_fnc_investigateHashmap;
*/


params[["_hashmapIdentifiers", objNull, [createHashMap]], ["_workingHashMap", objNull, [createHashMap]], ["_allHashmaps", false, [false]]];

{
	_key = _x;
	_value = _y;

	if (_key in _hashmapIdentifiers or _allHashmaps) then
	{
		_newHashmap = createHashMapFromArray _value;
		_childrenHashmaps = _hashmapIdentifiers getOrDefault [_key, false];
		_workingHashMap set [_key, _newHashmap];
		[_hashmapIdentifiers, _newHashmap, _childrenHashmaps] call macp_core_fnc_investigateHashmap;
	};
} forEach _workingHashMap;
