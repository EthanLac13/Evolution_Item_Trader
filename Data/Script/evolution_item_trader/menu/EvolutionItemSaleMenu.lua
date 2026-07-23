-- This code is copied from MistressNebula's InventorySelectMenu.
EvolutionItemSaleMenu = Class("EvolutionItemSaleMenu")

--- Creates a new ``EvolutionItemSaleMenu`` instance using the provided list and callbacks.
--- @param title string the title this window will have.
--- @param filter function a function that takes a ``RogueEssence.Dungeon.InvSlot`` object and returns a boolean. Any slot that does not pass this check will have its option disabled in the menu. Defaults to ``return true``.
--- @param confirm_action function the function called when the selection is confirmed. It will have a table array of ``RogueEssence.Dungeon.InvSlot`` objects passed to it as a parameter.
--- @param refuse_action function the function called when the player presses the cancel or menu button.
--- @param confirm_button string the text used for the confirm button of ``ItemChosenMenu``. If nil, the sub-menu will be skipped entirely.
--- @param menu_width number the width of this window. Default is 176.
--- @param item_table table the table of items sold by this shop.
--- @param max_choices boolean if set, it will never be possible to select more than the amount of items defined here. Defaults to the amount of selectable items.
--- @param label string the label that will be applied to this menu. Defaults to "INVENTORY_MENU_LUA"
function EvolutionItemSaleMenu:initialize(title, filter, confirm_action, refuse_action, confirm_button, menu_width, item_table, max_choices, label)
    if include_equips == nil then include_equips = true end

    -- constants
    self.MAX_ELEMENTS = 8

    -- parsing data
    self.title = title
    self.confirm_button = confirm_button
    self.confirmAction = confirm_action
    self.refuseAction = refuse_action
    self.menuWidth = menu_width or 176
    self.filter = filter or function(_) return true end
    self.itemTable = item_table
    --self.slotList = self:load_slots()
    self.optionsList = self:generate_options()
    self.max_choices_param = max_choices
    self.max_choices = self:count_valid()
    label = label or "INVENTORY_MENU_LUA"
    self.label = label
    if self.max_choices_param and self.max_choices_param < self.max_choices then self.max_choices = self.max_choices_param end

    self.multiConfirmAction = function(list)
        self.choices = self:multiConfirm(list)
        local choose = function(answer)
            if answer then
                _MENU:RemoveMenu()
                self.confirmAction(self.choices)
            end
        end

        if not self.confirm_button then
            choose(true)
        else
            local menu = ItemChosenMenu:new(self.choices, self.menu, self.confirm_button, choose)
            _MENU:AddMenu(menu.menu, true)
        end
    end

    self.choices = {} -- result

    -- creating the menu
    local origin = RogueElements.Loc(16,16)
    local option_array = luanet.make_array(RogueEssence.Menu.MenuElementChoice, self.optionsList)
    self.menu = RogueEssence.Menu.ScriptableMultiPageMenu(label, origin, self.menuWidth, title, option_array, 0, self.MAX_ELEMENTS, refuse_action, refuse_action, false, self.max_choices, self.multiConfirmAction)
    self.menu.ChoiceChangedFunction = function() self:updateSummary() end
	self.menu.MultiSelectChangedFunction = function() self:updateSummary() end
    --self.menu.UpdateFunction = function(input) self:updateFunction(input) end

    -- create the summary window
    local GraphicsManager = RogueEssence.Content.GraphicsManager

    self.summary = RogueEssence.Menu.ItemSummary(RogueElements.Rect.FromPoints(
            RogueElements.Loc(16, GraphicsManager.ScreenHeight - 8 - GraphicsManager.MenuBG.TileHeight * 2 - 14 * 4), --LINE_HEIGHT = 12, VERT_SPACE = 14
            RogueElements.Loc(GraphicsManager.ScreenWidth - 16, GraphicsManager.ScreenHeight - 8)))
    self.menu.SummaryMenus:Add(self.summary)
    self:updateSummary()
end

--- Loads the item slots that will be part of the menu.
--- @return table a standardized version of the item list
function EvolutionItemSaleMenu:load_slots()
    local list = {}

    if self.includeEquips then
        -- add equipped items
        local chars = _DATA.Save.ActiveTeam.Players
        for i=0, chars.Count-1, 1 do
            local char = chars[i]
            if char.EquippedItem.ID and char.EquippedItem.ID ~= "" then
                local entry = RogueEssence.Dungeon.InvSlot(true, i)
                table.insert(list, entry)
            end
        end
    end
    -- add rest of inventory
    for i=0, _DATA.Save.ActiveTeam:GetInvCount()-1, 1 do
        local entry = RogueEssence.Dungeon.InvSlot(false, i)
        table.insert(list, entry)
    end
    return list
end

