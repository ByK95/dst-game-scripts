local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

--Not directly treasure, but relevant:
SLOTMACHINE_LOOT =
{
    -- A weighted average list of prizes, the bigger the number, the more likely it is.
    -- It's based off altar_prototyper.lua
    goodspawns = -- Best Slot Loot List
    {
    --    log = 50,
    --    twigs =50,
    --    cutgrass = 50,
    --    berries = 50,
    --    limpets = 50,
    --    meat = 50,
    --    monstermeat = 50,
    --    fish = 50,
    --    meat_dried = 30,
    --    seaweed = 50,
    --    jellyfish = 20,
    --    dubloon = 50,
    --    redgem = 10,
    --    bluegem = 10,
    --    purplegem = 10,
    --    goldnugget = 50,
    --    snakeskin = 20,
    --    spidergland = 20,
    --    torch = 50,
    --    coconut = 50,

        slot_goldy = 1,
        slot_10dubloons = 1,
        slot_honeypot = 1,
        slot_warrior1 = 1,
        slot_warrior2 = 1,
        slot_warrior3 = 1,
        slot_warrior4 = 1,
        slot_scientist = 1,
        slot_walker = 1,
        slot_gemmy = 1,
        slot_bestgem = 1,
        slot_lifegiver = 1,
        slot_chilledamulet = 1,
        slot_icestaff = 1,
        slot_firestaff = 1,
        slot_coolasice = 1,
        slot_gunpowder = 1,
        slot_firedart = 1,
        slot_sleepdart = 1,
        slot_blowdart = 1,
        slot_speargun = 1,
        slot_coconades = 1,
        slot_obsidian = 1,
        slot_thuleciteclub = 1,
        slot_ultimatewarrior = 1,
        slot_goldenaxe = 1,
        staydry = 1,
        cooloff = 1,
        birders = 1,
        gears = 1,
        trinket = 2,
        slot_seafoodsurprise = 1,
        slot_fisherman = 1,
        slot_camper = 1,
        slot_spiderboon = 1,
        slot_dapper = 1,
        slot_speed = 1,
        slot_tailor = 5,
        --IA loots
        slot_jackpot = 1,
        slot_jellybeans = 1,
        slot_chess = 1,
        slot_gems = 1,
        slot_pollyroger = 1,
        slot_celestial = 1,
        slot_megaflare = 1,
        slot_nightmare = 1,
        slot_constructor = 1,
        slot_lazy = 1,
        --slot_oceantrees = 1,
        slot_docks = 1,
        slot_trident = 1,
        slot_brain = 1,
        slot_turf = 1,

    },
    okspawns = -- Food and Resources
    {
        slot_anotherspin = 5,
        firestarter = 5,
        geologist = 5,
        cutgrassbunch = 5,
        logbunch = 5,
        twigsbunch = 5,
        --torch = 5,
        slot_torched = 5,
        slot_jelly = 5,
        slot_handyman = 5,
        slot_poop = 5,
        slot_berry = 5,
        slot_limpets = 5,
        slot_bushy = 5,
        slot_bamboozled = 5,
        slot_grassy = 5,
        slot_prettyflowers = 5,
        slot_witchcraft = 5,
        slot_bugexpert = 5,
        slot_flinty = 5,
        slot_fibre = 5,
        slot_drumstick = 5,
        slot_ropey = 5,
        slot_jerky = 5,
        slot_coconutty = 5,
        slot_bonesharded = 5,
        ---IA loots
        slot_vines = 5,
        slot_marble = 5,
        slot_moonrocks = 5,
        slot_salt = 5,
        slot_nubbin = 5,
        slot_honey = 5,
        slot_health = 5,
        slot_nitre = 5,
        slot_seashells = 5,
        slot_palmconeseeds = 5,
        slot_bananabush = 5,
        slot_monkeytails = 5,
        slot_rainbowjelly = 5,
        slot_farming = 5,
    },
    badspawns =
    {
        --snake = 1,
        --spider_hider = 1,
        slot_spiderattack = 1,
        slot_mosquitoattack = 1,
        slot_snakeattack = 1,
        slot_monkeysurprise = 1,
        slot_poisonsnakes = 1,
        slot_hounds = 1,
        ---IA loots
        slot_crocodogs = 1,
        slot_beeguards = 1,
        slot_peepers = 1,
        slot_nursespiders = 1,
        slot_poisoncrocodogs = 1,

        --nothing = 100,
    },
    actions = -- actions to perform for the spawns
    {
        -- if there's a cnt, then it'll spawn that many
        -- if there's a var, then that'll be used as variance for cnt
        -- if there's a "callback" function, then that'll run cnt times (min once)
        -- if there's a treasure, it'll spawn that instead of an item

        --trinket = { cnt = 2, },
        --spider_hider = { cnt = 3, },
        --snake = { cnt = 3, },

        firestarter = { treasure = "firestarter", },
        geologist = { treasure = "geologist", },
        cutgrassbunch = { treasure = "3cutgrass", },
        logbunch = { treasure = "3logs", },
        twigsbunch = { treasure = "3twigs", },
        slot_torched = { treasure = "slot_torched", },
        slot_jelly = { treasure = "slot_jelly", },
        slot_handyman = { treasure = "slot_handyman", },
        slot_poop = { treasure = "slot_poop", },
        slot_berry = { treasure = "slot_berry", },
        slot_limpets = { treasure = "slot_limpets", },
        slot_seafoodsurprise = { treasure = "slot_seafoodsurprise", },
        slot_bushy = { treasure = "slot_bushy", },
        slot_bamboozled = { treasure = "slot_bamboozled", },
        slot_grassy = { treasure = "slot_grassy", },
        slot_prettyflowers = { treasure = "slot_prettyflowers", },
        slot_witchcraft = { treasure = "slot_witchcraft", },
        slot_bugexpert = { treasure = "slot_bugexpert", },
        slot_flinty = { treasure = "slot_flinty", },
        slot_fibre = { treasure = "slot_fibre", },
        slot_drumstick = { treasure = "slot_drumstick", },
        slot_fisherman = { treasure = "slot_fisherman", },
        slot_dapper = { treasure = "slot_dapper", },
        slot_speed = { treasure = "slot_speed", },

        slot_anotherspin = { treasure = "slot_anotherspin", },
        slot_goldy = { treasure = "slot_goldy", },
        slot_honeypot = { treasure = "slot_honeypot", },
        slot_warrior1 = { treasure = "slot_warrior1", },
        slot_warrior2 = { treasure = "slot_warrior2", },
        slot_warrior3 = { treasure = "slot_warrior3", },
        slot_warrior4 = { treasure = "slot_warrior4", },
        slot_scientist = { treasure = "slot_scientist", },
        slot_walker = { treasure = "slot_walker", },
        slot_gemmy = { treasure = "slot_gemmy", },
        slot_bestgem = { treasure = "slot_bestgem", },
        slot_lifegiver = { treasure = "slot_lifegiver", },
        slot_chilledamulet = { treasure = "slot_chilledamulet", },
        slot_icestaff = { treasure = "slot_icestaff", },
        slot_firestaff = { treasure = "slot_firestaff", },
        slot_coolasice = { treasure = "slot_coolasice", },
        slot_gunpowder = { treasure = "slot_gunpowder", },
        slot_firedart = { treasure = "slot_firedart", },
        slot_sleepdart = { treasure = "slot_sleepdart", },
        slot_blowdart = { treasure = "slot_blowdart", },
        slot_speargun = { treasure = "slot_speargun", },
        slot_coconades = { treasure = "slot_coconades", },
        slot_obsidian = { treasure = "slot_obsidian", },
        slot_thuleciteclub = { treasure = "slot_thuleciteclub", },
        slot_ultimatewarrior = { treasure = "slot_ultimatewarrior", },
        slot_goldenaxe = { treasure = "slot_goldenaxe", },
        staydry = { treasure = "staydry", },
        cooloff = { treasure = "cooloff", },
        birders = { treasure = "birders", },
        slot_monkeyball = { treasure = "slot_monkeyball", },

        slot_bonesharded = { treasure = "slot_bonesharded", },
        slot_jerky = { treasure = "slot_jerky", },
        slot_coconutty = { treasure = "slot_coconutty", },
        slot_camper = { treasure = "slot_camper", },
        slot_ropey = { treasure = "slot_ropey", },
        slot_tailor = { treasure = "slot_tailor", },
        slot_spiderboon = { treasure = "slot_spiderboon", },
        slot_3dubloons = { treasure = "3dubloons", },
        slot_10dubloons = { treasure = "10dubloons", },

        slot_spiderattack = { treasure = "slot_spiderattack", },
        slot_mosquitoattack = { treasure = "slot_mosquitoattack", },
        slot_monkeysurprise = { treasure = "slot_monkeysurprise", },
        slot_poisonsnakes = { treasure = "slot_poisonsnakes", },
        slot_hounds = { treasure = "slot_hounds", },
        slot_snakeattack = { treasure = "slot_snakeattack", },

--------IA Loots
        slot_jackpot = { treasure = "slot_jackpot", },
        slot_jellybeans = { treasure = "slot_jellybeans", },
        slot_chess =  { treasure = "slot_chess", },
        slot_gems =  { treasure = "slot_gems", },
        slot_pollyroger =  { treasure = "slot_pollyroger", },
        slot_celestial =  { treasure = "slot_celestial", },
        slot_megaflare = { treasure = "slot_megaflare", },
        slot_nightmare = { treasure = "slot_nightmare", },
        slot_constructor = { treasure = "slot_constructor", },
        slot_lazy = { treasure = "slot_lazy", },
        --slot_oceantrees  = { treasure = "slot_oceantrees", },
        slot_docks  = { treasure = "slot_docks", },
        slot_trident  = { treasure = "slot_trident", },
        slot_brain  = { treasure = "slot_brain", },
        slot_turf  = { treasure = "slot_turf", },

        slot_marble = { treasure = "slot_marble", },
        slot_moonrocks = { treasure = "slot_moonrocks", },
        slot_vines = { treasure = "slot_vines", },
        slot_salt = { treasure = "slot_salt", },
        slot_nubbin = { treasure = "slot_nubbin", },
        slot_honey = { treasure = "slot_honey", },
        slot_health = { treasure = "slot_health", },
        slot_nitre = { treasure = "slot_nitre", },
        slot_seashells = { treasure = "slot_seashells", },
        slot_palmconeseeds = { treasure = "slot_palmconeseeds", },
        slot_bananabush = { treasure = "slot_bananabush", },
        slot_monkeytails = { treasure = "slot_monkeytails", },
        slot_rainbowjelly = { treasure = "slot_rainbowjelly", },
        slot_farming  = { treasure = "slot_farming", },

        slot_crocodogs = { treasure = "slot_crocodogs", },
        slot_beeguards = { treasure = "slot_beeguards", },
        slot_peepers = { treasure = "slot_peepers", },
        slot_nursespiders = { treasure = "slot_nursespiders", },
        slot_poisoncrocodogs = { treasure = "slot_poisoncrocodogs", },
    }
}

