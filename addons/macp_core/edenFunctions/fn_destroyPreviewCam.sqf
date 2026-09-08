/*
	Author: Mallen

	Description:
		Destroys the preview camera and cleans everything up

	Parameter(s):
		None

	Returns:
		None

	Examples:
		[] call macp_core_fnc_destroyPreviewCam;
*/

if (isNil 'macp_rttCamera') exitWith {};

macp_rttCamera cameraEffect ['terminate','back'];

camDestroy macp_rttCamera;
macp_rttCamera = nil;
