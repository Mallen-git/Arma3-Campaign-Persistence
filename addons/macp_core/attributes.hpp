class Cfg3DEN
{
	class Attributes
	{
		class EditMulti3;
		class EditMulti5: EditMulti3
		{
			class Controls;
		};
		class EditCodeMulti5: EditMulti5 {
			class Controls: Controls {
				class Title;
				class Background;
				class Value;
			};
		};
		// Your attribute class
		class MACP_comboCampaignKey : EditCodeMulti5
		{
			attributeLoad = "_usedValue = _value;if (not (_value isEqualType createHashMap)) then {_usedValue = createHashMap;};(_this controlsGroupCtrl 100) ctrlSetText (str _usedValue);_ctrlCombo = _this controlsGroupCtrl 659;_currentKey = _usedValue getOrDefault ['key', 'NOKEYFOUNDRIP'];_allCampaignData = profileNamespace getVariable ['macp_clientAllCampaignData', createHashMap];_selNotSet = true;_emptyCampaignData = true;{	_emptyCampaignData = false;	_lbadd = _ctrlCombo lbadd (str(_forEachIndex + 1)+ ': ' + _x);	_ctrlCombo lbsetdata [_lbadd, _x];	_testingKey = _y getOrDefault ['key', 'NOKEYFOUNDDOUBLERIP'];	if (_testingKey isEqualTo _currentKey) then	{		_ctrlCombo lbsetcursel _lbadd;		_selNotSet = false;	};} foreach _allCampaignData;if (_emptyCampaignData) then{	_lbadd = _ctrlCombo lbadd 'No Campaigns Found';	_ctrlCombo lbsetdata [_lbadd, 'NOCAMPAIGNSFOUNDRIP'];	_ctrlCombo lbsetcursel _lbadd;	(_this controlsGroupCtrl 100) ctrlSetText 'Create a campaign in the MACP Campaign Manager tool at the top of Eden Editor under Tools...';};";
			attributeSave = "_ctrlCombo = _this controlsGroupCtrl 659;_curSel = lbCurSel _ctrlCombo;_key = _ctrlCombo lbdata _curSel;_allCampaignData = profileNamespace getVariable ['macp_clientAllCampaignData', createHashMap];_allCampaignData getOrDefault [_key, 'NOCAMPAIGNSFOUNDRIP'];";

			h = "6.4 * 	5 * (pixelH * pixelGrid * 	0.50)";
			// List of controls, structure is the same as with any other controls group
			class Controls : Controls
			{
				class Background: Background
				{
					h = "(5 * 	5.5) * (pixelH * pixelGrid * 	0.50)";
				};
				class Title: Title
				{
					h = "(5 * 	5.9) * (pixelH * pixelGrid * 	0.50)";
				};
				class Value : Value
				{
					//no autocomplete as i'm handeling it from here out
					y = "2.4 * 	5 * (pixelH * pixelGrid * 	0.50)";
					canModify = 0;
				};
				class Combo : ctrlCombo
				{
					idc = 659;
					colorSelectRight[] = {0,0,0,0.5};
					colorTextRight[] = {1,1,1,0.5};
					h = "5 * (pixelH * pixelGrid * 	0.50)";
					w = "81 * (pixelW * pixelGrid * 	0.50)";
					x = "47 * (pixelW * pixelGrid * 	0.50)";
					y = "1 * 5 * (pixelH * pixelGrid * 	0.50)";
					onLBSelChanged = "params ['_control', '_lbCurSel'];_curData = _control lbData _lbCurSel;_ctrlGroup = ctrlParentControlsGroup _control;_valuectrl = _ctrlGroup controlsGroupCtrl 100;_allCampaignData = profileNamespace getVariable ['macp_clientAllCampaignData', createHashMap];if (_curData isEqualTo 'NOCAMPAIGNSFOUNDRIP') then{	_valuectrl ctrlSetText 'Create a campaign in the MACP Campaign Manager tool at the top of Eden Editor under Tools...';} else {	_campaignToShow = _allCampaignData get _curData;	_valuectrl ctrlSetText (str _campaignToShow);};";
				};
			};
		};
	};
	class EventHandlers
	{
		class macpEventHandlers
		{
			onMissionLoad = "[] call macp_core_fnc_updateModuleAttributes;";
			OnMissionPreviewEnd = "[] call macp_core_fnc_updateModuleAttributes;";
		};
	};
};