OCTOPUSKING_LOOT = {
    randomchestloot = -- These are "dubloon" substitutes for when there's not specific chestloot.
    {
        "seaweed",
        "seaweed",
        "seaweed",
        "seaweed",
        "seaweed",
        "seashell",
        "seashell",
        "seashell",
        "coral",
        "coral",
        "coral",
        "shark_fin",
        "blubber",
        "bioluminescence",
		"bioluminescence",
    },
    chestloot = -- These are specific boni for specific gifts. Not to be confused with item.components.trabable.tradefor !
    {
        californiaroll = "sail_palmleaf",
        seafoodgumbo = "sail_cloth",
        bisque = "trawlnet",
        jellyopop = "seatrap",
        ceviche = "telescope",
        surfnturf = "boat_lantern",
        wobsterbisque = "piratehat",
        lobsterbisque = "piratehat",
        lobsterdinner = "boatcannon",
        wobsterdinner = "boatcannon",
        caviar = "bottlelantern",
        tropicalbouillabaisse = "sail_feather",
        sharkfinsoup = "boatrepairkit",
    },
}

if not IA_CONFIG.octopustrade then
    OCTOPUSKING_LOOT.chestloot["tropicalbouillabaisse"] = nil
    OCTOPUSKING_LOOT.chestloot["sharkfinsoup"] = nil
end
---------------------------------------------------------------------

local internaltreasure =
{
    ["TestTreasure"] =
    {
        {
            --Set piece with the treasure prefab
            treasure_set_piece = "BuriedTreasureLayout",

            --The treasure prefab itself. If treasure_set_piece is set this is the prefab
            --inside the set piece. If treasure_set_piece is not set this prefab will be spawned
            --during worldgen
            treasure_prefab = "buriedtreasure",

            --Set piece with the map prefab, only for the first stage in multi stage treasures
            map_set_piece = "TreasureHunterBoon",

            --currently unused
            map_prefab = "ia_messagebottle",

            --Reference to the loot table for the treasure when it is dug up
            loot = "snaketrap"
        }
    },
    ["PirateBank"] =
    {
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "10dubloons",
        }
    },

    ["SuperTelescope"] =
    {
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "SuperTelescope",
        }
    },

    ["WoodlegsKey1"] =
    {
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "WoodlegsKey1",
        }
    },

    ["WoodlegsKey2"] =
    {
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "WoodlegsKey2",
        }
    },

    ["WoodlegsKey3"] =
    {
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "WoodlegsKey3",
        }
    },

    ["PiratePeanuts"] =
    {
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "1dubloon",
        }
    },

    ["minerhat"] =
    {
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "minerhat",
        }

    },

    ["RandomGem"] =
    {
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "gems",
        }
    },


    ["DubloonsGem"] =
    {
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "dubloonsandgem",
        }
    },


    ["SeamansCarePackage"] =
    {
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "seamanscarepackage",
        }
    },

    ["ChickenOfTheSea"] =
    {
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "ChickenOfTheSea",
        }
    },

        ["BootyInDaBooty"] =
    {
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "BootyInDaBooty",
        }
    },

        ["OneTrueEarring"] =
    {
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "OneTrueEarring",
        }
    },

        ["PegLeg"] =
    {
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "PegLeg",
        }
    },

        ["VolcanoStaff"] =
    {
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "VolcanoStaff",
        }
    },

        ["Gladiator"] =
    {
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "Gladiator",
        }
    },

        ["FancyHandyMan"] =
    {
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "FancyHandyMan",
        }
    },

        ["LobsterMan"] =
    {
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "LobsterMan",
        }
    },

        ["Compass"] =
    {
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "Compass",
        }
    },

        ["Scientist"] =
    {
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "Scientist",
        }
    },

        ["Alchemist"] =
    {
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "Alchemist",
        }
    },

        ["Shaman"] =
    {
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "Shaman",
        }
    },

        ["FireBrand"] =
    {
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "FireBrand",
        }
    },

        ["SailorsDelight"] =
    {
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "SailorsDelight",
        }
    },

        ["WarShip"] =
    {
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "WarShip",
        }
    },

        ["Desperado"] =
    {
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "Desperado",
        }
    },

        ["JewelThief"] =
    {
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "JewelThief",
        }
    },

        ["AntiqueWarrior"] =
    {
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "AntiqueWarrior",
        }
    },

        ["Yaar"] =
    {
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "Yaar",
        }
    },

        ["GdayMate"] =
    {
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "GdayMate",
        }
    },

        ["ToxicAvenger"] =
    {
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "ToxicAvenger",
        }
    },

        ["MadBomber"] =
    {
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "MadBomber",
        }
    },

        ["FancyAdventurer"] =
    {
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "FancyAdventurer",
        }
    },

        ["ThunderBall"] =
    {
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "ThunderBall",
        }
    },

        ["TombRaider"] =
    {
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "TombRaider",
        }
    },

        ["SteamPunk"] =
    {
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "SteamPunk",
        }
    },

        ["CapNCrunch"] =
    {
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "CapNCrunch",
        }
    },

        ["AyeAyeCapn"] =
    {
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "AyeAyeCapn",
        }
    },

        ["BreakWind"] =
    {
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "BreakWind",
        }
    },

        ["Diviner"] =
    {
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "Diviner",
        }
    },

        ["GoesComesAround"] =
    {
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "GoesComesAround",
        }
    },

        ["GoldGoldGold"] =
    {
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "GoldGoldGold",
        }
    },

        ["FirePoker"] =
    {
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "FirePoker",
        }
    },

        ["DeadmansTreasure"] =
    {
        {
            treasure_set_piece = "RockSkull",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "DeadmansTreasure",
        }
    },

    ["TestMultiStage"] =
    {
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "1dubloon",
        },
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "1dubloon",
        },
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "gems",
        },
    },

    ["SeaPackageQuest"] =
    {
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "1dubloon",
        },
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "dubloonsandgem",
        },
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "seamanscarepackage",
        },
    },

    ["TierQuest"] =
    {
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "seamanscarepackage",
        },
        {
            tier = 1,
        },
        {
            tier = 2,
        },
        {
            tier = 2,
        },
        {
            tier = 3,
        },
    }
}

-- everytime a tier chest is picked, it's removed from this list
local Tiers =
{
    [1] = {
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "1dubloon",
        },
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "slot_blowdart",
        },
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "slot_speargun",
        },
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "slot_obsidian",
        },
    },
    ----------------------------------------------------------------------
    [2] = {
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "1dubloon",
        },
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "slot_blowdart",
        },
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "slot_speargun",
        },
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "slot_obsidian",
        },
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "slot_dapper",
        },
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "slot_speed",
        },

    },
    ----------------------------------------------------------------------
    [3] = {
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "1dubloon",
        },
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "slot_blowdart",
        },
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "slot_speargun",
        },
        {
            treasure_set_piece = "BuriedTreasureLayout",
            treasure_prefab = "buriedtreasure",
            map_prefab = "ia_messagebottle",
            loot = "slot_obsidian",
        },
    },
}

