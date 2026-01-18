---@class LibAT
local LibAT = LibAT

----------------------------------------------------------------------------------------------------
-- ProgressBar Component
----------------------------------------------------------------------------------------------------

---Create a progress bar with modern styling
---@param parent Frame Parent frame
---@param width number Bar width
---@param height number Bar height
---@return StatusBar progressBar Progress bar with standard methods
function LibAT.UI.CreateProgressBar(parent, width, height)
	local bar = CreateFrame('StatusBar', nil, parent)
	bar:SetSize(width, height)
	bar:SetStatusBarTexture('Interface\\TargetingFrame\\UI-StatusBar')
	bar:SetStatusBarColor(0, 0.6, 1) -- Blue progress bar
	bar:SetMinMaxValues(0, 100)
	bar:SetValue(0)

	-- Background
	bar.bg = bar:CreateTexture(nil, 'BACKGROUND')
	bar.bg:SetAllPoints(bar)
	bar.bg:SetColorTexture(0, 0, 0, 0.5)

	-- Border using NineSlice for clean edges
	bar.Border = CreateFrame('Frame', nil, bar, 'NineSlicePanelTemplate')
	bar.Border:SetAllPoints()
	NineSliceUtil.ApplyUniqueCornersLayout(bar.Border, 'NineSliceLayout-Thin')

	-- Optional text display
	bar.text = bar:CreateFontString(nil, 'OVERLAY', 'GameFontNormalSmall')
	bar.text:SetPoint('CENTER')
	bar.text:SetText('')

	-- Convenience method to set text
	---Set the progress bar text
	---@param text string Text to display
	function bar:SetText(text)
		self.text:SetText(text or '')
	end

	-- Convenience method to update value and text together
	---Update both value and text display
	---@param value number Progress value
	---@param text? string Optional text to display
	function bar:Update(value, text)
		self:SetValue(value)
		if text then
			self:SetText(text)
		end
	end

	return bar
end

return LibAT.UI
