#include "macros.hpp"
/*
    Project Reality ArmA 3

    Author: joko // Jonas

    Description:
    Check if the player is Allowed to switch sides

    Parameter(s):
    0: NewSide <Side>
    1: OldSide <Side>

    Returns:
    <Bool> can change side
*/
params ["_newSide", "_oldSide"];

if ((GVAR(lastTimeSideChanged) + GVAR(restirctSideSwitchRestrictionTime)) >= serverTime) exitWith {
    [format ["You need wait %1 sec Until you can change the side again", (GVAR(lastTimeSideChanged) + GVAR(restirctSideSwitchRestrictionTime)) - serverTime]] call CFUNC(displayNotification);
    false
};

private _fnc = {
    params ["_side"];
    {_side == side _x} count allPlayers;
};

private _newSideCount = _newSide call _fnc;
private _oldSideCount = _oldSide call _fnc;
if (_oldSideCount < (_newSide + GVAR(restirctSideSwitchRestrictionCount))) exitWith {
    ["Max Player count on Enemy Side Reached."] call CFUNC(displayNotification); // TODO: l18N
    false
};

GVAR(lastTimeSideChanged) = serverTime;
true
