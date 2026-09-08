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
	onLoad = "hint str _this";
	onUnload  = "hint str _this";
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
			text = "#(argb,512,512,1)r2t(macprttforunit,1.0)";
			x = CENTER_X - WINDOW_W_WIDE * 0.5 * GRID_W + 0.3 * WINDOW_W_WIDE * GRID_W;
			y = WINDOW_TOPAbs + 2 * CTRL_DEFAULT_H;
			w = 0.7 * WINDOW_W_WIDE * GRID_W;
			h = WINDOW_HAbs - 7 * CTRL_DEFAULT_H;
			onLoad = "[] call macp_core_fnc_createPreviewCam;";
			onUnload  = "[] call macp_core_fnc_destroyPreviewCam;";
		};
		class FolderPath: ctrlStatic
		{
			idc = 1002;
			text = "    File >> Path >> For >> Selection"; //--- ToDo: Localize;
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
		};
		class FolderList: ctrlListBox
		{
			idc = 1500;
			x = CENTER_X - WINDOW_W_WIDE * 0.5 * GRID_W;
			y = WINDOW_TOPAbs + 2 * CTRL_DEFAULT_H;
			w = 0.3 * WINDOW_W_WIDE * GRID_W;
			h = WINDOW_HAbs - 7 * CTRL_DEFAULT_H;
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
			x = CENTER_X - WINDOW_W_WIDE * 0.5 * GRID_W + 27 * GRID_W
			y = WINDOW_TOPAbs + WINDOW_HAbs - 3 * CTRL_DEFAULT_H - GRID_H;
			w = 25 * GRID_W;
			h = CTRL_DEFAULT_H;
		};
		class NewItem: ctrlButton
		{
			idc = 2403;
			text = "New"; //--- ToDo: Localize;
			x = CENTER_X - WINDOW_W_WIDE * 0.5 * GRID_W + GRID_W;
			y = WINDOW_TOPAbs + WINDOW_HAbs - 3 * CTRL_DEFAULT_H - GRID_H;
			w = 25 * GRID_W;
			h = CTRL_DEFAULT_H;
		};
		class EditValue: ctrlButton
		{
			idc = 2404;
			text = "Edit"; //--- ToDo: Localize;
			x = CENTER_X - WINDOW_W_WIDE * 0.5 * GRID_W + 53 * GRID_W
			y = WINDOW_TOPAbs + WINDOW_HAbs - 3 * CTRL_DEFAULT_H - GRID_H;
			w = 25 * GRID_W;
			h = CTRL_DEFAULT_H;
		};
	};
};
