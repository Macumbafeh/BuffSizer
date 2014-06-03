local function log(msg) DEFAULT_CHAT_FRAME:AddMessage(msg) end -- alias for convenience

BuffSizerDB = BuffSizerDB or { buffSize = 25, debuffSize = 25, buffOffset = 2, debuffOffset = 2, type = "below" }
local SO = LibStub("LibSimpleOptions-1.0")

local BuffSizer = CreateFrame("Frame", "BuffSizer", UIParent)
function BuffSizer:OnEvent(event, ...) -- functions created in "object:method"-style have an implicit first parameter of "self", which points to object
	self[event](self, ...) -- route event parameters to Addon:event methods
end
BuffSizer:SetScript("OnEvent", BuffSizer.OnEvent)
BuffSizer:RegisterEvent("PLAYER_ENTERING_WORLD")
BuffSizer:RegisterEvent("PLAYER_LOGIN")

function BuffSizer:PLAYER_ENTERING_WORLD(...)
	self:CallBuffType()
end

function BuffSizer:PLAYER_LOGIN(...)
	self:CreateOptions()
end

function BuffSizer:CallBuffType()
	if BuffSizerDB.type == "below" then
		BuffSizer_Below()
	elseif BuffSizerDB.type == "TopBuffToDebuff" then
		BuffSizer_TopBuffToDebuff()
	elseif BuffSizerDB.type == "TopDebuffToBuff" then
		BuffSizer_TopDebuffToBuff()
	end
end

function BuffSizer:CreateOptions()
	local panel = SO.AddOptionsPanel("BuffSizer", function() end)
	self.panel = panel
	SO.AddSlashCommand("BuffSizer","/buffsizer")
	SO.AddSlashCommand("BuffSizer","/bsizer")
	SO.AddSlashCommand("BuffSizer","/bs")
	local title, subText = panel:MakeTitleTextAndSubText("BuffSizer", "General settings")
	local buffScale = panel:MakeSlider(
	     'name', 'Buff size',
	     'description', 'Set the size of buff icons',
	     'minText', '10',
	     'maxText', '50',
	     'minValue', 10,
	     'maxValue', 50,
	     'step', 1,
	     'default', 15,
	     'current', BuffSizerDB.buffSize,
	     'setFunc', function(value) BuffSizerDB.buffSize = value end,
	     'currentTextFunc', function(value) return string.format("%.2f",value) end)
	buffScale:SetPoint("TOPLEFT",subText,"TOPLEFT",16,-32)
	
	local debuffScale = panel:MakeSlider(
	     'name', 'Debuff size',
	     'description', 'Set the size of debuff icons',
	     'minText', '10',
	     'maxText', '50',
	     'minValue', 10,
	     'maxValue', 50,
	     'step', 1,
	     'default', 15,
	     'current', BuffSizerDB.debuffSize,
	     'setFunc', function(value) BuffSizerDB.debuffSize = value end,
	     'currentTextFunc', function(value) return string.format("%.2f",value) end)
	debuffScale:SetPoint("TOPLEFT",buffScale,"TOPRIGHT",16,0)
	
	local buffType = panel:MakeDropDown(
	    'name', 'Buff display type',
	    'description', 'Choose which way buffs are shown',
	    'values', {
	        'below', "Below",
	        'TopBuffToDebuff', "On top (buffs first)",
	        'TopDebuffToBuff', "On top (debuffs first)",
	     },
	    'default', 'below',
	    'current', BuffSizerDB.type,
	    'setFunc', function(value) BuffSizerDB.type = value BuffSizer:CallBuffType() end)
	buffType:SetPoint("TOPLEFT", buffScale, "BOTTOMLEFT", -15, -35)	
end