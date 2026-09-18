class RscEdit;
class RscText;
class RscTree;

// Eden base controls
class ctrlActivePictureKeepAspect;
class ctrlButton;
class ctrlButtonCancel;
class ctrlButtonClose;
class ctrlButtonCollapseAll;
class ctrlButtonExpandAll;
class ctrlButtonOK;
class ctrlButtonPictureKeepAspect;
class ctrlButtonSearch;
class ctrlButtonToolbar;
class ctrlCheckbox;
class ctrlCheckboxToolbar;
class ctrlCombo;
class ctrlControlsGroup;
class ctrlControlsGroupNoScrollbars;
class ctrlEdit;
class ctrlEditMulti;
class ctrlListbox;
class ctrlListNBox;
class ctrlMap;
class ctrlMenu;
class ctrlMenuStrip;
class ctrlProgress;
class ctrlShortcutButtonSteam;
class ctrlStatic;
class ctrlStaticBackground;
class ctrlStaticBackgroundDisable;
class ctrlStaticBackgroundDisableTiles;
class ctrlStaticFooter;
class ctrlStaticFrame;
class ctrlStaticMulti;
class ctrlStaticOverlay;
class ctrlStaticPicture;
class ctrlStaticPictureKeepAspect;
class ctrlStaticTitle;
class ctrlStructuredText;
class ctrlToolbox;
class ctrlToolboxPictureKeepAspect;
class ctrlTree;
class ctrlXSliderH;
class scrollbar;

class macp_campaignManagerToolDialog
{
	idd = -1;
	onUnload = "[] call macp_core_fnc_updateModuleAttributes;";
	class ControlsBackground
	{
		//Background controls

		class BackgroundDisable: ctrlStaticBackgroundDisable {};
		class BackgroundDisableTiles: ctrlStaticBackgroundDisableTiles {};

		class Header: ctrlStaticTitle
		{
			text = "MACP Campaign Editor";
			x = CENTER_X - WINDOW_W_WIDE * 0.5 * GRID_W;
			y = WINDOW_TOPAbs;
			w = WINDOW_W_WIDE * GRID_W;
			h = CTRL_DEFAULT_H;
		};

		class Background: ctrlStaticBackground
		{
			x = CENTER_X - WINDOW_W_WIDE * 0.5 * GRID_W;
			y = WINDOW_TOPAbs + 2 * CTRL_DEFAULT_H;
			w = WINDOW_W_WIDE * GRID_W;
			h = WINDOW_HAbs - 4 * CTRL_DEFAULT_H;
		};

		class Footer: ctrlStaticFooter
		{
			x = CENTER_X - WINDOW_W_WIDE * 0.5 * GRID_W;
			y = WINDOW_TOPAbs + WINDOW_HAbs - 3 * CTRL_DEFAULT_H - 2 * GRID_H;
			w = WINDOW_W_WIDE * GRID_W;
			h = 7 * GRID_H;
		};
	};
	class Controls
	{
		//Controls

