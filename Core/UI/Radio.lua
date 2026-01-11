---@class LibAT
local LibAT = LibAT

-- Global radio group storage
---@class RadioGroupData
---@field buttons Frame[] List of radio buttons in the group
---@field value any Currently selected value
---@field callbacks function[] List of callback functions

---@type table<string, RadioGroupData>
local RadioGroups = {}

----------------------------------------------------------------------------------------------------
-- Radio Button Component
----------------------------------------------------------------------------------------------------

---Create a radio button
---@param parent Frame Parent frame
---@param text string Button label
---@param groupName string Radio group name
---@param width? number Optional width (default 120)
---@param height? number Optional height (default 20)
---@return CheckButton radio Radio button with value management
function LibAT.UI.CreateRadio(parent, text, groupName, width, height)
	width = width or 120
	height = height or 20

	local radio = CreateFrame('CheckButton', nil, parent, 'UIRadioButtonTemplate')
	radio:SetSize(20, 20) -- Standard radio button size

	-- Create label
	radio.Text = radio:CreateFontString(nil, 'OVERLAY', 'GameFontHighlight')
	radio.Text:SetText(text)
	radio.Text:SetPoint('LEFT', radio, 'RIGHT', 5, 0)
	radio.Text:SetJustifyH('LEFT')
	radio.Text:SetWidth(width - 25) -- Account for radio button size

	-- Store group reference and value
	radio.groupName = groupName
	radio.value = nil

	-- Initialize group if needed
	if not RadioGroups[groupName] then
		RadioGroups[groupName] = {
			buttons = {},
			value = nil,
			callbacks = {},
		}
	end

	-- Add to group
	table.insert(RadioGroups[groupName].buttons, radio)

	-- Click handler
	radio:SetScript('OnClick', function(self)
		-- Uncheck all others in group
		for _, btn in ipairs(RadioGroups[groupName].buttons) do
			btn:SetChecked(btn == self)
		end

		-- Update group value
		RadioGroups[groupName].value = self.value

		-- Fire callbacks
		for _, callback in ipairs(RadioGroups[groupName].callbacks) do
			callback(self.value)
		end
	end)

	-- Add value setter/getter
	---Set the value associated with this radio button
	---@param value any The value to associate
	function radio:SetValue(value)
		self.value = value
	end

	---Get the value associated with this radio button
	---@return any value The associated value
	function radio:GetValue()
		return self.value
	end

	return radio
end

---Set the selected value of a radio group
---@param groupName string Radio group name
---@param value any Value to select
function LibAT.UI.SetRadioGroupValue(groupName, value)
	if not RadioGroups[groupName] then
		return
	end

	for _, button in ipairs(RadioGroups[groupName].buttons) do
		if button.value == value then
			button:SetChecked(true)
			RadioGroups[groupName].value = value
		else
			button:SetChecked(false)
		end
	end
end

---Get the selected value of a radio group
---@param groupName string Radio group name
---@return any|nil value Selected value or nil if no selection
function LibAT.UI.GetRadioGroupValue(groupName)
	if not RadioGroups[groupName] then
		return nil
	end
	return RadioGroups[groupName].value
end

---Register a callback for radio group value changes
---@param groupName string Radio group name
---@param callback function Callback function receiving (value)
function LibAT.UI.OnRadioGroupValueChanged(groupName, callback)
	if not RadioGroups[groupName] then
		RadioGroups[groupName] = {
			buttons = {},
			value = nil,
			callbacks = {},
		}
	end

	table.insert(RadioGroups[groupName].callbacks, callback)
end

---Clear all selections in a radio group
---@param groupName string Radio group name
function LibAT.UI.ClearRadioGroup(groupName)
	if not RadioGroups[groupName] then
		return
	end

	for _, button in ipairs(RadioGroups[groupName].buttons) do
		button:SetChecked(false)
	end

	RadioGroups[groupName].value = nil
end

---Get all radio buttons in a group (useful for cleanup)
---@param groupName string Radio group name
---@return Frame[]|nil buttons Array of radio buttons or nil
function LibAT.UI.GetRadioGroupButtons(groupName)
	if not RadioGroups[groupName] then
		return nil
	end
	return RadioGroups[groupName].buttons
end

return LibAT.UI
