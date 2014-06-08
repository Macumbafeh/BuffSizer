local function log(msg) DEFAULT_CHAT_FRAME:AddMessage(msg) end -- alias for convenience

BuffSizerDB = BuffSizerDB or { targetbuffSize = 25, targetdebuffSize = 25, focusbuffSize = 25, focusdebuffSize = 25, buffOffset = 2, debuffOffset = 2, targetType = "below", focusType = "below" }
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
	if BuffSizerDB.targetType == "below" then
		BuffSizer_TargetBelow()
	elseif BuffSizerDB.targetType == "TopBuffToDebuff" then
		BuffSizer_TargetTopBuffToDebuff()
	elseif BuffSizerDB.targetType == "TopDebuffToBuff" then
		BuffSizer_TargetTopDebuffToBuff()
	end
	
	if BuffSizerDB.focusType == "below" then
		BuffSizer_FocusBelow()
	elseif BuffSizerDB.focusType == "TopBuffToDebuff" then
		BuffSizer_FocusTopBuffToDebuff()
	elseif BuffSizerDB.focusType == "TopDebuffToBuff" then
		BuffSizer_FocusTopDebuffToBuff()
	end
end

function BuffSizer:CreateOptions()
	local panel = SO.AddOptionsPanel("BuffSizer", function() end)
	self.panel = panel
	SO.AddSlashCommand("BuffSizer","/buffsizer")
	SO.AddSlashCommand("BuffSizer","/bsizer")
	SO.AddSlashCommand("BuffSizer","/bs")
	local title, subText = panel:MakeTitleTextAndSubText("BuffSizer", "General settings")
	local targetbuffScale = panel:MakeSlider(
	     'name', 'Target buff size',
	     'description', 'Set the size of buff icons',
	     'minText', '10',
	     'maxText', '50',
	     'minValue', 10,
	     'maxValue', 50,
	     'step', 1,
	     'default', 15,
	     'current', BuffSizerDB.targetbuffSize,
	     'setFunc', function(value) BuffSizerDB.targetbuffSize = value end,
	     'currentTextFunc', function(value) return string.format("%.2f",value) end)
	targetbuffScale:SetPoint("TOPLEFT",subText,"TOPLEFT",16,-32)
	
	local targetdebuffScale = panel:MakeSlider(
	     'name', 'Target debuff size',
	     'description', 'Set the size of debuff icons',
	     'minText', '10',
	     'maxText', '50',
	     'minValue', 10,
	     'maxValue', 50,
	     'step', 1,
	     'default', 15,
	     'current', BuffSizerDB.targetdebuffSize,
	     'setFunc', function(value) BuffSizerDB.targetdebuffSize = value end,
	     'currentTextFunc', function(value) return string.format("%.2f",value) end)
	targetdebuffScale:SetPoint("TOPLEFT",targetbuffScale,"TOPRIGHT",16,0)
	
	local targetbuffType = panel:MakeDropDown(
	    'name', 'Target buff display type',
	    'description', 'Choose which way buffs are shown',
	    'values', {
	        'below', "Below",
	        'TopBuffToDebuff', "On top (buffs first)",
	        'TopDebuffToBuff', "On top (debuffs first)",
	     },
	    'default', 'below',
	    'current', BuffSizerDB.targetType,
	    'setFunc', function(value) BuffSizerDB.targetType = value BuffSizer:CallBuffType() end)
	targetbuffType:SetPoint("TOPLEFT", targetbuffScale, "BOTTOMLEFT", -15, -35)

	local focusbuffScale = panel:MakeSlider(
	     'name', 'Focus buff size',
	     'description', 'Set the size of buff icons',
	     'minText', '10',
	     'maxText', '50',
	     'minValue', 10,
	     'maxValue', 50,
	     'step', 1,
	     'default', 15,
	     'current', BuffSizerDB.focusbuffSize,
	     'setFunc', function(value) BuffSizerDB.focusbuffSize = value end,
	     'currentTextFunc', function(value) return string.format("%.2f",value) end)
	focusbuffScale:SetPoint("TOPLEFT",targetbuffType,"TOPLEFT",16,-40)
	
	local focusdebuffScale = panel:MakeSlider(
	     'name', 'Focus debuff size',
	     'description', 'Set the size of debuff icons',
	     'minText', '10',
	     'maxText', '50',
	     'minValue', 10,
	     'maxValue', 50,
	     'step', 1,
	     'default', 15,
	     'current', BuffSizerDB.focusdebuffSize,
	     'setFunc', function(value) BuffSizerDB.focusdebuffSize = value end,
	     'currentTextFunc', function(value) return string.format("%.2f",value) end)
	focusdebuffScale:SetPoint("TOPLEFT",focusbuffScale,"TOPRIGHT",16,0)
	
	local focusbuffType = panel:MakeDropDown(
	    'name', 'Focus buff display type',
	    'description', 'Choose which way buffs are shown',
	    'values', {
	        'below', "Below",
	        'TopBuffToDebuff', "On top (buffs first)",
	        'TopDebuffToBuff', "On top (debuffs first)",
	     },
	    'default', 'below',
	    'current', BuffSizerDB.focusType,
	    'setFunc', function(value) BuffSizerDB.focusType = value BuffSizer:CallBuffType() end)
	focusbuffType:SetPoint("TOPLEFT", focusbuffScale, "BOTTOMLEFT", -15, -35)		
end