local internalloot =
{
    --[[
    ["sample"] =
    {
        --[Optional] container that spawns with the loot in it see prefabs/treasurechest.lua
        --any prefab with a container component should work
        chest = "treasurechest",

        --All items in loot is given when a treasure is dug up
        loot =
        {
            dubloon = 2,
            redgem = 4
        },

        --'num_random_loot' items are given from random_loot (a weighted table)
        num_random_loot = 1,
        random_loot =
        {
            purplegem = 1,
            orangegem = 1,
            yellowgem = 1,
            greengem = 1,
            redgem = 5,
            bluegem = 5,
        },

        --Every item in chance_loot has a custom chance of being given
        --Possible for nothing or everything to be given
        chance_loot =
        {
            dubloon = 0.25,
            goldnugget = 0.25,
            bluegem = 0.1
        },

        --A custom function used to give items
        custom_lootfn = function(lootlist) end
    },
    --]]
    ["snaketrap"] =
    {
        loot =
        {
            snake = 3,
            dubloon = 3,
        },
        random_loot =
        {
            purplegem = 1,
            orangegem = 1,
            yellowgem = 1,
            greengem = 1,
            redgem = 5,
            bluegem = 5,
        },
    },

    ["1dubloon"] =
    {
        loot =
        {
            dubloon = 1,
        }
    },

    ["3dubloons"] =
    {
        loot =
        {
            dubloon = 3,
        }
    },

    ["10dubloons"] =
    {
        loot =
        {
            dubloon = 10,
        }
    },

    ["SuperTelescope"] =
    {
        loot =
        {
            supertelescope = 1,
            dubloon = 5,
            spear_poison = 1,
            boat_lantern = 1,
        },

        random_loot =
        {
            papyrus = 1,
            tunacan = 1,
            blueprint = 1,
            goldnugget = 1,
            gears = 1,
            purplegem = 1,
            redgem = 1,
            bluegem = 1,
            rope = 1,
            cookingrecipecard = 1,
            scrapbook_page = 1,
        },
    },

    ["minerhat"] =
    {
        loot =
        {
            minerhat = 1,
            dubloon = 5,
            obsidianaxe = 1,
        },

        random_loot =
        {
            papyrus = 1,
            tunacan = 1,
            blueprint = 1,
            goldnugget = 1,
            gears = 1,
            purplegem = 1,
            redgem = 1,
            bluegem = 1,
            rope = 1,
            cookingrecipecard = 1,
            scrapbook_page = 1,
        },
    },

    ["seamanscarepackage"] =
    {
        chest = "pandoraschest_tropical",
        loot =
        {
            dubloon = 5,
            telescope = 1,
            armor_lifejacket = 1,
            captainhat = 1
        },

        random_loot =
        {
            papyrus = 1,
            tunacan = 1,
            blueprint = 1,
            goldnugget = 1,
            gears = 1,
            purplegem = 1,
            redgem = 1,
            bluegem = 1,
            rope = 1,
            cookingrecipecard = 1,
            scrapbook_page = 1,
        },
    },

    ["gems"] =
    {
        chest = "treasurechest",
        loot =
        {
            goldnugget = 3,
        },

        random_loot =
        {
            papyrus = 1,
            tunacan = 1,
            blueprint = 1,
            goldnugget = 1,
            gears = 1,
            purplegem = 1,
            redgem = 1,
            bluegem = 1,
            rope = 1,
            cookingrecipecard = 1,
            scrapbook_page = 1,
        },

        chance_loot =
        {
            purplegem = .5,
            orangegem = .25,
            yellowgem = .25,
            greengem = .25
        },
    },

    ["dubloonsandgem"] =
    {
        loot =
        {
            dubloon = 5
        },
        random_loot =
        {
            purplegem = 1,
            redgem = 5,
            bluegem = 5,
        }
    },

    ["ChickenOfTheSea"] =
    {
        loot =
        {
            dubloon = 5,
            tunacan = 5,
        },

        random_loot =
        {
            papyrus = 1,
            tunacan = 1,
            blueprint = 1,
            goldnugget = 1,
            gears = 1,
            purplegem = 1,
            redgem = 1,
            bluegem = 1,
            rope = 1,
            cookingrecipecard = 1,
            scrapbook_page = 1,
        },

        chance_loot =
        {
            purplegem = .1,
            redgem = .25,
            bluegem = .25,
        }
    },
-------------------------------------------------------DAN ADDED FROM HERE
    ["BootyInDaBooty"] =
    {
        loot =
        {
            dubloon = 5,
            piratepack = 1,
        },

        random_loot =
        {
            papyrus = 1,
            tunacan = 1,
            blueprint = 1,
            goldnugget = 1,
            gears = 1,
            purplegem = 1,
            redgem = 1,
            bluegem = 1,
            rope = 1,
            cookingrecipecard = 1,
            scrapbook_page = 1,
        },

        chance_loot =
        {
            purplegem = .1,
            redgem = .25,
            bluegem = .25,
        }
    },

    ["OneTrueEarring"] =
    {
        loot =
        {
            earring = 1,
        },
        chance_loot =
        {
            purplegem = .1,
            redgem = .25,
            bluegem = .25,
        }
    },

    ["PegLeg"] =
    {
        loot =
        {
            dubloon = 2,
            peg_leg = 1,
        },

        random_loot =
        {
            papyrus = 1,
            tunacan = 1,
            blueprint = 1,
            goldnugget = 1,
            gears = 1,
            purplegem = 1,
            redgem = 1,
            bluegem = 1,
            rope = 1,
            cookingrecipecard = 1,
            scrapbook_page = 1,
        },

        chance_loot =
        {
            purplegem = .1,
            redgem = .25,
            bluegem = .25,
        }
    },

    ["VolcanoStaff"] =
    {
        loot =
        {
            dubloon = 6,
            volcanostaff = 1,
        },

        random_loot =
        {
            papyrus = 1,
            tunacan = 1,
            blueprint = 1,
            goldnugget = 1,
            gears = 1,
            purplegem = 1,
            redgem = 1,
            bluegem = 1,
            rope = 1,
            cookingrecipecard = 1,
            scrapbook_page = 1,
        },

        chance_loot =
        {
            purplegem = .1,
            redgem = .25,
            bluegem = .25,
        }
    },

    ["Gladiator"] =
    {
        loot =
        {
            dubloon = 2,
            footballhat = 1,
            spear = 1,
            armorseashell= 1,
        },

        random_loot =
        {
            papyrus = 1,
            tunacan = 1,
            blueprint = 1,
            goldnugget = 1,
            gears = 1,
            purplegem = 1,
            redgem = 1,
            bluegem = 1,
            rope = 1,
            cookingrecipecard = 1,
            scrapbook_page = 1,
        },

        chance_loot =
        {
            purplegem = .1,
            redgem = .25,
            bluegem = .25,
        }
    },

    ["FancyHandyMan"] =
    {
        loot =
        {
            dubloon = 1,
            goldenaxe = 1,
            goldenshovel = 1,
            goldenpickaxe= 1,
        },

        random_loot =
        {
            papyrus = 1,
            tunacan = 1,
            blueprint = 1,
            goldnugget = 1,
            gears = 1,
            purplegem = 1,
            redgem = 1,
            bluegem = 1,
            rope = 1,
            cookingrecipecard = 1,
            scrapbook_page = 1,
        },

        chance_loot =
        {
            purplegem = .1,
            redgem = .25,
            bluegem = .25,
        }

    },

    ["LobsterMan"] =
    {
        loot =
        {
            dubloon = 4,
            boat_lantern = 1,
            seatrap = 1,
        },

        random_loot =
        {
            papyrus = 1,
            tunacan = 1,
            blueprint = 1,
            goldnugget = 1,
            gears = 1,
            purplegem = 1,
            redgem = 1,
            bluegem = 1,
            rope = 1,
            cookingrecipecard = 1,
            scrapbook_page = 1,
        },

        chance_loot =
        {
            purplegem = .1,
            redgem = .25,
            bluegem = .25,
        }
    },

    ["Compass"] =
    {
        loot =
        {
            dubloon = 3,
            compass = 1,
            boneshard = 2,
            ia_messagebottleempty = 1,
            sand = 1,
        },

        random_loot =
        {
            papyrus = 1,
            tunacan = 1,
            blueprint = 1,
            goldnugget = 1,
            gears = 1,
            purplegem = 1,
            redgem = 1,
            bluegem = 1,
            rope = 1,
            cookingrecipecard = 1,
            scrapbook_page = 1,
        }
    },

    ["Scientist"] =
    {
        loot =
        {
            dubloon = 3,
            transistor = 1,
            gunpowder = 3,
            heatrock = 1,
        },

        random_loot =
        {
            papyrus = 1,
            tunacan = 1,
            blueprint = 1,
            goldnugget = 1,
            gears = 1,
            purplegem = 1,
            redgem = 1,
            bluegem = 1,
            rope = 1,
            cookingrecipecard = 1,
            scrapbook_page = 1,
        },

        chance_loot =
        {
            purplegem = .1,
            redgem = .25,
            bluegem = .25,
        }
    },

    ["Alchemist"] =
    {
        loot =
        {
            dubloon = 2,
            antivenom = 1,
            healingsalve = 3,
            blowdart_sleep = 2,
        },

        random_loot =
        {
            papyrus = 1,
            tunacan = 1,
            blueprint = 1,
            goldnugget = 1,
            gears = 1,
            purplegem = 1,
            redgem = 1,
            bluegem = 1,
            rope = 1,
            cookingrecipecard = 1,
            scrapbook_page = 1,
        },

        chance_loot =
        {
            purplegem = .1,
            redgem = .25,
            bluegem = .25,
        }
    },

    ["Shaman"] =
    {
        loot =
        {
            dubloon = 1,
            nightsword = 1,
            amulet = 1,
        },

        random_loot =
        {
            papyrus = 1,
            tunacan = 1,
            blueprint = 1,
            goldnugget = 1,
            gears = 1,
            purplegem = 1,
            redgem = 1,
            bluegem = 1,
            rope = 1,
            cookingrecipecard = 1,
            scrapbook_page = 1,
        },

        chance_loot =
        {
            purplegem = .1,
            redgem = .25,
            bluegem = .25,
        }

    },

    ["FireBrand"] =
    {
        loot =
        {
            dubloon = 2,
            obsidianaxe = 1,
            gunpowder = 2,
        },

        random_loot =
        {
            papyrus = 1,
            tunacan = 1,
            blueprint = 1,
            goldnugget = 1,
            gears = 1,
            purplegem = 1,
            redgem = 1,
            bluegem = 1,
            rope = 1,
            cookingrecipecard = 1,
            scrapbook_page = 1,
        },

        chance_loot =
        {
            purplegem = .1,
            redgem = .25,
            bluegem = .25,
        }
    },

    ["SailorsDelight"] =
    {
        loot =
        {
            dubloon = 4,
            sail_cloth = 1,
            boatrepairkit = 1,
            boat_lantern = 1,
        },

        random_loot =
        {
            papyrus = 1,
            tunacan = 1,
            blueprint = 1,
            goldnugget = 1,
            gears = 1,
            purplegem = 1,
            redgem = 1,
            bluegem = 1,
            rope = 1,
            cookingrecipecard = 1,
            scrapbook_page = 1,
        },

        chance_loot =
        {
            purplegem = .1,
            redgem = .25,
            bluegem = .25,
        }

    },

    ["WarShip"] =
    {
        loot =
        {
            dubloon = 3,
            coconade = 3,
            boatcannon = 1,
        },

        random_loot =
        {
            papyrus = 1,
            tunacan = 1,
            blueprint = 1,
            goldnugget = 1,
            gears = 1,
            purplegem = 1,
            redgem = 1,
            bluegem = 1,
            rope = 1,
            cookingrecipecard = 1,
            scrapbook_page = 1,
        },

        chance_loot =
        {
            purplegem = .1,
            redgem = .25,
            bluegem = .25,
        }
    },

    ["Desperado"] =
    {
        loot =
        {
            dubloon = 1,
            snakeskinhat = 1,
            armor_snakeskin = 1,
            spear_launcher = 2,
            spear = 1,
        },

    random_loot =
        {
            papyrus = 1,
            tunacan = 1,
            blueprint = 1,
            goldnugget = 1,
            gears = 1,
            purplegem = 1,
            redgem = 1,
            bluegem = 1,
            rope = 1,
            cookingrecipecard = 1,
            scrapbook_page = 1,
        },

        chance_loot =
        {
            purplegem = .1,
            redgem = .25,
            bluegem = .25,
        }
    },

	["JewelThief"] =
	{
		loot =
		{
			dubloon = 5,
			goldnugget =6,
			purplegem =2,
			redgem = 4,
			bluegem = 3,
		},
	
	random_loot =
		{
            papyrus = 1,
            tunacan = 1,
            blueprint = 1,
            goldnugget = 1,
            gears = 1,
            purplegem = 1,
            redgem = 1,
            bluegem = 1,
            rope = 1,
            cookingrecipecard = 1,
            scrapbook_page = 1,
		}
	},

    ["AntiqueWarrior"] =
    {
        loot =
        {
            dubloon = 5,
            ruins_bat = 1,
            ruinshat = 1,
            armorruins = 1,
            bluegem = 2,
        },

        random_loot =
        {
            papyrus = 1,
            tunacan = 1,
            blueprint = 1,
            goldnugget = 1,
            gears = 1,
            purplegem = 1,
            redgem = 1,
            bluegem = 1,
            rope = 1,
            cookingrecipecard = 1,
            scrapbook_page = 1,
        }
    },

    ["Yaar"] =
    {
        loot =
        {
            dubloon = 1,
            telescope = 1,
            piratehat = 1,
            boatcannon = 1,
        },

        random_loot =
        {
            papyrus = 1,
            tunacan = 1,
            blueprint = 1,
            goldnugget = 1,
            gears = 1,
            purplegem = 1,
            redgem = 1,
            bluegem = 1,
            rope = 1,
            cookingrecipecard = 1,
            scrapbook_page = 1,
        },

        chance_loot =
        {
            purplegem = .1,
            redgem = .25,
            bluegem = .25,
        }
    },

    ["GdayMate"] =
    {
        loot =
        {
            dubloon = 3,
            boomerang = 1,
            snakeskin = 3,
            strawhat = 1,
        },

        random_loot =
        {
            papyrus = 1,
            tunacan = 1,
            blueprint = 1,
            goldnugget = 1,
            gears = 1,
            purplegem = 1,
            redgem = 1,
            bluegem = 1,
            rope = 1,
            cookingrecipecard = 1,
            scrapbook_page = 1,
        },

        chance_loot =
        {
            purplegem = .1,
            redgem = .25,
            bluegem = .25,
        }
    },
    ["ToxicAvenger"] =
    {
        loot =
        {
            dubloon = 1,
            gashat = 1,
            venomgland = 3,
            spear_poison = 1,
        },

        random_loot =
        {
            papyrus = 1,
            tunacan = 1,
            blueprint = 1,
            goldnugget = 1,
            gears = 1,
            purplegem = 1,
            redgem = 1,
            bluegem = 1,
            rope = 1,
            cookingrecipecard = 1,
            scrapbook_page = 1,
        },

        chance_loot =
        {
            purplegem = .1,
            redgem = .25,
            bluegem = .25,
        }
    },

    ["MadBomber"] =
    {
        loot =
        {
            dubloon = 2,
            coconade = 2,
            obsidiancoconade = 1,
            gunpowder = 2,
        },

        random_loot =
        {
            papyrus = 1,
            tunacan = 1,
            blueprint = 1,
            goldnugget = 1,
            gears = 1,
            purplegem = 1,
            redgem = 1,
            bluegem = 1,
            rope = 1,
            cookingrecipecard = 1,
            scrapbook_page = 1,
        },

        chance_loot =
        {
            purplegem = .1,
            redgem = .25,
            bluegem = .25,
        }
    },

    ["FancyAdventurer"] =
    {
        loot =
        {
            dubloon = 4,
            goldenmachete = 1,
            tophat = 1,
            rope = 3,
            telescope = 1,
        },

        random_loot =
        {
            papyrus = 1,
            tunacan = 1,
            blueprint = 1,
            goldnugget = 1,
            gears = 1,
            purplegem = 1,
            redgem = 1,
            bluegem = 1,
            rope = 1,
            cookingrecipecard = 1,
            scrapbook_page = 1,
        }
    },

    ["ThunderBall"] =
    {
        loot =
        {
            dubloon = 6,
            spear_launcher = 2,
            spear = 1,
            blubbersuit = 1,
        },

        random_loot =
        {
            papyrus = 1,
            tunacan = 1,
            blueprint = 1,
            goldnugget = 1,
            gears = 1,
            purplegem = 1,
            redgem = 1,
            bluegem = 1,
            rope = 1,
            cookingrecipecard = 1,
            scrapbook_page = 1,
        },

        chance_loot =
        {
            purplegem = .1,
            redgem = .25,
            bluegem = .25,
        }
    },

    ["TombRaider"] =
    {
        loot =
        {
            dubloon = 4,
            boneshard = 3,
            nightmarefuel = 4,
            purplegem = 2,
            goldnugget = 3,
        },

        random_loot =
        {
            papyrus = 1,
            tunacan = 1,
            blueprint = 1,
            goldnugget = 1,
            gears = 1,
            purplegem = 1,
            redgem = 1,
            bluegem = 1,
            rope = 1,
            cookingrecipecard = 1,
            scrapbook_page = 1,
        }
    },

    ["SteamPunk"] =
    {
        loot =
        {
            dubloon = 1,
            gears = 4,
            transistor = 2,
            telescope = 1,
            goldnugget = 2,
        },

        random_loot =
        {
            papyrus = 1,
            tunacan = 1,
            blueprint = 1,
            goldnugget = 1,
            gears = 1,
            purplegem = 1,
            redgem = 1,
            bluegem = 1,
            rope = 1,
        }
    },

    ["CapNCrunch"] =
    {
        loot =
        {
            dubloon = 4,
            piratehat = 1,
            boatcannon = 1,
        },

        random_loot =
        {
            papyrus = 1,
            tunacan = 1,
            blueprint = 1,
            goldnugget = 1,
            gears = 1,
            purplegem = 1,
            redgem = 1,
            bluegem = 1,
            rope = 1,
            cookingrecipecard = 1,
            scrapbook_page = 1,
        },

        chance_loot =
        {
            purplegem = .1,
            redgem = .25,
            bluegem = .25,
        }
    },

    ["AyeAyeCapn"] =
    {
        loot =
        {
            dubloon = 1,
            captainhat = 1,
            armor_lifejacket = 1,
            tunacan = 1,
            trawlnet = 1,
        },

        random_loot =
        {
            papyrus = 1,
            tunacan = 1,
            blueprint = 1,
            goldnugget = 1,
            gears = 1,
            purplegem = 1,
            redgem = 1,
            bluegem = 1,
            rope = 1,
            cookingrecipecard = 1,
            scrapbook_page = 1,
        }
    },

    ["BreakWind"] =
    {
        loot =
        {
            dubloon = 4,
            armor_windbreaker = 1,
            obsidianmachete = 1,
        },

        random_loot =
        {
            papyrus = 1,
            tunacan = 1,
            blueprint = 1,
            goldnugget = 1,
            gears = 1,
            purplegem = 1,
            redgem = 1,
            bluegem = 1,
            rope = 1,
            cookingrecipecard = 1,
            scrapbook_page = 1,
        },

        chance_loot =
        {
            purplegem = .1,
            redgem = .25,
            bluegem = .25,
        }
    },

    ["Diviner"] =
    {
        loot =
        {
            dubloon = 5,
            nightmarefuel = 4,
            gears = 1,
        },

        random_loot =
        {
            papyrus = 1,
            tunacan = 1,
            blueprint = 1,
            goldnugget = 1,
            gears = 1,
            purplegem = 1,
            redgem = 1,
            bluegem = 1,
            rope = 1,
            cookingrecipecard = 1,
            scrapbook_page = 1,
        },

        chance_loot =
        {
            purplegem = .1,
            redgem = .25,
            bluegem = .25,
        }
    },

    ["GoesComesAround"] =
    {
        loot =
        {
            dubloon = 3,
            boomerang = 1,
            trap_teeth = 2,
        },

        random_loot =
        {
            papyrus = 1,
            tunacan = 1,
            blueprint = 1,
            goldnugget = 1,
            gears = 1,
            purplegem = 1,
            redgem = 1,
            bluegem = 1,
            rope = 1,
            cookingrecipecard = 1,
            scrapbook_page = 1,
        },

        chance_loot =
        {
            purplegem = .1,
            redgem = .25,
            bluegem = .25,
        }
    },

    ["GoldGoldGold"] =
    {
        loot =
        {
            dubloon = 6,
            goldnugget = 5,
        },

        random_loot =
        {
            papyrus = 1,
            tunacan = 1,
            blueprint = 1,
            goldnugget = 1,
            gears = 1,
            purplegem = 1,
            redgem = 1,
            bluegem = 1,
            rope = 1,
            cookingrecipecard = 1,
            scrapbook_page = 1,
        },

        chance_loot =
        {
            purplegem = .1,
            redgem = .25,
            bluegem = .25,
        }
    },

    ["FirePoker"] =
    {
        loot =
        {
            dubloon = 2,
            spear_obsidian = 1,
            armorobsidian = 1,
        },

        random_loot =
        {
            papyrus = 1,
            tunacan = 1,
            blueprint = 1,
            goldnugget = 1,
            gears = 1,
            purplegem = 1,
            redgem = 1,
            bluegem = 1,
            rope = 1,
            cookingrecipecard = 1,
            scrapbook_page = 1,
        },

        chance_loot =
        {
            purplegem = .1,
            redgem = .25,
            bluegem = .25,
        }
    },

    ["DeadmansTreasure"] =
    {
        loot =
        {
            dubloon = 4,
            boatrepairkit = 1,
            goldenmachete = 1,
            obsidiancoconade = 3,
        },

        random_loot =
        {
            fabric = 1,
            papyrus = 1,
            tunacan = 1,
            goldnugget = 1,
            gears = 1,
            purplegem = 1,
            redgem = 1,
            bluegem = 1,
            rope = 1,
            cookingrecipecard = 1,
            scrapbook_page = 1,
        },

        chance_loot =
        {
            harpoon = .1,
            boatcannon = .01,
            rope = .25,
        }
    },
-------------------------------GOOD LIST

    ["staydry"] =
    {
        loot =
        {
            palmleaf_umbrella = 1,
            armor_snakeskin = 1,
            snakeskinhat = 1,
        },
    },

    ["gears"] =
    {
        loot =
        {
            gears = 5,

        },
    },

    ["cooloff"] =
    {
        loot =
        {
            ice = 3,
            hawaiianshirt = 1,
            umbrella = 1,
        },
    },

    ["birders"] =
    {
        loot =
        {
            birdtrap = 1,
            featherhat = 1,
            seeds = 4,
        },
    },

    ["slot_anotherspin"] =
    {
        loot =
        {
            dubloon = 1,
        },
    },

    ["slot_goldy"] =
    {
        loot =
        {
            goldnugget = 5,
        },
    },

    ["slot_honeypot"] =
    {
        loot =
        {
            beehat = 1,
            bandage = 1,
            honey = 5,
        },
    },

    ["slot_warrior1"] =
    {
        loot =
        {
            footballhat = 1,
            armorwood = 1,
            spear = 1,
        },
    },

    ["slot_warrior2"] =
    {
        loot =
        {
            armormarble = 1,
            hambat = 1,
            blowdart_pipe = 1,
        },
    },

    ["slot_warrior3"] =
    {
        loot =
        {
            trap_teeth = 1,
            armorgrass = 1,
            boomerang = 1,
        },
    },

    ["slot_warrior4"] =
    {
        loot =
        {
            spear_launcher = 1,
            spear_poison = 1,
            armorseashell = 1,
            coconade= 1,
        },
    },

    ["slot_scientist"] =
    {
        loot =
        {
            transistor = 3,
            heatrock = 1,
            gunpowder= 3,
        },
    },

    ["slot_walker"] =
    {
        loot =
        {
            cane = 1,
            goldnugget= 3,
        },
    },

    ["slot_gemmy"] =
    {
        loot =
        {
            redgem = 3,
            bluegem= 3,
        },
    },

    ["slot_bestgem"] =
    {
        loot =
        {
            purplegem = 3,
        },
    },

    ["slot_lifegiver"] =
    {
        loot =
        {
            amulet = 1,
            goldnugget = 3,
        },
    },

    ["slot_chilledamulet"] =
    {
        loot =
        {
            blueamulet = 1,
            goldnugget = 3,
        },
    },

    ["slot_icestaff"] =
    {
        loot =
        {
            icestaff = 1,
            goldnugget = 3,
        },
    },

    ["slot_firestaff"] =
    {
        loot =
        {
            firestaff = 1,
            goldnugget = 3,
        },
    },

    ["slot_coolasice"] =
    {
        loot =
        {
            icehat = 1,
            tropicalfan = 1, -- not in vanilla
            palmleaf_umbrella = 1,
        },
    },

    ["slot_gunpowder"] =
    {
        loot =
        {
            gunpowder = 5,
        },
    },

    ["slot_darty"] = 
    {
    loot = 
    {
        blowdart_pipe = 1,
        blowdart_sleep = 1,
        blowdart_fire = 1,
    },
    },

    ["slot_firedart"] =
    {
        loot =
        {
            blowdart_fire = 3,
            goldnugget = 3,
        },
    },

    ["slot_sleepdart"] =
    {
        loot =
        {
            blowdart_sleep = 3,
            goldnugget = 3,
        },
    },

    ["slot_blowdart"] =
    {
        loot =
        {
            blowdart_pipe = 3,
            goldnugget = 3,
        },
    },

    ["slot_speargun"] =
    {
        loot =
        {
            spear_launcher = 1,
            spear = 1,
            goldnugget = 3,
        },
    },


    ["slot_dapper"] =
    {
        loot =
        {
            cane = 1,
            goldnugget = 3,
            tophat = 1,
        },
    },

    ["slot_speed"] =
    {
        loot =
        {
            yellowamulet = 1,
            nightmarefuel = 3,
            goldnugget = 3,
        },
    },

    ["slot_coconades"] =
    {
        loot =
        {
            coconade= 3,
            goldnugget = 3,
        },
    },

    ["slot_obsidian"] =
    {
        loot =
        {
            obsidian= 5,
        },
    },

    ["slot_thuleciteclub"] =
    {
        loot =
        {
            ruins_bat= 1,
            goldnugget = 3,
        },
    },

    ["slot_thulecitesuit"] =
    {
        loot =
        {
            armorruins= 1,
            goldnugget = 3,
        },
    },

    ["slot_ultimatewarrior"] =
    {
        loot =
        {
            armorruins= 1,
            ruins_bat= 1,
            ruinshat= 1,
        },
    },

    ["slot_goldenaxe"] =
    {
        loot =
        {
            goldenaxe = 1,
            goldnugget = 3,
        },
    },

    ["slot_monkeyball"] =
    {
        loot =
        {
            monkeyball = 1,
            cave_banana = 2,
        },
    },


---------------------------------------OK LIST

    ["firestarter"] =
    {
        loot =
        {
            log = 2,
            -- twigs = 1,
            cutgrass = 3,
        },
    },

    ["geologist"] =
    {
        loot =
        {
            rocks = 1,
            goldnugget = 1,
            obsidian = 1,
        },
    },

    ["3cutgrass"] =
    {
        loot =
        {
            cutgrass = 5,
        },
    },

    ["3logs"] =
    {
        loot =
        {
            log = 3,
        },
    },

    ["3twigs"] =
    {
        loot =
        {
            twigs = 3,
        },
    },

    ["slot_torched"] =
    {
        loot =
        {
            torch = 1,
            charcoal = 2,
            ash = 2,
        },
    },

    ["slot_jelly"] =
    {
        loot =
        {
            jellyfish_dead = 3,
        },
    },

    ["slot_handyman"] =
    {
        loot =
        {
            axe = 1,
            hammer = 1,
            shovel = 1,
        },
    },

    ["slot_poop"] =
    {
        loot =
        {
            poop = 5,
        },
    },

    ["slot_berry"] =
    {
        loot =
        {
            berries = 5,
        },
    },

    ["slot_limpets"] =
    {
        loot =
        {
            limpets = 5,
        },
    },

    ["slot_seafoodsurprise"] =
    {
        loot =
        {
            limpets = 2,
            jellyfish_dead = 1,
            pondfish_tropical = 2,
            fishmeat = 1,
        },
    },

    ["slot_bushy"] =
    {
        loot =
        {
            berries = 3,
            dug_berrybush2 = 1, --cut down from 3
        },
    },


    ["slot_bamboozled"] =
    {
        loot =
        {
            dug_bambootree = 1,
            bamboo = 3,
        },
    },

    ["slot_grassy"] =
    {
        loot =
        {
            trap = 1,
            cutgrass = 3,
            strawhat = 1,
        },
    },

    ["slot_prettyflowers"] =
    {
        loot =
        {
            petals = 5,
            flowerhat = 1,
        },
    },

    ["slot_witchcraft"] =
    {
        loot =
        {
            flower_evil = 5,
            red_cap= 1,
            green_cap = 1,
            blue_cap = 1,
        },
    },

    ["slot_bugexpert"] =
    {
        loot =
        {
            bugnet = 1,
            fireflies = 3,
            butterfly = 3,
        },
    },

    ["slot_flinty"] =
    {
        loot =
        {
            flint = 5,
        },
    },

    ["slot_fibre"] =
    {
        loot =
        {
            cave_banana = 1,
            dragonfruit = 1,
            watermelon = 1,
            fig = 1, -- not in vanilla
        },
    },

    ["slot_drumstick"] =
    {
        loot =
        {
            drumstick = 3,
        },
    },

    ["slot_fisherman"] =
    {
        loot =
        {
            fishingrod = 1,
            fishmeat = 3,
            pondfish_tropical = 3,
        },
    },

    ["slot_bonesharded"] =
    {
        loot =
        {
            hammer = 1,
            skeleton = 3,
        },
    },

    ["slot_jerky"] =
    {
        loot =
        {
            meat_dried = 3,
        },
    },

    ["slot_coconutty"] =
    {
        loot =
        {
            coconut = 5,
        },
    },

    ["slot_camper"] =
    {
        loot =
        {
            heatrock = 1,
            bedroll_straw = 1,
            meat_dried = 1,
        },
    },

    ["slot_ropey"] =
    {
        loot =
        {
            rope = 5,
        },
    },

      ["slot_tailor"] =
    {
        loot =
        {
            sewing_kit = 1,
            fabric= 3,
            tophat = 1,
        },
    },

    ["slot_spiderboon"] =
    {
        loot =
        {
            spidergland = 2,
            silk = 5,
            monstermeat = 3,
        },
    },

--------------------------------------BAD LIST

    ["slot_spiderattack"] =
    {
        loot =
        {
            spider = 3,
        },
    },

      ["slot_mosquitoattack"] =
    {
        loot =
        {
            mosquito_poison= 5,
        },
    },

      ["slot_snakeattack"] =
    {
        loot =
        {
            snake = 3,
        },
    },

          ["slot_monkeysurprise"] =
    {
        loot =
        {
            primeape = 2,
        },
    },

        ["slot_poisonsnakes"] =
    {
        loot =
        {
            snake_poison = 2,
        },
    },

        ["slot_hounds"] =
    {
        loot =
        {
            hound = 2,
        },
    },

---------------------------------------IA Loots
    --GOOD List
    ["slot_jackpot"] =
    {
        loot =
        {
            dubloon = 40,
            goldnugget = 20,
            confetti_fx = 10,
        },
    },

    ["slot_jellybeans"] =
    {
        loot =
        {
            jellybean = 5,
        },
    },

    ["slot_chess"] =
    {
        loot =
        {
            trinket_31 = 1,
            trinket_29 = 1,
            trinket_16 = 1,
            nightmarefuel = 5,
        },
    },

    ["slot_gems"] =
    {
        loot =
        {
            redgem = 2,
            bluegem = 2,
            purplegem = 2,
            orangegem = 2,
            greengem = 2,
            yellowgem = 2,
        },
    },

    ["slot_pollyroger"] =
    {
        loot =
        {
            polly_rogershat = 1,
            cave_banana = 3,
            dubloon = 5,
        },
    },

    ["slot_celestial"] =
    {
        loot =
        {
            glasscutter = 1,
            moonglassaxe = 1,
            moonrocknugget = 5,
            moonglass = 5,
            moonbutterfly = 3,
        },
    },

    ["slot_megaflare"] =
    {
        loot =
        {
            megaflare = 1,
            goldnugget = 3,
        },
    },
    
    ["slot_nightmare"] =
    {
        loot =
        {
            purpleamulet = 1,
            nightmarefuel = 3,
        },
    },

    ["slot_constructor"] =
    {
        loot =
        {
            greenamulet = 1,
            nightmarefuel = 3,
            goldnugget = 3,
        },
    },

    ["slot_lazy"] =
    {
        loot =
        {
            orangeamulet = 1,
            nightmarefuel = 3,
            goldnugget = 3,
        },
    },

    --[["slot_oceantrees"] =
    {
        loot =
        {
            oceantreenut = 3,
            treegrowthsolution = 12,
            goldnugget = 5,
        },
    },]]

    ["slot_docks"] =
    {
        loot =
        {
            dock_kit = 5,
            dock_kit_blueprint = 1,
            palmcone_seed = 3,
            cave_banana = 3,
        },
    },

    ["slot_trident"] =
    {
        loot =
        {
            trident = 1,
            gnarwail_horn = 2,
            seaweed = 5,
        },
    },

    ["slot_brain"] =
    {
        loot =
        {
            brainjellyhat = 1,
            goldnugget = 3,
        },
    },

    ["slot_turf"] =
    {
        loot =
        {
            thulecite = 1,
            turfcraftingstation_blueprint = 1,
            antlionhat = 1,
            goldnugget = 3,
        },
    },

    --OK List
    ["slot_vines"] =
    {
        loot =
        {
            dug_bush_vine = 1,
            vine = 3,
        },
    },

    ["slot_marble"] =
    {
        loot =
        {
            marble = 3,
            marblebean = 2,
        },
    },

    ["slot_moonrocks"] =
    {
        loot =
        {
            moonrocknugget = 3,
            moonglass = 3,
            moonbutterfly = 3
        },
    },

    ["slot_salt"] =
    {
        loot =
        {
            saltrock = 5,
        },
    },

    ["slot_nubbin"] =
    {
        loot =
        {
            nubbin = 1,
            coral = 3,
        },
    },

    ["slot_honey"] =
    {
        loot =
        {
            honeycomb = 1,
            honey = 3,
        },
    },

    ["slot_health"] =
    {
        loot =
        {
            antivenom = 1,
            lifeinjector = 1,
            healingsalve = 1,
        },
    },

    ["slot_nitre"] =
    {
        loot =
        {
            nitre = 5,
        }
    },

    ["slot_seashells"] =
    {
        loot =
        {
            seashell = 5,
        }
    },

    ["slot_palmconeseeds"] =
    {
        loot =
        {
            palmcone_seed = 5,
        }
    },

    ["slot_bananabush"] =
    {
        loot =
        {
            dug_bananabush = 1,
            cave_banana = 3,
        }
    },

    ["slot_monkeytails"] =
    {
        loot =
        {
            dug_monkeytail = 1,
            cutreeds = 3,
        }
    },

    ["slot_rainbowjelly"] =
    {
        loot =
        {
            rainbowjellyfish_dead = 3,
        }
    },

    ["slot_farming"] =
    {
        loot =
        {
            wateringcan = 1,
            seeds = 5,
            poop = 4,
        },
    },

    --BAD List

    ["slot_crocodogs"] =
    {
        loot =
        {
            crocodog = 2,
        },
    },

    ["slot_beeguards"] =
    {
        loot =
        {
            beeguard = 3,
        },
    },

    ["slot_peepers"] =
    {
        loot =
        {
            eyeofterror_mini = 2,
        },
    },

    ["slot_nursespiders"] =
    {
        loot =
        {
            spider_healer = 2,
        },
    },

    ["slot_poisoncrocodogs"] =
    {
        loot =
        {
            poisoncrocodog = 2,
        },
    },
}

