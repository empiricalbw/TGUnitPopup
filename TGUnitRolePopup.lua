local ROLE_TABLE = {
    ["TANK"]    = 1,
    ["HEALER"]  = 2,
    ["DAMAGER"] = 3,
}

local function SetRoleTank(dd, index)
    UnitSetRole(dd.config.unit, "TANK")
    TGUnitPopup.HideUnitPopup()
end

local function SetRoleHealer(dd, index)
    UnitSetRole(dd.config.unit, "HEALER")
    TGUnitPopup.HideUnitPopup()
end

local function SetRoleDPS(dd, index)
    UnitSetRole(dd.config.unit, "DAMAGER")
    TGUnitPopup.HideUnitPopup()
end

TGUnitPopup.SetRoleDropDown = function(unit)
    local c = TGUnitPopup.DropDownConfig:New(unit, 16)
    c:AddLine(" "..INLINE_TANK_ICON.." "..TANK, SetRoleTank)
    c:AddLine(" "..INLINE_HEALER_ICON.." "..HEALER, SetRoleHealer)
    c:AddLine(" "..INLINE_DAMAGER_ICON.." "..DAMAGER, SetRoleDPS)

    local dd = TGUnitPopup.DropDown:New(c)
    local index = ROLE_TABLE[UnitGroupRolesAssigned(unit)]
    if index ~= nil then
        dd:CheckOneItem(index)
    end

    return dd
end
