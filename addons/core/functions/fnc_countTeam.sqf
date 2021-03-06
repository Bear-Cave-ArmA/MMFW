/*
 * Author: BlackHawk
 *
 * Count alive units in a team.
 *
 * Arguments:
 * 0: team name <string>
 *
 * Return Value:
 * unit count, -1 if team not found <number>
 *
 * Public: Yes
 */


#include "script_component.hpp"
EXEC_CHECK(SERVER);

params ["_team"];
private _count = -1;
{
    _x params ["_name", "_side", "_Type", "_total", "_current"];
    if (_name isEqualTo _team) exitWith {
        _count = _current;
    };
} forEach GVAR(Teams);

_count
