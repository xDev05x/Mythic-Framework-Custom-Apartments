Config = {}

-- Reception Ped Configuration
-- This ped allows players to request apartments if they don't have one
Config.ReceptionPed = {
    model = "s_m_y_cop_01", -- Receptionist ped model
    coords = vector4(-461.8189, -914.9046, 27.147, 87.8875), -- Location near apartment entrance (x, y, z, heading)
    scenario = "WORLD_HUMAN_CLIPBOARD", -- Ped scenario/animation
}

Config.HotelElevatorsDesc = {
    ["nexus_apartment_block_1"] = {
        [-1] = "Garage",
        [0] = "Lobby",
        [1] = "Rooms: 100 - 106",
        [2] = "Rooms: 200 - 206",
        [3] = "Rooms: 300 - 306",
        [4] = "Rooms: 400 - 406",
        [5] = "Rooms: 500 - 506",
        [6] = "Rooms: 600 - 606",
        [7] = "Rooms: 700 - 706",
    }
}

Config.PoliceRaidRequiresBreach = false

Config.HotelElevators = {
    ["nexus_apartment_block_1"] = { -- hotel
        [-1] = { -- GARAGE
            bucketReset = true, -- Resets bucket to global route when arriving at this floor
            [1] = {
                pos = vector4(-442.6301, -950.0204, 20.6901, 89.7917),
                poly = {
                    center = vector3(-442.6301, -950.0204, 20.6901),
                    length = 2.0,
                    width = 2.0,
                    options = {
                        heading = 90,
                        minZ = 19,
                        maxZ = 23
                    }
                }
            },
        },
        [0] = { -- GROUND FLOOR (Lobby)
            bucketReset = true, -- Resets bucket to global route when arriving at this floor
            [1] = {
                pos = vector4(-461.0209, -924.0651, 28.102636, 88.522109),
                poly = {
                    center = vector3(-461.0209, -924.0651, 28.102636),
                    length = 2.0,
                    width = 2.0,
                    options = {
                        heading = 90,
                        minZ = 27,
                        maxZ = 31
                    }
                }
            },
            bucketReset = true, -- Resets bucket to global route when arriving at this floor
            [2] = {
                pos = vector4(-460.8976, -928.1514, 28.102855, 93.049896),
                poly = {
                    center = vector3(-460.8976, -928.1514, 28.102855),
                    length = 2.0,
                    width = 2.0,
                    options = {
                        heading = 90,
                        minZ = 27,
                        maxZ = 31
                    }
                },
            },
        },
        [1] = { -- 1st Floor
            isApartmentFloor = true, -- Sets bucket to apartment route when arriving at this floor
            [1] = {
                pos = vector4(-451.97125244141, -933.34240722656, 47.617900848389, 89.54),
                poly = {
                    center = vector3(-451.97125244141, -933.34240722656, 47.617900848389),
                    length = 2.0,
                    width = 2.0,
                    options = {
                        heading = 90,
                        minZ = 46,
                        maxZ = 49
                    }
                }
            },
        },
        [2] = { -- 2nd Floor
            isApartmentFloor = true, -- Sets bucket to apartment route when arriving at this floor
            [1] = {
                pos = vector4(-451.97125244141, -933.34240722656, 58.61344909668, 89.54),
                poly = {
                    center = vector3(-451.97125244141, -933.34240722656, 58.61344909668),
                    length = 2.0,
                    width = 2.0,
                    options = {
                        heading = 90,
                        minZ = 57,
                        maxZ = 60
                    }
                }
            },
        },
        [3] = { -- 3rd Floor
            isApartmentFloor = true, -- Sets bucket to apartment route when arriving at this floor
            [1] = {
                pos = vector4(-451.97125244141, -933.34240722656, 69.613418579102, 89.54),
                poly = {
                    center = vector3(-451.97125244141, -933.34240722656, 69.613418579102),
                    length = 2.0,
                    width = 2.0,
                    options = {
                        heading = 90,
                        minZ = 68,
                        maxZ = 71
                    }
                }
            },
        },
        [4] = { -- 4th Floor
            isApartmentFloor = true, -- Sets bucket to apartment route when arriving at this floor
            [1] = {
                pos = vector4(-451.97125244141, -933.34240722656, 80.613082885742, 89.54),
                poly = {
                    center = vector3(-451.97125244141, -933.34240722656, 80.613082885742),
                    length = 2.0,
                    width = 2.0,
                    options = {
                        heading = 90,
                        minZ = 79,
                        maxZ = 82
                    }
                }
            },
        },
        [5] = { -- 5th Floor
            isApartmentFloor = true, -- Sets bucket to apartment route when arriving at this floor
            [1] = {
                pos = vector4(-451.97125244141, -933.34240722656, 91.613677978516, 89.54),
                poly = {
                    center = vector3(-451.97125244141, -933.34240722656, 91.613677978516),
                    length = 2.0,
                    width = 2.0,
                    options = {
                        heading = 90,
                        minZ = 90,
                        maxZ = 93
                    }
                }
            },
        },
        [6] = { -- 6th Floor
            isApartmentFloor = true, -- Sets bucket to apartment route when arriving at this floor
            [1] = {
                pos = vector4(-451.97125244141, -933.34240722656, 102.61270904541, 89.54),
                poly = {
                    center = vector3(-451.97125244141, -933.34240722656, 102.61270904541),
                    length = 2.0,
                    width = 2.0,
                    options = {
                        heading = 90,
                        minZ = 101,
                        maxZ = 104
                    }
                }
            },
        },
        [7] = { -- 7th floor
            isApartmentFloor = true, -- Sets bucket to apartment route when arriving at this floor
            [1] = {
                pos = vector4(-451.97125244141, -933.34240722656, 108.11304473877, 89.54),
                poly = {
                    center = vector3(-451.97125244141, -933.34240722656, 108.11304473877),
                    length = 2.0,
                    width = 2.0,
                    options = {
                        heading = 90,
                        minZ = 107,
                        maxZ = 110
                    }
                }
            },
        },
    },
}

