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
    local unit = dd.config.unit
    TGUnitPopup.HideUnitPopup()

    if index == 10 then
        SetRaidTarget(unit, 0)
    else
        SetRaidTarget(unit, index - 1)
    end
end

TGUnitPopup.configGenerators["RAID_TARGET_ICON"] = function(unit)
    local config = {
        unit = unit,
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

    local currTarget = GetRaidTargetIndex(unit)
    if currTarget ~= nil and currTarget > 0 then
        config.items[currTarget + 1].radio = true
    end

    return config
end
