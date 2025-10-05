# LibAT UI System

A shared UI component library for creating consistent, styled windows and UI elements across LibAT systems.

## Overview

The LibAT UI system provides reusable components styled to match Blizzard's modern UI design (specifically the AuctionHouse aesthetic). This reduces code duplication and ensures visual consistency across all LibAT systems.

## Components

### UIComponents.lua

Basic UI building blocks for buttons, inputs, and panels.

### BaseWindow.lua

Window creation and layout helpers for consistent window structure.

### NavigationTree.lua

Hierarchical navigation trees styled like AuctionHouse category lists.

## Quick Start

### Creating a Basic Window

```lua
local LibAT = LibAT
local UI = LibAT.UI

-- Create window
local window = UI.CreateWindow({
	name = 'MyAddon_MainWindow',
	title = 'My Addon',
	width = 800,
	height = 538,
	portrait = 'Interface\\AddOns\\MyAddon\\logo'
})

-- Create control frame (top bar for search/filters)
local controlFrame = UI.CreateControlFrame(window)

-- Create main content area
local contentFrame = UI.CreateContentFrame(window, controlFrame)

-- Create left/right panels
local leftPanel = UI.CreateLeftPanel(contentFrame)
local rightPanel = UI.CreateRightPanel(contentFrame, leftPanel)

-- Add action buttons at bottom
local buttons = UI.CreateActionButtons(window, {
	{text = 'Save', width = 80, onClick = function() print('Save clicked') end},
	{text = 'Cancel', width = 80, onClick = function() window:Hide() end}
})
```

### Adding Navigation Tree

```lua
-- Prepare categories data
local categories = {
	['General'] = {
		name = 'General',
		key = 'General',
		expanded = false,
		subCategories = {
			['Settings'] = {
				name = 'Settings',
				key = 'General.Settings',
				onSelect = function(key, data)
					print('Selected:', key)
				end
			},
			['Profiles'] = {
				name = 'Profiles',
				key = 'General.Profiles',
				onSelect = function(key, data)
					print('Selected:', key)
				end
			}
		},
		sortedKeys = {'Settings', 'Profiles'}
	},
	['Advanced'] = {
		name = 'Advanced',
		key = 'Advanced',
		expanded = false,
		isToken = true, -- Blue styling for external addons
		subCategories = {
			['Debug'] = {
				name = 'Debug',
				key = 'Advanced.Debug',
				onSelect = function(key, data)
					print('Selected:', key)
				end
			}
		},
		sortedKeys = {'Debug'}
	}
}

-- Create navigation tree
local navTree, treeContainer = UI.CreateNavigationTree({
	parent = leftPanel,
	categories = categories,
	activeKey = 'General.Settings',
	onCategoryClick = function(key, data)
		print('Category clicked:', key)
	end,
	onSubCategoryClick = function(key, data)
		print('Subcategory clicked:', key)
		UpdateDisplayForKey(key)
	end
})

-- Build and display the tree
UI.BuildNavigationTree(navTree)
```

### Adding UI Controls

```lua
-- Search box
local searchBox = UI.CreateSearchBox(controlFrame, 241)
searchBox:SetPoint('LEFT', controlFrame, 'LEFT', 10, 0)
searchBox:SetScript('OnTextChanged', function(self)
	local searchTerm = self:GetText()
	FilterResults(searchTerm)
end)

-- Checkbox
local checkbox = UI.CreateCheckbox(controlFrame, 'Auto-scroll')
checkbox:SetPoint('LEFT', searchBox, 'RIGHT', 10, 0)
checkbox:SetScript('OnClick', function(self)
	AutoScrollEnabled = self:GetChecked()
end)

-- Dropdown
local dropdown = UI.CreateDropdown(controlFrame, 'Filter', 120, 22)
dropdown:SetPoint('LEFT', checkbox.Label, 'RIGHT', 10, 0)
dropdown:SetupMenu(function(dropdown, rootDescription)
	rootDescription:CreateButton('Option 1', function()
		print('Selected Option 1')
	end)
	rootDescription:CreateButton('Option 2', function()
		print('Selected Option 2')
	end)
end)

-- Icon button (gear icon)
local settingsBtn = UI.CreateIconButton(
	controlFrame,
	'Warfronts-BaseMapIcons-Empty-Workshop',
	'Warfronts-BaseMapIcons-Alliance-Workshop',
	'Warfronts-BaseMapIcons-Horde-Workshop'
)
settingsBtn:SetPoint('RIGHT', controlFrame, 'RIGHT', -10, 0)
settingsBtn:SetScript('OnClick', function()
	OpenSettings()
end)
```