Config.HotelRooms = {
    ["nexus_apartment_block_1"] = {
        label = "La Putura",
        -- FIRST FLOOR
        [1] = {
            roomLabel = 100,
            doorId = "apt_room_100",
            type = 'regular',
            floor = 1,
            zones = {
                doorEntry = vector3(-459.8265, -938.6508, 47.617954),
                stash = vector3(-464.3675, -935.7334, 47.617954),
                wardrobe = vector3(-464.2869, -932.7739, 47.617954),
                shower = vector3(-461.4623, -931.8782, 47.706924)
            }
        },
        [2] = {
            roomLabel = 101,
            doorId = "apt_room_101",
            type = 'regular',
            floor = 1,
            zones = {
                doorEntry = vector3(-454.6119, -923.6325, 47.617946),
                stash = vector3(-450.0599, -926.6741, 47.617946),
                wardrobe = vector3(-449.7002, -929.6013, 47.617954),
                shower = vector3(-452.958, -930.4773, 47.706581)
            }
        },
        [3] = {
            roomLabel = 102,
            doorId = "apt_room_102",
            type = 'regular',
            floor = 1,
            zones = {
                doorEntry = vector3(-459.8521, -924.5889, 47.617961),
                stash = vector3(-464.3279, -921.5688, 47.617954),
                wardrobe = vector3(-464.6367, -918.7537, 47.617946),
                shower = vector3(-461.6259, -917.9022, 47.703983)
            }
        },
        [4] = {
            roomLabel = 103,
            doorId = "apt_room_103",
            type = 'regular',
            floor = 1,
            zones = {
                doorEntry = vector3(-454.6358, -909.7139, 47.61795),
                stash = vector3(-450.0709, -912.7156, 47.617946),
                wardrobe = vector3(-449.641, -915.5927, 47.617946),
                shower = vector3(-452.8888, -916.5816, 47.709651)
            }
        },
        [5] = {
            roomLabel = 104,
            doorId = "apt_room_104",
            type = 'regular',
            floor = 1,
            zones = {
                doorEntry = vector3(-459.8412, -910.7286, 47.617954),
                stash = vector3(-464.4056, -907.771, 47.617954),
                wardrobe = vector3(-464.8889, -904.8333, 47.617946),
                shower = vector3(-461.4842, -903.7851, 47.712352)
            }
        },
        [6] = {
            roomLabel = 105,
            doorId = "apt_room_105",
            type = 'regular',
            floor = 1,
            zones = {
                doorEntry = vector3(-454.5732, -895.7935, 47.617946),
                stash = vector3(-450.0029, -898.7509, 47.617946),
                wardrobe = vector3(-449.4658, -901.7604, 47.61795),
                shower = vector3(-452.9404, -902.7141, 47.711299)
            }
        },
        [7] = {
            roomLabel = 106,
            doorId = "apt_room_106",
            type = 'regular',
            floor = 1,
            zones = {
                doorEntry = vector3(-459.9028, -896.7797, 47.617961),
                stash = vector3(-464.4308, -893.762, 47.61795),
                wardrobe = vector3(-464.9906, -890.9302, 47.61795),
                shower = vector3(-461.5498, -890.0003, 47.707637)
            }
        },
        [8] = {
            roomLabel = 200,
            doorId = "apt_room_200",
            type = 'regular',
            floor = 2,
            zones = {
                doorEntry = vector3(-459.8499, -938.6092, 58.617984),
                stash = vector3(-464.4103, -935.7116, 58.617988),
                wardrobe = vector3(-464.7381, -932.7702, 58.617984),
                shower = vector3(-461.5304, -931.7783, 58.710319)
            }
        },
        [9] = {
            roomLabel = 201,
            doorId = "apt_room_201",
            type = 'regular',
            floor = 2,
            zones = {
                doorEntry = vector3(-454.565, -923.6552, 58.617988),
                stash = vector3(-450.0416, -926.6071, 58.617988),
                wardrobe = vector3(-449.7808, -929.525, 58.617988),
                shower = vector3(-452.7666, -930.3723, 58.705101)
            }
        },
        [10] = {
            roomLabel = 202,
            doorId = "apt_room_202",
            type = 'regular',
            floor = 2,
            zones = {
                doorEntry = vector3(-459.8596, -924.5664, 58.617988),
                stash = vector3(-464.4006, -921.6439, 58.61798),
                wardrobe = vector3(-464.6408, -918.6881, 58.617984),
                shower = vector3(-461.5211, -917.7923, 58.707534)
            }
        },
        [11] = {
            roomLabel = 203,
            doorId = "apt_room_203",
            type = 'regular',
            floor = 2,
            zones = {
                doorEntry = vector3(-454.6534, -909.7174, 58.617988),
                stash = vector3(-450.045, -912.6619, 58.617988),
                wardrobe = vector3(-449.736, -915.625, 58.617984),
                shower = vector3(-452.9096, -916.5985, 58.710411)
            }
        },
        [12] = {
            roomLabel = 204,
            doorId = "apt_room_204",
            type = 'regular',
            floor = 2,
            zones = {
                doorEntry = vector3(-459.8446, -910.7789, 58.617988),
                stash = vector3(-464.4035, -907.7108, 58.617977),
                wardrobe = vector3(-464.7606, -904.8715, 58.617984),
                shower = vector3(-461.4688, -903.9538, 58.706329)
            }
        },
        [13] = {
            roomLabel = 205,
            doorId = "apt_room_205",
            type = 'regular',
            floor = 2,
            zones = {
                doorEntry = vector3(-454.6407, -895.7611, 58.617984),
                stash = vector3(-450.0802, -898.7576, 58.617984),
                wardrobe = vector3(-449.6643, -901.6346, 58.617954),
                shower = vector3(-452.9813, -902.5368, 58.705978)
            }
        },
        [14] = {
            roomLabel = 206,
            doorId = "apt_room_206",
            type = 'regular',
            floor = 2,
            zones = {
                doorEntry = vector3(-459.7806, -896.7604, 58.617992),
                stash = vector3(-464.3741, -893.7621, 58.617977),
                wardrobe = vector3(-464.7907, -890.986, 58.61798),
                shower = vector3(-461.4613, -890.0659, 58.704231)
            }
        },
        [15] = {
            roomLabel = 300,
            doorId = "apt_room_300",
            type = 'regular',
            floor = 3,
            zones = {
                doorEntry = vector3(-459.8172, -938.6744, 69.618034),
                stash = vector3(-464.3265, -935.708, 69.618003),
                wardrobe = vector3(-464.9541, -932.7658, 69.618019),
                shower = vector3(-461.4544, -931.9301, 69.703613)
            }
        },
        [16] = {
            roomLabel = 301,
            doorId = "apt_room_301",
            type = 'regular',
            floor = 3,
            zones = {
                doorEntry = vector3(-454.5994, -923.6597, 69.618019),
                stash = vector3(-450.0434, -926.6452, 69.617996),
                wardrobe = vector3(-449.5507, -929.3887, 69.618026),
                shower = vector3(-452.9311, -930.4879, 69.708969)
            }
        },
        [17] = {
            roomLabel = 302,
            doorId = "apt_room_302",
            type = 'regular',
            floor = 3,
            zones = {
                doorEntry = vector3(-459.6473, -924.5573, 69.619812),
                stash = vector3(-464.4051, -921.6428, 69.618011),
                wardrobe = vector3(-464.8427, -918.6829, 69.618019),
                shower = vector3(-461.5034, -917.7896, 69.707748)
            }
        },
        [18] = {
            roomLabel = 303,
            doorId = "apt_room_303",
            type = 'regular',
            floor = 3,
            zones = {
                doorEntry = vector3(-454.5631, -909.6316, 69.618034),
                stash = vector3(-450.068, -912.6591, 69.618019),
                wardrobe = vector3(-449.479, -915.6188, 69.618011),
                shower = vector3(-452.9332, -916.4763, 69.70478)
            }
        },
        [19] = {
            roomLabel = 304,
            doorId = "apt_room_304",
            type = 'regular',
            floor = 3,
            zones = {
                doorEntry = vector3(-459.7756, -910.8242, 69.618003),
                stash = vector3(-464.4285, -907.6948, 69.618003),
                wardrobe = vector3(-464.574, -904.805, 69.618019),
                shower = vector3(-461.4879, -903.9833, 69.704421)
            }
        },
        [20] = {
            roomLabel = 305,
            doorId = "apt_room_305",
            type = 'regular',
            floor = 3,
            zones = {
                doorEntry = vector3(-454.5635, -895.8009, 69.618019),
                stash = vector3(-450.0484, -898.7837, 69.618019),
                wardrobe = vector3(-449.5211, -901.6661, 69.618011),
                shower = vector3(-452.9018, -902.63, 69.708625)
            }
        },
        [21] = {
            roomLabel = 306,
            doorId = "apt_room_306",
            type = 'regular',
            floor = 3,
            zones = {
                doorEntry = vector3(-459.8085, -896.8035, 69.618011),
                stash = vector3(-464.3974, -893.806, 69.618011),
                wardrobe = vector3(-464.6232, -890.9758, 69.618011),
                shower = vector3(-461.4562, -890.0916, 69.703399)
            }
        },
        [22] = {
            roomLabel = 400,
            doorId = "apt_room_400",
            type = 'regular',
            floor = 4,
            zones = {
                doorEntry = vector3(-459.6063, -938.8074, 80.619918),
                stash = vector3(-464.3424, -935.6331, 80.618049),
                wardrobe = vector3(-464.7529, -932.7871, 80.618041),
                shower = vector3(-461.5896, -931.8703, 80.707397)
            }
        },
        [23] = {
            roomLabel = 401,
            doorId = "apt_room_401",
            type = 'regular',
            floor = 4,
            zones = {
                doorEntry = vector3(-454.5476, -923.6629, 80.618049),
                stash = vector3(-450.0525, -926.6629, 80.618049),
                wardrobe = vector3(-449.7114, -929.4426, 80.618041),
                shower = vector3(-452.9352, -930.4089, 80.706153)
            }
        },
        [24] = {
            roomLabel = 402,
            doorId = "apt_room_402",
            type = 'regular',
            floor = 4,
            zones = {
                doorEntry = vector3(-459.8524, -924.584, 80.618057),
                stash = vector3(-464.3811, -921.6439, 80.618019),
                wardrobe = vector3(-464.6986, -918.7052, 80.618049),
                shower = vector3(-461.4673, -917.7852, 80.705902)
            }
        },
        [25] = {
            roomLabel = 403,
            doorId = "apt_room_403",
            type = 'regular',
            floor = 4,
            zones = {
                doorEntry = vector3(-454.6608, -909.7468, 80.618095),
                stash = vector3(-450.0465, -912.7595, 80.618026),
                wardrobe = vector3(-449.6758, -915.6239, 80.618034),
                shower = vector3(-452.9119, -916.4876, 80.705978)
            }
        },
        [26] = {
            roomLabel = 404,
            doorId = "apt_room_404",
            type = 'regular',
            floor = 4,
            zones = {
                doorEntry = vector3(-459.8183, -910.7601, 80.618057),
                stash = vector3(-464.3755, -907.7114, 80.618049),
                wardrobe = vector3(-464.6875, -904.8541, 80.618049),
                shower = vector3(-461.4769, -903.8406, 80.708541)
            }
        },
        [27] = {
            roomLabel = 405,
            doorId = "apt_room_405",
            type = 'regular',
            floor = 4,
            zones = {
                doorEntry = vector3(-454.5345, -895.8499, 80.618041),
                stash = vector3(-450.0396, -898.7493, 80.618026),
                wardrobe = vector3(-449.7196, -901.6161, 80.618041),
                shower = vector3(-452.9613, -902.5886, 80.70684)
            }
        },
        [28] = {
            roomLabel = 406,
            doorId = "apt_room_406",
            type = 'regular',
            floor = 4,
            zones = {
                doorEntry = vector3(-459.8956, -896.8067, 80.618064),
                stash = vector3(-464.4014, -893.7745, 80.618026),
                wardrobe = vector3(-464.8812, -890.8916, 80.618049),
                shower = vector3(-461.4842, -890.0695, 80.704208)
            }
        },
        [29] = {
            roomLabel = 500,
            doorId = "apt_room_500",
            type = 'regular',
            floor = 5,
            zones = {
                doorEntry = vector3(-459.9377, -938.668, 91.618064),
                stash = vector3(-464.3793, -935.6416, 91.618041),
                wardrobe = vector3(-464.8039, -932.7638, 91.618034),
                shower = vector3(-461.483, -931.905, 91.706047)
            }
        },
        [30] = {
            roomLabel = 501,
            doorId = "apt_room_501",
            type = 'regular',
            floor = 5,
            zones = {
                doorEntry = vector3(-454.587, -923.6707, 91.618041),
                stash = vector3(-450.0693, -926.6088, 91.618041),
                wardrobe = vector3(-449.7944, -929.6115, 91.618034),
                shower = vector3(-453.0165, -930.2867, 91.702705)
            }
        },
        [31] = {
            roomLabel = 502,
            doorId = "apt_room_502",
            type = 'regular',
            floor = 5,
            zones = {
                doorEntry = vector3(-459.8824, -924.5454, 91.61808),
                stash = vector3(-464.3665, -921.5753, 91.618041),
                wardrobe = vector3(-464.7328, -918.6834, 91.618034),
                shower = vector3(-461.4851, -917.7785, 91.705963)
            }
        },
        [32] = {
            roomLabel = 503,
            doorId = "apt_room_503",
            type = 'regular',
            floor = 5,
            zones = {
                doorEntry = vector3(-454.6296, -909.6669, 91.618057),
                stash = vector3(-450.0007, -912.6984, 91.618034),
                wardrobe = vector3(-449.6354, -915.5984, 91.618041),
                shower = vector3(-453.0362, -916.5066, 91.708)
            }
        },
        [33] = {
            roomLabel = 504,
            doorId = "apt_room_504",
            type = 'regular',
            floor = 5,
            zones = {
                doorEntry = vector3(-459.8083, -910.7084, 91.618064),
                stash = vector3(-464.3963, -907.7857, 91.618041),
                wardrobe = vector3(-464.6936, -904.8123, 91.618041),
                shower = vector3(-461.508, -903.8447, 91.708679)
            }
        },
        [34] = {
            roomLabel = 505,
            doorId = "apt_room_505",
            type = 'regular',
            floor = 5,
            zones = {
                doorEntry = vector3(-454.5258, -895.8005, 91.618057),
                stash = vector3(-450.0469, -898.7535, 91.618041),
                wardrobe = vector3(-449.7074, -901.6862, 91.618026),
                shower = vector3(-453.0049, -902.6008, 91.707626)
            }
        },
        [35] = {
            roomLabel = 506,
            doorId = "apt_room_506",
            type = 'regular',
            floor = 5,
            zones = {
                doorEntry = vector3(-459.8629, -896.8132, 91.618072),
                stash = vector3(-464.3923, -893.7714, 91.618034),
                wardrobe = vector3(-464.8608, -890.8854, 91.618041),
                shower = vector3(-461.4396, -889.9995, 91.70539)
            }
        },
        [36] = {
            roomLabel = 600,
            doorId = "apt_room_600",
            type = 'regular',
            floor = 6,
            zones = {
                doorEntry = vector3(-459.8741, -938.6595, 102.6181),
                stash = vector3(-464.3624, -935.6489, 102.61807),
                wardrobe = vector3(-464.7087, -932.7684, 102.61807),
                shower = vector3(-461.4253, -931.9489, 102.70328)
            }
        },
        [37] = {
            roomLabel = 601,
            doorId = "apt_room_601",
            type = 'regular',
            floor = 6,
            zones = {
                doorEntry = vector3(-454.5345, -923.6654, 102.6181),
                stash = vector3(-450.0505, -926.6968, 102.61808),
                wardrobe = vector3(-449.5772, -929.6016, 102.61808),
                shower = vector3(-453.0199, -930.4693, 102.70812)
            }
        },
        [38] = {
            roomLabel = 602,
            doorId = "apt_room_602",
            type = 'regular',
            floor = 6,
            zones = {
                doorEntry = vector3(-459.8191, -924.5685, 102.61806),
                stash = vector3(-464.3328, -921.588, 102.61806),
                wardrobe = vector3(-464.5907, -918.6951, 102.61808),
                shower = vector3(-461.4872, -917.6385, 102.71056)
            }
        },
        [39] = {
            roomLabel = 603,
            doorId = "apt_room_603",
            type = 'regular',
            floor = 6,
            zones = {
                doorEntry = vector3(-454.3643, -909.6967, 102.6181),
                stash = vector3(-450.0216, -912.7051, 102.61806),
                wardrobe = vector3(-450.0523, -915.6636, 102.61806),
                shower = vector3(-452.9158, -916.5282, 102.70819)
            }
        },
        [40] = {
            roomLabel = 604,
            doorId = "apt_room_604",
            type = 'regular',
            floor = 6,
            zones = {
                doorEntry = vector3(-459.9044, -910.706, 102.61808),
                stash = vector3(-464.4178, -907.8217, 102.61805),
                wardrobe = vector3(-464.8454, -904.8593, 102.61805),
                shower = vector3(-461.4633, -903.9805, 102.7045)
            }
        },
        [41] = {
            roomLabel = 605,
            doorId = "apt_room_605",
            type = 'regular',
            floor = 6,
            zones = {
                doorEntry = vector3(-454.444, -895.7724, 102.61809),
                stash = vector3(-449.9708, -898.7532, 102.61805),
                wardrobe = vector3(-449.5597, -901.6171, 102.61808),
                shower = vector3(-453.0145, -902.5825, 102.70582)
            }
        },
        [42] = {
            roomLabel = 606,
            doorId = "apt_room_606",
            type = 'regular',
            floor = 6,
            zones = {
                doorEntry = vector3(-459.8337, -896.8083, 102.61808),
                stash = vector3(-464.3951, -893.7705, 102.61806),
                wardrobe = vector3(-464.8681, -890.9796, 102.61807),
                shower = vector3(-461.4436, -890.098, 102.70462)
            }
        },
        [43] = {
            roomLabel = 700,
            doorId = "apt_room_700",
            type = 'regular',
            floor = 7,
            zones = {
                doorEntry = vector3(-459.9887, -938.6293, 108.1181),
                stash = vector3(-464.2777, -935.6985, 108.11808),
                wardrobe = vector3(-464.7641, -932.84, 108.11808),
                shower = vector3(-461.4688, -931.965, 108.20243)
            }
        },
        [44] = {
            roomLabel = 701,
            doorId = "apt_room_701",
            type = 'regular',
            floor = 7,
            zones = {
                doorEntry = vector3(-454.4289, -923.6311, 108.11808),
                stash = vector3(-450.0114, -926.6248, 108.11808),
                wardrobe = vector3(-449.8564, -929.4912, 108.11806),
                shower = vector3(-453.0465, -930.3442, 108.20167)
            }
        },
        [45] = {
            roomLabel = 702,
            doorId = "apt_room_702",
            type = 'regular',
            floor = 7,
            zones = {
                doorEntry = vector3(-459.8583, -924.6122, 108.11808),
                stash = vector3(-464.395, -921.6377, 108.11808),
                wardrobe = vector3(-464.579, -918.7581, 108.11809),
                shower = vector3(-461.4777, -917.8696, 108.20484)
            }
        },
        [46] = {
            roomLabel = 703,
            doorId = "apt_room_703",
            type = 'regular',
            floor = 7,
            zones = {
                doorEntry = vector3(-454.6109, -909.7611, 108.11808),
                stash = vector3(-449.9763, -912.6675, 108.11808),
                wardrobe = vector3(-449.9605, -915.6337, 108.11808),
                shower = vector3(-453.031, -916.5756, 108.2098)
            }
        },
        [47] = {
            roomLabel = 704,
            doorId = "apt_room_704",
            type = 'regular',
            floor = 7,
            zones = {
                doorEntry = vector3(-459.7674, -910.6989, 108.11808),
                stash = vector3(-464.3879, -907.7858, 108.11807),
                wardrobe = vector3(-464.8251, -904.8223, 108.11808),
                shower = vector3(-461.3618, -903.9031, 108.20801)
            }
        },
        [48] = {
            roomLabel = 705,
            doorId = "apt_room_705",
            type = 'regular',
            floor = 7,
            zones = {
                doorEntry = vector3(-454.4957, -895.8024, 108.11809),
                stash = vector3(-450.035, -898.7493, 108.11808),
                wardrobe = vector3(-449.8126, -901.7233, 108.11808),
                shower = vector3(-452.8858, -902.7389, 108.21053)
            }
        },
        [49] = {
            roomLabel = 706,
            doorId = "apt_room_706",
            type = 'regular',
            floor = 7,
            zones = {
                doorEntry = vector3(-459.9194, -896.8417, 108.11808),
                stash = vector3(-464.3326, -893.8549, 108.11808),
                wardrobe = vector3(-464.5981, -890.9415, 108.11808),
                shower = vector3(-461.4172, -890.1202, 108.20253)
            }
        },
    }
}

