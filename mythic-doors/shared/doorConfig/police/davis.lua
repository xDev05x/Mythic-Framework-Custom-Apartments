addDoorsListToConfig({
    -- Davis PD

    --Front Left Stair Doors
    {
        id = "dpd_front_1",
        double = "dpd_front_2",
        model = 964838196,
        coords = vector3(379.293, -1591.917, 29.462),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'ems', workplace = 'safd', gradeLevel = 0, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "dpd_front_2",
        double = "dpd_front_1",
        model = 964838196,
        coords = vector3(377.623, -1593.907, 29.462),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'ems', workplace = 'safd', gradeLevel = 0, jobPermission = false, reqDuty = true },
        },
    },

    --Main Entrance Door
    {
        id = "dpd_front_enterance",
        model = 964838196,
        coords = vector3(371.655, -1590.092, 29.458),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'ems', workplace = 'safd', gradeLevel = 0, jobPermission = false, reqDuty = true },
        },
    },

    --Front Right Doors
    {
        id = "dpd_frontright_1",
        double = "dpd_frontright_2",
        model = 964838196,
        coords = vector3(370.331, -1587.919, 29.462),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'ems', workplace = 'safd', gradeLevel = 0, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "dpd_frontright_2",
        double = "dpd_frontright_1",
        model = 964838196,
        coords = vector3(372.001, -1585.929, 29.462),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'ems', workplace = 'safd', gradeLevel = 0, jobPermission = false, reqDuty = true },
        },
    },

    --Parking Lot Rear Doors
    {
        id = "dpd_rear_1",
        double = "dpd_rear_2",
        model = 1182912693,
        coords = vector3(368.211, -1608.218, 29.453),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'ems', workplace = 'safd', gradeLevel = 0, jobPermission = false, reqDuty = true },
        },
    },

    {
        id = "dpd_rear_2",
        double = "dpd_rear_1",
        model = -1020933633,
        coords = vector3(369.895, -1606.211, 29.453),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'ems', workplace = 'safd', gradeLevel = 0, jobPermission = false, reqDuty = true },
        },
    },

    --Sheriff Door
    {
        id = "dpd_command_1",
        model = 964838196,
        coords = vector3(360.718, -1598.347, 32.660),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 60, jobPermission = false, reqDuty = false },
        },
    },

    --Undersheriff Door
    {
        id = "dpd_seccommand_2",
        model = 964838196,
        coords = vector3(356.401, -1598.089, 32.668),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 60, jobPermission = false, reqDuty = false },
        },
    },

    --Evidence Room
    {
        id = "dpd_evidence",
        model = 963839001,
        coords = vector3(369.809, -1605.280, 32.668),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
        },
    },

    --Break Room
    {
        id = "dpd_breakroom",
        model = 964838196,
        coords = vector3(373.377, -1602.926, 32.667),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
        },
    },

    --Roof Doors
    {
        id = "dpd_roof_1",
        model = 631057723,
        coords = vector3(376.384, -1599.344, 32.656),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
        },
    },

    {
        id = "dpd_roof_2",
        model = 1831357345,
        coords = vector3(378.628, -1602.469, 37.095),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
        },
    },

    --Training Room
    {
        id = "dpd_training",
        model = 964838196,
        coords = vector3(376.418, -1597.635, 29.453),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
        },
    },

    --Locker Room Doors
    {
        id = "dpd_lockers1",
        model = 631057723,
        coords = vector3(368.639, -1583.877, 29.476),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "dpd_lockers2",
        model = 631057723,
        coords = vector3(361.476, -1588.921, 29.463),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },

    --Mugshot Room
    {
        id = "dpd_mugshot",
        model = -1207336640,
        coords = vector3(356.884, -1600.518, 29.452),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },

    --Interrogation Rooms
    {
        id = "dpd_interrogation1",
        model = 963839001,
        coords = vector3(356.921, -1605.756, 29.457),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
        },
    },
    {
        id = "dpd_interrogation2",
        model = 963839001,
        coords = vector3(352.710, -1602.222, 29.457),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
        },
    },

    --Armory Doors
    {
        id = "dpd_armoury1",
        model = 964838196,
        coords = vector3(364.981, -1602.045, 29.464),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "dpd_armoury2",
        model = 631057723,
        coords = vector3(363.608, -1600.339, 29.495),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
        },
    },

    --Left Side Armory Doors
    {
        id = "dpd_cdouble_1",
        double = "dpd_cdouble_2",
        model = 964838196,
        coords = vector3(369.168, -1604.677, 29.451),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "dpd_cdouble_2",
        double = "dpd_cdouble_1",
        model = 964838196,
        coords = vector3(367.181, -1603.010, 29.451),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },

    --Right Side Lockers Doors
    {
        id = "dpd_rightcdouble_1",
        double = "dpd_rightcdouble_2",
        model = 964838196,
        coords = vector3(360.279, -1592.268, 29.455),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "dpd_rightcdouble_2",
        double = "dpd_rightcdouble_1",
        model = 964838196,
        coords = vector3(361.946, -1590.282, 29.455),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },

    --Cells
    {
        id = "dpd_cell_1",
        model = -397840766,
        coords = vector3(362.859, -1610.046, 29.464),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "dpd_cell_2",
        model = -397840766,
        coords = vector3(359.957, -1610.086, 29.464),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "dpd_cell_3",
        model = -397840766,
        coords = vector3(358.796, -1609.106, 29.464),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
        },
    },

    --Cell Entrance Doors
    {
        id = "dpd_cellenterance_1",
        double = "dpd_cellenterance_2",
        model = 631057723,
        coords = vector3(364.645, -1607.058, 29.460),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "dpd_cellenterance_2",
        double = "dpd_cellenterance_1",
        model = 631057723,
        coords = vector3(362.653, -1605.386, 29.460),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },

    --Right Side Enterance Doors
    {
        id = "dpd_rightdoorenter_1",
        double = "dpd_rightdoorenter_2",
        model = 1182912693,
        coords = vector3(354.909, -1592.876, 29.445),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "dpd_rightdoorenter_2",
        double = "dpd_rightdoorenter_1",
        model = -1020933633,
        coords = vector3(353.224, -1594.883, 29.445),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },

    --Gate
    {
        id = "dpd_gate",
        model = 1286535678,
        coords = vector3(397.885, -1607.386, 28.3416),
        locked = true,
        --autoRate = 6.0,
        special = true,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
        },
    },

    --Other Doors
    {
        id = "dpd_outsidechainlink1",
        model = -1156020871,
        coords = vector3(391.860, -1636.070, 29.974),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "dpd_chainlink2",
        double = "dpd_chainlink1",
        model = -1156020871,
        coords = vector3(343.879, -1605.381, 29.905),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "dpd_chainlink1",
        double = "dpd_chainlink2",
        model = -1156020871,
        coords = vector3(346.106, -1602.838, 29.905),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "dpd_celldoor2",
        double = "dpd_celldoor3",
        model = 631057723,
        coords = vector3(359.449, -1603.579, 29.449),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "dpd_celldoor3",
        double = "dpd_celldoor2",
        model = 631057723,
        coords = vector3(357.777, -1605.572, 29.449),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "dpd_extradoor2",
        double = "dpd_extradoor3",
        model = -1207336640,
        coords = vector3(352.257, -1596.633, 29.464),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "dpd_extradoor3",
        double = "dpd_extradoor2",
        model = 963839001,
        coords = vector3(354.246, -1598.300, 29.464),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "dpd_extradoor4",
        double = "dpd_extradoor5",
        model = 964838196,
        coords = vector3(356.320, -1591.795, 29.453),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "dpd_extradoor5",
        double = "dpd_extradoor4",
        model = 964838196,
        coords = vector3(358.309, -1593.463, 29.453),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
})

