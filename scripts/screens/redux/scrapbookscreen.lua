require "util"
require "strings"
require "constants"

--[[
TheScrapbookPartitions:WasSeenInGame("prefab")
TheScrapbookPartitions:SetSeenInGame("prefab")

TheScrapbookPartitions:WasViewedInScrapbook("prefab")
TheScrapbookPartitions:SetViewedInScrapbook("prefab")

TheScrapbookPartitions:WasInspectedByCharacter("prefab", "wilson")
TheScrapbookPartitions:SetInspectedByCharacter("prefab", "wilson")

TheScrapbookPartitions:DebugDeleteAllData()
TheScrapbookPartitions:DebugSeenEverything()
TheScrapbookPartitions:DebugUnlockEverything()
]]

local recipes_filter = require("recipes_filter")

local Screen = require "widgets/screen"
local Subscreener = require "screens/redux/subscreener"
local ImageButton = require "widgets/imagebutton"
local Menu = require "widgets/menu"
local Grid = require "widgets/grid"
local Text = require "widgets/text"
local Image = require "widgets/image"
local Widget = require "widgets/widget"
local ScrollableList = require "widgets/scrollablelist"
local PopupDialogScreen = require "screens/redux/popupdialog"
local OnlineStatus = require "widgets/onlinestatus"
local TEMPLATES = require "widgets/redux/templates"
local TrueScrollArea = require "widgets/truescrollarea"
local UIAnim = require "widgets/uianim"

local dataset = require("screens/redux/scrapbookdata")

local PANEL_WIDTH = 1000
local PANEL_HEIGHT = 530
local SEARCH_BOX_HEIGHT = 40
local SEARCH_BOX_WIDTH = 300

local FILLER = "zzzzzzz"
local UNKNOWN = "unknown"

local UK_TINT = {0.5,0.5,0.5,1}

---------------------------------------
-- SEEDED RANDOM NUMBER
local A1, A2 = 727595, 798405 -- 5^17=D20*A1+A2
local D20, D40 = 1048576, 1099511627776 -- 2^20, 2^40
local X1, X2 = 0, 1

function rand()
  	local U = X2 * A2
  	local V = (X1 * A2 + X2 * A1) % D20
  	V = (V * D20 + U) % D40
  	X1 = math.floor(V / D20)
  	X2 = V - X1 * D20
  	return V / D40
end

function primeRand(seed)
	X1= seed
 	A1, A2 = 727595, 798405 -- 5^17=D20*A1+A2
	D20, D40 = 1048576, 1099511627776 -- 2^20, 2^40
	X2 = 0, 1
end

--------------------------------------------------

local ScrapbookScreen = Class(Screen, function( self, prev_screen, default_section )
	Screen._ctor(self, "ScrapbookScreen")

    self.letterbox = self:AddChild(TEMPLATES.old.ForegroundLetterbox())	
	self.root = self:AddChild(TEMPLATES.ScreenRoot("ScrapBook"))		
    self.bg = self.root:AddChild(TEMPLATES.PlainBackground())

    if not TheScrapbookPartitions:ApplyOnlineProfileData() then
        local msg = not TheInventory:HasSupportForOfflineSkins() and (TheFrontEnd ~= nil and TheFrontEnd:GetIsOfflineMode() or not TheNet:IsOnlineMode()) and STRINGS.UI.SCRAPBOOK.ONLINE_DATA_USER_OFFLINE or STRINGS.UI.SCRAPBOOK.ONLINE_DATA_DOWNLOAD_FAILED
        self.sync_status = self.root:AddChild(Text(HEADERFONT, 24, msg, UICOLOURS.WHITE))
        self.sync_status:SetVAnchor(ANCHOR_TOP)
        self.sync_status:SetHAnchor(ANCHOR_RIGHT)
        local w, h = self.sync_status:GetRegionSize()
        self.sync_status:SetPosition(-w/2 - 2, -h/2 - 2) -- 2 Pixel padding, top right screen justification.
    end

    self:SetPlayerKnowledge()

	self.colums_setting = 3
	self.current_dataset = self:CollectType(dataset,"creature")
	self.current_view_data = self:CollectType(dataset,"creature")

    self:MakeSideBar()

	self.current_dataset = self:CollectType(dataset,"creature")
	self.current_view_data = self:CollectType(dataset,"creature")
    self:SelectSideButton("creature")

    self.title = self.root:AddChild(TEMPLATES.ScreenTitle(STRINGS.UI.SCRAPBOOK.TITLE, ""))

    self:LinkDeps()

	self:MakeBackButton()

    self.dialog = self.root:AddChild(TEMPLATES.RectangleWindow(PANEL_WIDTH, PANEL_HEIGHT))
    self.dialog:SetPosition(0, 0)

    self.detailsroot = self.dialog:AddChild(Widget("details_root"))
    self.detailsroot:SetPosition(-250,0)

    self.gridroot = self.dialog:AddChild(Widget("grid_root"))
    self.gridroot:SetPosition(250,0)

    self.item_grid = self.gridroot:AddChild( self:BuildItemGrid() )
    self.item_grid:SetPosition(0, 0)    

    self.item_grid:SetItemsData(self.current_view_data)

	local grid_w, grid_h = self.item_grid:GetScrollRegionSize()	

	self.details = self.detailsroot:AddChild(self:PopulateInfoPanel())

	self:MakeBottomBar()
	self:MakeTopBar()
	self:SetGrid()
	
	self.focus_forward = self.item_grid

	if TheInput:ControllerAttached() then
		self:SetFocus()
	end

	SetAutopaused(true)
end)


function ScrapbookScreen:SetPlayerKnowledge()
	for prefab,data in pairs(dataset) do
		data.knownlevel = TheScrapbookPartitions:GetLevelFor(prefab)
	end	
end

function ScrapbookScreen:LinkDeps()
	for i,mainprefab in pairs(dataset)do
		for d,depprefab in ipairs(mainprefab.deps)do
			local newdata = dataset[depprefab]
			if newdata then
				local there=false
				if newdata.deps then
					for t,dep in ipairs(newdata.deps)do
						if dep == i then
							there = true
						end
					end
				end
				if not there then
					if not newdata.deps then
						newdata.deps = {}
					end
					table.insert(newdata.deps,i)
				end
			end
		end
	end
end

function ScrapbookScreen:FilterData(search_text, search_set)

	if not search_set  then
		search_set = self:CollectType(dataset)
	end

	if not search_text or search_text == "" then
		self.current_view_data = {} --search_set -- self.current_dataset
		return
	end

	local newset = {}
	for i,set in ipairs( search_set ) do
		local name = nil
		if set.type ~= UNKNOWN then
			name = TrimString(string.lower(STRINGS.NAMES[string.upper(set.name)])):gsub(" ", "")
		
		--local name = TrimString(string.lower(set.name)):gsub(" ", "")
			if set.subcat then
				name = name .. TrimString(string.lower(set.subcat)):gsub(" ", "")
			end
			local num = string.find(name, search_text, 1, true)
			if num then
				table.insert(newset,set)
			end
		end
	end
	
	self.current_view_data = newset
end

function ScrapbookScreen:SetSearchText(search_text)
	search_text = TrimString(string.lower(search_text)):gsub(" ", "")

	if search_text == self.last_search_text then
		return
	end

	self.last_search_text = search_text

	self:FilterData(search_text)

	self:SetGrid()
end

function ScrapbookScreen:MakeSearchBox(box_width, box_height)
    local searchbox = Widget("search")
	searchbox:SetHoverText(STRINGS.UI.CRAFTING_MENU.SEARCH, {offset_y = 30, attach_to_parent = self })

    searchbox.textbox_root = searchbox:AddChild(TEMPLATES.StandardSingleLineTextEntry(nil, box_width, box_height))
    searchbox.textbox = searchbox.textbox_root.textbox
    searchbox.textbox:SetTextLengthLimit(200)
    searchbox.textbox:SetForceEdit(true)
    searchbox.textbox:EnableWordWrap(false)
    searchbox.textbox:EnableScrollEditWindow(true)
    searchbox.textbox:SetHelpTextEdit("")
    searchbox.textbox:SetHelpTextApply(STRINGS.UI.SERVERCREATIONSCREEN.SEARCH)
    searchbox.textbox:SetTextPrompt(STRINGS.UI.SERVERCREATIONSCREEN.SEARCH, UICOLOURS.GREY)
    searchbox.textbox.prompt:SetHAlign(ANCHOR_MIDDLE)
    searchbox.textbox.OnTextInputted = function()
    	self:SelectSideButton()
		self:SetSearchText(self.searchbox.textbox:GetString())
    end

     -- If searchbox ends up focused, highlight the textbox so we can tell something is focused.
    searchbox:SetOnGainFocus( function() searchbox.textbox:OnGainFocus() end )
    searchbox:SetOnLoseFocus( function() searchbox.textbox:OnLoseFocus() end )

    searchbox.focus_forward = searchbox.textbox

    return searchbox
end

function ScrapbookScreen:CollectType(set, filter)
	local newset = {}
	local blankset = {}
	local blank = {name="",type=UNKNOWN, name=FILLER}
	for i,data in pairs(set)do
		if not filter or data.type == filter then
			local ok = false
			if self.menubuttons then
				for i, button in ipairs (self.menubuttons) do
					if button.filter == data.type then
						ok = true
						break
					end
				end
			else
				ok = true
			end

			if data.knownlevel > 0 and ok then
				table.insert(newset,deepcopy(data))
			elseif ok then
				table.insert(blankset,deepcopy(blank))
			end
		end
	end

	for i,blank in ipairs(blankset)do
		table.insert(newset,blank)
	end
	return newset
end

function ScrapbookScreen:updatemenubuttonflashes()
	
	for i,button in ipairs(self.menubuttons)do
		button.flash:Hide()
	end
	local noflash = true
	for prefab,data in pairs(dataset)do
		if not TheScrapbookPartitions:WasViewedInScrapbook(prefab) and data.knownlevel > 0 then
			for i,button in ipairs(self.menubuttons)do
				if button.filter == dataset[prefab].type then
					button.flash:Show()
					noflash = false
				end
			end
		end
 	end

 	self.flashestoclear = true
 	if noflash then
 		self.flashestoclear = nil
 	end

 	if self.clearflash then
		self.clearflash:Show()
	 	if noflash then
			self.clearflash:Hide()
	 	end
 	end