--     ["pink_cage"] = {
--         -- FIRST FLOOR
--         [1] = {
--             roomLabel = 1,
--             type = 'regular',
--             floor = 1,
--             zones = {
--                 doorEntry = vector3(307.33673, -213.2884, 54.219924),
--                 stash = vector3(306.04263, -204.5437, 54.225761),
--                 wardrobe = vector3(302.41131, -207.3485, 54.225765),
--                 logout = vector3(304.64755, -203.2297, 54.367156),
--                 shower = vector3(304.64755, -203.2297, 54.367156)
--             }
--         },
--         [2] = {
--             roomLabel = 2,
--             type = 'regular',
--             floor = 1,
--             zones = {
--                 doorEntry = vector3(311.20318, -203.4407, 54.219985),
--                 stash = vector3(309.81057, -194.8552, 54.225807),
--                 wardrobe = vector3(306.28399, -197.4455, 54.225811),
--                 logout = vector3(308.4595, -193.2355, 54.36721),
--                 shower = vector3(308.4595, -193.2355, 54.36721)
--             }
--         },
--         [3] = {
--             roomLabel = 3,
--             type = 'regular',
--             floor = 1,
--             zones = {
--                 doorEntry = vector3(315.7221, -195.0128, 54.226726),
--                 stash = vector3(324.51397, -193.3554, 54.225608),
--                 wardrobe = vector3(321.77215, -189.7904, 54.225608),
--                 logout = vector3(325.92556, -191.9423, 54.367015),
--                 shower = vector3(325.92556, -191.9423, 54.367015)
--             }
--         },
--         [4] = {
--             roomLabel = 4,
--             type = 'regular',
--             floor = 1,
--             zones = {
--                 doorEntry = vector3(339.02346, -219.43, 54.219886),
--                 stash = vector3(340.64877, -228.0033, 54.22631),
--                 wardrobe = vector3(344.19903, -225.4467, 54.226306),
--                 logout = vector3(341.98272, -229.6227, 54.367721),
--                 shower = vector3(341.98272, -229.6227, 54.367721)
--             }
--         },
--         [5] = {
--             roomLabel = 5,
--             type = 'regular',
--             floor = 1,
--             zones = {
--                 doorEntry = vector3(342.854, -209.5079, 54.219882),
--                 stash = vector3(344.49694, -218.2412, 54.225849),
--                 wardrobe = vector3(348.00646, -215.5657, 54.225849),
--                 logout = vector3(345.82028, -219.7119, 54.36716),
--                 shower = vector3(345.82028, -219.7119, 54.36716)
--             }
--         },
--         [6] = {
--             roomLabel = 6,
--             type = 'regular',
--             floor = 1,
--             zones = {
--                 doorEntry = vector3(346.78799, -199.6912, 54.219989),
--                 stash = vector3(348.23336, -208.4419, 54.226295),
--                 wardrobe = vector3(351.79397, -205.7006, 54.226287),
--                 logout = vector3(349.59753, -209.835, 54.367717),
--                 shower = vector3(349.59753, -209.835, 54.367717)
--             }
--         },
--         [7] = {
--             roomLabel = 7,
--             type = 'regular',
--             floor = 1,
--             zones = {
--                 doorEntry = vector3(314.97994, -219.6829, 58.021438),
--                 stash = vector3(306.26611, -221.1683, 58.024612),
--                 wardrobe = vector3(308.87796, -224.6223, 58.024612),
--                 logout = vector3(304.61627, -222.4891, 58.166099),
--                 shower = vector3(304.61627, -222.4891, 58.166099)
--             }
--         },
--         [8] = {
--             roomLabel = 8,
--             type = 'regular',
--             floor = 1,
--             zones = {
--                 doorEntry = vector3(307.45831, -213.4686, 58.015094),
--                 stash = vector3(305.97183, -204.8853, 58.023372),
--                 wardrobe = vector3(302.44631, -207.2843, 58.023365),
--                 logout = vector3(304.64727, -203.1623, 58.164672),
--                 shower = vector3(304.64727, -203.1623, 58.164672)
--             }
--         },
--         [9] = {
--             roomLabel = 9,
--             type = 'regular',
--             floor = 1,
--             zones = {
--                 doorEntry = vector3(311.3294, -203.4826, 58.015159),
--                 stash = vector3(309.77593, -194.869, 58.023723),
--                 wardrobe = vector3(306.20745, -197.4423, 58.023727),
--                 logout = vector3(308.49035, -193.1714, 58.165111),
--                 shower = vector3(308.49035, -193.1714, 58.165111)
--             }
--         },
--         [10] = {
--             roomLabel = 10,
--             type = 'regular',
--             floor = 1,
--             zones = {
--                 doorEntry = vector3(315.72058, -194.7438, 58.015186),
--                 stash = vector3(324.44482, -193.2924, 58.023944),
--                 wardrobe = vector3(321.71762, -189.7593, 58.023941),
--                 logout = vector3(325.86767, -191.9611, 58.16534),
--                 shower = vector3(325.86767, -191.9611, 58.16534)
--             }
--         },
--         [11] = {
--             roomLabel = 11,
--             type = 'regular',
--             floor = 1,
--             zones = {
--                 doorEntry = vector3(334.98779, -227.3412, 58.015033),
--                 stash = vector3(326.41311, -228.9187, 58.023796),
--                 wardrobe = vector3(328.94766, -232.4894, 58.023788),
--                 logout = vector3(324.70172, -230.2014, 58.165184),
--                 shower = vector3(324.70172, -230.2014, 58.165184)
--             }
--         },
--         [12] = {
--             roomLabel = 12,
--             type = 'regular',
--             floor = 1,
--             zones = {
--                 doorEntry = vector3(339.01776, -219.3259, 58.01511),
--                 stash = vector3(340.58706, -228.1559, 58.022747),
--                 wardrobe = vector3(344.19671, -225.4566, 58.02275),
--                 logout = vector3(342.0693, -229.6536, 58.164196),
--                 shower = vector3(342.0693, -229.6536, 58.164196)
--             }
--         },
--         [13] = {
--             roomLabel = 13,
--             type = 'regular',
--             floor = 1,
--             zones = {
--                 doorEntry = vector3(342.87957, -209.6293, 58.015117),
--                 stash = vector3(344.5487, -218.1159, 58.02275),
--                 wardrobe = vector3(347.96704, -215.5266, 58.022747),
--                 logout = vector3(345.75149, -219.7943, 58.164161),
--                 shower = vector3(345.75149, -219.7943, 58.164161)
--             }
--         },
--         [14] = {
--             roomLabel = 14,
--             type = 'regular',
--             floor = 1,
--             zones = {
--                 doorEntry = vector3(346.81661, -199.8673, 58.015045),
--                 stash = vector3(348.22488, -208.4799, 58.022747),
--                 wardrobe = vector3(351.91177, -205.7503, 58.022739),
--                 logout = vector3(349.59234, -209.9286, 58.164058),
--                 shower = vector3(349.59234, -209.9286, 58.164058)
--             }
--         },
--     }
-- }