		class RscPicture_1200: ctrlStaticPicture
		{
			idc = 1200;
			//text = "#(argb,512,512,1)r2t(macprttforunit,1.0)";
			text = "#(rgb,8,8,3)color(1,0,0,0)";
			x = CENTER_X - WINDOW_W_WIDE * 0.5 * GRID_W + 0.3 * WINDOW_W_WIDE * GRID_W;
			y = WINDOW_TOPAbs + 2 * CTRL_DEFAULT_H;
			w = 0.7 * WINDOW_W_WIDE * GRID_W;
			h = WINDOW_HAbs - 7 * CTRL_DEFAULT_H;
			onLoad = "[] call macp_core_fnc_createPreviewCam;";
			onUnload  = "[] call macp_core_fnc_destroyPreviewCam;";
		};
		class DataViewer: ctrlStaticMulti
		{
			idc = 1003;
			text = "";
			x = CENTER_X - WINDOW_W_WIDE * 0.5 * GRID_W + 0.3 * WINDOW_W_WIDE * GRID_W;
			y = WINDOW_TOPAbs + 2 * CTRL_DEFAULT_H;
			w = 0.7 * WINDOW_W_WIDE * GRID_W;
			h = WINDOW_HAbs - 7 * CTRL_DEFAULT_H;
			colorBackground[] = {0,0,0,1};
		};
		class FolderPath: ctrlStatic
		{
			idc = 1002;
			text = "    Home >> ";
			x = CENTER_X - WINDOW_W_WIDE * 0.5 * GRID_W + 5 * GRID_W;
			y = WINDOW_TOPAbs + CTRL_DEFAULT_H;
			w = WINDOW_W_WIDE * GRID_W - 5 * GRID_W;
			h = CTRL_DEFAULT_H;
			colorBackground[] = {0,0,0,1};
		};
		class BackButton: ctrlButton
		{
			idc = 2400;
			text = "<<"; //--- ToDo: Localize;
			x = CENTER_X - WINDOW_W_WIDE * 0.5 * GRID_W;
			y = WINDOW_TOPAbs + CTRL_DEFAULT_H;
			w = 5 * GRID_W;
			h = CTRL_DEFAULT_H;
			onButtonClick = "params ['_control']; _display = ctrlParent _control; _filePath = _display getVariable ['macp_filePath', []]; if (_filePath isEqualTo []) exitWith {}; _filePath deleteAt [-1]; _display setVariable ['macp_filePath', _filePath]; [_display] call macp_core_fnc_updateFileBrowser;";
		};
		class FolderList: ctrlListBox
		{
			idc = 1500;
			x = CENTER_X - WINDOW_W_WIDE * 0.5 * GRID_W;
			y = WINDOW_TOPAbs + 2 * CTRL_DEFAULT_H;
			w = 0.3 * WINDOW_W_WIDE * GRID_W;
			h = WINDOW_HAbs - 7 * CTRL_DEFAULT_H;
			onLBSelChanged = "params ['_control', '_lbCurSel']; _data = ''; if (_lbCurSel isNotEqualTo -1) then {_data = _control lbText _lbCurSel;}; _display = ctrlParent _control; [_display, _data] call macp_core_fnc_updateFilePath;";
			onLBDblClick = "params ['_control', '_selectedIndex']; _data = ''; if (_selectedIndex isNotEqualTo -1) then {_data = _control lbData _selectedIndex;}; _display = ctrlParent _control; _filePath = _display getVariable ['macp_filePath', []]; _filePath pushBack _data; _display setVariable ['macp_filePath', _filePath]; [_display] call macp_core_fnc_updateFileBrowser;";
		};
		class Close: ctrlButtonClose
		{
			x = CENTER_X + 0.5 * WINDOW_W_WIDE * GRID_W - 26 * GRID_W;
			y = WINDOW_TOPAbs + WINDOW_HAbs - 3 * CTRL_DEFAULT_H - GRID_H;
			w = 25 * GRID_W;
			h = CTRL_DEFAULT_H;
		};
		class Delete: ctrlButton
		{
			idc = 2402;
			text = "Delete"; //--- ToDo: Localize;
			x = CENTER_X - WINDOW_W_WIDE * 0.5 * GRID_W + 27 * GRID_W;
			y = WINDOW_TOPAbs + WINDOW_HAbs - 3 * CTRL_DEFAULT_H - GRID_H;
			w = 25 * GRID_W;
			h = CTRL_DEFAULT_H;
			onButtonClick = "params ['_control']; _display = ctrlParent _control; [_display] call macp_core_fnc_buttonDeletePressed;";
		};
		class NewItem: ctrlButton
		{
			idc = 2403;
			text = "New"; //--- ToDo: Localize;
			x = CENTER_X - WINDOW_W_WIDE * 0.5 * GRID_W + GRID_W;
			y = WINDOW_TOPAbs + WINDOW_HAbs - 3 * CTRL_DEFAULT_H - GRID_H;
			w = 25 * GRID_W;
			h = CTRL_DEFAULT_H;
			onButtonClick = "params ['_control']; _display = ctrlParent _control; [_display] call macp_core_fnc_buttonNewPressed;";
		};
		class EditValue: ctrlButton
		{
			idc = 2404;
			text = "Edit"; //--- ToDo: Localize;
			x = CENTER_X - WINDOW_W_WIDE * 0.5 * GRID_W + 53 * GRID_W;
			y = WINDOW_TOPAbs + WINDOW_HAbs - 3 * CTRL_DEFAULT_H - GRID_H;
			w = 25 * GRID_W;
			h = CTRL_DEFAULT_H;
			onButtonClick = "params ['_control']; _display = ctrlParent _control; [_display] call macp_core_fnc_buttonEditPressed;";
		};
		class Export: ctrlButton
		{
			idc = 2406;
			text = "Export"; //--- ToDo: Localize;
			x = CENTER_X - WINDOW_W_WIDE * 0.5 * GRID_W + 105 * GRID_W;
			y = WINDOW_TOPAbs + WINDOW_HAbs - 3 * CTRL_DEFAULT_H - GRID_H;
			w = 25 * GRID_W;
			h = CTRL_DEFAULT_H;
			onButtonClick = "params ['_control']; _display = ctrlParent _control; [_display] call macp_core_fnc_buttonExportPressed;";
		};
	};
};

