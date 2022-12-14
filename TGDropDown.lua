TGUnitPopup.DropDown = {}
TGUnitPopup.DropDown.__index = TGUnitPopup.DropDown
local TGDropDown = TGUnitPopup.DropDown

TGUNITPOPUP_DROPDOWN_BACKDROP_INFO = {
    bgFile   = "Interface/DialogFrame/UI-DialogBox-Background-Dark",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    tile     = true,
    tileEdge = true,
    tileSize = 16,
    edgeSize = 16,
    insets   = {left = 4, right = 4, top = 4, bottom = 4},

    backdropBorderColor = TOOLTIP_DEFAULT_COLOR,
}

local ADD_INDEX = 1
local ADD_BUTTON_POOL = {}
local TEMPLATE_BUTTON = CreateFrame("Button", nil, UIParent,
                                    "TGDropDownItemTemplate")

local DD_POOL = {}

function TGDropDown:_New()
    local dd = {}
    setmetatable(dd, self)
    return dd
end

function TGDropDown:New(config)
    local dd

    if #DD_POOL > 0 then
        dd = table.remove(DD_POOL)
        dd:ReInit(config)
    else
        dd = self:_New()
        dd:Init(config)
    end

    return dd
end

function TGDropDown:Free()
    self:Hide()
    self.config = nil
    table.insert(DD_POOL, self)
end

function TGDropDown:AllocButton()
    local f
    if #ADD_BUTTON_POOL > 0 then
        f = table.remove(ADD_BUTTON_POOL)
        f:SetParent(self.frame)
        f:Show()
        return f
    end

    f = CreateFrame("Button", nil, self.frame,
                    "TGDropDownItemTemplate")
    local b = f.XButton
    b.Texture:SetAlpha(0.5)
    b:SetScript("OnEnter", function() b.Texture:SetAlpha(1) end)
    b:SetScript("OnLeave", function() b.Texture:SetAlpha(0.5) end)
    return f
end

function TGDropDown:FreeButton(b)
    b:ClearAllPoints()
    b:Hide()
    b:SetParent(UIParent)
    table.insert(ADD_BUTTON_POOL, b)
end

function TGDropDown:Init(config)
    local name = "TGDropDownFrame"..ADD_INDEX
    ADD_INDEX  = ADD_INDEX + 1

    self.frame = CreateFrame("Frame", name, UIParent, "TGDropDownListTemplate")
    self.frame:SetScript("OnHide", function() self:OnHide() end)
    self.items = {}

    if config ~= nil then
        self:ReInit(config)
    end

    table.insert(UIMenus, name)
end

function TGDropDown:ReInit(config)
    while #self.items > 0 do
        self:FreeButton(table.remove(self.items))
    end

    self.frame:Hide()
    self.frame:SetWidth(12)
    self.frame:SetHeight(20)

    self.config = config

    if config.anchor then
        assert(config.anchor.relativeTo ~= nil)
        self.frame:ClearAllPoints()
        self.frame:SetPoint(config.anchor.point,
                            config.anchor.relativeTo,
                            config.anchor.relativePoint,
                            config.anchor.dx,
                            config.anchor.dy)
    end

    local fwidth = config.width or 32
    if fwidth <= 32 then
        for _, s in ipairs(config.items) do
            TEMPLATE_BUTTON.LabelEnabled:SetText(s.name:sub(2))
            fwidth = max(fwidth,
                TEMPLATE_BUTTON.LabelEnabled:GetUnboundedStringWidth() + 32)
        end
    end

    local x      = 12
    local height = self.frame:GetHeight()
    for i, item in ipairs(config.items) do
        local f = self:AllocButton(config.rheight)
        f.XButton:SetScript("OnClick", function() self:OnXClick(i) end)
        table.insert(self.items, f)

        f:SetWidth(fwidth)
        if i == 1 then
            f:SetPoint("TOPLEFT", x, -10)
        else
            f:SetPoint("TOPLEFT", self.items[i - 1], "BOTTOMLEFT")
        end
        self:SetItemText(i, item.name:sub(2))
        f:SetScript("OnClick", function() self:OnItemClick(i) end)

        f.selected = false

        local c = item.name:sub(1, 1)
        self:SetItemEnabled(i, c ~= "-")
        f.Separator:SetShown(item.name == "-")
        f.XButton:SetShown(c == "x")
        f.RadioOff:SetShown(c == "o")
        f.RadioOn:Hide()
        if item.name == "-" then
            f:SetHeight(8)
        else
            f:SetHeight(config.rheight or 13)
        end
        height = height + f:GetHeight()
        if c == "!" then
            self:SetItemTitle(i)
        end
    end

    self.frame:SetHeight(height)
    self.frame:SetWidth(self.frame:GetWidth() + fwidth)