end

function ScrapbookScreen:SetGrid()
	if self.item_grid then
		self.gridroot:KillAllChildren()
	end
	self.item_grid = nil
	self.item_grid = self.gridroot:AddChild( self:BuildItemGrid(self.colums_setting) )
	self.item_grid:SetPosition(0, 0)
	local griddata = deepcopy(self.current_view_data)

	local setfocus = true
	if #griddata <= 0 then
		setfocus = false

		for i=1,self.colums_setting do
			table.insert(griddata,{name=FILLER})
		end
	end

	if #griddata%self.colums_setting > 0 then
		for i=1,self.colums_setting -(#self.current_view_data%self.colums_setting) do
			table.insert(griddata,{name=FILLER})
		end
	end

	self.item_grid:SetItemsData( griddata )
	local grid_w, grid_h = self.item_grid:GetScrollRegionSize()

	self:updatemenubuttonflashes()
	self:DoFocusHookups()
	self.focus_forward = self.item_grid

	TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/scrapbook_pageflip")

	if TheInput:ControllerAttached() then
		if setfocus and not self.searchbox.focus then
			self:SetFocus()
		else
			self.searchbox:SetFocus()
		end
	end
end

function ScrapbookScreen:SelectMenuItem(dir)
	local cat = "creature"
	if self.menubuttons_selected then
		local selected = nil
		for i,button in ipairs(self.menubuttons) do
			if button.filter ==  self.menubuttons_selected then
				selected = i
			end
		end
		if dir == "down" then
			if selected == #self.menubuttons then
				selected = 1
			else
				selected = selected +1
			end
		else
			if selected == 1 then
				selected = #self.menubuttons
			else
				selected = selected -1
			end
		end		
		cat = self.menubuttons[selected].filter
	end

	self:SelectSideButton(cat)		
	self.current_dataset = self:CollectType(dataset,cat)
	self.current_view_data = self:CollectType(dataset,cat)
	self:SetGrid()	
end

function ScrapbookScreen:SelectSideButton(category)
	self.menubuttons_selected = category
	for i,button in ipairs(self.menubuttons)do

		if button.filter == category then
			button.selectimg:Show()
		else
			button.selectimg:Hide()
		end

	end
end

function ScrapbookScreen:MakeSideBar()

	self.menubuttons = {}
	local colors = {
		{114/255,56/255,56/255},
		{111/255,85/255,47/255},
		{137/255,126/255,89/255},
		--{195/255,179/255,109/255},
		{95/255,123/255,87/255},
		{113/255,127/255,126/255},
		{74/255,84/255,99/255},
		{79/255,73/255,107/255},
	}

	local buttons = {
		{name="Creatures", filter="creature"},	
		{name="Giants", filter="giant"},
		{name="Items", filter="item"},
		{name="Food", filter="food"},
		{name="Things", filter="thing"},
		{name="POI", filter="POI"},
		{name="Biomes", filter="biome"},
		{name="Seasons", filter="season"},
	}

	for i, button in ipairs(buttons)do
		local idx = i % #colors
		if idx == 0 then idx = #colors end
		button.color = colors[idx]
	end
	
	for t=#buttons,1,-1 do
		local ok =false
		for i,cat in ipairs(SCRAPBOOK_CATS)do
			if buttons[t].filter == cat then
				ok = true
				break
			end
		end
		if not ok then
			table.remove(buttons,t)
		end
	end

	local buttonwidth = 252/2.2--75
	local buttonheight = 112/2.2--30

	-- PANEL_HEIGHT

	local totalheight = PANEL_HEIGHT - 100

	local MakeButton = function(idx,data)

		local y = totalheight/2 - ((totalheight/7) * idx-1) + 50

		local buttonwidget = self.root:AddChild(Widget())

		local button = buttonwidget:AddChild(ImageButton("images/scrapbook.xml", "tab.tex"))
		button:ForceImageSize(buttonwidth,buttonheight)
		button.scale_on_focus = false
		button.basecolor = {data.color[1],data.color[2],data.color[3]}
		button:SetImageFocusColour(math.min(1,data.color[1]*1.2),math.min(1,data.color[2]*1.2),math.min(1,data.color[3]*1.2),1)
		button:SetImageNormalColour(data.color[1],data.color[2],data.color[3],1)
		button:SetImageSelectedColour(data.color[1],data.color[2],data.color[3],1)
		button:SetImageDisabledColour(data.color[1],data.color[2],data.color[3],1)
		button:SetOnClick(function()
				self:SelectSideButton(data.filter)
				self.current_dataset = self:CollectType(dataset,data.filter)
				self.current_view_data = self:CollectType(dataset,data.filter)
				self:SetGrid()
			end)

		buttonwidget.focusimg = buttonwidget:AddChild(Image("images/scrapbook.xml", "tab_over.tex"))
		buttonwidget.focusimg:ScaleToSize(buttonwidth,buttonheight)
		buttonwidget.focusimg:SetClickable(false)
		buttonwidget.focusimg:Hide()

		buttonwidget.selectimg = buttonwidget:AddChild(Image("images/scrapbook.xml", "tab_selected.tex"))
		buttonwidget.selectimg:ScaleToSize(buttonwidth,buttonheight)
		buttonwidget.selectimg:SetClickable(false)
		buttonwidget.selectimg:Hide()

		buttonwidget:SetOnGainFocus(function()
			buttonwidget.focusimg:Show()
		end)
		buttonwidget:SetOnLoseFocus(function()
			buttonwidget.focusimg:Hide()
		end)

		local text = buttonwidget:AddChild(Text(HEADERFONT, 12, STRINGS.SCRAPBOOK.CATS[string.upper(data.name)] , UICOLOURS.WHITE))
		text:SetPosition(10,-8)		
		buttonwidget:SetPosition(522+buttonwidth/2, y)

		local total = 0
		local count = 0
		for i,set in pairs(dataset)do
			if set.type == data.filter then
				total = total +1
				if set.knownlevel > 0 then
					count = count+1					
				end
			end
		end
		if total > 0 then

 			local percent = (count/total)*100
			if percent < 1 then
				percent = math.floor(percent*100)/100
			else
				percent = math.floor(percent)
			end

			local progress = buttonwidget:AddChild(Text(HEADERFONT, 18, percent.."%" , UICOLOURS.GOLD))
			progress:SetPosition(15,17)
		end

		buttonwidget.newcreatures = {}

		buttonwidget.flash = buttonwidget:AddChild(UIAnim())
		buttonwidget.flash:GetAnimState():SetBank("cookbook_newrecipe")
		buttonwidget.flash:GetAnimState():SetBuild("cookbook_newrecipe")
		buttonwidget.flash:GetAnimState():PlayAnimation("anim",true)
		buttonwidget.flash:GetAnimState():SetScale(0.15,0.15,0.15)
		buttonwidget.flash:SetPosition( 40,0,0 )
		buttonwidget.flash:Hide()
		buttonwidget.flash:SetClickable(false)

		buttonwidget.filter = data.filter
		buttonwidget.focus_forward = button

		table.insert(self.menubuttons,buttonwidget)
	end

	for i,data in ipairs(buttons)do
		MakeButton(i,data)
	end
end

function ScrapbookScreen:updatemenubuttonnewitem(data, setting)
	local buttontype = data.type
	for i, button in ipairs(self.menubuttons)do
		if button.filter == buttontype then			
			button.newcreatures[data.prefab] = setting

			button.flash:Hide()
			
			for prefab,bool in pairs(button.newcreatures)do
				if bool == true then
					button.flash:Show()
					break
				end
			end
			break
		end		
	end
end

function ScrapbookScreen:ClearFlashes()
	for prefab,data in pairs(dataset)do
        if TheScrapbookPartitions:GetLevelFor(prefab) > 0 then
		    TheScrapbookPartitions:SetViewedInScrapbook(prefab)
        end
	end
	self:SetGrid()
end

function ScrapbookScreen:MakeBottomBar()
	if not TheInput:ControllerAttached() then
		self.clearflash = self.root:AddChild(ImageButton("images/global_redux.xml", "button_carny_long_normal.tex", "button_carny_long_hover.tex", "button_carny_long_disabled.tex", "button_carny_long_down.tex"))
		self.clearflash.image:SetScale(.6)
		self.clearflash:SetFont(HEADERFONT)
		self.clearflash:SetText(STRINGS.SCRAPBOOK.CLEARFLASH)
		self.clearflash.text:SetColour(0,0,0,1)
		self.clearflash:SetPosition(220+(SEARCH_BOX_WIDTH/2)+28+28, -PANEL_HEIGHT/2 -38)
		self.clearflash:SetTextSize(16)
		self.clearflash:SetOnClick(function()
				self:ClearFlashes()
			end)
	end
end

function ScrapbookScreen:MakeTopBar()
	self.last_search_text = ""
	self.search_text = ""

	self.searchbox = self.root:AddChild(self:MakeSearchBox(300, SEARCH_BOX_HEIGHT))
	self.searchbox:SetPosition(220, PANEL_HEIGHT/2 +33)

	self.display_col_1_button = self.root:AddChild(ImageButton("images/scrapbook.xml", "sort1.tex"))
	self.display_col_1_button:SetPosition(220+(SEARCH_BOX_WIDTH/2)+28, PANEL_HEIGHT/2 +33)
	self.display_col_1_button:ForceImageSize(25,25)
	self.display_col_1_button.scale_on_focus = false
	self.display_col_1_button.focus_scale = {1.1,1.1,1.1}
	self.display_col_1_button.ignore_standard_scaling = true
	self.display_col_1_button:SetOnClick(function()
			self.colums_setting = 1
			self:SetGrid()
		end)

	self.display_col_2_button = self.root:AddChild(ImageButton("images/scrapbook.xml", "sort2.tex"))
	self.display_col_2_button:SetPosition(220+(SEARCH_BOX_WIDTH/2)+28+28, PANEL_HEIGHT/2 +33)
	self.display_col_2_button:ForceImageSize(25,25)	
	self.display_col_2_button.scale_on_focus = false
	self.display_col_2_button.focus_scale = {1.1,1.1,1.1}
	self.display_col_2_button.ignore_standard_scaling = true
	self.display_col_2_button:SetOnClick(function()
			self.colums_setting = 2
			self:SetGrid()
		end)

	self.display_col_3_button = self.root:AddChild(ImageButton("images/scrapbook.xml", "sort3.tex"))
	self.display_col_3_button:SetPosition(220+(SEARCH_BOX_WIDTH/2)+28+28+28, PANEL_HEIGHT/2 +33)
	self.display_col_3_button:ForceImageSize(25,25)	
	self.display_col_3_button.scale_on_focus = false
	self.display_col_3_button.focus_scale = {1.1,1.1,1.1}
	self.display_col_3_button.ignore_standard_scaling = true
	self.display_col_3_button:SetOnClick(function()
			self.colums_setting = 3
			self:SetGrid()
		end)

	self.display_col_grid_button = self.root:AddChild(ImageButton("images/scrapbook.xml", "sort4.tex"))
	self.display_col_grid_button:SetPosition(220+(SEARCH_BOX_WIDTH/2)+28+28+28+28, PANEL_HEIGHT/2 +33)
	self.display_col_grid_button:ForceImageSize(25,25)	
	self.display_col_grid_button.scale_on_focus = false
	self.display_col_grid_button.focus_scale = {1.1,1.1,1.1}
	self.display_col_grid_button.ignore_standard_scaling = true
	self.display_col_grid_button:SetOnClick(function()
			self.colums_setting = 7
			self:SetGrid()
		end)

	self.topbuttons = {}
	table.insert(self.topbuttons, self.searchbox)
	table.insert(self.topbuttons, self.display_col_1_button)
	table.insert(self.topbuttons, self.display_col_2_button)
	table.insert(self.topbuttons, self.display_col_3_button)
	table.insert(self.topbuttons, self.display_col_grid_button)
end

function ScrapbookScreen:MakeBackButton()
	self.cancel_button = self.root:AddChild(TEMPLATES.BackButton(
		function()
			self:Close() --go back
		end))	
end

function ScrapbookScreen:Close(fn)
    TheFrontEnd:FadeBack(nil, nil, fn)
end

function ScrapbookScreen:GetData(name)
	if dataset[name] then
		return dataset[name]
	end
end

function ScrapbookScreen:BuildItemGrid()
	self.MISSING_STRINGS = {}
	local totalwidth = 450
	local columns = self.colums_setting
	local imagesize = 32
	local bigimagesize = 64
	local imagebuffer = 6
	local row_w = totalwidth/columns
	
	if columns > 3 then
 		imagesize = bigimagesize
 		imagebuffer = 12
 		row_w = imagesize
	end

	local row_h = imagesize

    local row_spacing = 5    
    local bg_padding = 3
    local name_pos = -5
    local catname_pos = 8

	table.sort(self.current_view_data, function(a, b)
		local a_name = STRINGS.NAMES[string.upper(a.name)] or FILLER
		local b_name = STRINGS.NAMES[string.upper(b.name)] or FILLER
		if a.subcat then a_name = STRINGS.SCRAPBOOK.SUBCATS[string.upper(a.subcat)] .. a_name end
		if b.subcat then b_name = STRINGS.SCRAPBOOK.SUBCATS[string.upper(b.subcat)] .. b_name end
		if not a_name or not b_name then
			return false
		end
		return a_name < b_name
	end)

	for i, data in ipairs(self.current_view_data) do
		data.index = i
	end

    local function ScrollWidgetsCtor(context, index)
        local w = Widget("recipe-cell-".. index)		

		----------------
		w.item_root = w:AddChild(Widget("item_root"))
				
		w.item_root.bg = w.item_root:AddChild(Image("images/global.xml", "square.tex"))
		w.item_root.bg:ScaleToSize(totalwidth+((row_spacing+bg_padding)*columns), row_h+bg_padding)
		w.item_root.bg:SetPosition(-(((columns-1)*.5) * row_w),0)
		w.item_root.bg:SetTint(1,1,1,0.1)

		w.item_root.button = w.item_root:AddChild(ImageButton("images/global.xml", "square.tex"))
		w.item_root.button:SetImageNormalColour(1,1,1,0)
		w.item_root.button:SetImageFocusColour(1,1,1,0.3)
		w.item_root.button.scale_on_focus = false
		w.item_root.button:ForceImageSize(row_w+bg_padding, row_h+bg_padding)

		w.item_root.image = w.item_root:AddChild(Image(GetScrapbookIconAtlas("cactus.tex"), "cactus.tex"))
		w.item_root.image:ScaleToSize(imagesize, imagesize)
		w.item_root.image:SetPosition((-row_w/2)+imagesize/2,0 )
		w.item_root.image:SetClickable(false)

		w.item_root.inv_image = w.item_root:AddChild(Image(GetScrapbookIconAtlas("cactus.tex"), "cactus.tex"))
		w.item_root.inv_image:ScaleToSize(imagesize-imagebuffer, imagesize-imagebuffer)
		w.item_root.inv_image:SetPosition((-row_w/2)+imagesize/2,0 )
		w.item_root.inv_image:SetClickable(false)
		w.item_root.inv_image:Hide()

		w.item_root.name = w.item_root:AddChild(Text(HEADERFONT, 18, "NAME OF CRITTER", UICOLOURS.WHITE))
		w.item_root.name:SetPosition((-row_w/2)+imagesize + 5 ,name_pos)

		w.item_root.catname = w.item_root:AddChild(Text(HEADERFONT, 10, "NAME OF CRITTER", UICOLOURS.GOLD))
		w.item_root.catname:SetPosition((-row_w/2)+imagesize + 5 ,catname_pos)

		w.item_root.flash =w.item_root:AddChild(UIAnim())
		w.item_root.flash:GetAnimState():SetBank("cookbook_newrecipe")
		w.item_root.flash:GetAnimState():SetBuild("cookbook_newrecipe")
		w.item_root.flash:GetAnimState():PlayAnimation("anim",true)
		w.item_root.flash:SetPosition((-row_w/2)+imagesize-(imagesize*0.1),0 )
		w.item_root.flash:Hide()
		w.item_root.flash:SetClickable(false)

		w.item_root.button:SetOnClick(function()

			if ThePlayer and ThePlayer.scrapbook_seen then
				if ThePlayer.scrapbook_seen[w.data.prefab] then
					ThePlayer.scrapbook_seen[w.data.prefab] = nil
					w.item_root.flash:Hide()
				end
			end

			self:updatemenubuttonflashes()

			self.detailsroot:KillAllChildren()
			self.details = nil
			self.details = self.detailsroot:AddChild(self:PopulateInfoPanel(w.data))
			self:DoFocusHookups()
		end)

		w.focus_forward = w.item_root.button

		w.item_root.button.ongainfocusfn = function()		
			self.item_grid:OnWidgetFocus(w)
		end

		----------------
		return w
    end

    local function ScrollWidgetSetData(context, widget, data, index)
    	
		widget.item_root.image:SetTint(1,1,1,1)
		widget.item_root.inv_image:SetTint(1,1,1,1)
		widget.item_root.flash:Hide()

		widget.data = data
		if data ~= nil and data.name ~= FILLER and data.type ~= UNKNOWN then
			widget.item_root.image:Show()			
			widget.item_root.button:Show()
			if columns <= 3 then
				widget.item_root.name:Show()							
			else
				widget.item_root.name:Hide()
			end									
			widget.item_root.catname:Hide()
			widget.item_root.inv_image:Hide()

			if data.type == "item" or data.type == "food" then
				widget.item_root.image:SetTexture("images/hud.xml", "inv_slot.tex")
				widget.item_root.image:ScaleToSize(imagesize, imagesize)
				widget.item_root.inv_image:Show()
				widget.item_root.inv_image:SetTexture(GetInventoryItemAtlas(data.tex), data.tex)
				widget.item_root.inv_image:ScaleToSize(imagesize-imagebuffer, imagesize-imagebuffer)
			else
				widget.item_root.image:SetTexture(GetScrapbookIconAtlas(data.tex) or GetScrapbookIconAtlas("cactus.tex"), data.tex or "cactus.tex")
			end

			if data.knownlevel == 1 then
				widget.item_root.inv_image:SetTint(UK_TINT[1],UK_TINT[2],UK_TINT[3],UK_TINT[4])
				widget.item_root.image:SetTint(UK_TINT[1],UK_TINT[2],UK_TINT[3],UK_TINT[4])
			end

			if columns <= 3 then
				local name = STRINGS.NAMES[string.upper(data.name)]
				local chars = 16
				if columns == 1 then
					chars = 64
				elseif columns == 2 then
					chars = 24
				end
				--maxcharsperline, ellipses, shrink_to_fit, min_shrink_font_size, linebreak_string)
				widget.item_root.name:SetMultilineTruncatedString(name,1,row_w-imagesize,chars,true)
				local tw, th = widget.item_root.name:GetRegionSize()
				widget.item_root.name:SetPosition((-row_w/2)+imagesize + 5 +(tw/2) ,name_pos)

				if data.subcat  then
					widget.item_root.catname:Show()
					local subcat = STRINGS.SCRAPBOOK.SUBCATS[string.upper(data.subcat)]
					widget.item_root.catname:SetMultilineTruncatedString(subcat.."/",1,row_w-imagesize,chars,true)
					local tw, th = widget.item_root.catname:GetRegionSize()
					widget.item_root.catname:SetPosition((-row_w/2)+imagesize + 5 +(tw/2) ,catname_pos)
				end
			end

			widget.item_root.button:SetOnClick(function()
				widget.item_root.flash:Hide()
				self:updatemenubuttonflashes()
				self.detailsroot:KillAllChildren()
				self.details = nil
				self.details = self.detailsroot:AddChild(self:PopulateInfoPanel(widget.data))
				self:DoFocusHookups()
				TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/scrapbook_pageflip")
			end)

		else
			if data and data.type == UNKNOWN then			
				widget.item_root.image:SetTexture(GetScrapbookIconAtlas("unknown.tex"), "unknown.tex")
				widget.item_root.image:Show()
				widget.item_root.image:SetTint(1,1,1,1)
				widget.item_root.flash:Hide()
				widget.item_root.image:ScaleToSize(imagesize, imagesize)
			else
				widget.item_root.image:Hide()
			end
			widget.item_root.button:SetOnClick(function() end)
			widget.item_root.name:Hide()
			widget.item_root.catname:Hide()
			widget.item_root.inv_image:Hide()			
		end	

		if data and data.name ~= FILLER and data.type ~= UNKNOWN then
			if not TheScrapbookPartitions:WasViewedInScrapbook(data.prefab) then
				widget.item_root.flash:Show()
			else				
				widget.item_root.flash:Hide()
			end
		end

		if columns > 3 then 
			widget.item_root.bg:Hide()
		else
			if index % (columns *2) ~= 0 then
				widget.item_root.bg:Hide()
			else
				widget.item_root.bg:Show()
			end	
		end
    end

    local grid = TEMPLATES.ScrollingGrid(
        {},
        {
            context = {},
            widget_width  = row_w+row_spacing,
            widget_height = row_h+row_spacing,
			force_peek    = true,
            num_visible_rows = imagesize == bigimagesize and 7 or 13,
            num_columns      = columns,
            item_ctor_fn = ScrollWidgetsCtor,
            apply_fn     = ScrollWidgetSetData,
            scrollbar_offset = 20,
            scrollbar_height_offset = -60
        })

    return grid
