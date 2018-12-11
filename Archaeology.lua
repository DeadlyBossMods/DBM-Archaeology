local Revision = ("$Revision$"):sub(12, -3)

local default_settings = {
	enabled = true,}
DBM_Archaeology_Settings = {}
local settings = default_settings

local L = DBM_Archaeology_Translations

local IsInInstance = IsInInstance
local mRandom = math.random

local soundFiles = {
	"Sound\\Creature\\YoggSaron\\AK_YoggSaron_HowlingFjordWhisper01.ogg",
	"Sound\\Creature\\YoggSaron\\AK_YoggSaron_HowlingFjordWhisper01.ogg",
	"Sound\\Creature\\YoggSaron\\AK_YoggSaron_HowlingFjordWhisper02.ogg",
	"Sound\\Creature\\YoggSaron\\AK_YoggSaron_HowlingFjordWhisper03.ogg",
	"Sound\\Creature\\YoggSaron\\AK_YoggSaron_HowlingFjordWhisper04.ogg",
	"Sound\\Creature\\YoggSaron\\AK_YoggSaron_HowlingFjordWhisper05.ogg",
	"Sound\\Creature\\YoggSaron\\AK_YoggSaron_HowlingFjordWhisper06.ogg",
	"Sound\\Creature\\YoggSaron\\AK_YoggSaron_HowlingFjordWhisper07.ogg",
	"Sound\\Creature\\YoggSaron\\AK_YoggSaron_HowlingFjordWhisper08.ogg",
	"Sound\\Creature\\YoggSaron\\AK_YoggSaron_Whisper01.ogg",
	"Sound\\Creature\\YoggSaron\\AK_YoggSaron_Whisper02.ogg",
	"Sound\\Creature\\YoggSaron\\AK_YoggSaron_Whisper03.ogg",
	"Sound\\Creature\\YoggSaron\\AK_YoggSaron_Whisper04.ogg",
	"Sound\\Creature\\CThun\\CThunDeathIsClose.ogg",
	"Sound\\Creature\\CThun\\CThunYouAreAlready.ogg",
	"Sound\\Creature\\CThun\\CThunYouWillBetray.ogg",
	"Sound\\Creature\\CThun\\CThunYouWillDIe.ogg",
	"Sound\\Creature\\CThun\\CThunYourCourage.ogg",
	"Sound\\Creature\\CThun\\CThunYourFriends.ogg",
	"Sound\\Creature\\CThun\\YourHeartWill.ogg",
	"Sound\\Creature\\CThun\\YouAreWeak.ogg"
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
				DBM:PlaySoundFile(soundFiles[x])
			end

		elseif settings.enabled and event == "UNIT_SPELLCAST_SUCCEEDED" then
			local spellId = select(3, ...)
			if spellId == 91756 then--Puzzle Box of Yogg-Saron
				DBM:PlaySoundFile("Sound\\Creature\\YoggSaron\\UR_YoggSaron_Slay01.ogg")
			elseif spellId == 91754 then--Blessing of the Old God
				DBM:PlaySoundFile("Sound\\Creature\\YoggSaron\\UR_YoggSaron_Insanity01.ogg")
			end
		end
	end)
	mainframe:RegisterEvent("ADDON_LOADED")
end
