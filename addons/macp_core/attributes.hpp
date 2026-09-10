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
			attributeLoad = "_usedValue = _value;if (not (_value isEqualType 'tester')) then {_usedValue = str _value;};(_this controlsGroupCtrl 100) ctrlSetText _usedValue;_ctrlCombo = _this controlsGroupCtrl 659;(_this controlsGroupCtrl 100) ctrlEnable false;_allCampaignData = profileNamespace getVariable ['macp_clientAllCampaignData', createHashMap];_selNotSet = true;{	_lbadd = _ctrlCombo lbadd (str(_forEachIndex + 1)+ ': ' + _x);	_ctrlCombo lbsetdata [_lbadd, (str _y)];	if ((str _y) isEqualTo _usedValue) then	{		_ctrlCombo lbsetcursel _lbadd;		_selNotSet = false;	};} foreach _allCampaignData;_lbadd = _ctrlCombo lbadd 'Custom Data';_ctrlCombo lbsetdata [_lbadd, 'CUSTOMCHOSEN'];if (_selNotSet) then{	_ctrlCombo lbsetcursel _lbadd;	(_this controlsGroupCtrl 100) ctrlEnable true;};";

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
					onLBSelChanged = "params ['_control', '_lbCurSel'];_curData = _control lbData _lbCurSel;_ctrlGroup = ctrlParentControlsGroup _control;_valuectrl = _ctrlGroup controlsGroupCtrl 100;if (_curData isEqualTo 'CUSTOMCHOSEN') then{	_valuectrl ctrlEnable true;} else {	_valuectrl ctrlEnable false;	_valuectrl ctrlSetText _curData;};";
				};
			};
		};
	};
};
