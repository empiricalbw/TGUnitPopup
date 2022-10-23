-- Complete replacement for Blizzard's shitty UIDROPDOWNMENU nightmare of taint.
TGUnitPopup = {
    visiblePopup     = nil,
    configGenerators = {},
}

function TGUnitPopup.HideUnitPopup(unit)
    if TGUnitPopup.visiblePopup ~= nil then
        if unit == nil or TGUnitPopup.visiblePopup.config._unit == unit then
            TGUnitPopup.visiblePopup:Hide()
        end
    end
end

function TGUnitPopup.VisiblePopupHidden(dd)
    assert(TGUnitPopup.visiblePopup == dd)
    TGUnitPopup.visiblePopup:Free()
    TGUnitPopup.visiblePopup = nil
end

function TGUnitPopup.ShowUnitPopup(unit)
    TGUnitPopup.HideUnitPopup()

    local key
    if UnitIsUnit(unit,"player") then
        key = "SELF"
    elseif UnitIsUnit(unit,"pet") then
        key = "PET"
    elseif UnitIsPlayer(unit) then
        id = UnitInRaid(unit)
        if id then
            key = "RAID_PLAYER"
        elseif UnitInParty(unit) then
            key = "PARTY"
        else
            key = "PLAYER"
        end
    else
        key = "RAID_TARGET_ICON"
    end

    if key == nil then
        return
    end

    local cg = TGUnitPopup.configGenerators[key]
    if cg == nil then
        return
    end

    dd = cg(unit)
    dd:Show({point = "TOPLEFT", relativeTo = "cursor", dx = 20, dy = 0})
    dd.config.hideHandler = TGUnitPopup.VisiblePopupHidden
    TGUnitPopup.visiblePopup = dd
    print(dd)
end
