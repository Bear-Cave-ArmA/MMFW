#include "script_component.hpp"
EXEC_CHECK(CLIENT);

LOG("Client Pre Init");

[QGVAR(RecievePlayerVars), {
    params ["_playerUnit","_varArray"];
    //LOG_1("Var Recieve _playerUnit: %1",_playerUnit);
    //LOG_1("Var Recieve _varArray: %1",_varArray);
    if !(local _playerUnit) exitwith {};
    {
        _x params ["_propertyName","_value"];
        player setvariable [_propertyName,_value];
    } foreach _varArray;
    [QGVAR(SettingsLoaded), []] call CBA_fnc_localEvent;
}] call CBA_fnc_addEventHandler;

[QGVAR(RegisterModuleEvent), {
    if !(hasInterface) exitwith {};
    params ["_name", "_description", "_author"];
    [{!(isNull player)}, {
        params ["_name", "_description", "_author"];
        if !(player diarySubjectExists QGVAR(Menu)) then {
            player createDiarySubject [QGVAR(Menu), "Mission Framework"];
        };
        if (isNil QGVAR(ModuleDiaryEntries)) then {GVAR(ModuleDiaryEntries) = []};
        //IGNORE_PRIVATE_WARNING ["_x"];
        if ((GVAR(ModuleDiaryEntries) findIf {_name isEqualto _x}) isEqualto -1) then {
            GVAR(ModuleDiaryEntries) append [_name];
            player createDiaryRecord [QGVAR(Menu), [_name,"<font size='16'>" + _name + "</font><br/>Description: " + _description + "<br/>by " + _author]];
        };
    },[_name, _description, _author]] call CBA_fnc_WaitUntilAndExecute;
}] call CBA_fnc_addEventHandler;

[QGVAR(RegisterFrameworkEvent), {
    if !(player diarySubjectExists QGVAR(Menu)) then {
        player createDiarySubject [QGVAR(Menu), "Mission Framework"];
    };
    private _info = "
    <font size='18'>Mission Maker Framework</font><br/>
    The Mission Maker framework is an addon based utility and function library for making missions.<br/>
    <br/>
    Find out more about the framework on GitHub.<br/>
    <br/>
    <br/>
    Current Version: " + QUOTE(VERSION);
    player createDiaryRecord [QGVAR(Menu), ["Framework Info", _info]];
}] call CBA_fnc_addEventHandler;

[{!(isNull player)}, {
    LOG_1("Client call waituntil player: %1",player);
    [QGVAR(RecievePlayerVarRequest), [player,clientOwner]] call CBA_fnc_serverEvent;
    SETMVAR(SpawnPos,(getpos player));
    GVAR(TeamTag) = switch (side player) do {
        case WEST: {"BLUFOR"};
        case EAST: {"OPFOR"};
        case INDEPENDENT: {"INDFOR"};
        case CIVILIAN: {"CIVILIAN"};
        default {"BLUFOR"};
    };
}] call CBA_fnc_WaitUntilAndExecute;

[QGVAR(EndMissionPlayerEvent), {
    params ["_scenario","_timeLimit","_teams"];
    [_scenario,_timeLimit,_teams] call FUNC(EndScreen);
}] call CBA_fnc_addEventHandler;

[QGVAR(EndmissionEvent), {
    params ["_scenario","_timeLimit","_teams"];
    [QGVAR(EndMissionPlayerEvent), [_scenario,_timeLimit,_teams]] call CBA_fnc_localEvent;
}] call CBA_fnc_addEventHandler;

[QEGVAR(Spectator,StartSpectateEvent), {
    [] call FUNC(Spectate);
}] call CBA_fnc_addEventHandler;

[QEGVAR(Spectator,EndSpectateEvent), {
    [] call FUNC(endSpectate);
}] call CBA_fnc_addEventHandler;

[QGVAR(PlayerRespawnEvent), {
    [] call FUNC(HandlePlayerRespawn);
}] call CBA_fnc_addEventHandler;