class macp_campaignManagerSingleValuePopup
{
	idd = -1;
	class ControlsBackground
	{
		//Background controls

		class BackgroundDisable: ctrlStaticBackgroundDisable {};
		class BackgroundDisableTiles: ctrlStaticBackgroundDisableTiles {};

		class Background: ctrlStaticBackground
		{
			x = CENTER_X - 0.5 * 53 * GRID_W;
			y = WINDOW_TOPAbs + CTRL_DEFAULT_H;
			w = 53 * GRID_W;
			h = 21 * GRID_H;
		};

		class Header: ctrlStaticTitle
		{
			idc = 5340;
			text = "MACP...";
			x = CENTER_X - 0.5 * 53 * GRID_W;
			y = WINDOW_TOPAbs;
			w = 53 * GRID_W;
			h = CTRL_DEFAULT_H;
		};

		class Footer: ctrlStaticFooter
		{
			x = CENTER_X - 0.5 * 53 * GRID_W;
			y = WINDOW_TOPAbs + 19 * GRID_H;
			w = 53 * GRID_W;
			h = CTRL_DEFAULT_H + 2 * GRID_H;
		};
	};
	class Controls
	{
		//Controls

		class Text: ctrlStatic
		{
			idc = 5341;
			text = "Changing a Value";
			x = CENTER_X - 0.5 * 53 * GRID_W;
			y = WINDOW_TOPAbs + 6 * GRID_H;
			w = 51 * GRID_W;
			h = CTRL_DEFAULT_H;
		};
		class Value: ctrlEdit
		{
			idc = 5342;
			x = CENTER_X - 0.5 * 52 * GRID_W;
			y = WINDOW_TOPAbs + 13 * GRID_H;
			w = 51 * GRID_W;
			h = CTRL_DEFAULT_H;
		};
		class Cancel: ctrlButtonCancel
		{
			x = CENTER_X - 0.5 * 53 * GRID_W + (53 - 26) * GRID_W;
			y = WINDOW_TOPAbs + 20 * GRID_H;
			w = 25 * GRID_W;
			h = CTRL_DEFAULT_H;
		};
		class Save: ctrlButtonOK
		{
			x = CENTER_X - 0.5 * 53 * GRID_W + (53 - 52) * GRID_W;
			y = WINDOW_TOPAbs + 20 * GRID_H;
			w = 25 * GRID_W;
			h = CTRL_DEFAULT_H;
		};
	};
};

class macp_campaignManagerConfirmDelete
{
	idd = -1;
	class ControlsBackground
	{
		//Background controls

		class BackgroundDisable: ctrlStaticBackgroundDisable {};
		class BackgroundDisableTiles: ctrlStaticBackgroundDisableTiles {};

		class Background: ctrlStaticBackground
		{
			x = CENTER_X - 0.5 * 53 * GRID_W;
			y = WINDOW_TOPAbs + CTRL_DEFAULT_H;
			w = 53 * GRID_W;
			h = 21 * GRID_H;
		};

		class Header: ctrlStaticTitle
		{
			idc = 5340;
			text = "MACP Confirm Delete";
			x = CENTER_X - 0.5 * 53 * GRID_W;
			y = WINDOW_TOPAbs;
			w = 53 * GRID_W;
			h = CTRL_DEFAULT_H;
		};

		class Footer: ctrlStaticFooter
		{
			x = CENTER_X - 0.5 * 53 * GRID_W;
			y = WINDOW_TOPAbs + 19 * GRID_H;
			w = 53 * GRID_W;
			h = CTRL_DEFAULT_H + 2 * GRID_H;
		};
	};
	class Controls
	{
		//Controls

		class Text: ctrlStaticMulti
		{
			idc = 5341;
			text = "Are you sure you want to delete this?";
			x = CENTER_X - 0.5 * 53 * GRID_W;
			y = WINDOW_TOPAbs + 6 * GRID_H;
			w = 51 * GRID_W;
			h = 2 * CTRL_DEFAULT_H;
		};
		class Cancel: ctrlButtonCancel
		{
			x = CENTER_X - 0.5 * 53 * GRID_W + (53 - 26) * GRID_W;
			y = WINDOW_TOPAbs + 20 * GRID_H;
			w = 25 * GRID_W;
			h = CTRL_DEFAULT_H;
		};
		class Save: ctrlButtonOK
		{
			text = "Delete";
			x = CENTER_X - 0.5 * 53 * GRID_W + (53 - 52) * GRID_W;
			y = WINDOW_TOPAbs + 20 * GRID_H;
			w = 25 * GRID_W;
			h = CTRL_DEFAULT_H;
		};
	};
};
