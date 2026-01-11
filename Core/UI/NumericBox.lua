---@class LibAT
local LibAT = LibAT

----------------------------------------------------------------------------------------------------
-- NumericBox Component
----------------------------------------------------------------------------------------------------

---Create a numeric input box with validation
---@param parent Frame Parent frame
---@param width number Box width
---@param height number Box height
---@param min? number Optional minimum value
---@param max? number Optional maximum value
---@return EditBox numericBox Numeric edit box with validation
function LibAT.UI.CreateNumericBox(parent, width, height, min, max)
	local editBox = LibAT.UI.CreateEditBox(parent, width, height)
	editBox:SetNumeric(true) -- Only allow numbers
	editBox:SetJustifyH('CENTER')

	editBox.min = min
	editBox.max = max

	-- Add validation on text change
	editBox:SetScript('OnTextChanged', function(self, userInput)
		if not userInput then
			return
		end

		local value = tonumber(self:GetText())
		if value then
			if self.min and value < self.min then
				self:SetText(tostring(self.min))
			elseif self.max and value > self.max then
				self:SetText(tostring(self.max))
			end
		end
	end)

	-- Convenience method to set value
	---Set the numeric value
	---@param value number Value to set
	function editBox:SetValue(value)
		self:SetText(tostring(value or 0))
	end

	-- Convenience method to get value
	---Get the numeric value
	---@return number value Current value
	function editBox:GetValue()
		return tonumber(self:GetText()) or 0
	end

	-- Method to update min/max constraints
	---Set minimum and maximum values
	---@param newMin number Minimum value
	---@param newMax number Maximum value
	function editBox:SetMinMaxValues(newMin, newMax)
		self.min = newMin
		self.max = newMax
	end

	return editBox
end

return LibAT.UI