local newtreasures =
{
    ["moonrockseed"] =
    {
        loot =
        {
            moonrockseed = 1,
            houndcorpse = 2,
            rock_avocado_fruit_sprout = 5,
            moonrocknugget = 25,
            moonglass = 10,
        },
    },

    ["doydoy"] =
    {
        loot =
        {
            doydoyegg = 1,
            twigs = 8,
            doydoyfeather = 2,
            poop = 4,
        },
    },

    ["pollyroger"] =
    {
        loot =
        {
            polly_rogershat = 1,
            cutlass = 1,
            dubloon = 6,
            earring = 1,
            meat_dried = 4,
            bananajuice = 1,
        },
    },

    ["palmconefarmer"] =
    {
        loot =
        {
            palmcone_seed = 6,
            palmcone_scale = 3,
            dubloon = 5,
            cave_banana = 3,
            meat_dried = 1,
        },
    },

    ["palmconefarmer2"] =
    {
        loot =
        {
            palmcone_seed = 10,
            palmcone_scale = 6,
            dubloon = 5,
            cave_banana = 4,
            meat_dried = 4,
        },
    },

    ["bananafarmer"] =
    {
        loot =
        {
            dug_bananabush = 6,
            poop = 6,
            cave_banana = 3,
            meat_dried = 1,
            dubloon = 5,
        },
    },

    ["bananafarmer2"] =
    {
        loot =
        {
            dug_bananabush = 10,
            fertilizer = 1,
            cave_banana = 4,
            meat_dried = 4,
            dubloon = 5,
        },
    },

    ["reedfarmer"] =
    {
        loot =
        {
            dug_monkeytail = 6,
            poop = 6,
            cave_banana = 3,
            meat_dried = 1,
            dubloon = 5,
        },
    },

    ["reedfarmer2"] =
    {
        loot =
        {
            dug_monkeytail = 10,
            fertilizer = 1,
            cave_banana = 4,
            meat_dried = 4,
            dubloon = 5,
        },
    },

    ["dockbuilder"] =
    {
        loot =
        {
            dock_kit = 6,
            dock_kit_blueprint = 1,
            dock_woodposts_item = 4,
            dock_woodposts_item_blueprint = 1,
            cave_banana = 4,
            meat_dried = 4,
            dubloon = 5,
            palmcone_seed = 4,
        },
    },
}