### Adding Content Display

```lua
-- Scrollable text display
local scrollFrame, editBox = UI.CreateScrollableTextDisplay(rightPanel)
scrollFrame:SetPoint('TOPLEFT', rightPanel, 'TOPLEFT', 6, -6)
scrollFrame:SetPoint('BOTTOMRIGHT', rightPanel, 'BOTTOMRIGHT', 0, 2)
editBox:SetWidth(scrollFrame:GetWidth() - 20)
editBox:SetText('Your content here...')

-- Or create custom content with styled panel
local customPanel = UI.CreateStyledPanel(rightPanel, 'auctionhouse-background-index')
customPanel:SetPoint('TOPLEFT', rightPanel, 'TOPLEFT', 6, -6)
customPanel:SetPoint('BOTTOMRIGHT', rightPanel, 'BOTTOMRIGHT', -6, 6)

-- Add labels
local header = UI.CreateHeader(customPanel, 'Section Header')
header:SetPoint('TOP', customPanel, 'TOP', 0, -10)

local label = UI.CreateLabel(customPanel, 'Description text')
label:SetPoint('TOP', header, 'BOTTOM', 0, -10)
```

## Component Reference

### Buttons

#### `UI.CreateButton(parent, width, height, text)`

Creates a standard WoW button with UIPanelButtonTemplate.

**Returns:** Button frame

#### `UI.CreateIconButton(parent, normalAtlas, highlightAtlas, pushedAtlas, size)`

Creates an icon button with hover/click effects.

**Parameters:**

- `normalAtlas` - Atlas name for normal state
- `highlightAtlas` - Atlas name for hover state
- `pushedAtlas` - Atlas name for pressed state
- `size` - Optional size (default 24)

**Returns:** Button frame

### Inputs

#### `UI.CreateSearchBox(parent, width, height)`

Creates a search box with clear button.

**Returns:** EditBox frame

#### `UI.CreateEditBox(parent, width, height, multiline)`

Creates a standard edit box.

**Returns:** EditBox frame

#### `UI.CreateCheckbox(parent, label)`

Creates a checkbox with optional label.

**Returns:** CheckButton frame with `.Label` property

#### `UI.CreateDropdown(parent, text, width, height)`

Creates a dropdown button using WowStyle1FilterDropdownTemplate.

**Returns:** DropdownButton frame

### Panels

#### `UI.CreateStyledPanel(parent, atlas)`

Creates a panel with AuctionHouse background and nine-slice border.

**Common atlas values:**

- `'auctionhouse-background-summarylist'` - Left panel style
- `'auctionhouse-background-index'` - Right panel style

**Returns:** Frame with `.Background` and `.NineSlice` properties

#### `UI.CreateScrollFrame(parent)`

Creates a scroll frame with MinimalScrollBar.

**Returns:** ScrollFrame with `.ScrollBar` property

#### `UI.CreateScrollableTextDisplay(parent)`

Creates a scrollable text display (EditBox within ScrollFrame).

**Returns:** ScrollFrame, EditBox

### Text

#### `UI.CreateLabel(parent, text, fontObject)`

Creates a label using GameFontNormalSmall (or specified font).

**Returns:** FontString

#### `UI.CreateHeader(parent, text)`

Creates a gold-colored header using GameFontNormal.

**Returns:** FontString

### Windows

#### `UI.CreateWindow(config)`

Creates a standardized ButtonFrameTemplate window.

**Config options:**

```lua
{
	name = 'UniqueWindowName',     -- Required
	title = 'Window Title',        -- Required
	width = 800,                   -- Optional (default 800)
	height = 538,                  -- Optional (default 538)
	portrait = 'texture/path',     -- Optional
	hidePortrait = true            -- Optional (default true)
}
```

**Returns:** Frame window

#### `UI.CreateControlFrame(window, yOffset, height)`

