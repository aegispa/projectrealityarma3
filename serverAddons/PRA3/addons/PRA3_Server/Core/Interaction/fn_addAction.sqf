#include "macros.hpp"
/*
    Project Reality ArmA 3

    Author: NetFusion edit By Joko

    Description:
    Add an action to an object or type(s) of object(s).

    Parameter(s):
    0: the title of the action. <String, Code>
    1: the object (type) which the action should be added to. <Object, Array, String>
    2: the distance in which the action is visible. <Number>
    3: the condition which is evaluated on every frame (if play is in range) to determine whether the action is visible. <String, Cde>
    4: the callback which gets called when the action is activated. <Code>
    5: the arguments which get passed to the callback. <Array> (Default: [])

    Returns:
    None
*/
params ["_text", "_onObject", "_distance", "_condition", "_callback", ["_args",[]]];

// Convert Condition to String
_condition = _condition call FUNC(codeToString);

_condition = if (_distance > 0) then {"[_target, " + (str _distance) + "] call PRA3_Core_fnc_inRange && " + _condition} else {_condition};

/* @TODO
_callback = _callback call FUNC(codeToString);
_callback = "[{" + _callback +"}, _this] call " + QFUNC(directCall) + ";";
_callback = compile _callback;
*/

if (_text isEqualType "") then {_text = compile ("format ['" + _text + "']")};
if (_onObject isEqualType "") then {_onObject = [_onObject];};

if (_onObject isEqualType []) then {
    {
        GVAR(Interaction_Actions) pushBackUnique [_x, _text, _condition, _callback, _args];
        false
    } count _onObject;
};

if (_onObject isEqualType objNull) then {
    if (_onObject == PRA3_Player) then {
        _text = (call _text);
        _onObject addAction [_text, _callback, _args, 1.5, false, true, "", _condition];
        ["playerChanged", {
            params ["_data", "_params"];
            _data params ["_currentPlayer", "_oldPlayer"];
            _params params ["_text", "_callback", "_args", "_condition"];

            _currentPlayer addAction [_text, _callback, _args, 1.5, false, true, "", _condition];
        }, [_text, _callback, _args, _condition]] call FUNC(addEventhandler);
    } else {
        GVAR(Interaction_Actions) pushBackUnique [_onObject, _text, _condition, _callback, _args];
    };
};
