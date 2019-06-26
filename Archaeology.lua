local Revision = "@file-date-integer@"

local default_settings = {
	enabled = true,}
DBM_Archaeology_Settings = {}
local settings = default_settings

local L = DBM_Archaeology_Translations

local IsInInstance = IsInInstance
local mRandom = math.random

local soundFiles = {
	14376,--"Sound\\Creature\\YoggSaron\\AK_YoggSaron_HowlingFjordWhisper01.ogg"
	14377,--"Sound\\Creature\\YoggSaron\\AK_YoggSaron_HowlingFjordWhisper02.ogg",
	14378,--"Sound\\Creature\\YoggSaron\\AK_YoggSaron_HowlingFjordWhisper03.ogg",
	14379,--"Sound\\Creature\\YoggSaron\\AK_YoggSaron_HowlingFjordWhisper04.ogg",
	14380,--"Sound\\Creature\\YoggSaron\\AK_YoggSaron_HowlingFjordWhisper05.ogg",
	14381,--"Sound\\Creature\\YoggSaron\\AK_YoggSaron_HowlingFjordWhisper06.ogg",
	14382,--"Sound\\Creature\\YoggSaron\\AK_YoggSaron_HowlingFjordWhisper07.ogg",
	14383,--"Sound\\Creature\\YoggSaron\\AK_YoggSaron_HowlingFjordWhisper08.ogg",
	14372,--"Sound\\Creature\\YoggSaron\\AK_YoggSaron_Whisper01.ogg",
	14373,--"Sound\\Creature\\YoggSaron\\AK_YoggSaron_Whisper02.ogg",
	14374,--"Sound\\Creature\\YoggSaron\\AK_YoggSaron_Whisper03.ogg",
	14375,--"Sound\\Creature\\YoggSaron\\AK_YoggSaron_Whisper04.ogg",
	8580,--"Sound\\Creature\\CThun\\CThunDeathIsClose.ogg",
	8581,--"Sound\\Creature\\CThun\\CThunYouAreAlready.ogg",
	8582,--"Sound\\Creature\\CThun\\CThunYourCourage.ogg",
	8583,--"Sound\\Creature\\CThun\\CThunYourFriends.ogg",
	8584,--"Sound\\Creature\\CThun\\CThunYouWillBetray.ogg",
	8585,--"Sound\\Creature\\CThun\\CThunYouWillDIe.ogg",
	8586,--"Sound\\Creature\\CThun\\YouAreWeak.ogg"
	8587,--"Sound\\Creature\\CThun\\YourHeartWill.ogg",
}

-- functions
local addDefaultOptions
do 
	local function creategui()
		local createnewentry
		local CurCount = 0
		local panel = DBM_GUI:CreateNewPanel(L.TabCategory_Archaeology, "option")
		local generalarea = panel:CreateArea(L.AreaGeneral, nil, 100, true)
		
		do
			local area = generalarea
			local enabled = area:CreateCheckButton(L.Enable, true)
			enabled:SetScript("OnShow", function(self) self:SetChecked(settings.enabled) end)
			enabled:SetScript("OnClick", function(self) settings.enabled = not not self:GetChecked() end)

			local version = area:CreateText("r"..Revision, nil, nil, GameFontDisableSmall, "RIGHT")
			version:SetPoint("BOTTOMRIGHT", area.frame, "BOTTOMRIGHT", -5, 5)
		end
		panel:SetMyOwnHeight()
	end
	DBM:RegisterOnGuiLoadCallback(creategui, 19)
end

do
	local itemIds = {
		[52843] = true,
		[63127] = true,
		[63128] = true,
		[64392] = true,
		[64395] = true,
		[64396] = true,
		[64397] = true,
		[79868] = true,
		[79869] = true,
		[95373] = true,
		[109584] = true,
		[108439] = true,
		[109585] = true,
		--Legion
		[130903] = true,
		[130904] = true,
		[130905] = true,
		--BfA
		[154990] = true,
		[154989] = true,
	}
	function addDefaultOptions(t1, t2)
		for i, v in pairs(t2) do
			if t1[i] == nil then
				t1[i] = v
			elseif type(v) == "table" and type(t1[i]) == "table" then
				addDefaultOptions(t1[i], v)
			end
		end
	end

	local mainframe = CreateFrame("frame", "DBM_Archaeology", UIParent)
	local spamSound = 0
	mainframe:SetScript("OnEvent", function(self, event, ...)
		if event == "ADDON_LOADED" and select(1, ...) == "DBM-Archaeology" then
			self:RegisterEvent("CHAT_MSG_LOOT")
			self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
			-- Update settings of this Addon
			settings = DBM_Archaeology_Settings
			addDefaultOptions(settings, default_settings)

		elseif settings.enabled and event == "CHAT_MSG_LOOT" then
			if IsInInstance() then return end--There are no keystones in dungeons/raids so save cpu
			local lootmsg = select(1, ...)
			local player, itemID = lootmsg:match(L.DBM_LOOT_MSG)
			if player and itemID and itemIds[tonumber(itemID)] and GetTime() - spamSound >= 10 then
				local x = mRandom(1, #soundFiles)
				spamSound = GetTime()
				DBM:PlaySound(soundFiles[x])
			end

		elseif settings.enabled and event == "UNIT_SPELLCAST_SUCCEEDED" then
			local spellId = select(3, ...)
			if spellId == 91756 then--Puzzle Box of Yogg-Saron
				DBM:PlaySound(15757)--"Sound\\Creature\\YoggSaron\\UR_YoggSaron_Slay01.ogg"
			elseif spellId == 91754 then--Blessing of the Old God
				DBM:PlaySound(15759)--"Sound\\Creature\\YoggSaron\\UR_YoggSaron_Insanity01.ogg"
			end
		end
	end)
	mainframe:RegisterEvent("ADDON_LOADED")
end
