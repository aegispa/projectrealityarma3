#include "macros.hpp"
/*
    Project Reality ArmA 3

    Author: BadGuy

    Description:
    Server Init

    Parameter(s):
    -

    Returns:
    -
*/

GVAR(namespace) = false call CFUNC(createNamespace);

[QGVAR(startDestroyTimer), {
    (_this select 0) params ["_pointId"];
    private _pfhId = [{
        (_this select 0) params ["_pointId", "_timerValue"];

        private _counterStopped = [_pointId, "counterStopped", 0] call EFUNC(Common,getDeploymentCustomData);

        if (_counterStopped == 1) exitWith {};

        _timerValue = _timerValue + 0.1;
        DUMP(_timerValue);
        _this set [0, [_pointId, _timerValue]];

        private _pos = [_pointId, "position"] call EFUNC(Common,getDeploymentPointData);

        private _speed = 1;

        if (_timerValue >= 15) then {
            _speed = 0.5;
        };

        if (_timerValue >= 20) then {
            _speed = 0.2;
        };

        if (_timerValue >= 25) then {
            _speed = 0.1;
        };

        if (_timerValue mod _speed) then {
            playSound3D ["a3\sounds_f\sfx\beep_target.wss", objNull, false, AGLtoASL _pos, 10, 0.5, 80];
        };

        if (_timerValue < 30) exitWith {};

        [{
            params ["_pos"];
            private _bomb = "M_Mo_82mm_AT_LG" createVehicle _pos;
            _bomb setDamage 1;
        }, [_pos]] call CFUNC(execNextFrame);

        [_pointId] call EFUNC(Common,removeDeploymentPoint);

        (_this select 1) call CFUNC(removePerFrameHandler);

    }, 0.1, [_pointId, 0]] call CFUNC(addPerFrameHandler);
    GVAR(namespace) setVariable [_pointId, [_pfhId]];

    [_pointId, "counterActive", 1] call EFUNC(Common,setDeploymentCustomData);
}] call CFUNC(addEventhandler);

[QGVAR(resetDestroyTimer), {
    (_this select 0) params ["_pointId"];
    private _data = [GVAR(namespace), _pointId, []] call CFUNC(getVariable);
    _data params ["_pfhId"];
    _pfhId call CFUNC(removePerFrameHandler);
    GVAR(namespace) setVariable [_pointId, nil];

    [_pointId, "counterActive", 0] call EFUNC(Common,setDeploymentCustomData);
    [_pointId, "counterStopped", 0] call EFUNC(Common,setDeploymentCustomData);
}] call CFUNC(addEventhandler);

[QGVAR(stopDestroyTimer), {
    (_this select 0) params ["_pointId"];
    [_pointId, "counterStopped", 1] call EFUNC(Common,setDeploymentCustomData);
}] call CFUNC(addEventhandler);

[QGVAR(continueDestroyTimer), {
    (_this select 0) params ["_pointId"];
    [_pointId, "counterStopped", 0] call EFUNC(Common,setDeploymentCustomData);
}] call CFUNC(addEventhandler);

GVAR(soundList) = [
    ["radio\ambient_radio2", 10],
    ["radio\ambient_radio3", 11],
    ["radio\ambient_radio4", 7],
    ["radio\ambient_radio5", 9],
    ["radio\ambient_radio6", 7],
    ["radio\ambient_radio7", 5],
    ["radio\ambient_radio8", 12],
    ["radio\ambient_radio9", 8],
    ["radio\ambient_radio10", 11],
    ["radio\ambient_radio11", 6],
    ["radio\ambient_radio13", 6],
    ["radio\ambient_radio14", 7],
    ["radio\ambient_radio15", 8],
    ["radio\ambient_radio16", 11],
    ["radio\ambient_radio17", 6],
    ["radio\ambient_radio18", 10],
    ["radio\ambient_radio19", 10],
    ["radio\ambient_radio20", 6],
    ["radio\ambient_radio21", 4],
    ["radio\ambient_radio22", 5],
    ["radio\ambient_radio23", 8],
    ["radio\ambient_radio24", 8],
    ["radio\ambient_radio25", 10],
    ["radio\ambient_radio26", 8],
    ["radio\ambient_radio30", 9],
    ["UI\uav\UAV_01", 4, 4.5],
    ["UI\uav\UAV_02", 11, 4.5],
    ["UI\uav\UAV_03", 5, 4.5],
    ["UI\uav\UAV_04", 8, 4.5],
    ["UI\uav\UAV_05", 8, 4.5],
    ["UI\uav\UAV_06", 17, 4.5],
    ["UI\uav\UAV_07", 10, 4.5]
];

DFUNC(shuffleSoundArray) = {
    GVAR(soundList) = GVAR(soundList) call CFUNC(shuffleArray);
    [FUNC(shuffleSoundArray), 300] call CFUNC(wait);
};

call FUNC(shuffleSoundArray);

DFUNC(playRadioSound) = {
    params ["_obj"];
    if (isNull _obj) exitWith {};
    private _data = selectRandom GVAR(soundList);
    _data params ["_soundPath", "_length", ["_volume", 1]];
    _soundPath = format ["a3\sounds_f\sfx\%1.wss", _soundPath];

    playSound3D [_soundPath, _obj, false, getPosASL _obj, (_volume * 4), 1, 40];
    [FUNC(playRadioSound), (_length + random 5), _obj] call CFUNC(wait);
};

[QGVAR(placed), {
    (_this select 0) params ["_pointId"];
    private _data = [_pointId, "pointobjects"] call EFUNC(Common,getDeploymentPointData);
    (selectRandom _data) call FUNC(playRadioSound);
}] call CFUNC(addEventhandler);
