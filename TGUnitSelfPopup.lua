--  SELF
--      !UnitName
--      Raid Target Icon>
--               oSkull
--               oCross
--               oSquare
--               oMoon
--               oTriangle
--               oDiamond
--               oCircle
--               oStart
--               oNone
--      Set Focus
--      Player vs. Player>    
--               oEnable
--               oDisable
--      -
--      !Loot Options
--      Pass on Loot: No>
--               oYes
--               oNo
--      -
--      !Instance Options
--      Dungeon Difficulty>
--               oNormal
--               oHeroic
--      Raid Difficulty>
--               o10 Player
--               o25 Player
--      Reset all instances
--      -
--      !Other Options
--      Voice Chat>
--               Mic  <==========|=========> 50%
--               Spkr <==========|=========> 50%
--      Cancel

local function EnablePVP(dd, index)
    SetPVP(1)
    TGUnitPopup.HideUnitPopup()
end

local function DisablePVP(dd, index)
    SetPVP(false)
    TGUnitPopup.HideUnitPopup()
end

local function PassOnLoot(dd, index)
    SetOptOutOfLoot(true)
    TGUnitPopup.HideUnitPopup()
end

local function DontPassOnLoot(dd, index)
    SetOptOutOfLoot(false)
    TGUnitPopup.HideUnitPopup()
end

local function SetDungeonNormal(dd, index)
    SetDungeonDifficultyID(1)
    TGUnitPopup.HideUnitPopup()
end

local function SetDungeonHeroic(dd, index)
    SetDungeonDifficultyID(2)
    TGUnitPopup.HideUnitPopup()
end

local function SetRaid10Player(dd, index)
    SetRaidDifficultyID(3)
    TGUnitPopup.HideUnitPopup()
end

local function SetRaid25Player(dd, index)
    SetRaidDifficultyID(4)
    TGUnitPopup.HideUnitPopup()
end

local function ResetInstances(dd, index)
    StaticPopup_Show("CONFIRM_RESET_INSTANCES")
    TGUnitPopup.HideUnitPopup()
end

local function HideHandler(dd, index)
    TGUnitPopup.HideUnitPopup()
end

local function PVPDropDown(unit)
    local config = {
        _unit = unit,
        rheight = 16,
        items = {
            {name = "!Player vs. Player"},
            {name = "oEnabled", handler = EnablePVP},
            {name = "oDisabled", handler = DisablePVP},
        },
    }

    local dd = TGUnitPopup.DropDown:New(config)
    local pvp = GetPVPDesired()
    dd:SetRadio(2, pvp)
    dd:SetRadio(3, not pvp)

    return dd
end

local function GetPassOnLootName(unit)
    if GetOptOutOfLoot() then
        return " Pass on Loot: Yes"
    end
    return " Pass on Loot: No"
end

local function PassOnLootDropDown(unit)
    local config = {
        _unit = unit,
        rheight = 16,
        items = {
            {name = "!Pass on Loot"},
            {name = "oYes", handler = PassOnLoot},
            {name = "oNo", handler = DontPassOnLoot},
        },
    }

    local dd = TGUnitPopup.DropDown:New(config)
    local pass = GetOptOutOfLoot()
    dd:SetRadio(2, pass)
    dd:SetRadio(3, not pass)

    return dd
end

local function GetDungeonDifficultyName(unit)
    local did = GetDungeonDifficultyID()
    if did == 1 then
        return " Dungeon Difficulty: Normal"
    elseif did == 2 then
        return " Dungeon Difficulty: Heroic"
    end
    return " Dungeon Difficulty"
end

local function DungeonDifficultyDropDown(unit)
    local config = {
        _unit = unit,
        rheight = 16,
        items = {
            {name = "!Dungeon Difficulty"},
            {name = "oNormal", handler = SetDungeonNormal},
            {name = "oHeroic", handler = SetDungeonHeroic},
        },
    }

    local dd = TGUnitPopup.DropDown:New(config)
    local did = GetDungeonDifficultyID()
    dd:SetRadio(2, did == 1)
    dd:SetRadio(3, did == 2)

    return dd
end

local function GetRaidDifficultyName(unit)
    local did = GetRaidDifficultyID()
    if did == 3 then
        return " Raid Difficulty: 10 Player"
    elseif did == 4 then
        return " Raid Difficulty: 25 Player"
    end
    return " Raid Difficulty"
end

local function RaidDifficultyDropDown(unit)
    local config = {
        _unit = unit,
        rheight = 16,
        items = {
            {name = "!Raid Difficulty"},
            {name = "o10 Player", handler = SetRaid10Player},
            {name = "o25 Player", handler = SetRaid25Player},
        },
    }

    local dd = TGUnitPopup.DropDown:New(config)
    local did = GetRaidDifficultyID()
    dd:SetRadio(2, did == 3)
    dd:SetRadio(3, did == 4)

    return dd
end

local function ConfigDropDown(unit)
    local config = {
        _unit = unit,
        rheight = 16,
        items = {
            {name = "!"..UnitName("player")},
            {
                name = " Raid Target Icon",
                child = TGUnitPopup.configGenerators["RAID_TARGET_ICON"](unit),
            },
            {
                name = " Player vs. Player",
                child = PVPDropDown(unit),
            },
            {name = "-"},
            {name = "!Loot Options"},
            {
                name = GetPassOnLootName(unit),
                child = PassOnLootDropDown(unit),
            },
            {name = "-"},
            {name = "!Instance Options"},
            {
                name = GetDungeonDifficultyName(unit),
                child = DungeonDifficultyDropDown(unit),
            },
            {
                name = GetRaidDifficultyName(unit),
                child = RaidDifficultyDropDown(unit),
            },
            {name = " Reset all instances", handler = ResetInstances},
            {name = "-"},
            {name = "!Other Options"},
            {name = " Cancel"},
        },
        handler = HideHandler,
    }

    return TGUnitPopup.DropDown:New(config)
end

TGUnitPopup.configGenerators["SELF"] = ConfigDropDown
