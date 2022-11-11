-- Party member
--  Role
--      Tank
--      Healer
--      DPS
--      None
--  Raid Target Icon
--  Set Focus
--  Add Friend
--  Add Friend
--      Add Battle Tag Friend
--      Add Character Friend
--  ---Interact---
--  RAF Summon
--  RAF Grant Level
--  Promote To Leader
--  Promote Guide
--  Loot Promote
--  Whisper
--  Inspect
--  Achievement
--  Trade
--  Follow
--  Duel
--  Pet Battle Duel
--  ---Other---
--  Report Group Member
--  Copy Character Name
--  PVP Report AFK
--  Vote To Kick
--  Uninvite
--  Cancel

local function TGUPromoteToLeader(dd, index)
    PromoteToLeader(dd.config.unit, 1)
    TGUnitPopup.HideUnitPopup()
end

TGUnitPopup.configGenerators["PARTY"] = function(unit)
    local c = TGUnitPopup.DropDownConfig:New(unit, 16,
                                             TGUnitPopup.HideUnitPopup)

    c:AddLine("!"..UnitName(unit))
    if UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") then
        c:AddLine(" "..SET_ROLE, nil, TGUnitPopup.SetRoleDropDown(unit))
    end
    c:AddLine(" Raid Target Icon", nil,
              TGUnitPopup.configGenerators["RAID_TARGET_ICON"](unit))
    -- TODO: Battle tag friends
    if TGUnitPopup.CanAddFriend(unit) then
        c:AddLine(" "..ADD_FRIEND, TGUnitPopup.AddFriend)
    end
    c:AddLine("!"..UNIT_FRAME_DROPDOWN_SUBSECTION_TITLE_INTERACT)
    if TGUnitPopup.IsPartyLeader() then
        -- TODO: Should be disabled if unit is disconnected.
        -- TODO: If HasLFGRestrictions() should read PROMOTE_GUIDE but
        --       functionality is unchanged.
        c:AddLine(" "..PARTY_PROMOTE, TGUPromoteToLeader)

        if GetLootMethod() == "master" then
            if TGUnitPopup.IsMasterLooter(unit) then
                c:AddLine("-"..LOOT_PROMOTE)
            else
                c:AddLine(" "..LOOT_PROMOTE, TGUnitPopup.PromoteToLootMaster)
            end
        end
    end
    c:AddLine(" "..WHISPER, TGUnitPopup.SendTell)
    c:AddLine(" "..INSPECT, TGUnitPopup.InspectUnit)
    c:AddLine(" "..COMPARE_ACHIEVEMENTS, TGUnitPopup.InspectAchievements)
    if UnitCanCooperate("player", unit) then
        -- TODO: Disable if we are dead/ghost or target is dead/ghost.
        c:AddLine(" "..TRADE, TGUnitPopup.InitiateTrade)
        -- TODO: Disable if target is dead and not ghost.
        c:AddLine(" "..FOLLOW, TGUnitPopup.FollowUnit)
    end
    c:AddLine(" "..DUEL, TGUnitPopup.StartDuel)

    c:AddLine("!"..UNIT_FRAME_DROPDOWN_SUBSECTION_TITLE_OTHER)
    -- TODO: Report group member.
    -- TODO: Report pvp member AFK.
    -- TODO: Vote to kick.
    if TGUnitPopup.IsPartyLeader() then
        local _, instanceType = IsInInstance()
        if instanceType ~= "pvp" and instanceType ~= "arena" then
            c:AddLine(" "..PARTY_UNINVITE, TGUnitPopup.UninviteUnit)
        end
    end
    c:AddLine(" "..CANCEL)

    return TGUnitPopup.DropDown:New(c)
end
