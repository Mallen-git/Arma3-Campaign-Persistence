/*
	Author: Mallen

	Description:
		Updates the player list based on filter and search term

	Parameter(s):
		0: DISPLAY - The display used for the admin menu

	Returns:
		None

	Examples:
		[_display] call macp_core_fnc_updatePlayerList;
*/
params [["_display", displayNull, [displayNull]]];

//no display? how did we get here...
if (isNull _display) exitWith {};

_filterCombo = _display displayCtrl 1021;
_searchBar = _display displayCtrl 1020;
_playerListBox = _display displayCtrl 1500;

//clear listbox and add default choice
lbClear _playerListBox;
_lbAdd = _playerListBox lbAdd "No Selection";
_playerListBox lbSetData [_lbAdd, "NOSELECTION"];
_playerListBox lbSetCurSel _lbAdd;

//get search term, if not typed set to nothing for wildcard
_searchTerm = toLower (ctrlText _searchBar);
if (_searchTerm isEqualTo "search...") then {_searchTerm = "";};

//for all player profiles
_allPlayerProfiles = macp_currentCampaignData get "players";
{
	_uid = _x;
	_name = _y get "lastUsedName";

	//check if name matches search term
	_nameLower = toLower _name;
	if ((_nameLower find _searchTerm) isEqualTo -1) then {continue;};

	//add name to list box
	_lbAdd = _playerListBox lbAdd (_name + " (" + _uid + ")");
	_playerListBox lbSetData [_lbAdd, _uid];
} forEach _allPlayerProfiles;

_selectedFilter = lbCurSel _filterCombo;

//if filter is set to 0 we are looking at online players
if (_selectedFilter isEqualTo 0) then
{
	//get all online player UIDs
	_validUIDs = [];
	{
		_uid = getPlayerUID _x;
		_validUIDs pushBack _uid;
	} forEach allPlayers;

	//figure out what indexs to delete as those players are offline
	_indToDelete = [];
	for [{ _i = 1 }, { _i < (lbSize _playerListBox) }, { _i = _i + 1 }] do
	{
		_data = _playerListBox lbData _i;
		if (not (_data in _validUIDs)) then
		{
			_indToDelete pushBack _i;
		};
	};

	//delete the not needed indexs
	{
		_playerListBox lbDelete _x;
	} forEachReversed _indToDelete
};