local TreasureList = {}
local TreasureLootList = {}

function AddTreasure(name, data)
    TreasureList[name] = data
end

function AddTreasureLoot(name, data)
    TreasureLootList[name] = data
end

for name, data in pairs(internaltreasure) do
    AddTreasure(name, data)
end

for name, data in pairs(internalloot) do
    AddTreasureLoot(name, data)
end

if not IA_CONFIG.slotmachineloot then
    SLOTMACHINE_LOOT.goodspawns["slot_jackpot"] = nil
    SLOTMACHINE_LOOT.goodspawns["slot_jellybeans"] = nil
    SLOTMACHINE_LOOT.goodspawns["slot_chess"] = nil
    SLOTMACHINE_LOOT.goodspawns["slot_gems"] = nil
    SLOTMACHINE_LOOT.goodspawns["slot_pollyroger"] = nil
    SLOTMACHINE_LOOT.goodspawns["slot_celestial"] = nil
    SLOTMACHINE_LOOT.goodspawns["slot_megaflare"] = nil
    SLOTMACHINE_LOOT.goodspawns["slot_nightmare"] = nil
    SLOTMACHINE_LOOT.goodspawns["slot_constructor"] = nil
    SLOTMACHINE_LOOT.goodspawns["slot_lazy"] = nil
    --SLOTMACHINE_LOOT.goodspawns["slot_oceantrees"] = nil
    SLOTMACHINE_LOOT.goodspawns["slot_docks"] = nil
    SLOTMACHINE_LOOT.goodspawns["slot_trident"] = nil
    SLOTMACHINE_LOOT.goodspawns["slot_brain"] = nil
    SLOTMACHINE_LOOT.goodspawns["slot_turf"] = nil

    SLOTMACHINE_LOOT.okspawns["slot_vines"] = nil
    SLOTMACHINE_LOOT.okspawns["slot_marble"] = nil
    SLOTMACHINE_LOOT.okspawns["slot_moonrocks"] = nil
    SLOTMACHINE_LOOT.okspawns["slot_salt"] = nil
    SLOTMACHINE_LOOT.okspawns["slot_nubbin"] = nil
    SLOTMACHINE_LOOT.okspawns["slot_honey"] = nil
    SLOTMACHINE_LOOT.okspawns["slot_health"] = nil
    SLOTMACHINE_LOOT.okspawns["slot_nitre"] = nil
    SLOTMACHINE_LOOT.okspawns["slot_seashells"] = nil
    SLOTMACHINE_LOOT.okspawns["slot_palmconeseeds"] = nil
    SLOTMACHINE_LOOT.okspawns["slot_bananabush"] = nil
    SLOTMACHINE_LOOT.okspawns["slot_monkeytails"] = nil
    SLOTMACHINE_LOOT.okspawns["slot_rainbowjelly"] = nil
    SLOTMACHINE_LOOT.okspawns["slot_farming"] = nil

    SLOTMACHINE_LOOT.badspawns["slot_crocodogs"] = nil
    SLOTMACHINE_LOOT.badspawns["slot_beeguards"] = nil
    SLOTMACHINE_LOOT.badspawns["slot_peepers"] = nil
    SLOTMACHINE_LOOT.badspawns["slot_nursespiders"] = nil
    SLOTMACHINE_LOOT.badspawns["slot_poisoncrocodogs"] = nil

    internalloot["slot_fibre"].loot = {
        cave_banana = 1,
        dragonfruit = 1,
        watermelon = 1,
    }
    internalloot["slot_coolasice"].loot = {
        icehat = 1,
        palmleaf_umbrella = 1,
    }
