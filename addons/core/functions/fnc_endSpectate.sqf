
#include "script_component.hpp"
EXEC_CHECK(CLIENT);

if !(GETPLVAR(Spectating,false)) exitwith {};

SETPLPVAR(Spectating,false);
SETPLPVAR(Dead,false);
[player,false] remoteExecCall ["hideObject", 0];
[player,false] remoteExecCall ["hideObjectGlobal", 2];
player setCaptive false;
player allowdamage true;
[player, false] remoteExec ["setCaptive", 2];
[player, true] remoteExec ["allowdamage", 2];
player call EFUNC(Gear,RemoveAllGear);
if (!isNil QGVAR(keyHandle46)) then {
    (findDisplay 46) displayRemoveEventHandler ["keyDown",GVAR(keyHandle46)];
};

["Terminate"] call BIS_fnc_EGSpectator;

private _marker = "";
switch (side player) do {
    case WEST: {_marker = "respawn_west";};
    case EAST: {_marker = "respawn_east";};
    case INDEPENDENT: {_marker = "respawn_guerrila";};
    case CIVILIAN: {_marker = "respawn_Civilian";};
    default {};
};

player setPos (getMarkerPos _marker);

[QEGVAR(Spectator,EndHookEvent), []] call CBA_fnc_localEvent;