end

function TGDropDown.GetUIScale()
    local uiParentScale = UIParent:GetScale()
    if GetCVar("useUIScale") == "1" then
        local uiScale = tonumber(GetCVar("uiscale"))
        if uiParentScale < uiScale then
            return uiParentScale
        end
        return uiScale
    end
    return uiParentScale
end

function TGDropDown:Show(anchor)
    if anchor then
        self.frame:ClearAllPoints()
        if anchor.relativeTo == "cursor" then
            local scale = TGDropDown.GetUIScale()
            local x, y = GetCursorPosition()
            self.frame:SetPoint(anchor.point,
                                nil,
                                "BOTTOMLEFT",
                                x/scale + anchor.dx,
                                y/scale + anchor.dy
                                )
        else
            self.frame:SetPoint(anchor.point,
                                anchor.relativeTo,
                                anchor.relativePoint,
                                anchor.dx,
                                anchor.dy)
        end
    end
    self.frame:Show()
end

function TGDropDown:Hide()
    self.frame:Hide()
end

function TGDropDown:Toggle()
    self.frame:SetShown(not self.frame:IsShown())
end

function TGDropDown:OnHide()
    local h = self.config.hideHandler
    if h then
        h(self)
    end
end

function TGDropDown:OnItemClick(index)
    local f = self.items[index]
    local h = self.config.items[index].handler or self.config.handler
    if h then
        h(self, index, f.selected)
    end
end

function TGDropDown:OnXClick(index)
    local h = self.config.items[index].xhandler or self.config.xhandler
    assert(h)
    h(self, index)
end

function TGDropDown:SetItemTitle(index)
    local f = self.items[index]
    self:DisableItem(index)
    f.LabelDisabled:SetFontObject(GameFontNormalSmall)
end

function TGDropDown:SetItemText(index, text)
    local f = self.items[index]
    f.LabelEnabled:SetText(text)
    f.LabelDisabled:SetText(text)
end

function TGDropDown:GetItemText(index)
    local f = self.items[index]
    return f.LabelEnabled:GetText()
end

function TGDropDown:SetItemEnabled(index, enabled)
    if enabled then
        self:EnableItem(index)
    else
        self:DisableItem(index)
    end
end

function TGDropDown:DisableItem(index)
    self.items[index]:Disable()
    self.items[index].LabelEnabled:Hide()
    self.items[index].LabelDisabled:Show()
    self.items[index].XButton:Hide()
end

function TGDropDown:EnableItem(index)
    self.items[index]:Enable()
    self.items[index].LabelEnabled:Show()
    self.items[index].LabelDisabled:Hide()
    self.items[index].XButton:SetShown(self.xhandler ~= nil)
end

function TGDropDown:CheckOneItem(index)
    for i, item in ipairs(self.items) do
        item.CheckMark:SetShown(i == index)
    end
end

function TGDropDown:GetFirstCheckIndex()
    for i, item in ipairs(self.items) do
        if item.CheckMark:IsShown() then
            return i
        end
    end

    error("No items selected!")
end

function TGDropDown:SetRadio(index, selected)
    local f = self.items[index]
    f.RadioOn:SetShown(selected)
    f.RadioOff:SetShown(not selected)
end