end

if IA_CONFIG.newloot == "part" then
    newtreasures["moonrockseed"] = nil
elseif IA_CONFIG.newloot == "vanilla" then
    newtreasures = {}
end

for _, v in pairs(internaltreasure) do
    for name, data in pairs(internalloot) do
        if v[1].loot == name then
            newtreasures[name] = data
        end
    end
end

local function GetTierLootTable(tier)
    -- TODO: yank it out!
    print("GetTierLootTable", tier, #Tiers[tier])
    return table.remove(Tiers[tier], math.random(1, #Tiers[tier]))
end

function GetTreasureDefinitionTable()
    return TreasureList
end

function GetTreasureDefinition(name)
    return TreasureList[name]
end

function GetTreasureLootDefinitionTable()
    return TreasureLootList
end

function GetTreasureLootDefinition(name)
    return TreasureLootList[name]
end

function GetNewTreasures()
    return newtreasures
end

function GetNewTreasuresDefinition(name)
    return newtreasures[name]
end

function ApplyModsToTreasure()
    for name, data in pairs(TreasureList) do
        local modfns = ModManager:GetPostInitFns("TreasurePreInit", name)
        for i,modfn in ipairs(modfns) do
            print("Applying mod to treasure ", name)
            modfn(data)
        end
    end
end

function ApplyModsToTreasureLoot()
    for name, data in pairs(TreasureLootList) do
        local modfns = ModManager:GetPostInitFns("TreasureLootPreInit", name)
        for i,modfn in ipairs(modfns) do
            print("Applying mod to treasure loot ", name)
            modfn(data)
        end
    end
end

local function GetTreasureLoot(loots)
    local lootlist = {}
    if loots then
        if loots.loot then
            for prefab, n in pairs(loots.loot) do
                if lootlist[prefab] == nil then
                    lootlist[prefab] = 0
                end
                lootlist[prefab] = lootlist[prefab] + n
            end
        end
        if loots.random_loot then
            for i = 1, (loots.num_random_loot or 1) do
                local prefab = weighted_random_choice(loots.random_loot)
                if prefab then
                    if lootlist[prefab] == nil then
                        lootlist[prefab] = 0
                    end
                    lootlist[prefab] = lootlist[prefab] + 1
                end
            end
        end
        if loots.chance_loot then
            for prefab, chance in pairs(loots.chance_loot) do
                if math.random() < chance then
                    if lootlist[prefab] == nil then
                        lootlist[prefab] = 0
                    end
                    lootlist[prefab] = lootlist[prefab] + 1
                end
            end
        end
        if loots.custom_lootfn then
            loots.custom_lootfn(lootlist)
        end
    end
    return lootlist
end

function GetTreasureLootList(name)
    return GetTreasureLoot(GetTreasureLootDefinition(name))
end

function SpawnTreasureLoot(name, lootdropper, pt, nexttreasure)
    if name and lootdropper ~= nil then
        if not pt then
            pt = Point(lootdropper.inst.Transform:GetWorldPosition())
        end

        if nexttreasure and nexttreasure ~= nil then
            --Spawn a bottle to the next treasure
            local bottle = inst.components.lootdropper:SpawnLootPrefab("ia_messagebottle")
            bottle.treasure = nexttreasure
            --bottle:OnDrop() Handled by lootdropper/inventoryitem  now
        end

		local player = ThePlayer --TODO, for when we implement treasure hunting
		local loots = GetTreasureLootDefinition(name)
		local lootprefabs = GetTreasureLoot(loots)
		for p, n in pairs(lootprefabs) do
			for i = 1, n, 1 do
				local loot = lootdropper:SpawnLootPrefab(p, pt)
				assert(loot, "can't spawn "..tostring(p))
				if not loot.components.inventoryitem then
					-- attacker?
					if loot.components.combat then
						loot.components.combat:SuggestTarget(player)
					end
				end
			end
		end
	end
end

function SpawnTreasureChest(name, lootdropper, pt, nexttreasure)
    local loots = GetNewTreasuresDefinition(name) or GetTreasureLootDefinition(name)
    if loots then
        local chest = SpawnPrefab(loots.chest or "treasurechest")
        if chest then
            if not pt then
                pt = Point(lootdropper.inst.Transform:GetWorldPosition())
            end

            chest.Transform:SetPosition(pt.x, pt.y, pt.z)
            SpawnPrefab("collapse_small").Transform:SetPosition(pt.x, pt.y, pt.z)

            if chest.components.container then
                if nexttreasure and nexttreasure ~= nil then
                    --Spawn a bottle to the next treasure
                    local bottle = SpawnPrefab("ia_messagebottle")
                    bottle.treasure = nexttreasure
                    chest.components.container:GiveItem(bottle, nil, nil, true, false)
                end

				local player = ThePlayer
				local lootprefabs = GetTreasureLoot(loots)
				for p, n in pairs(lootprefabs) do
					for i = 1, n, 1 do
						local loot = SpawnPrefab(p)
						if loot then
							if loot.components.inventoryitem and not loot.components.container then
								chest.components.container:GiveItem(loot, nil, nil, true, false)
							else
								local pos = Vector3(pt.x, pt.y, pt.z)
								local start_angle = math.random()*PI*2
								local rad = 1
								if chest.Physics then
									rad = rad + chest.Physics:GetRadius()
								end
								local offset = FindWalkableOffset(pos, start_angle, rad, 8, false)
								if offset == nil then
									return
								end

                                pos = pos + offset

                                loot.Transform:SetPosition(pos.x, pos.y, pos.z)
                                -- attacker?
                                if loot.components.combat then
                                    loot.components.combat:SuggestTarget(player)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

function WorldGenPlaceTreasures(tasks, entitiesOut, width, height, min_id, level)
    print("WorldGenPlaceTreasures called!", tasks, entitiesOut, width, height, min_id)

    local obj_layout = require("map/object_layout")

    local function AllStagesPlaced(treasure, stageCount)
        local ret = true
        for i = 1, stageCount do
            if treasure.stages[i] == nil then
                print("Not all stages placed, missing ", i)
                ret = false
            end
        end
        return ret
    end

    local function GetRandomNode(task, layout, restrict_to)
        local is_entrance = function(room)
            -- return true if the room is an entrance
            --print("is_entrance", tostring(room.data.entrance))
            return room.data.entrance ~= nil and room.data.entrance == true
        end
        local is_background_ok = function(room, restrict_to)
            -- return true if the piece is not backround restricted, or if it is but we are on a background
            --print("is_background_ok", tostring(restrict_to), tostring(room.data.type))
            return restrict_to ~= "background" or room.data.type == "background"
        end
        local is_water_ok = function(room, layout)
            local water_room = room.data.type == "water" or IsOceanTile(room.data.value)
            local water_layout = layout and layout.water == true
            --print("is_water_ok", tostring(water_room), tostring(water_layout))
            return (water_room and water_layout) or (not water_room and not water_layout)
        end
        local isnt_blank = function(room)
            --print("isnt_blank", tostring(room.data.type))
            return room.data.type ~= "blank"
        end

        local choicekeys = shuffledKeys(task.nodes)
        for i, choicekey in ipairs(choicekeys) do
            local node = task.nodes[choicekey]
            if node.data.value ~= WORLD_TILES.IMPASSABLE and not is_entrance(node) and is_background_ok(node, restrict_to) and isnt_blank(node) and is_water_ok(node, layout) then
                return node
            end
        end
    end

    local function GetRandomTaskNode(tasks, layout, restrict_to)
        local taskkeys = shuffledKeys(tasks)
        local node = nil
        local j = 1
        while j < #taskkeys and node == nil do
            node = GetRandomNode(tasks[taskkeys[j]], layout, restrict_to)
            j = j + 1
        end

        return node
    end

    local function GetRandomTaskNodeFromList(tasks, layout, choicetasks)
        if choicetasks then
            local choices = shuffleArray(choicetasks)
            for i, task in ipairs(choices) do
                if tasks[task] then
                    local node = GetRandomNode(tasks[task], layout)
                    if node then
                        return node
                    end
                end
            end
        end
        return GetRandomTaskNode(tasks, layout)
    end

    local function GetSetpiecePosition(nodeid, layout, prefabs)
        print("GetPointsForSite", nodeid)
        local layoutsize = math.max(SpawnUtil.GetLayoutRadius(layout, prefabs), 1)
        local points_x, points_y, points_type = WorldSim:GetPointsForSite(nodeid)
        if layout.water and layout.water == true then
            for i = 1, #points_x do
                if SpawnUtil.IsSurroundedByWaterTile(points_x[i], points_y[i], layoutsize) then
                    return points_x[i], points_y[i]
                end
            end
        else
            for i = 1, #points_x do
                if not SpawnUtil.IsCloseToWaterTile(points_x[i], points_y[i], layoutsize) then
                    return points_x[i], points_y[i]
                end
            end
        end
        return nil, nil
    end

    local function GetPrefabPosition(nodeid, radius)
        print("GetPointsForSite", nodeid)
        local points_x, points_y, points_type = WorldSim:GetPointsForSite(nodeid)
        for i = 1, #points_x do
            if not SpawnUtil.IsCloseToWaterTile(points_x[i], points_y[i], radius) then
                return points_x[i], points_y[i]
            end
        end
    end

    local function VerifyTreasure(level)
        for name, _ in pairs(self.treasures) do
            local def = GetTreasureDefinition(name)
            assert(def ~= nil, "Treasure: '"..name.."' does not exist!, Check treasures in shipwrecked.lua")
        end
        for i = 1, #self.optional_treasures do
            local def = GetTreasureDefinition(self.optional_treasures[i])
            assert(def ~= nil, "Treasure: '"..self.optional_treasures[i].."' does not exist!, Check optional_treasures in shipwrecked.lua")
        end
        for i = 1, #self.random_treasures do
            local def = GetTreasureDefinition(self.random_treasures[i])
            assert(def ~= nil, "Treasure: '"..self.random_treasures[i].."' does not exist!, Check random_treasures in shipwrecked.lua")
        end
        for i = 1, #self.required_treasures do
            local def = GetTreasureDefinition(self.required_treasures[i])
            assert(def ~= nil, "Treasure: '"..self.required_treasures[i].."' does not exist!, Check required_treasures in shipwrecked.lua")
        end
    end

    local treasureid = 2400
    local function AddTreasureToList(treasure_list, name, treasuretasks, maptasks, nodeid)
        --print("Add treasure", name, treasureid, nodeid)
        treasure_list[treasureid] = {}
        treasure_list[treasureid].name = name
        treasure_list[treasureid].treasuretasks = treasuretasks
        treasure_list[treasureid].maptasks = maptasks
        treasure_list[treasureid].stages = {}

        local treasuredef = GetTreasureDefinition(name)
        for i, stagedef in ipairs(treasuredef) do
            treasure_list[treasureid].stages[i] = {}
        end

        if nodeid then
            treasure_list[treasureid].stages[1].nodeid = nodeid
        end

        treasureid = treasureid + 1
    end

    local function BuildTreasureListFromTasks(treasure_list, tasks)
        for taskid, task in pairs(tasks) do
            local nodes = task:GetNodes(true)
            for nodeid, node in pairs(nodes) do
                if node.data.terrain_contents then
                    if node.data.terrain_contents.treasure_data ~= nil then
                        for id, treasure_data in pairs(node.data.terrain_contents.treasure_data) do
                            if treasure_list[id] == nil then
                                --print("Add treasure", treasure_data.name, id)
                                treasure_list[id] = {}
                                treasure_list[id].name = treasure_data.name
                                treasure_list[id].stages = {}
                            end
                            assert(treasure_list[id].name == treasure_data.name)
                            treasure_list[id].stages[treasure_data.stage] = {nodeid = node.id}
                        end
                    end
                    if node.data.terrain_contents.treasures ~= nil then
                        for i, treasure_data in ipairs(node.data.terrain_contents.treasures) do
                            AddTreasureToList(treasure_list, treasure_data.name, nil, nil, node.id)
                        end
                    end
                end
            end
        end
    end

    local function BuildTreasureListFromLevel(treasure_list, tasks, level)
        if level.treasures then
            for name, data in pairs(level.treasures) do
                for i = 1, data.count or 1 do
                    AddTreasureToList(treasure_list, name, data.treasuretasks, data.maptasks)
                end
            end
        end

        if level.optional_treasures and level.numoptional_treasures and level.numoptional_treasures > 0 then
            local choicekeys = shuffledKeys(level.optional_treasures)
            for i = 1, level.numoptional_treasures do
                AddTreasureToList(treasure_list, level.optional_treasures[choicekeys[i]])
            end
        end

        if level.random_treasures and level.numrandom_treasures and level.numrandom_treasures > 0 then
            for i = 1, level.numrandom_treasures do
                AddTreasureToList(treasure_list, level.random_treasures[math.random(1, #level.random_treasures)])
            end
        end
    end

    print("Building treasure defs...")
    local treasure_list = {}
    local treasure_prefabs = {}
    local map_prefabs = {}
    local prefab_list = {}
    local add_fn = {
        fn=function(prefab, points_x, points_y, idx, entitiesOut, width, height, prefab_list, prefab_data, rand_offset)
            SpawnUtil.AddEntity(prefab, points_x[idx], points_y[idx], entitiesOut, width, height, prefab_list, prefab_data, rand_offset)
        end,
        args={entitiesOut=entitiesOut, width=width, height=height, rand_offset = true, debug_prefab_list=prefab_list}
    }

    BuildTreasureListFromTasks(treasure_list, tasks)
    BuildTreasureListFromLevel(treasure_list, tasks, level)

    ApplyModsToTreasure()

    local function PlaceTreasure(treasureid, treasure)
        --print("Placing ", treasureid, treasure.name)
        local treasuredef = GetTreasureDefinition(treasure.name)
        if treasuredef and AllStagesPlaced(treasure, #treasuredef) then
            local first_stage = math.huge
            for stageid, stage in pairs(treasure.stages) do
                local stagedef = treasuredef[stageid]

                if stageid < first_stage then
                    first_stage = stageid
                end

                -- random tier stuff
                if stagedef.tier then
                    stagedef = GetTierLootTable(stagedef.tier)
                end

                if stagedef.treasure_set_piece then
                    --print("Treasure set piece ", stagedef.treasure_set_piece)
                    local layout = obj_layout.LayoutForDefinition(stagedef.treasure_set_piece)
                    local prefabs = obj_layout.ConvertLayoutToEntitylist(layout)

                    for i,p in ipairs(prefabs) do
                        if p.prefab == stagedef.treasure_prefab then
                            --print("Treasure prefab", p.prefab, stagedef.treasure_prefab)
                            if p.properties == nil then
                                p.properties = {}
                            end
                            p.properties.id=min_id
                            p.properties.data={treasureid=treasureid, stage=stageid, loot=stagedef.loot}
                            min_id = min_id + 1

                            stage.prefab = p
                            break
                        end
                    end

                    if stage.nodeid == nil then
                        stage.nodeid = GetRandomTaskNodeFromList(tasks, layout, treasure.treasuretasks).id
                    end

                    --local lx, ly = GetSetpiecePosition(stage.nodeid, layout, prefabs)
                    --obj_layout.ReserveAndPlaceLayout("POSITIONED", layout, prefabs, add_fn, {lx, ly})
                    obj_layout.ReserveAndPlaceLayout(stage.nodeid, layout, prefabs, add_fn)
                else
                    local treasure_prefab = stagedef.treasure_prefab or "buriedtreasure"
                    --print("Treasure prefab ", treasure_prefab)
                    local properties = {}
                    properties.id = min_id
                    properties.data={treasureid=treasureid, stage=stageid, loot=stagedef.loot}
                    min_id = min_id + 1

                    stage.prefab = {}
                    stage.prefab.properties = properties

                    if stage.nodeid == nil then
                        stage.nodeid = GetRandomTaskNodeFromList(tasks, nil, treasure.treasuretasks).id
                    end

                    local px, py = GetPrefabPosition(stage.nodeid, 1)
                    add_fn.fn(treasure_prefab, {px}, {py}, 1, add_fn.args.entitiesOut, add_fn.args.width, add_fn.args.height, add_fn.args.debug_prefab_list, properties, false)
                end
            end

            --add a map
            local first_stagedef = treasuredef[first_stage]
            if first_stagedef.map_set_piece then
                --print("Map set piece ", first_stagedef.map_set_piece)
                local layout = obj_layout.LayoutForDefinition(first_stagedef.map_set_piece)
                local prefabs = obj_layout.ConvertLayoutToEntitylist(layout)

                for i,p in ipairs(prefabs) do
                    if p.prefab == first_stagedef.map_prefab then
                        --print("Map prefab ", p.prefab, treasure.stages[first_stage].prefab.properties.id)
                        if p.properties == nil then
                            p.properties = {}
                        end

                        p.properties.data={treasure = treasure.stages[first_stage].prefab.properties.id, name=treasure.name}
                        break
                    end
                end

                if layout and layout.water then
                    local checkFn = function(ground) return IsOceanTile(ground) end
                    PlaceWaterLayout(layout, prefabs, add_fn, checkFn)
                else
                    local node = GetRandomTaskNodeFromList(tasks, layout, treasure.maptasks)
                    if node and node.id then
                        --local lx, ly = GetSetpiecePosition(node.id, layout, prefabs)
                        --obj_layout.ReserveAndPlaceLayout("POSITIONED", layout, prefabs, add_fn, {lx, ly})
                        obj_layout.ReserveAndPlaceLayout(node.id, layout, prefabs, add_fn)
                    else
                        print("Error couldn't find a node for ", first_stagedef.map_set_piece)
                    end
                end
            else
                local map_prefab = first_stagedef.map_prefab or "ia_messagebottle"
                --print("Map prefab ", map_prefab, treasure.stages[first_stage].prefab.properties.id)
                map_prefabs[treasureid] = {}
                map_prefabs[treasureid].prefab = map_prefab
                map_prefabs[treasureid].properties = {data={treasure = treasure.stages[first_stage].prefab.properties.id, name=treasure.name}}
            end

            --print("Linking treasure ", treasureid)
            for stageid, stage in pairs(treasure.stages) do
                local p = stage.prefab
                assert(p, "Can't link treasures treasureid: "..tostring(treasureid)..", stageid: "..tostring(stageid))
                assert(p.properties.data.treasureid == treasureid, "Treasure ids don't match! "..tostring(p.properties.data.treasureid)..", "..tostring(treasureid))
                --print(string.format("treasureid %d, stage %d, loot %s", p.properties.data.treasureid, p.properties.data.stage, p.properties.data.loot))

                if treasure.stages[stageid - 1] then
                    local prevp = treasure.stages[stageid - 1].prefab
                    --print(string.format("Connect prev %d -> %d", prevp.properties.id, p.properties.id))
                    p.properties.data.treasureprev = prevp.properties.id
                end
                if treasure.stages[stageid + 1] then
                    local nextp = treasure.stages[stageid + 1].prefab
                    --print(string.format("Connect next %d -> %d", p.properties.id, nextp.properties.id))
                    p.properties.data.treasurenext = nextp.properties.id
                end
            end
        else
            print("Treasure can't be placed ", treasureid, treasure.name)
        end
    end

    print("Placing treasures...")
    for treasureid, treasure in pairs(treasure_list) do
        PlaceTreasure(treasureid, treasure)
    end

    print("Placing maps...")
    local edge_dist = 24
    local map_count = GetTableSize(map_prefabs)
    local points_x, points_y = SpawnUtil.FindRandomWaterPoints(function(ground) return IsOceanTile(ground) end, width, height, edge_dist, 2 * map_count + 10)
    local cur_pos = 1
    for treasureid, map in pairs(map_prefabs) do
        add_fn.fn(map.prefab, points_x, points_y, cur_pos, add_fn.args.entitiesOut, add_fn.args.width, add_fn.args.height, add_fn.args.debug_prefab_list, map.properties, false)
        cur_pos = cur_pos + 1
    end

    return true
end