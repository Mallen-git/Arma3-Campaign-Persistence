/*
	Author: Mallen

	Description:
		Checks whether player is allowed to save campaign data to profileNameSpace

	Parameter(s):
		None

	Returns:
		Boolean

	Examples:
		[] call macp_core_fnc_canSaveCampaignData;
*/

_saveValue = false;

//depending on CBA settings choice either save or dont save
switch (macp_saveChoice) do
{
	//only admin
	case 1: {_saveValue = ((call BIS_fnc_admin) > 0);};

	//admin and UIDs
	case 2: {
		_saveValue = ((call BIS_fnc_admin) > 0);
		if ([macp_saveUIDs] call macp_core_fnc_validUIDArray) then
		{
			_array = parseSimpleArray macp_saveUIDs;
			if ((getPlayerUID player) in _array) then
			{
				_saveValue = true;
			};
		};
	};

	//Everyone
	case 3: {_saveValue = true;};

	//also only admin
	default {_saveValue = ((call BIS_fnc_admin) > 0);};
};

_saveValue;
