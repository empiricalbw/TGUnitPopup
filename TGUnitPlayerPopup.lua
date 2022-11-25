-- Player in the world
--  Raid Target Icon
--  Set Focus
--  Add Friend
--  Add Friend
--      Add Battle Tag Friend
--      Add Character Friend
--  ---Interact---
--  RAF Summon
--  RAF Grant Level
--  Invite
--  Suggest Invite
--  Request Invite
--  Whisper
--  Inspect
--  Achievement
--  Trade
--  Follow
--  Duel
--  Pet Battle Duel
--  ---Other---
--  Report in World
--  Copy Character Name
--  Cancel

TGUnitPopup.configGenerators["PLAYER"] = function(unit)
    local c = TGUnitPopup.DropDownConfig:New(unit, 16,
                                             TGUnitPopup.HideUnitPopup)

    c:AddLine("!"..UnitName(unit))
    c:AddLine(" Raid Target Icon", nil,
              TGUnitPopup.configGenerators["RAID_TARGET_ICON"](unit))
    -- TODO: Battle tag friends
    if TGUnitPopup.CanAddFriend(unit) then
        c:AddLine(" "..ADD_FRIEND, TGUnitPopup.AddFriend)
    end

    c:AddLine("!"..UNIT_FRAME_DROPDOWN_SUBSECTION_TITLE_INTERACT)
    if not IsInGroup() or UnitIsGroupLeader("player") then
        c:AddLine(" "..PARTY_INVITE, TGUnitPopup.InviteUnit)
    end
    c:AddLine(" "..WHISPER, TGUnitPopup.SendTell)
    c:AddLine(" "..INSPECT, TGUnitPopup.InspectUnit)
    c:AddLine(" "..COMPARE_ACHIEVEMENTS, TGUnitPopup.InspectAchievements)
    -- TODO: Disable if we are dead/ghost or target is dead/ghost.
    c:AddLine(" "..TRADE, TGUnitPopup.InitiateTrade)
    -- TODO: Disable if target is dead and not ghost.
    c:AddLine(" "..FOLLOW, TGUnitPopup.FollowUnit)
    c:AddLine(" "..DUEL, TGUnitPopup.StartDuel)

    c:AddLine("!"..UNIT_FRAME_DROPDOWN_SUBSECTION_TITLE_OTHER)
    -- TODO: Report group member.
    c:AddLine(" "..CANCEL)

    return c
end
