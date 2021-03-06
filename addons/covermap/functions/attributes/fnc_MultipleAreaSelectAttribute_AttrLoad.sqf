#include "script_component.hpp"
EDEN_CHECK;

params ["_ctrl","_value","_config"];

private _pictureChecked = gettext (configfile >> "ctrlCheckbox" >> "textureChecked");
private _pictureUnchecked = gettext (configfile >> "ctrlCheckbox" >> "textureUnchecked");
private _ctrlListbox = _ctrl controlsGroupCtrl 100;
private _CoverMapModules = (all3DENEntities select 3) select {_x isKindOf QGVAR(Module)};
if (_CoverMapModules isEqualTo []) exitwith {
    ERROR("No CoverMap Modules Found!");
};

private _CoverMapModulesList = [];
{
    private _logic = _x;
    private _AreaName = (_logic get3DENAttribute QGVAR(AOName)) select 0;
    if (_AreaName in _CoverMapModulesList) then {
        ERROR_1("Duplicate AreaName for Covermap AO %1",_AreaName);
    } else {
        _CoverMapModulesList append [_AreaName];
    };
} foreach _CoverMapModules;

LOG_1("_CoverMapModulesList: %1",_CoverMapModulesList);
{
    private _name = _x;
    private _lbAdd = _ctrlListbox lbadd _name;
    _ctrlListbox lbsetdata [_lbAdd,_name];
    private _active = _name in _value;
    _ctrlListbox lbsetvalue [_lbAdd,([0,1] select _active)];
    _ctrlListbox lbsetpicture [_lbAdd,[_pictureUnchecked,_pictureChecked] select _active];
} foreach _CoverMapModulesList;
