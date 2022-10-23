--  SELF
--      !UnitName
--      oSkull
--      oCross
--      oSquare
--      oMoon
--      oTriangle
--      oDiamond
--      oCircle
--      oStart
--      oNone

local function RaidTargetIconHandler(dd, index)
    local unit = dd.config._unit
    TGUnitPopup.HideUnitPopup()

    print(unit)
    print(index)
    if index == 10 then
        SetRaidTarget(unit, 0)
    else
        SetRaidTarget(unit, index - 1)
    end
end

local function ConfigDropDown(unit)
    local config = {
        _unit = unit,
        rheight = 16,
        items = {
             {name = "!"..RAID_TARGET_ICON},
             {name = "oStar"},
             {name = "oCircle"},
             {name = "oDiamond"},
             {name = "oTriangle"},
             {name = "oMoon"},
             {name = "oSquare"},
             {name = "oCross"},
             {name = "oSkull"},
             {name = "oNone"},
        },
        handler = RaidTargetIconHandler,
    }

    local dd = TGUnitPopup.DropDown:New(config)
    local currTarget = GetRaidTargetIndex(unit)
    if currTarget ~= nil and currTarget > 0 then
        dd:SetRadio(currTarget + 1, true)
    end

    return dd
end

TGUnitPopup.configGenerators["RAID_TARGET_ICON"] = ConfigDropDown
