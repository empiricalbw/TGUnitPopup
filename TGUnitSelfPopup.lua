local function EnablePVP(dd, index)
    SetPVP(1)
    TGUnitPopup.HideUnitPopup()
end

local function DisablePVP(dd, index)
    SetPVP(false)
    TGUnitPopup.HideUnitPopup()
end

local function SetLootFreeForAll(dd, index)
    SetLootMethod("freeforall")
    TGUnitPopup.HideUnitPopup()
end

local function SetLootRoundRobin(dd, index)
    SetLootMethod("roundrobin")
    TGUnitPopup.HideUnitPopup()
end

local function SetLootMasterLooter(dd, index)
    SetLootMethod("master")
    TGUnitPopup.HideUnitPopup()
end

local function SetLootGroupLoot(dd, index)
    SetLootMethod("group")
    TGUnitPopup.HideUnitPopup()
end

local function SetLootNeedBeforeGreed(dd, index)
    SetLootMethod("needbeforegreed")
    TGUnitPopup.HideUnitPopup()
end

local function SetLootThresholdGreen(dd, index)
    SetLootThreshold(2)
    TGUnitPopup.HideUnitPopup()
end

local function SetLootThresholdRare(dd, index)
    SetLootThreshold(3)
    TGUnitPopup.HideUnitPopup()
end

local function SetLootThresholdEpic(dd, index)
    SetLootThreshold(4)
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

function TGUnitPopup.PromoteToLootMaster(dd, index)
    SetLootMethod("master", dd.config.unit, 2)
    TGUnitPopup.HideUnitPopup()
end

local function TGUConvertToRaid(dd, index)
    ConvertToRaid()
    TGUnitPopup.HideUnitPopup()
end

local function TGUConvertToParty(dd, index)
    ConvertToParty()
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

local function TGULeaveParty(dd, index)
    LeaveParty()
    TGUnitPopup.HideUnitPopup()
end

local function HideHandler(dd, index)
    TGUnitPopup.HideUnitPopup()
end

local function PVPDropDown(unit)
    local pvp = GetPVPDesired()
    local c = TGUnitPopup.DropDownConfig:New(unit, 16)
    c:AddLine("!Player vs. Player")
    c:AddLine("oEnabled", EnablePVP)
    c:AddLine("oDisabled", DisablePVP)

    c.items[2].radio = pvp
    c.items[3].radio = not pvp

    return c
end

local LOOT_TABLE = {
    ["freeforall"]      = 1,
    ["roundrobin"]      = 2,
    ["master"]          = 3,
    ["group"]           = 4,
    ["needbeforegreed"] = 5,
}

local function LootMethodDropDown(unit)
    local e
    if not UnitIsGroupLeader("player") then
        e = "-"
    else
        e = " "
    end

    local c = TGUnitPopup.DropDownConfig:New(unit, 16)
    c:AddLine(e..LOOT_FREE_FOR_ALL, SetLootFreeForAll)
    c:AddLine(e..LOOT_ROUND_ROBIN, SetLootRoundRobin)
    c:AddLine(e..LOOT_MASTER_LOOTER, SetLootMasterLooter)
    c:AddLine(e..LOOT_GROUP_LOOT, SetLootGroupLoot)
    c:AddLine(e..LOOT_NEED_BEFORE_GREED, SetLootNeedBeforeGreed)

    local index = LOOT_TABLE[GetLootMethod()]
    if index then
        c.items[index].checked = true
    end

    return c
end

local function LootThresholdDropDown(unit)
    if not UnitIsGroupLeader("player") then
        return nil
    end

    local c = TGUnitPopup.DropDownConfig:New(unit, 16)
    c:AddLine(" "..ITEM_QUALITY2_DESC, SetLootThresholdGreen)
    c:AddLine(" "..ITEM_QUALITY3_DESC, SetLootThresholdRare)
    c:AddLine(" "..ITEM_QUALITY4_DESC, SetLootThresholdEpic)

    c.items[1].color = ITEM_QUALITY_COLORS[2]
    c.items[2].color = ITEM_QUALITY_COLORS[3]
    c.items[3].color = ITEM_QUALITY_COLORS[4]
    c.items[GetLootThreshold() - 1].checked = true

    return c