Creates a control frame at the top of the window (like AuctionHouse SearchBar).

**Returns:** Frame

#### `UI.CreateContentFrame(window, controlFrame, yOffset, bottomOffset)`

Creates the main content area below the control frame.

**Returns:** Frame

#### `UI.CreateLeftPanel(parent, width, xOffset, yOffset, bottomOffset)`

Creates a left navigation panel with AuctionHouse styling.

**Returns:** Frame with `.Background` and `.NineSlice` properties

#### `UI.CreateRightPanel(parent, leftPanel, spacing, rightOffset, yOffset, bottomOffset)`

Creates a right content panel with AuctionHouse styling.

**Returns:** Frame with `.Background` and `.NineSlice` properties

#### `UI.CreateActionButtons(window, buttons, spacing, bottomOffset, rightOffset)`

Creates action buttons at the bottom right of the window.

**Buttons config:**

```lua
{
	{text = 'Button1', width = 80, height = 22, onClick = function() end},
	{text = 'Button2', width = 80, height = 22, onClick = function() end}
}
```

**Returns:** Array of button frames

### Navigation Tree

#### `UI.CreateNavigationTree(config)`

Creates a hierarchical navigation tree.

**Config structure:**

```lua
{
	parent = leftPanelFrame,       -- Required
	categories = categoriesTable,  -- Required (see below)
	activeKey = 'selectedKey',     -- Optional
	onCategoryClick = function(key, data) end,     -- Optional
	onSubCategoryClick = function(key, data) end,  -- Optional
	onSubSubCategoryClick = function(key, data) end -- Optional
}
```

**Categories structure:**

```lua
{
	['CategoryKey'] = {
		name = 'Display Name',
		key = 'CategoryKey',
		expanded = false,
		isToken = false,  -- Blue styling if true
		subCategories = {
			['SubKey'] = {
				name = 'Sub Name',
				key = 'CategoryKey.SubKey',
				expanded = false,
				subSubCategories = { -- Optional third level
					['SubSubKey'] = {
						name = 'Sub-Sub Name',
						key = 'CategoryKey.SubKey.SubSubKey',
						onSelect = function(key, data) end
					}
				},
				sortedKeys = {'SubSubKey', ...}
			}
		},
		sortedKeys = {'SubKey', ...}
	}
}
```

**Returns:** ScrollFrame, TreeContainer, ButtonsTable

#### `UI.BuildNavigationTree(scrollFrame, sortedCategoryKeys)`

Builds and displays the navigation tree.

## Best Practices

1. **Use the layout helpers:** `CreateControlFrame`, `CreateContentFrame`, `CreateLeftPanel`, `CreateRightPanel` maintain consistent spacing and positioning.

2. **Store references:** Keep references to your windows and key UI elements for updates:

   ```lua
   MyAddon.window = UI.CreateWindow({...})
   MyAddon.searchBox = UI.CreateSearchBox(...)
   ```

3. **Rebuild navigation trees on change:** Call `UI.BuildNavigationTree(scrollFrame)` whenever categories expand/collapse or data changes.

4. **Use callbacks:** The navigation tree supports per-item `onSelect` callbacks as well as global handlers for flexibility.

5. **Follow naming conventions:** Use descriptive, unique names for window frames to avoid conflicts.

## Migration Guide

### From Custom UI Code to LibAT UI

**Before:**

```lua
local window = CreateFrame('Frame', 'MyWindow', UIParent, 'ButtonFrameTemplate')
window:SetSize(800, 538)
window:SetPoint('CENTER')
window:SetMovable(true)
window:EnableMouse(true)
window:RegisterForDrag('LeftButton')
-- ... many more lines
```

**After:**

```lua
local window = LibAT.UI.CreateWindow({
	name = 'MyWindow',
	title = 'My Window',
	width = 800,
	height = 538
})
```

## Examples

See:

- `Systems/Logger/Logger.lua` - Complex example with navigation tree and dynamic content
- `Systems/ProfileManager/Profiles.lua` - Simpler example with basic window structure

## Contributing

When adding new shared UI components:

1. Add to appropriate file (UIComponents, BaseWindow, or NavigationTree)
2. Document with LuaDoc annotations
3. Add example to this README
4. Update the `LibAT.UI` class definition in Main.lua
