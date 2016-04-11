#include "macros.hpp"
/*
    Project Reality ArmA 3

    Author: BadGuy

    Description:
    Initialize the Unit Tracker

    Parameter(s):
    None

    Returns:
    None
*/
GVAR(playerCounter) = 0;

["missionStarted", {
    private _color = missionNamespace getVariable format [QEGVAR(Mission,SideColor_%1), playerSide];
    {
        if (side _x == playerSide && !isHidden _x) then {
            private _iconId = _x getVariable [QGVAR(playerIconId), ""];
            if (_iconId == "") then {
                _iconId = format [QGVAR(player_%1), GVAR(playerCounter)];
                GVAR(playerCounter) = GVAR(playerCounter) + 1;
                _x setVariable [QGVAR(playerIconId), _iconId];

                [
                    _iconId,
                    [
                        [_x getVariable [QEGVAR(Kit,mapIcon), "\A3\ui_f\data\map\vehicleicons\iconMan_ca.paa"], _color, _x, 25, "AUTO"]
                    ]
                ] call CFUNC(addMapIcon);
                [
                    _iconId,
                    [
                        [_x getVariable [QEGVAR(Kit,mapIcon), "\A3\ui_f\data\map\vehicleicons\iconMan_ca.paa"], _color, _x, 25, "AUTO"],
                        ["a3\ui_f\data\Map\Markers\System\dummy_ca.paa", [1,1,1,1], _x, 25, 0, name _x, 2]
                    ],
                    "hover"
                ] call CFUNC(addMapIcon);

                if (_x == leader _x) then {
                    [
                        format [QGVAR(Group_%1), groupId group _x],
                        [
                            [_x getVariable [QEGVAR(Squad,mapIcon), "\A3\ui_f\data\map\markers\nato\b_inf.paa"], _color, [_x, [0, -25]], 25],
                            ["a3\ui_f\data\Map\Markers\System\dummy_ca.paa", [1,1,1,1], [_x, [0, -25]], 25, 0, groupId group _x, 2]
                        ]
                    ] call CFUNC(addMapIcon);
                };
            };
        };
        nil
    } count allPlayers;
}] call CFUNC(addEventHandler);

["MPRespawn", {
    (_this select 0) params ["_newUnit","_oldUnit"];
    private _color = missionNamespace getVariable format [QEGVAR(Mission,SideColor_%1), playerSide];
    if (side _newUnit == playerSide && !isHidden _newUnit) then {
        private _iconId = _newUnit getVariable [QGVAR(playerIconId), ""];
        if (_iconId == "") then {
            private _oldIconId = _oldUnit getVariable [QGVAR(playerIconId), ""];
            if (_oldIconId == "") then {
                _iconId = format [QGVAR(player_%1), GVAR(playerCounter)];
                GVAR(playerCounter) = GVAR(playerCounter) + 1;
            } else {
                _iconId = _oldIconId;
            };

            _newUnit setVariable [QGVAR(playerIconId), _iconId];
        };
        [
            _iconId,
            [
                [_newUnit getVariable [QEGVAR(Kit,mapIcon), "\A3\ui_f\data\map\vehicleicons\iconMan_ca.paa"], _color, _newUnit, 25, "AUTO"]
            ]
        ] call CFUNC(addMapIcon);

        [
            _iconId,
            [
                [_newUnit getVariable [QEGVAR(Kit,mapIcon), "\A3\ui_f\data\map\vehicleicons\iconMan_ca.paa"], _color, _newUnit, 25, "AUTO"],
                ["a3\ui_f\data\Map\Markers\System\dummy_ca.paa", [1,1,1,1], _newUnit, 25, 0, name _newUnit, 2]
            ],
            "hover"
        ] call CFUNC(addMapIcon);

        if (_newUnit == leader _newUnit) then {
            [
                format [QGVAR(Group_%1), groupId group _newUnit],
                [
                    [_newUnit getVariable [QEGVAR(Squad,mapIcon), "\A3\ui_f\data\map\markers\nato\b_inf.paa"], _color, [_newUnit, [0, -25]], 25],
                    ["a3\ui_f\data\Map\Markers\System\dummy_ca.paa", [1,1,1,1], [_newUnit, [0, -25]], 25, 0, groupId group _newUnit, 2]
                ]
            ] call CFUNC(addMapIcon);
        };

    };
}] call CFUNC(addEventHandler);
