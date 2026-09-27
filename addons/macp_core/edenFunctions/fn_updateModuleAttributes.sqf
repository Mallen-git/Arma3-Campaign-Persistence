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

//quick note this is a terible way of doing this, ideally set3DENAttribute would be used, however this fails due to Value not allowed to be a hashmap, maybe itll get fixed eventually

spawn {
	//get all campaign manager modules
	_all3denSystems = (all3DENEntities select 3);
	_campaignManagers = _all3denSystems select {typeOf _x isEqualTo "macp_campaignManager"};

	{
		//make the module selected
		set3DENSelected [_x];

		//open its attributes
		do3DENAction "OpenAttributes";

		//wait until its attributes window actually opens
		waitUntil {not (isNull(findDisplay 315))};

		//immediately close it
		(findDisplay 315) closeDisplay 1;
	} forEach _campaignManagers;
	//cannot set selected to nothing after this, for some reason this causes a hang when called on mission load
};

