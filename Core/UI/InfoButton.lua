---@class LibAT
local LibAT = LibAT

---Create an info/help button with tooltip support
---Styled like Tetlas Atlas Viewer with help icon and zoom highlight
---@param parent Frame Parent frame
---@param tooltipTitle string Tooltip header text
---@param tooltipText string Tooltip body text
---@param size? number Optional button size (default 20)
---@return Frame button Info button with tooltip
function LibAT.UI.CreateInfoButton(parent, tooltipTitle, tooltipText, size)
	size = size or 20
	local button = CreateFrame('Button', nil, parent)
	button:SetSize(size, size)

	-- Normal texture: help-i icon
	button.Icon = button:CreateTexture(nil, 'BACKGROUND')
	button.Icon:SetTexture('Interface\\common\\help-i')
	button.Icon:SetSize(size * 1.5, size * 1.5) -- 30x30 for 20x20 button
	button.Icon:SetPoint('CENTER', 0, 0)

	-- Highlight texture: zoom button highlight with ADD blend
	button.HighlightTexture = button:CreateTexture(nil, 'HIGHLIGHT')
	button.HighlightTexture:SetTexture('Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight')
	button.HighlightTexture:SetSize(size * 1.5, size * 1.5)
	button.HighlightTexture:SetPoint('CENTER', 0, 0)
	button.HighlightTexture:SetBlendMode('ADD')

	-- Visual feedback on click (icon moves down-left slightly)
	button:SetScript('OnMouseDown', function(self)
		self.Icon:SetPoint('CENTER', -1, -1)
	end)
	button:SetScript('OnMouseUp', function(self)
		self.Icon:SetPoint('CENTER', 0, 0)
	end)

	-- Tooltip support
	button:SetScript('OnEnter', function(self)
		GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
		GameTooltip:SetText(tooltipTitle, 1, 1, 1, nil, true)
		if tooltipText and tooltipText ~= '' then
			GameTooltip:AddLine(tooltipText, nil, nil, nil, true)
		end
		GameTooltip:Show()
	end)
	button:SetScript('OnLeave', function(self)
		GameTooltip:Hide()
	end)

	return button
end

return LibAT.UI
