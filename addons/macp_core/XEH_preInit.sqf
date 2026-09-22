[
	"macp_autoSaveTime", // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
	"TIME", // setting type
	["Auto save Interval", "How often is the campaign data saved and sent to players?"],
	"MACP - Campaign Persistence", // Pretty name of the category where the setting can be found. Can be stringtable entry.
	[5, 300, 30], // data for this setting: [min, max, default, number of shown trailing decimals]
	true, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
	{},
	true
] call CBA_fnc_addSetting;

[
	"macp_saveChoice", // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
	"LIST", // setting type
	["Who saves Campaign Data?", "Which players in a multiplayer scenario save the campaign data to their profiles?"],
	"MACP - Campaign Persistence", // Pretty name of the category where the setting can be found. Can be stringtable entry.
	[[1,2,3],["Admin Only", "Admin + UIDs", "All Players"],0], // data for this setting: [min, max, default, number of shown trailing decimals]
	true // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
] call CBA_fnc_addSetting;

[
	"macp_saveUIDs", // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
	"EDITBOX", // setting type
	["UIDs of players to save", 'Which UIDs should save the campaign data for the current mission, formatted as: ["76561198000000000","76561198000000001"]'],
	"MACP - Campaign Persistence", // Pretty name of the category where the setting can be found. Can be stringtable entry.
	"[]", // data for this setting: [min, max, default, number of shown trailing decimals]
	true // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
] call CBA_fnc_addSetting;

[
	"macp_defaultKit", // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
	"CHECKBOX", // setting type
	["Recieve default kit?", 'Should players recieve the default kit when they respawn or are new to the campaign? if not, kit will default to whatever was set for the unit in the editor'],
	"MACP - Campaign Persistence", // Pretty name of the category where the setting can be found. Can be stringtable entry.
	true, // data for this setting: [min, max, default, number of shown trailing decimals]
	true // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
] call CBA_fnc_addSetting;