end

local function GetPassOnLootName(unit)
    if GetOptOutOfLoot() then
        return " Pass on Loot: Yes"
    end
    return " Pass on Loot: No"
end

local function PassOnLootDropDown(unit)
    local c = TGUnitPopup.DropDownConfig:New(unit, 16)
    c:AddLine("!Pass on Loot")
    c:AddLine("oYes", PassOnLoot)
    c:AddLine("oNo", DontPassOnLoot)

    local pass = GetOptOutOfLoot()
    c.items[2].radio = pass
    c.items[3].radio = not pass

    return c
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
    local c = TGUnitPopup.DropDownConfig:New(unit, 16)
    c:AddLine("!Dungeon Difficulty")
    c:AddLine("oNormal", SetDungeonNormal)
    c:AddLine("oHeroic", SetDungeonHeroic)

    local did = GetDungeonDifficultyID()
    c.items[2].radio = (did == 1)
    c.items[3].radio = (did == 2)

    return c
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
    local c = TGUnitPopup.DropDownConfig:New(unit, 16)
    c:AddLine("!Raid Difficulty")
    c:AddLine("o10 Player", SetRaid10Player)
    c:AddLine("o25 Player", SetRaid25Player)

    local did = GetRaidDifficultyID()
    c.items[2].radio = (did == 3)
    c.items[3].radio = (did == 4)

    return c
end

TGUnitPopup.configGenerators["SELF"] = function(unit)
    local c = TGUnitPopup.DropDownConfig:New(unit, 16, HideHandler)

    c:AddLine("!"..UnitName("player"))
    if IsInGroup() then
        c:AddLine(" "..SET_ROLE, nil, TGUnitPopup.SetRoleDropDown(unit))
    end
    c:AddLine(" Raid Target Icon", nil,
              TGUnitPopup.configGenerators["RAID_TARGET_ICON"](unit))
    c:AddLine(" Player vs. Player", nil, PVPDropDown(unit))

    c:AddSeparator()
    c:AddLine("!Loot Options")
    if IsInGroup() then
        c:AddLine(" "..LOOT_METHOD, nil, LootMethodDropDown(unit))
        c:AddLine(" ".._G["ITEM_QUALITY"..GetLootThreshold().."_DESC"], nil,
                  LootThresholdDropDown(unit))
        c:SetColor(ITEM_QUALITY_COLORS[GetLootThreshold()])
    end
    c:AddLine(GetPassOnLootName(unit), nil, PassOnLootDropDown(unit))
    if TGUnitPopup.IsPartyLeader() and GetLootMethod() == "master" then
        if TGUnitPopup.IsMasterLooter(unit) then
            c:AddLine("-"..LOOT_PROMOTE)
        else
            c:AddLine(" "..LOOT_PROMOTE, TGUnitPopup.PromoteToLootMaster)
        end
    end

    c:AddSeparator()
    c:AddLine("!Instance Options")
    if TGUnitPopup.IsPartyLeader() and not IsInRaid() and
        not IsInGroup(LE_PARTY_CATEGORY_INSTANCE)
    then
        c:AddLine(" "..CONVERT_TO_RAID, TGUConvertToRaid)
    end
    if IsInRaid() and UnitIsGroupLeader("player") and
        not IsInGroup(LE_PARTY_CATEGORY_INSTANCE)
    then
        c:AddLine(" "..CONVERT_TO_PARTY, TGUConvertToParty)
    end
    c:AddLine(GetDungeonDifficultyName(unit), nil,
              DungeonDifficultyDropDown(unit))
    c:AddLine(GetRaidDifficultyName(unit), nil, RaidDifficultyDropDown(unit))
    c:AddLine(" Reset all instances", ResetInstances)

    c:AddSeparator()
    c:AddLine("!"..UNIT_FRAME_DROPDOWN_SUBSECTION_TITLE_OTHER)
    local _, instanceType = IsInInstance()
    if IsInGroup() and not IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and
        instanceType ~= "pvp" and instanceType ~= "arena"
    then
        c:AddLine(" "..PARTY_LEAVE, TGULeaveParty)
    end
    c:AddLine(" "..CANCEL)

    return c
end
