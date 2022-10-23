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

local function ResetInstances(dd, index)
    StaticPopup_Show("CONFIRM_RESET_INSTANCES")
    TGUnitPopup.HideUnitPopup()
end

local function HideHandler(dd, index)
    TGUnitPopup.HideUnitPopup()
end

local function ConfigDropDown(unit)
    local config = {
        _unit = unit,
        rheight = 16,
        items = {
            {name = "!"..UnitName("player")},
            {name = " Raid Target Icon>",
             child = {
                 cookie = unit,
                 rheight = 16,
                 items = {
                     {name = "oSkull"},
                     {name = "oCross"},
                     {name = "oSquare"},
                     {name = "oMoon"},
                     {name = "oTriangle"},
                     {name = "oDiamond"},
                     {name = "oCircle"},
                     {name = "oStar"},
                     {name = "oNone"},
                 },
                 handler = RaidTargetIconHandler}
             },
            {name = " Player vs. Player>"},
            {name = "-"},
            {name = "!Loot Options"},
            {name = " Pass on Loot: No>"},
            {name = "-"},
            {name = "!Instance Options"},
            {name = " Dungeon Difficulty>"},
            {name = " Raid Difficulty>"},
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
