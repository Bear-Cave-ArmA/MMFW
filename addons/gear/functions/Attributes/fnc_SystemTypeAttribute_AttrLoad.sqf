#include "script_component.hpp"
EDEN_CHECK;

params ["_control","_value"];

private _unit = ((get3denselected "object") select 0);
private _ctrlCombo = (_control controlsGroupCtrl 100);
private _gearSystem = _value;
LOG_2("_unit: %1 _gearSystem: %2",_unit,_gearSystem);
SETVAR(_unit,UnitSystemType,_GearSystem);
private _gearSystemTypes = [["None","NONE"],["ACE Arsenal","ACEAR"],["Olsen","OLSEN"]];
{
    _x params ["_name","_string"];
    private _index = _ctrlCombo lbadd _name;
    _ctrlCombo lbsetdata [_index,_string];
    _ctrlCombo lbsetValue [_index,_forEachIndex];
    if (_value isEqualto (_ctrlCombo lbData _index)) then {
        _ctrlCombo lbSetCurSel _index;
    };
} foreach _gearSystemTypes;
