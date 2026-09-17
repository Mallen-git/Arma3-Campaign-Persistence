/*
	Author: Mallen

	Description:
		looks for any Campaign Manager modules in the current 3den file, updates there values based on profileNameSpace values

	Parameter(s):
		None

	Returns:
		None

	Examples:
		[] call macp_core_fnc_updateModuleAttributes;
*/

//quick note this is a terible way of doing this, ideally set3DENAttribute would be used, however this fails due to Value not allowed to be a hashmap, maybe it'll get fixed eventually

spawn {
	_currentCameraPos = getPos get3DENCamera;
	_all3denSystems = (all3DENEntities select 3);
	_campaignManagers = _all3denSystems select {typeOf _x isEqualTo "macp_campaignManager"};
	{
		set3DENSelected [_x];
		do3DENAction "OpenAttributes";
		waitUntil {not (isNull(findDisplay 315))};
		(findDisplay 315) closeDisplay 1;
	} forEach _campaignManagers;
};