[QGVAR(PlayerRespawnRecieveTicketEvent), {
    params ["_unit","_response","_ticketType","_ticketsRemaining"];
    LOG_1("RecieveTicketEvent",_this);
    if !(local _unit) exitwith {};
    private ["_delay"];
    switch (side player) do {
        case west: {
            _delay = MGETMVAR(Respawn_Delay_BLUFOR,5);
        };
        case east: {
            _delay = MGETMVAR(Respawn_Delay_OPFOR,5);
        };
        case independent: {
            _delay = MGETMVAR(Respawn_Delay_Indfor,5);
        };
        case civilian: {
            _delay = MGETMVAR(Respawn_Delay_Civ,5);
        };
    };
    [{
        params ["_response","_ticketType","_ticketsRemaining"];
        switch (_ticketType) do {
            case "IND": {
                if (_response) then {
                    [QGVAR(PlayerRespawnEvent), []] call CBA_fnc_localEvent;
                    if (_ticketsRemaining isEqualTo 0) exitwith {
                        "You have no respawn tickets remaining." call BIS_fnc_titleText;
                    };
                    private _pluralForm = "tickets";
                    if (_ticketsRemaining isEqualTo 1) then {
                        _pluralForm = "ticket";
                    };
                    (format ["You have %1 respawn %2 remaining.",_ticketsRemaining,_pluralForm]) call BIS_fnc_titleText;
                } else {
                    [QEGVAR(Spectator,StartSpectateEvent), []] call CBA_fnc_localEvent;
                    "You had no respawn tickets remaining<br />Enabling spectator." call BIS_fnc_titleText;
                };
            };
            case "TEAM": {
                if (_response) then {
                    [QGVAR(PlayerRespawnEvent), []] call CBA_fnc_localEvent;
                    if (_ticketsRemaining isEqualTo 0) exitwith {
                        "Your team has no respawn tickets remaining." call BIS_fnc_titleText;
                    };
                    private _pluralForm = "tickets";
                    if (_ticketsRemaining isEqualTo 1) then {
                        _pluralForm = "ticket";
                    };
                    (format ["Your team has %1 respawn %2 remaining.",_ticketsRemaining,_pluralForm]) call BIS_fnc_titleText;
                } else {
                    [QEGVAR(Spectator,StartSpectateEvent), []] call CBA_fnc_localEvent;
                    "Your team had no respawn tickets remaining<br />Enabling spectator." call BIS_fnc_titleText;
                };
            };
        };
    }, [_response,_ticketType,_ticketsRemaining], (_delay + 3)] call CBA_fnc_WaitAndExecute;
}] call CBA_fnc_addEventHandler;

[QGVAR(PlayerInitEvent), {
    if (GETMVAR(ViewDistance_Enforce,false)) then {
        setViewDistance GETMVAR(ViewDistance,2500);
    };
    enableSaving [false, false];
    enableEngineArtillery false;
    enableRadio false;
    enableSentences false;
    0 fadeRadio 0;
    player addRating 100000;
    player setvariable ["BIS_noCoreConversations",true,true];
}] call CBA_fnc_addEventHandler;

[QGVAR(PlayerInitEHEvent), {
    SETPLPVAR(Dead,false);
    SETPLPVAR(HasDied,false);
    SETPLPVAR(Spectating,false);
    SETPLPVAR(Body,player);
    GVAR(PlayerHitHandle) = [player, "Hit", FUNC(HitHandler), []] call CBA_fnc_addBISEventHandler;
    [QGVAR(PlayerSpawned), player] call CBA_fnc_serverEvent;
}] call CBA_fnc_addEventHandler;

[QEGVAR(EndConditions,TimelimitClient), {
    params ["_command",["_timeLimit",0,[0]]];
    private _timeLeft = _timeLimit - (CBA_missionTime / 60);
    switch (_command) do {
        case "check": {
            private _text = format ["TimeLimit: %1 Time Remaining: %2",_timeLimit,_timeLeft];
            [_text, 1.5, ACE_Player, 10] call ace_common_fnc_displayTextStructured;
        };
        case "extend": {
            private _text = format ["TimeLimit set to: %1 Time Remaining: %2",_timeLimit,_timeLeft];
            [_text, 1.5, ACE_Player, 10] call ace_common_fnc_displayTextStructured;
        };
        default {};
    };
}] call CBA_fnc_addEventHandler;

[QEGVAR(JiP,PlayerEvent), {
    if ((((EGETMVAR(JiP,Type_BLUFOR,0)) isEqualto 2) && {(side player isEqualto west)})
        || (((EGETMVAR(JiP,Type_OPFOR,0)) isEqualto 2) && {(side player isEqualto east)})
        || (((EGETMVAR(JiP,Type_Indfor,0)) isEqualto 2) && {(side player isEqualto independent)})
        || (((EGETMVAR(JiP,Type_Civ,0)) isEqualto 2) && {(side player isEqualto civilian)})
    ) exitwith {
        ["This mission does not support JIP for your team, enabling spectator"] call FUNC(parsedTextDisplay);
        [QGVAR(UnTrackEvent), [player]] call CBA_fnc_serverEvent;
        [QEGVAR(Spectator,StartSpectateEvent), []] call CBA_fnc_localEvent;
        SETPLPVAR(JIPExcluded,true);
    };
    // Player can JiP, initialize player vars and EHs
    [QGVAR(PlayerInitEHEvent), []] call CBA_fnc_localEvent;
    [QGVAR(PlayerInitEvent), []] call CBA_fnc_localEvent;
    [] call FUNC(GiveActions);
}] call CBA_fnc_addEventHandler;
