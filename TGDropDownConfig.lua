TGUnitPopup.DropDownConfig = {}
TGUnitPopup.DropDownConfig.__index = TGUnitPopup.DropDownConfig
local TGDropDownConfig = TGUnitPopup.DropDownConfig

function TGDropDownConfig:New(unit, rheight, handler)
    local ddc = {
        unit    = unit,
        rheight = rheight,
        handler = handler,
        items   = {},
    }
    setmetatable(ddc, self)

    return ddc
end

function TGDropDownConfig:AddLine(name, handler, childConfig)
    table.insert(self.items,
                 {name=name, handler=handler, childConfig=childConfig})
end

function TGDropDownConfig:SetRadio(index, selected)
    self.items[index].radio = selected
end

function TGDropDownConfig:AddSeparator()
    table.insert(self.items, {name="-"})
end

function TGDropDownConfig:SetColor(color)
    self.items[#self.items].color = color
end
