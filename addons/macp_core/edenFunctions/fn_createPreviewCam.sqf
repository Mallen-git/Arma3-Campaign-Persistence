/*
	Author: Mallen

	Description:
		Creates the preview camera and everything needed for it to work

	Parameter(s):
		None

	Returns:
		None

	Examples:
		[] call macp_core_fnc_createPreviewCam;
*/

if (not (isNil 'macp_rttCamera')) exitWith {};

macp_rttCamera = 'camera' camCreate [0,0,100];
macp_rttCamera cameraEffect ['Internal', 'back', 'macprttforunit'];

get3DENCamera switchCamera 'Internal';
