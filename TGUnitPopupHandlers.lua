function TGUnitPopup.IsPartyLeader()
    return IsInGroup() and UnitIsGroupLeader("player")
end

function TGUnitPopup.IsMasterLooter(unit)
    if not IsInGroup() then
        return false
    end

    local lootMethod, partyIndex, raidIndex = GetLootMethod()
    if lootMethod ~= "master" then
        return false
    end
    if partyIndex == 0 then
        return UnitIsUnit(unit, "player")
    elseif partyIndex ~= nil then
        return UnitIsUnit(unit, "party"..partyIndex)
    elseif raidIndex ~= nil then
        return UnitIsUnit(unit, "raid"..raidIndex)
    end

    return false
end


function TGUnitPopup.CanAddFriend(unit)
    return UnitCanCooperate("player", unit) and
           UnitIsPlayer(unit) and
           UnitIsSameServer(unit) and
           not C_FriendList.GetFriendInfo(UnitNameUnmodified(unit))
end

function TGUnitPopup.AddFriend(dd, index)
    local name = UnitNameUnmodified(dd.config.unit)
    C_FriendList.AddFriend(name)
    TGUnitPopup.HideUnitPopup()
end

function TGUnitPopup.SendTell(dd, index)
    ChatFrame_SendTell(UnitNameUnmodified(dd.config.unit))
    TGUnitPopup.HideUnitPopup()
end

function TGUnitPopup.InspectUnit(dd, index)
    InspectUnit(dd.config.unit)
    TGUnitPopup.HideUnitPopup()
end

function TGUnitPopup.InspectAchievements(dd, index)
    InspectAchievements(dd.config.unit)
    TGUnitPopup.HideUnitPopup()
end

function TGUnitPopup.InitiateTrade(dd, index)
    InitiateTrade(dd.config.unit)
    TGUnitPopup.HideUnitPopup()
end

function TGUnitPopup.FollowUnit(dd, index)
    FollowUnit(dd.config.unit)
    TGUnitPopup.HideUnitPopup()
end

function TGUnitPopup.StartDuel(dd, index)
    StartDuel(dd.config.unit, true)
    TGUnitPopup.HideUnitPopup()
end

function TGUnitPopup.InviteUnit(dd, index)
    InviteUnit(GetUnitName(dd.config.unit, true), nil, 1)
    TGUnitPopup.HideUnitPopup()
end

function TGUnitPopup.UninviteUnit(dd, index)
    UninviteUnit(GetUnitName(dd.config.unit, true), nil, 1)
    TGUnitPopup.HideUnitPopup()
end