-- Convert hotel rooms to apartment format
function GetApartmentDataFromConfig()
    local apartments = {}
    
    -- Sort rooms by building and room index for consistent ordering
    local sortedBuildings = {}
    for buildingName, rooms in pairs(Config.HotelRooms) do
        table.insert(sortedBuildings, {name = buildingName, rooms = rooms})
    end
    table.sort(sortedBuildings, function(a, b) return a.name < b.name end)
    
    for _, building in ipairs(sortedBuildings) do
        local buildingName = building.name
        local rooms = building.rooms
        
        -- Sort room indices (skip non-numeric keys like "label")
        local sortedRooms = {}
        for roomIndex, roomData in pairs(rooms) do
            -- Only include numeric indices (room numbers), skip string keys like "label"
            if type(roomIndex) == "number" then
                table.insert(sortedRooms, {index = roomIndex, data = roomData})
            end
        end
        table.sort(sortedRooms, function(a, b) return a.index < b.index end)
        
        for _, roomEntry in ipairs(sortedRooms) do
            local roomData = roomEntry.data
            local doorEntry = roomData.zones.doorEntry
            if not doorEntry then
                goto continue -- Skip rooms without doorEntry
            end
            
            local roomId = string.format("%s_%s", buildingName, roomData.roomLabel)
            
            -- Calculate interior zone bounds (room is roughly 8x8 meters)
            local interiorLength = 8.0
            local interiorWidth = 8.0
            
            -- Use logout zone if available, otherwise use wardrobe, then doorEntry as wakeup location
            local wakeupCoords = roomData.zones.logout or (roomData.zones.wardrobe and roomData.zones.wardrobe or doorEntry)
            
            -- Get building label (user-friendly name)
            local buildingLabel = rooms.label or buildingName
            
            table.insert(apartments, {
                name = string.format("%s - Room %s", buildingLabel, roomData.roomLabel),
                buildingName = buildingName,
                buildingLabel = buildingLabel,
                roomLabel = roomData.roomLabel,
                roomId = roomId,
                roomIndex = roomEntry.index, -- Room index from Config.HotelRooms (used as ox_doorlock door ID)
                type = roomData.type,
                floor = roomData.floor,
                doorId = roomData.doorId or roomEntry.index, -- ox_doorlock door ID from config or fallback to index
                invEntity = 13, -- Inventory entity type
                coords = vector3(doorEntry.x, doorEntry.y, doorEntry.z), -- Door entry position (exterior)
                heading = 0,
                length = 1.0, -- Exterior door zone size
                width = 1.0,
                options = {
                    heading = 0,
                    minZ = doorEntry.z - 1.0,
                    maxZ = doorEntry.z + 2.0
                },
                interior = {
                    -- Interior zone around door entry - defines the apartment interior MLO area
                    zone = {
                        center = doorEntry,
                        length = interiorLength,
                        width = interiorWidth,
                        options = {
                            heading = 0,
                            minZ = doorEntry.z - 2.0,
                            maxZ = doorEntry.z + 3.0
                        }
                    },
                    wakeup = {
                        x = wakeupCoords.x,
                        y = wakeupCoords.y,
                        z = wakeupCoords.z,
                        h = 0.0
                    },
                    spawn = {
                        x = doorEntry.x,
                        y = doorEntry.y,
                        z = doorEntry.z,
                        h = 0.0
                    },
                    locations = {
                        exit = {
                            coords = doorEntry,
                            length = 0.6,
                            width = 1.2,
                            options = {
                                heading = 0,
                                minZ = doorEntry.z - 0.5,
                                maxZ = doorEntry.z + 2.0
                            }
                        },
                        wardrobe = roomData.zones.wardrobe and {
                            coords = roomData.zones.wardrobe,
                            length = 0.6,
                            width = 1.2,
                            options = {
                                heading = 0,
                                minZ = roomData.zones.wardrobe.z - 0.5,
                                maxZ = roomData.zones.wardrobe.z + 2.0
                            }
                        } or nil,
                        shower = roomData.zones.shower and {
                            coords = roomData.zones.shower,
                            length = 0.6,
                            width = 1.2,
                            options = {
                                heading = 0,
                                minZ = roomData.zones.shower.z - 0.5,
                                maxZ = roomData.zones.shower.z + 2.0
                            }
                        } or nil,
                        stash = roomData.zones.stash and {
                            coords = roomData.zones.stash,
                            length = 1.0,
                            width = 1.0,
                            options = {
                                heading = 0,
                                minZ = roomData.zones.stash.z - 0.5,
                                maxZ = roomData.zones.stash.z + 2.0
                            }
                        } or nil,
                        logout = (roomData.zones.logout or roomData.zones.wardrobe) and {
                            coords = roomData.zones.logout or roomData.zones.wardrobe,
                            length = 2.0,
                            width = 2.8,
                            options = {
                                heading = 0,
                                minZ = (roomData.zones.logout or roomData.zones.wardrobe).z - 0.5,
                                maxZ = (roomData.zones.logout or roomData.zones.wardrobe).z + 2.0
                            }
                        } or nil,
                    }
                }
            })
            ::continue::
        end
    end
    
    return apartments
end
