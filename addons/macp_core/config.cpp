class CfgPatches
{
	class macp_core
	{
		units[] = {};
		weapons[] = {};
		requiredVersion = 0.1;
		requiredAddons[] = {"A3_3DEN", "3DEN", "A3_Data_F_Decade_Loadorder"};
	};
};

#include "\a3\3DEN\UI\macros.inc"
#include "\a3\ui_f\hpp\definecommongrids.inc"
#include "customDefines.hpp"

#include "modules.hpp"
#include "functions.hpp"
#include "GUI.hpp"
#include "tools.hpp"
#include "attributes.hpp"


class Extended_PreInit_EventHandlers {
  class My_pre_init_event {
    init = "call compile preprocessFileLineNumbers 'macp_core\XEH_preInit.sqf'";
  };
};