--- Processes the menu's properties and generates the ``RogueEssence.Menu.MenuElementChoice`` list that will be displayed.
--- @return table a list of ``RogueEssence.Menu.MenuElementChoice`` objects.
function EvolutionItemSaleMenu:generate_options()
    local options = {}
    for i=1, #self.itemTable, 1 do
        local item = nil
        item = RogueEssence.Dungeon.InvItem(self.itemTable[i].Index)
        local color = Color.White

        local name = item:GetDisplayName()
        local price = STRINGS:Format("[color=#FF7FFF]\\u2661 [color=#00FF00]{0}[color]", self.itemTable[i].Price)
        local text_name = RogueEssence.Menu.MenuText(name, RogueElements.Loc(2, 1), color)
        local text_price = RogueEssence.Menu.MenuText(price, RogueElements.Loc(120, 1), color)
        local option = RogueEssence.Menu.MenuElementChoice(function() self:choose(i) end, true, text_name, text_price)
        table.insert(options, option)
    end
    return options
end

--- Counts the number of valid options generated.
--- @return number the number of valid options.
function EvolutionItemSaleMenu:count_valid()
    local count = 0
    for _, option in pairs(self.optionsList) do
        if option.Enabled then count = count+1 end
    end
    return count
end

--- Closes the menu and calls the menu's confirmation callback.
--- The result must be retrieved by accessing the choice variable of this object, which will hold
--- the chosen index as the single element of a table array.
--- @param index number the index of the chosen character, wrapped inside of a single element table array.
function EvolutionItemSaleMenu:choose(index)
    self.multiConfirmAction({index-1})
end

--- Uses the current input to apply changes to the menu.
--- @param input userdata the ``RogueEssense.InputManager``.
function EvolutionItemSaleMenu:updateFunction(input)
    --if input:JustPressed(RogueEssence.FrameInput.InputType.SortItems) then
        --_GAME:SE("Menu/Sort")
        --self:SortCommand()
    --end
end

--- Returns a newly created copy of this object
--- @return userdata an ``EvolutionItemSaleMenu``.
function EvolutionItemSaleMenu:cloneMenu()
    return EvolutionItemSaleMenu:new(self.title, self.filter, self.confirmAction, self.refuseAction, self.confirm_button, self.menuWidth, self.includeEquips, self.max_choices_param, self.label)
end

--- Updates the summary window.
function EvolutionItemSaleMenu:updateSummary()
    self.summary:SetItem(RogueEssence.Dungeon.InvItem(self.itemTable[self.menu.CurrentChoiceTotal+1].Index))
end

--- Extract the list of selected slots.
--- @param list table a table array containing the menu indexes of the chosen items.
--- @return table a table array containing ``RogueEssence.Dungeon.InvSlot`` objects.
function EvolutionItemSaleMenu:multiConfirm(list)
    local result = {}
    for _, index in pairs(list) do
        local inv_slot = self.itemTable[index+1]
        table.insert(result, inv_slot)
    end
    return result
end





ItemChosenMenu = Class("ItemChosenMenu")

--- Creates a new ``ItemChosenMenu`` instance using the provided object as parent.
--- @param slots table the list of selected InvSlots
--- @param parent userdata the parent menu
--- @param confirm_text function the confirm button text
--- @param confirm_action function the function that is called when the confirm button is pressed
--- @param label string the label that will be applied to this menu. Defaults to "ITEM_CHOSEN_MENU_LUA"
function ItemChosenMenu:initialize(slots, parent, confirm_text, confirm_action, label)
    local x, y = parent.Bounds.Right, parent.Bounds.Top
    local width = 72
    label = label or "ITEM_CHOSEN_MENU_LUA"
    self.first_item = slots[1]

    self.confirmAction = confirm_action
    local options = {
        {confirm_text, true, function() self:choose(true) end},
        {STRINGS:FormatKey("MENU_INFO"),      true, function() _MENU:AddMenu(RogueEssence.Menu.TeachInfoMenu(self.first_item), false) end},
        {STRINGS:FormatKey("MENU_CANCEL"),    true, function() self:choose(false) end}
    }
    if #slots>1 or self.first_item.UsageType ~= RogueEssence.Data.ItemData.UseType.Learn then
        table.remove(options, 2)
    end

    self.menu = RogueEssence.Menu.ScriptableSingleStripMenu(label, x, y, width, options, 0, function() self:choose(false) end)
end

function ItemChosenMenu:choose(result)
    _MENU:RemoveMenu()
    self.confirmAction(result)
end






--- Creates a basic ``EvolutionItemSaleMenu`` instance using the provided parameters, then runs it and returns its output.
--- @param title string the title this window will have
--- @param filter function a function that takes a ``RogueEssence.Dungeon.InvSlot`` object and returns a boolean. Any ``InvSlot`` that does not pass this check will have its option disabled in the menu. Defaults to ``return true``.
--- @param confirm_text string the text used by the confirm sub-menu's confirm option. If nil, the sub-menu will be skipped entirely.
--- @param item_list table the table of items used by this menu
--- @param max_choices number if set, it will never be possible to select more than the amount of items defined here. Defaults to the amount of selectable items.
--- @return table a table array containing the chosen ``RogueEssence.Dungeon.InvSlot`` objects.
function EvolutionItemSaleMenu.run(title, filter, confirm_text, item_list, max_choices)
    local ret = {}
    local choose = function(list) ret = list end
    local refuse = function() _MENU:RemoveMenu() end
    local menu = EvolutionItemSaleMenu:new(title, filter, choose, refuse, confirm_text, 176, item_list, max_choices)
    UI:SetCustomMenu(menu.menu)
    UI:WaitForChoice()
    return menu.choices
end