end

function calculteRotatedHeight(angle,w,h)
	return math.sin(angle*DEGREES)*w  +  math.sin((90-angle)*DEGREES)*h
end

function calculteRotatedWidth(angle,w,h)
	return math.cos(angle*DEGREES)*w  +  math.cos((90-angle)*DEGREES)*h
end

function ScrapbookScreen:PopulateInfoPanel(data)
	primeRand(hash((data and data.name or "")..ThePlayer.userid))

    local page = Widget("page")
    if data then TheScrapbookPartitions:SetViewedInScrapbook(data.prefab) end
   	self:updatemenubuttonflashes()

    page:SetPosition(-PANEL_WIDTH/4 - 20,0)

    local sub_root = Widget("text_root")

	local width = PANEL_WIDTH/2-40

	local left = 0
	local height = 0
	local title_space = 5
	local section_space = 22
	
	local applytexturesize = function(widget,w,h, tex, source)
		local suffix = "_square"
		local ratio = w/h
		if ratio > 5 then
			suffix = "_thin"
		elseif ratio > 1 then
			suffix = "_wide"
		elseif ratio < 0.75 then
			suffix = "_tall"
		end

		local materials = {
			"scrap",
			"scrap2",
		}
		if not tex then 
			tex = materials[math.ceil(rand()*#materials)]..suffix.. ".tex"
		end
		if not source then
			source = "images/scrapbook.xml"
		end
		
		widget:SetTexture(source, tex, tex)
		widget:ScaleToSize(w,h)
	end

	local setattachmentdetils = function (widget,w,h, shortblock)
		local choice = rand()

		if choice < 0.4 and not shortblock then
			-- picture tabs		
			local mat = "corner.tex"
			if rand() < 0.5 then
				mat = "corner2.tex"
			end
			local tape1 = widget:AddChild(Image("images/scrapbook.xml", mat))
			tape1:SetScale(0.5)
			tape1:SetClickable(false)
			tape1:SetPosition(-w/2+15,-h/2+15)
			tape1:SetRotation(0)

			local tape2 = widget:AddChild(Image("images/scrapbook.xml", mat))
			tape2:SetScale(0.5)
			tape2:SetClickable(false)
			tape2:SetPosition(-w/2+15,h/2-15)
			tape2:SetRotation(90)		
			
			local tape3 = widget:AddChild(Image("images/scrapbook.xml", mat))
			tape3:SetScale(0.5)
			tape3:SetClickable(false)
			tape3:SetPosition(w/2-15,h/2-15)
			tape3:SetRotation(180)
			
			local tape4 = widget:AddChild(Image("images/scrapbook.xml", mat))
			tape4:SetScale(0.5)
			tape4:SetClickable(false)
			tape4:SetPosition(w/2-15,-h/2+15)
			tape4:SetRotation(270)	
		elseif choice < 0.7 then
			local tape1 = widget:AddChild(Image("images/scrapbook.xml", "tape".. math.ceil(rand()*2).."_centre.tex"))
			tape1:SetScale(0.5)
			tape1:SetClickable(false)
			tape1:SetPosition(0,h/2)
			tape1:SetRotation(rand()*3- 1.5)
		elseif choice < 0.8 then
			--tape
			local diagonal = false
			local right = true
			if shortblock then
				if rand()<0.3 then
					diagonal = true
					if rand()<0.5 then
						right = false
					end
				end
			end
			if (rand() < 0.5 and not shortblock) or (diagonal==true and right==false) then
				local tape1 = widget:AddChild(Image("images/scrapbook.xml", "tape".. math.ceil(rand()*2).."_corner.tex"))
				tape1:SetScale(0.5)
				tape1:SetClickable(false)
				tape1:SetPosition(-w/2+5,-h/2+5)
				local rotation = -45
				tape1:SetRotation(rotation)
			end

			if not diagonal or right then
				local tape2 = widget:AddChild(Image("images/scrapbook.xml", "tape".. math.ceil(rand()*2).."_corner.tex"))
				tape2:SetScale(0.5)
				tape2:SetClickable(false)
				tape2:SetPosition(-w/2+5,h/2-5)
				local rotation = 45
				tape2:SetRotation(rotation)	
			end
			
			if not diagonal or right == false then
				local tape3 = widget:AddChild(Image("images/scrapbook.xml", "tape".. math.ceil(rand()*2).."_corner.tex"))
				tape3:SetScale(0.5)
				tape3:SetClickable(false)
				tape3:SetPosition(w/2-5,h/2-5)
				local rotation = 90 +45
				tape3:SetRotation(rotation)
			end

			if (rand() < 0.5 and not shortblock) or (diagonal==true and right==true) then
				local tape4 = widget:AddChild(Image("images/scrapbook.xml", "tape".. math.ceil(rand()*2).."_corner.tex"))
				tape4:SetScale(0.5)
				tape4:SetClickable(false)
				tape4:SetPosition(w/2-5,-h/2+5)
				local rotation = -90 - 45
				tape4:SetRotation(rotation)	
			end
		else
			local ropechoice = math.ceil(rand()*3)
			local rope = widget:AddChild(Image("images/scrapbook.xml", "rope".. ropechoice.."_corner.tex"))
			rope:SetScale(0.5)
			rope:SetClickable(false)
			if ropechoice == 1 then
				rope:SetPosition(-w/2+5,h/2-10)
			elseif ropechoice == 3 then
				rope:SetPosition(-w/2+5,h/2-13)
			else				
				rope:SetPosition(-w/2+13,h/2-16)
			end
		end
	end

	local settextblock = function (height, data) -- font, size, str, color,leftmargin,rightmargin, leftoffset, ignoreheightchange, widget
		assert(data.font and data.size and data.str and data.color, "Missing String Data")
		local targetwidget = data.widget and data.widget or sub_root 	
		local txt = targetwidget:AddChild(Text(data.font, data.size, data.str, data.color))
		txt:SetHAlign(ANCHOR_LEFT)
		txt:SetVAlign(ANCHOR_TOP)
		local subwidth = data.width or width 
		local adjustedwidth = subwidth - (data.leftmargin and data.leftmargin or 0) - (data.rightmargin and data.rightmargin or 0)
		txt:SetMultilineTruncatedString(data.str, 100, adjustedwidth, 60)
		local x, y = txt:GetRegionSize()
		local adjustedleft = left + (data.leftmargin and data.leftmargin or 0) + (data.leftoffset and data.leftoffset or 0)
		txt:SetPosition(adjustedleft + (0.5 * x) , height - (0.5 * y))
		if not data.ignoreheightchange then
			height = height - y - section_space
		end

		return height, txt
	end
	
	local setimageblock = function(height, data) -- source, tex, w,h,rotation,leftoffset, ignoreheightchange, widget)
		assert(data.source and data.tex, "Missing Image Data")
		local targetwidget = data.widget and data.widget or sub_root
		local img = targetwidget:AddChild(Image(data.source, data.tex))
		if data.w and data.h then
			applytexturesize(img,w,h, data.source, data.tex)
		end
		if data.rotation then 
			img:SetRotation(data.rotation)
		end
		local x, y = img:GetSize()		
		local truewidth = calculteRotatedWidth(data.rotation and data.rotation or 0,x,y)
		local trueheight = calculteRotatedHeight(data.rotation and data.rotation or 0,x,y)
		local adjustedoffset = data.leftoffset and data.leftoffset or  0
		img:SetPosition(left + truewidth + adjustedoffset, height - (0.5 * trueheight))
		img:SetClickable(false)
		if not data.ignoreheightchange then
			height = height - trueheight - section_space
		end

		return height, img
	end

	local setcustomblock = function(height,data)
		local panel = sub_root:AddChild(Widget("custompanel"))
		local bg
		height, bg = setimageblock(height,{ignoreheightchange=true, widget=panel, source="images/scrapbook.xml", tex="scrap_square.tex"})

		local shade = 0.8 + rand()*0.2
		bg:SetTint(shade,shade,shade,1)

		local MARGIN = data.margin and data.margin or 15
		local textblock
		height, textblock = settextblock(height, {str=data.str, width=data.width or nil, font=data.font or CHATFONT, size=data.size or 15, color=data.fontcolor or UICOLOURS.BLACK, leftmargin=MARGIN+50, rightmargin=MARGIN+50, leftoffset = -width/2, ignoreheightchange=true, widget=panel})
		local pos_t = textblock:GetPosition()
		textblock:SetPosition(0,0)

		local w,h= textblock:GetRegionSize()
		local boxwidth = w+(MARGIN*2)
		local widthdiff = 0
		if data.minwidth and boxwidth < data.minwidth then
			widthdiff = data.minwidth - boxwidth
			boxwidth = data.minwidth
		end
		
		applytexturesize(bg, boxwidth,h+(MARGIN*2))
		
		local angle =  data.norotation and 0 or rand()*3- 1.5
 		panel:SetRotation(angle)

		pos_t = textblock:GetPosition()
		bg:SetPosition(0,0)
 		
 		local attachments = panel:AddChild(Widget("attachments")) 	
 		attachments:SetPosition(0,0) 		
 		setattachmentdetils(attachments, boxwidth,h+(MARGIN*2), data.shortblock)
 		local newheight = calculteRotatedHeight(angle,boxwidth,h+(MARGIN*2))
 		--  
		panel:SetPosition( boxwidth/2 + (data.leftoffset or 0) ,height - (newheight/2) - (data.topoffset or 0))
		if not data.ignoreheightchange then
			height = height - newheight - section_space
		end
 		return height, panel, newheight
	end
	---------------------------------
	-- set the title
	local cattitle
	if data and data.subcat then
		local subcat = STRINGS.SCRAPBOOK.SUBCATS[string.upper(data.subcat)]
		height, cattitle = settextblock(height, {font=HEADERFONT, size=25, str= subcat.."/", color=UICOLOURS.GOLD,  ignoreheightchange=true})
	end

	local title
	local leftoffset = 0
	if cattitle then
		leftoffset = cattitle:GetRegionSize()
	end

	local name = data and STRINGS.NAMES[string.upper(data.name)] or ""
	height, title = settextblock(height, {font=HEADERFONT, size=25, str=name, color=UICOLOURS.WHITE, leftoffset=leftoffset})

	------------------------------------

	height = height  - 10

	-- set the photo
	local rotation = (rand() * 5)-2.5

	--------------------------------------------------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------------------------------------------------------

	local CUSTOM_SIZE = Vector3(150,250,0)	
	local CUSTOM_ANIMOFFSET = Vector3(0,-40,0)
	local CUSTOM_INDENT = 40 + (rand() * 25)

	local STAT_PANEL_WIDTH = 220
	local STAT_PANEL_INDENT = 30
	local STAT_GAP_SMALL = 5
	local STAT_ICONSIZE = 32	

	local stats,statsheight
	
	local statwidget = 	sub_root:AddChild(Widget("statswidget"))
	local statbg = statwidget:AddChild(Image("images/fepanel_fills.xml", "panel_fill_large.tex"))
	local statsheight = 0
	statsheight = statsheight - STAT_PANEL_INDENT
	
	local showstats = false
	local makeentry = function(tex,text)
		showstats = true
		if tex then
			local icon = statwidget:AddChild(Image(GetScrapbookIconAtlas(tex) or GetScrapbookIconAtlas("cactus.tex"), tex))
			icon:ScaleToSize(STAT_ICONSIZE,STAT_ICONSIZE)
			icon:SetPosition(STAT_PANEL_INDENT+(STAT_ICONSIZE/2), statsheight-STAT_ICONSIZE/2)		
		end
		local txt = statwidget:AddChild(Text(HEADERFONT, 18, text, UICOLOURS.BLACK))
		local tw, th = txt:GetRegionSize()
		txt:SetPosition(STAT_PANEL_INDENT+STAT_ICONSIZE + STAT_GAP_SMALL + (tw/2), statsheight-STAT_ICONSIZE/2 )
		statsheight = statsheight - STAT_ICONSIZE - STAT_GAP_SMALL
	end
	local makesubentry = function(text)
		showstats = true
		local txt = statwidget:AddChild(Text(HEADERFONT, 12, text, UICOLOURS.BLACK))
		local tw, th = txt:GetRegionSize()
		txt:SetPosition(STAT_PANEL_INDENT+STAT_ICONSIZE + STAT_GAP_SMALL + (tw/2), statsheight+STAT_GAP_SMALL)
		statsheight = statsheight - STAT_GAP_SMALL
	end

	local makesubiconentry = function(tex,subwidth,text)
		showstats = true
		local icon = statwidget:AddChild(Image(GetScrapbookIconAtlas(tex) or GetScrapbookIconAtlas("cactus.tex"), tex))
		icon:ScaleToSize(STAT_ICONSIZE,STAT_ICONSIZE)
		icon:SetPosition(STAT_PANEL_INDENT+ subwidth +(STAT_ICONSIZE/2), statsheight+STAT_GAP_SMALL+(STAT_ICONSIZE/2) )
		local txt = statwidget:AddChild(Text(HEADERFONT, 18, text, UICOLOURS.BLACK))
		local tw, th = txt:GetRegionSize()
		txt:SetPosition(STAT_PANEL_INDENT+ subwidth +STAT_ICONSIZE + (tw/2), statsheight+STAT_GAP_SMALL+(STAT_ICONSIZE/2) )		--+ STAT_GAP_SMALL 
		subwidth = subwidth + STAT_ICONSIZE+ tw
		return subwidth
	end

	---------------------------------------------
	if data then

		if data.health then
			makeentry("icon_health.tex", tostring(math.floor(data.health)))
		end

		if data.damage then
			makeentry("icon_damage.tex", tostring(checknumber(data.damage) and math.floor(data.damage) or data.damage))
		end

		if data.sanityaura then
			local sanitystr = ""
			if data.sanityaura >= TUNING.SANITYAURA_HUGE then
				sanitystr = STRINGS.SCRAPBOOK.SANITYDESC.POSHIGH
			elseif data.sanityaura >= TUNING.SANITYAURA_MED then
				sanitystr = STRINGS.SCRAPBOOK.SANITYDESC.POSMED
			elseif data.sanityaura > 0 then
				sanitystr = STRINGS.SCRAPBOOK.SANITYDESC.POSSMALL
			elseif data.sanityaura == 0 then
				sanitystr = nil
			elseif data.sanityaura > -TUNING.SANITYAURA_MED then
				sanitystr = STRINGS.SCRAPBOOK.SANITYDESC.NEGSMALL
			elseif data.sanityaura > -TUNING.SANITYAURA_HUGE then
				sanitystr = STRINGS.SCRAPBOOK.SANITYDESC.NEGMED
			else
				sanitystr = STRINGS.SCRAPBOOK.SANITYDESC.NEGHIGH
			end
			if sanitystr then
				makeentry("icon_sanity.tex",sanitystr)
			end
		end

		if data.type == "item" or data.type == "food" then
			if data.stacksize then
				makeentry("icon_stack.tex",data.stacksize..STRINGS.SCRAPBOOK.DATA_STACK)
			end
		end

		local showfood = true 
		if data.hungervalue and data.hungervalue == 0 and
			data.healthvalue and data.healthvalue == 0 and
			data.sanityvalue and data.sanityvalue == 0 then
			showfood = false
		end
--[[
		if data.foodtype == FOODTYPE.ELEMENTAL or data.foodtype == FOODTYPE.ROUGHAGE or data.foodtype == FOODTYPE.HORRIBLE then
			showfood = false
		end
]]
		if showfood and data.foodtype and data.foodtype ~= FOODTYPE.GENERIC then
			local str = STRINGS.SCRAPBOOK.FOODTYPE[data.foodtype]
			makeentry("icon_food.tex",str)
		end

		if data.hungervalue and showfood then
			local str = data.hungervalue
			if data.hungervalue > 0 then
				str = "+".. str
			end
			makeentry("icon_hunger.tex",str)
		end
		if data.healthvalue and showfood then
			local str = data.healthvalue
			if data.healthvalue> 0 then
				str = "+".. str
			end		
			makeentry("icon_health.tex",str)
		end
		if data.sanityvalue and showfood then
			local str = data.sanityvalue
			if data.sanityvalue> 0 then
				str = "+".. str
			end		
			makeentry("icon_sanity.tex",str)
		end

		if data.weapondamage then
			makeentry("icon_damage.tex",math.floor(data.weapondamage))
			if data.planardamage then
				makesubentry("+"..math.floor(data.planardamage) .. STRINGS.SCRAPBOOK.DATA_PLANAR_DAMAGE)
			end

			if data.weaponrange then
				statsheight = statsheight - STAT_GAP_SMALL -2
				makesubentry("+"..math.floor(data.weaponrange) .. STRINGS.SCRAPBOOK.DATA_RANGE)
			end
		end

		if data.finiteuses then
			makeentry("icon_uses.tex",math.floor(data.finiteuses)..STRINGS.SCRAPBOOK.DATA_USES)
		end

		if data.toolactions then
			local actions = ""
			for i,action in ipairs(data.toolactions)do
				actions = actions .. action
				if i ~= #data.toolactions then
					actions = actions .. ", "
				end
			end
			makesubentry(actions)
		end

		if data.armor then
			makeentry("icon_armor.tex",math.floor(data.armor))
		end

		if data.absorb_percent then
			makesubentry(STRINGS.SCRAPBOOK.DATA_ARMOR_ABSORB..(data.absorb_percent*100).. "%")
		end

		if data.armor_planardefence then
			if data.absorb_percent then
				statsheight = statsheight - STAT_GAP_SMALL -2
			end
			makesubentry("+"..data.armor_planardefence ..STRINGS.SCRAPBOOK.DATA_PLANAR_DEFENSE)
		end

		if data.waterproofer then
			makeentry("icon_wetness.tex",STRINGS.SCRAPBOOK.DATA_WETNESS ..(data.waterproofer*100) .. "%")
		end	

		if data.insulator then
			local icon = "icon_cold.tex"
			if data.insulator_type and data.insulator_type == SEASONS.SUMMER then
				icon = "icon_heat.tex"
			end
			makeentry(icon,data.insulator)
		end	

		if data.dapperness and data.dapperness ~= 0 then
			local dir = "+"
			if data.dapperness < 0 then
				dir = ""
			end
			makeentry("icon_sanity.tex",dir..math.floor((data.dapperness)*100)/100 .. STRINGS.SCRAPBOOK.DATA_PERSEC )
		end	

	 	-- FUEL + FUEL TYPES
		if data.fueledrate and data.fueledmax then
			local icon = "icon_needfuel.tex"
			if data.fueledtype1 and data.fueledtype1 == FUELTYPE.USAGE then
				icon = "icon_clothing.tex"
			end

			local days =math.floor((data.fueledmax/data.fueledrate)/60/8*100)/100

			if data.fueledtype1 and data.fueledtype1 == FUELTYPE.USAGE then
				makeentry(icon, days .. STRINGS.SCRAPBOOK.DATA_DAYS)
			else
				makeentry(icon," ")
			end

			local subwidth = STAT_ICONSIZE + STAT_GAP_SMALL

			if data.fueledtype1 and data.fueledtype1 ~= FUELTYPE.USAGE then
				local icon = nil
				if data.fueledtype1 == FUELTYPE.BURNABLE then
					icon = "icon_fuel_burnable.tex" --STRINGS.SCRAPBOOK.DATA_FUELTYPE .. data.fueltype .." ".. data.fuelvalue
				elseif data.fueledtype1 == FUELTYPE.CAVE then
					icon = "icon_fuel_cavelight.tex"
				elseif data.fueledtype1 == FUELTYPE.NIGHTMARE then
					icon = "icon_fuel_nightmare.tex"
				elseif data.fueledtype1 == FUELTYPE.MAGIC then
					icon = "icon_fuel_magic.tex"
				elseif data.fueledtype1 == FUELTYPE.CHEMICAL then
					icon = "icon_fuel_chemical.tex"	
				elseif data.fueledtype1 == FUELTYPE.WORMLIGHT then
					icon = "icon_fuel_wormlight.tex"
				end

				if data.fueledtype2 then
					subwidth = subwidth + STAT_ICONSIZE/3
				end
				if icon then
					makesubiconentry(icon,subwidth, days.. STRINGS.SCRAPBOOK.DATA_DAYS) --STRINGS.SCRAPBOOK.DATA_FUELTYPE .. data.fueltype .." ".. data.fuelvalue
				end
			end

			local subwidth = STAT_ICONSIZE + STAT_GAP_SMALL -STAT_ICONSIZE/4
			if data.fueledtype2 and data.fueledtype2 ~= FUELTYPE.USAGE then
				local icon = nil
				if data.fueledtype2 == FUELTYPE.BURNABLE then
					icon = "icon_fuel_burnable.tex" --STRINGS.SCRAPBOOK.DATA_FUELTYPE .. data.fueltype .." ".. data.fuelvalue
				elseif data.fueledtype2 == FUELTYPE.CAVE then
					icon = "icon_fuel_cavelight.tex"
				elseif data.fueledtype2 == FUELTYPE.NIGHTMARE then
					icon = "icon_fuel_nightmare.tex"
				elseif data.fueledtype2 == FUELTYPE.MAGIC then
					icon = "icon_fuel_magic.tex"
				elseif data.fueledtype2 == FUELTYPE.CHEMICAL then
					icon = "icon_fuel_chemical.tex"	
				elseif data.fueledtype2 == FUELTYPE.WORMLIGHT then
					icon = "icon_fuel_wormlight.tex"
				end
				if icon then
					makesubiconentry(icon,subwidth, "") --STRINGS.SCRAPBOOK.DATA_FUELTYPE .. data.fueltype .." ".. data.fuelvalue
				end
			end	
		end	

		if data.fueltype and data.fuelvalue then
			makeentry("icon_fuel.tex","") --STRINGS.SCRAPBOOK.DATA_FUELTYPE .. data.fueltype .." ".. data.fuelvalue
			local subwidth = STAT_ICONSIZE + STAT_GAP_SMALL
			local icon= nil
			if data.fueltype == FUELTYPE.BURNABLE then
				icon = "icon_fuel_burnable.tex" --STRINGS.SCRAPBOOK.DATA_FUELTYPE .. data.fueltype .." ".. data.fuelvalue
			elseif data.fueltype == FUELTYPE.CAVE then
				icon = "icon_fuel_cavelight.tex"
			elseif data.fueltype == FUELTYPE.NIGHTMARE then
				icon = "icon_fuel_nightmare.tex"
			elseif data.fueltype == FUELTYPE.MAGIC then
				icon = "icon_fuel_magic.tex"
			elseif data.fueltype == FUELTYPE.CHEMICAL then
				icon = "icon_fuel_chemical.tex"	
			elseif data.fueltype == FUELTYPE.WORMLIGHT then
				icon = "icon_fuel_wormlight.tex"
			end
			if icon then
				subwidth = makesubiconentry(icon,subwidth,data.fuelvalue)
			end
		end		

		if data.sewable then
			makeentry("icon_sewingkit.tex",STRINGS.SCRAPBOOK.DATA_SEWABLE )
		end

		-- PERISHABLE
		if data.perishable then
			makeentry("icon_spoil.tex",data.perishable/60/8 ..STRINGS.SCRAPBOOK.DATA_DAYS)
		end	

		-- NOTES
		if data.notes then
			if data.notes.shadow_aligned then
				makeentry("icon_shadowaligned.tex",STRINGS.SCRAPBOOK.NOTE_SHADOW_ALIGNED)
			end
			if data.notes.lunar_aligned then
				makeentry("icon_moonaligned.tex",STRINGS.SCRAPBOOK.NOTE_LUNAR_ALIGNED)
			end
		end

		if data.lightbattery then
			makeentry("icon_lightbattery.tex",STRINGS.SCRAPBOOK.DATA_LIGHTBATTERY)
		end

		if data.float_range and data.float_accuracy  then
			makeentry("icon_bobber.tex",STRINGS.SCRAPBOOK.DATA_FLOAT_RANGE ..data.float_range)
			makesubentry(STRINGS.SCRAPBOOK.DATA_FLOAT_ACCURACY..data.float_accuracy)
		end

		if data.lure_charm and data.lure_dist and data.lure_radius then
			makeentry("icon_lure.tex",STRINGS.SCRAPBOOK.DATA_LURE_RADIUS ..data.lure_radius)
			makesubentry(STRINGS.SCRAPBOOK.DATA_LURE_CHARM..data.lure_charm)
			statsheight = statsheight - STAT_GAP_SMALL -2
			makesubentry(STRINGS.SCRAPBOOK.DATA_LURE_DIST..data.lure_dist)
		end

		if data.oar_force and data.oar_velocity then
			makeentry("icon_oar.tex", STRINGS.SCRAPBOOK.DATA_OAR_VELOCITY.. data.oar_velocity)
			makesubentry(STRINGS.SCRAPBOOK.DATA_OAR_FORCE.. data.oar_force)
		end
	end

	---------------------------------------------

	statsheight = statsheight - (STAT_PANEL_INDENT - STAT_GAP_SMALL)

	applytexturesize(statbg,STAT_PANEL_WIDTH,math.abs(statsheight))

	local attachments = statwidget:AddChild(Widget("attachments"))
	attachments:SetPosition(STAT_PANEL_WIDTH/2,-math.abs(statsheight)/2)
	statbg:SetPosition(STAT_PANEL_WIDTH/2,-math.abs(statsheight)/2)
	setattachmentdetils(attachments, STAT_PANEL_WIDTH,math.abs(statsheight))

	--------------------------------------------------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------------------------------------------------------

	local photostack = sub_root:AddChild(Widget("photostack"))
	local photo = photostack:AddChild(Image("images/fepanel_fills.xml", "panel_fill_large.tex"))
	
	photo:SetClickable(false)
	local BUFFER = 35
	local ACTUAL_X = CUSTOM_SIZE.x
	local ACTUAL_Y = CUSTOM_SIZE.y	
	local offsety = 0
	local offsetx = 0
	local animal = nil
	if data then 
    	animal = photostack:AddChild(UIAnim())
		animal:GetAnimState():SetBuild(data.build)
		animal:GetAnimState():SetBank(data.bank)
		animal:GetAnimState():SetPercent(data.anim,rand())
		if data.scrapbook_setanim then
			animal:GetAnimState():SetPercent(data.anim,data.scrapbook_setanim)
		end

		if data.scrapbook_overridebuild then
			animal:GetAnimState():AddOverrideBuild(data.scrapbook_overridebuild)
		end

		animal:GetAnimState():Hide("snow")

		if data.scrapbook_hide then
			for i,hide in ipairs(data.scrapbook_hide) do
				animal:GetAnimState():Hide(hide)
			end
		end

		local x1, y1, x2, y2 = animal:GetAnimState():GetVisualBB()

		local ax,ay = animal:GetBoundingBoxSize()

		local SCALE = CUSTOM_SIZE.x/ax 

		if ay*SCALE >= ACTUAL_Y then
			SCALE = ACTUAL_Y/ay 
			ACTUAL_X = ax*SCALE
		else
			ACTUAL_Y = ay*SCALE
		end

		SCALE = SCALE*(data.scrapbook_scale or 1)
   
		animal:SetScale(math.min(0.5,SCALE))
 		offsety = ACTUAL_Y/2 -(y2*SCALE)
 		offsetx = ACTUAL_X/2 -(x2*SCALE)
	else
		animal = photostack:AddChild(Image("images/scrapbook.xml", "icon_empty.tex"))
		ACTUAL_X = CUSTOM_SIZE.x
		ACTUAL_Y = CUSTOM_SIZE.x/379*375
		animal:ScaleToSize(ACTUAL_X,ACTUAL_Y)
		offsetx = 0
		offsety = 0
	end

    local extraoffsetbgx = data and data.animoffsetbgx or 0
    local extraoffsetbgy = data and data.animoffsetbgy or 0

    local BG_X = (ACTUAL_X + BUFFER+ extraoffsetbgx)
    local BG_Y = (ACTUAL_Y + BUFFER+ extraoffsetbgy)

	applytexturesize(photo,BG_X, BG_Y)
	setattachmentdetils(photostack, BG_X, BG_Y)

    animal:SetClickable(false)

   	if data and data.overridesymbol then
	    if type(data.overridesymbol[1]) ~= "table" then
	    	animal:GetAnimState():OverrideSymbol(data.overridesymbol[1], data.overridesymbol[2], data.overridesymbol[3])
	    else
	    	for i,set in ipairs( data.overridesymbol ) do
	    		animal:GetAnimState():OverrideSymbol(set[1], set[2], set[3])
	    	end
	    end
	end

    CUSTOM_ANIMOFFSET = Vector3(offsetx,-offsety,0)
    local extraoffsetx = data and data.animoffsetx or 0
    local extraoffsety = data and data.animoffsety or 0    

    local posx =(CUSTOM_ANIMOFFSET.x+extraoffsetx) *(data and data.scrapbook_scale or 1)
    local posy =(CUSTOM_ANIMOFFSET.y+extraoffsety) *(data and data.scrapbook_scale or 1)

    animal:SetPosition(posx,posy)

    if data and data.knownlevel == 1 then
    	animal:GetAnimState():SetSaturation(0)
    	photo:SetTint(UK_TINT[1],UK_TINT[2],UK_TINT[3],UK_TINT[4])
    end

    photostack:SetRotation(rotation)

    local rotheight = calculteRotatedHeight(rotation,ACTUAL_X, ACTUAL_Y)
	local rotwidth = calculteRotatedWidth(rotation,ACTUAL_X, ACTUAL_Y)

	if statwidget then
	    local pos_s = statwidget:GetPosition()

	   statwidget:SetPosition(rotwidth+ CUSTOM_INDENT +30 ,height)
	end
	if not showstats or (data and data.knownlevel < 2) then
		statwidget:Hide()
	end

	height = height - 20

    photostack:SetPosition(left + (rotwidth/2) + CUSTOM_INDENT, height - (0.5 * rotheight)-(extraoffsetbgy/2))

	local finalheight = ( (rotheight+20 > math.abs(statsheight)) or (data and data.knownlevel < 2) ) and rotheight+20 or math.abs(statsheight)

    height = height - finalheight - section_space -(extraoffsetbgy/2)

	if data and data.knownlevel == 1 then
		local inspectbody 
		height, inspectbody = setcustomblock(height,{str=STRINGS.SCRAPBOOK.DATA_NEEDS_INVESTIGATION, minwidth=width-100, leftoffset=40, shortblock=true})
	end
	if not data then
		local inspectbody 
		height, inspectbody = setcustomblock(height,{str=" \n \n \n \n \n ", minwidth=width-100, leftoffset=40,})
	end


------------------------ SPECIAL INFO -------------------------------
	
	if data and data.specialinfo and STRINGS.SCRAPBOOK.SPECIALINFO[data.specialinfo] and data.knownlevel > 1 then
		local body
		local shortblock = string.len(STRINGS.SCRAPBOOK.SPECIALINFO[data.specialinfo]) < 110
		height, body = setcustomblock(height,{str=STRINGS.SCRAPBOOK.SPECIALINFO[data.specialinfo], minwidth=width-100, leftoffset=40, shortblock=shortblock})
	end

----------------------- DEPS -----------------------------------------
	self.depsbuttons = {}
    local DEPS_COLS = 7
    if data and data.deps and #data.deps>0 then
		
    	local idx = 1
    	local row= 1
    	local cols = DEPS_COLS --5
    	local gaps = 7 --10
    	local imagesize = 32
    	local depstoshow = {}
    	if #data.deps > 0 then
    		for i,dep in ipairs(data.deps) do

				local ok = false
				if self.menubuttons then
					for i, button in ipairs (self.menubuttons) do
						if self:GetData(dep) and button.filter == self:GetData(dep).type then
							ok = true
							break
						end
					end
				else
					ok = true
				end

    			if self:GetData(dep) and self:GetData(dep).knownlevel > 0 and ok then 
    				table.insert(depstoshow,dep)
    			end
    		end
    	end

		table.sort(depstoshow, function(a, b)
			local a = self:GetData(a)
			local b = self:GetData(b)

			local a_name = STRINGS.NAMES[string.upper(a.name)]
			local b_name = STRINGS.NAMES[string.upper(b.name)]
			if a.subcat then a_name = STRINGS.SCRAPBOOK.SUBCATS[string.upper(a.subcat)] .. a_name end
			if b.subcat then b_name = STRINGS.SCRAPBOOK.SUBCATS[string.upper(b.subcat)] .. b_name end
			if not a_name or not b_name then
				return false
			end
			return a_name < b_name
		end)

    	if #depstoshow > 0 then
		    for i, dep in ipairs(depstoshow)do
		    	local xidx = i%cols
			    if xidx == 0 then
			    	xidx = cols
			    end
		    	if self:GetData(dep) then
		    		local button = nil
			    	if self:GetData(dep).type == "item" or self:GetData(dep).type == "food" then
			    		button = sub_root:AddChild(ImageButton("images/hud.xml", "inv_slot.tex"))

			    		local img = button:AddChild(Image(GetInventoryItemAtlas( self:GetData(dep).tex ),  self:GetData(dep).tex ))
						button.ignore_standard_scaling = true
						button.scale_on_focus = true
						img:ScaleToSize(imagesize,imagesize)
						button:SetPosition(100+((imagesize+gaps)*(xidx-1)),height-imagesize/2 - ((row-1)*(imagesize+gaps)) )
						button:ForceImageSize(imagesize+2,imagesize+2)
						button:SetOnClick(function()
							self.detailsroot:KillAllChildren()
							self.details = nil
							self.details = self.detailsroot:AddChild(self:PopulateInfoPanel(self:GetData(dep)))
							self:DoFocusHookups()
							self.details:SetFocus()
						end)

						if self:GetData(dep).knownlevel == 1 then
							button:SetImageNormalColour(UK_TINT[1],UK_TINT[2],UK_TINT[3],UK_TINT[4])
							button:SetImageFocusColour(UK_TINT[1],UK_TINT[2],UK_TINT[3],UK_TINT[4])
						end
			    	else
						button = sub_root:AddChild(ImageButton(GetScrapbookIconAtlas(self:GetData(dep).tex) or GetScrapbookIconAtlas("cactus.tex"), self:GetData(dep).tex  )) --self:GetData(dep).tex
						
						button.ignore_standard_scaling = true
						button.scale_on_focus = true
						button:ForceImageSize(imagesize+2,imagesize+2)
						button:SetPosition(100+((imagesize+gaps)*(xidx-1)),height-imagesize/2 - ((row-1)*(imagesize+gaps)) )
						button:SetOnClick(function()
							self.detailsroot:KillAllChildren()
							self.details = nil
							self.details = self.detailsroot:AddChild(self:PopulateInfoPanel(self:GetData(dep)))
							self:DoFocusHookups()
							self.details:SetFocus()
						end)
						if self:GetData(dep).knownlevel == 1 then
							button:SetImageNormalColour(UK_TINT[1],UK_TINT[2],UK_TINT[3],UK_TINT[4])
							button:SetImageFocusColour(UK_TINT[1],UK_TINT[2],UK_TINT[3],UK_TINT[4])
						end
					end					
					table.insert(self.depsbuttons,button)
				end				
				if xidx == cols and i< #depstoshow then
					row = row +1
				end
			end
		
			height = height - ((imagesize+gaps) * row) -section_space
		end
	end

	if #self.depsbuttons > 0 then

		for i,button in ipairs(self.depsbuttons) do
			if i > DEPS_COLS then
				button:SetFocusChangeDir(MOVE_UP,							function(button) return self.depsbuttons[i-DEPS_COLS] end)
			end
			if i%DEPS_COLS ~= 1 then
				button:SetFocusChangeDir(MOVE_LEFT,							function(button) return self.depsbuttons[i-1] end)
			end
			if i%DEPS_COLS ~= 0 then
				button:SetFocusChangeDir(MOVE_RIGHT,						function(button) return self.depsbuttons[i+1] end)	
			end
			if i+DEPS_COLS <= #self.depsbuttons then
				button:SetFocusChangeDir(MOVE_DOWN,							function(button) return self.depsbuttons[i+DEPS_COLS] end)
			end
		end

	end

	------------------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------
	if data then
		if STRINGS.RECIPE_DESC[string.upper(data.prefab)] then

			local STAT_PANEL_WIDTH = width -40
			local STAT_PANEL_INDENT = 20
			local STAT_GAP_SMALL = 5
			local STAT_ICONSIZE = 40

			local recipewidget,recipeheight
			
			local recipewidget = sub_root:AddChild(Widget("statswidget"))
			local recipebg = recipewidget:AddChild(Image("images/fepanel_fills.xml", "panel_fill_large.tex"))
			local recipeheight = 0

			recipeheight = recipeheight - STAT_PANEL_INDENT

			local atlas,tex

			for cat,recdata in pairs(CRAFTING_FILTERS) do
				local breakout = false
				if recdata.recipes then

					if type(recdata.recipes) == "function" then
						recdata.recipes = recdata.recipes()
					end

					for idx,recipe in ipairs(recdata.recipes)do
						if recipe == data.prefab then
							atlas = recdata.atlas()
							tex = recdata.image
							breakout = true
							break
						end
					end
				end
				if breakout then 
					break
				end
			end

			if type(tex) == "function" then
				tex = tex(data.craftingprefab and {prefab=data.craftingprefab} or nil)
			end

			local makerecipeentry = function(tex,text)
				local icon = recipewidget:AddChild(Image(atlas, tex))
				icon:ScaleToSize(STAT_ICONSIZE,STAT_ICONSIZE)
				icon:SetPosition(STAT_PANEL_INDENT+(STAT_ICONSIZE/2), recipeheight-STAT_ICONSIZE/2)
				local txt = recipewidget:AddChild(Text(CHATFONT, 15, text, UICOLOURS.BLACK))
				txt:SetMultilineTruncatedString(text, 100, STAT_PANEL_WIDTH-(STAT_PANEL_INDENT*2), 60)
				local tw, th = txt:GetRegionSize()
				txt:SetPosition(STAT_PANEL_INDENT+STAT_ICONSIZE + STAT_GAP_SMALL + (tw/2), recipeheight-STAT_ICONSIZE/2 )				
				txt:SetHAlign(ANCHOR_LEFT)
				recipeheight = recipeheight - STAT_ICONSIZE - STAT_GAP_SMALL
			end

			local makerecipesubentry = function(text)
				local txt = recipewidget:AddChild(Text(CHATFONT, 15, text, UICOLOURS.BLACK))
				local tw, th = txt:GetRegionSize()
				txt:SetPosition(STAT_PANEL_WIDTH/2, recipeheight- (th/2) - STAT_GAP_SMALL)
				recipeheight = recipeheight - STAT_GAP_SMALL - th
			end

			local maketextentry = function(text)
				local txt = recipewidget:AddChild(Text(HEADERFONT, 15, text, UICOLOURS.BLACK))
				local tw, th = txt:GetRegionSize()
				txt:SetPosition(STAT_PANEL_WIDTH/2, recipeheight- (th/2) - STAT_GAP_SMALL)
				recipeheight = recipeheight - STAT_GAP_SMALL - th
			end

			---------------------------------------------

			maketextentry(STRINGS.SCRAPBOOK.DATA_CRAFTING)

			makerecipeentry(tex,STRINGS.RECIPE_DESC[string.upper(data.prefab)])

			--makerecipesubentry(STRINGS.RECIPE_DESC[string.upper(data.prefab)])

			---------------------------------------------
			recipeheight = recipeheight - (STAT_PANEL_INDENT - STAT_GAP_SMALL)

			applytexturesize(recipebg,STAT_PANEL_WIDTH,math.abs(recipeheight))

			local attachments = recipewidget:AddChild(Widget("attachments"))
			attachments:SetPosition(STAT_PANEL_WIDTH/2,-math.abs(recipeheight)/2)
			recipebg:SetPosition(STAT_PANEL_WIDTH/2,-math.abs(recipeheight)/2)
			setattachmentdetils(attachments, STAT_PANEL_WIDTH,math.abs(recipeheight))

			recipewidget:SetPosition( STAT_PANEL_INDENT ,height)  --rotwidth+ CUSTOM_INDENT +30

			local rotation = (rand() * 5)-2.5
			recipewidget:SetRotation(rotation)

		    local rotheight = calculteRotatedHeight(rotation,STAT_PANEL_WIDTH, math.abs(recipeheight))

		 	height = height - math.abs(rotheight) - (section_space*2)
		end
	end
	------------------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------

	if data then
		local character_panels = {}
		local viewed_characters = {}

		for i, char in ipairs(DST_CHARACTERLIST)do
			if TheScrapbookPartitions:WasInspectedByCharacter(data.prefab, char) then
				table.insert(viewed_characters, char)
			end
		end

		if data.knownlevel > 1 and STRINGS.CHARACTERS.GENERIC.DESCRIBE[string.upper(data.speechname or data.prefab)] and #viewed_characters > 0 then
			local row= 1
            local valid_index = 1
			for i, char in ipairs(viewed_characters)do

				local xidx = valid_index%9
			    if xidx == 0 then
			    	xidx = 9
			    end

				if char ~= "wonkey" then
					local body = nil
					local descstr = ""
					local descchar = string.upper(char)
					if char == "wilson" then
						descchar = "GENERIC"
					end

					local objstr = ""
					if char ~= "wes" then
						objstr = STRINGS.CHARACTERS[descchar].DESCRIBE[string.upper(data.speechname or data.prefab)]
					end

					if not objstr then
						objstr = STRINGS.CHARACTERS.GENERIC.DESCRIBE[string.upper(data.speechname or data.prefab)]
					end

					if type(objstr) == "table" then

						if #objstr > 0 then
							objstr = objstr[math.floor(rand()*#objstr)+1]
						elseif data.prefab == "blueprint" then
							objstr = objstr["COMMON"]
						elseif string.upper(data.speechname or data.prefab) == "WORM" then
							objstr = objstr["WORM"]
						elseif string.upper(data.speechname or data.prefab) == "MOLE" then
							objstr = objstr["ABOVEGROUND"]
						elseif string.upper(data.speechname or data.prefab) == "NIGHTMARE_TIMEPIECE" then
							objstr = objstr["WARN"]
						elseif string.upper(data.speechname or data.prefab) == "STAGEHAND" then
							objstr = objstr["HIDING"]
						elseif string.upper(data.speechname or data.prefab) == "STAGEUSHER" then
							objstr = objstr["SITTING"]							
						elseif data.prefab == "abigail" then
							objstr = objstr["LEVEL1"][1]
						else
							objstr = objstr["GENERIC"]
						end
					end

                    if objstr and objstr:find("only_used_by_") then
                        objstr = nil
                    end

					if objstr then
						descstr = descstr.. objstr
						descstr = descstr.. " - "..STRINGS.CHARACTER_NAMES[char]
						height, body = setcustomblock(height,{str=descstr, minwidth=width-100, leftoffset=40,ignoreheightchange=true, shortblock=true})
					end
					character_panels[char] = body
					if body then
                        body.id = i
						body:Hide()

						local button = sub_root:AddChild(ImageButton("images/crafting_menu_avatars.xml", "avatar_".. char ..".tex"))
						button:ForceImageSize(50,50)
						button.ignore_standard_scaling = true
						button.scale_on_focus = true
						button:SetOnClick(function()
							for t, subchar in ipairs(DST_CHARACTERLIST)do
								if character_panels[subchar] then
									character_panels[subchar]:Hide()
								end
							end
							character_panels[char]:Show()
						end)
						button:SetPosition(((width/(#DST_CHARACTERLIST/2)) *xidx) ,height-40 -((row)*50))
                        valid_index = valid_index + 1
					end
				end
				
				if xidx == 9 and valid_index< #DST_CHARACTERLIST then
					row = row +1
				end
			end
            local this_character_panel = character_panels[ThePlayer and TheScrapbookPartitions:WasInspectedByCharacter(data.prefab, ThePlayer.prefab) and ThePlayer.prefab or viewed_characters[1]]
			if this_character_panel then
				this_character_panel:Show()
				self.current_panel = this_character_panel.id
			end
		end
		self.character_panels = character_panels
		self.character_panels_total = #viewed_characters
	end

	height = height - 200

	height = math.abs(height)

	local max_visible_height = PANEL_HEIGHT -60  -- -20
	local padding = 5

	local top = math.min(height, max_visible_height)/2 - padding

	local scissor_data = {x = 0, y = -max_visible_height/2, width = width, height = max_visible_height}
	local context = {widget = sub_root, offset = {x = 0, y = top}, size = {w = width, height = height + padding} }
	local scrollbar = { scroll_per_click = 20*3 }
	self.scroll_area = page:AddChild(TrueScrollArea(context, scissor_data, scrollbar))
	
	if height < (PANEL_HEIGHT-60) then
		self.scroll_area:SetPosition(0,(((PANEL_HEIGHT-60)/2) - (height/2)) )
	end

	page.focus_forward = self.scroll_area
	if self.depsbuttons then
		self.scroll_area.focus_forward = self.depsbuttons[1]
	end

    return page
end

function ScrapbookScreen:CycleChraterQuotes(dir)
	if self.current_panel and self.character_panels and self.character_panels_total > 1 then

		for char,panel in pairs(self.character_panels) do
			if panel.id == self.current_panel then
				panel:Hide()
				break
			end
		end

		if dir == "left" then
			self.current_panel = self.current_panel -1 
			if self.current_panel < 1 then
				self.current_panel = 1
			end
		else
			self.current_panel = self.current_panel +1 
			if self.current_panel > self.character_panels_total then
				self.current_panel = self.character_panels_total
			end
		end		

		for char,panel in pairs(self.character_panels) do
			if panel.id == self.current_panel then
				panel:Show()
				break
			end
		end
	end
end

function ScrapbookScreen:OnControl(control, down)
    if ScrapbookScreen._base.OnControl(self, control, down) then return true end

    if not down then
	    if control == CONTROL_CANCEL then

			self:Close() --go back

			TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
			return true
		end

	    if control == CONTROL_PAUSE then

			if self.colums_setting == 1 then
				self.colums_setting = 2
			elseif self.colums_setting == 2 then
				self.colums_setting = 3
			elseif self.colums_setting == 3 then
				self.colums_setting = 7
			elseif self.colums_setting == 7 then
				self.colums_setting = 1
			end

			TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")

			self:SetGrid()

			return true
		end

	    if control == CONTROL_MENU_MISC_2 then
			TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")			
			self:SelectMenuItem("down")
			return true
		end	

	    if control == CONTROL_MAP then
			TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
			self:CycleChraterQuotes("right")
			return true
		end	

		if self.flashestoclear then
  			if control == CONTROL_CONTROLLER_ATTACK then
  				self.flashestoclear = nil
  				self:ClearFlashes()
				return true
			end	
		end

	end
end

function ScrapbookScreen:GetHelpText()
	local t = {}
	local controller_id = TheInput:GetControllerID()

	table.insert(t, TheInput:GetLocalizedControl(controller_id, CONTROL_CANCEL) .. " " .. STRINGS.UI.HELP.BACK)

	table.insert(t, TheInput:GetLocalizedControl(controller_id, CONTROL_MENU_MISC_2) .. " " .. STRINGS.SCRAPBOOK.CYCLE_CAT)

	if self.character_panels and self.character_panels_total>1 then
		table.insert(t, TheInput:GetLocalizedControl(controller_id, CONTROL_MAP).. " " .. STRINGS.SCRAPBOOK.CYCLE_QUOTES)
	end

	table.insert(t, TheInput:GetLocalizedControl(controller_id, CONTROL_PAUSE) .. " " .. STRINGS.SCRAPBOOK.CYCLE_VIEW)

	if self.searchbox.focus then
		table.insert(t, TheInput:GetLocalizedControl(controller_id, CONTROL_CONTROLLER_ACTION) .. " " .. STRINGS.SCRAPBOOK.SEARCH)
	end

	if self.flashestoclear then
		table.insert(t, TheInput:GetLocalizedControl(controller_id, CONTROL_CONTROLLER_ATTACK) .. " " .. STRINGS.SCRAPBOOK.CLEARFLASH)
	end

	return table.concat(t, "  ")
end

function ScrapbookScreen:DoFocusHookups()

	self.item_grid:SetFocusChangeDir(MOVE_UP,							function(w) return self.searchbox end)
	self.item_grid:SetFocusChangeDir(MOVE_LEFT,							function(w) return self.scroll_area or nil end)

	self.searchbox:SetFocusChangeDir(MOVE_DOWN,							function(w) return self.item_grid end)

	if self.scroll_area then
		self.scroll_area:SetFocusChangeDir(MOVE_RIGHT,					function(w) return self.item_grid end)
	end
	
end

function ScrapbookScreen:OnDestroy()
	SetAutopaused(false)
	self._base.OnDestroy(self)
end

function ScrapbookScreen:OnBecomeActive()
    ScrapbookScreen._base.OnBecomeActive(self)

    ThePlayer:PushEvent("scrapbookopened")
end

function ScrapbookScreen:OnBecomeInactive()
    ScrapbookScreen._base.OnBecomeInactive(self)
end

return ScrapbookScreen
