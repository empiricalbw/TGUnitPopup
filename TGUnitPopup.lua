-- Complete replacement for Blizzard's shitty UIDROPDOWNMENU nightmare of taint.
TGUnitPopup = {
    visiblePopup     = nil,
    configGenerators = {},
    log              = TGLog:new(1, 2),
}
TGUP_LOG = {}

function TGUnitPopup.Dump()
    TGUnitPopup.log:dump()
    TGUP_LOG = TGUnitPopup.log.lines
end

function TGUnitPopup.HideUnitPopup(unit)
    if TGUnitPopup.visiblePopup ~= nil then
        if unit == nil or TGUnitPopup.visiblePopup.config.unit == unit then
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
    if UnitIsUnit(unit, "player") then
        key = "SELF"
    elseif UnitIsUnit(unit, "vehicle") then
        key = "VEHICLE"
    elseif UnitIsUnit(unit, "pet") then
        key = "PET"
    elseif UnitIsOtherPlayersPet(unit) then
        key = "OTHERPET"
    elseif UnitIsPlayer(unit) then
        local id = UnitInRaid(unit)
        if id then
            key = "RAID_PLAYER"
        elseif UnitInParty(unit) then
            key = "PARTY"
        elseif UnitCanCooperate("player", unit) then
            key = "PLAYER"
        else
            key = "ENEMY_PLAYER"
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

    local dd = cg(unit)
    dd:Show({point = "TOPLEFT", relativeTo = "cursor", dx = 20, dy = 0})
    dd.config.hideHandler = TGUnitPopup.VisiblePopupHidden
    TGUnitPopup.visiblePopup = dd
end
