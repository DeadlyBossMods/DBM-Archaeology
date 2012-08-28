local Revision = ("$Revision$"):sub(12, -3)

local default_settings = {
	enabled = true,}
DBM_Archaeology_Settings = {}
local settings = default_settings

local L = DBM_Archaeology_Translations

local soundFiles = {
	"Sound\\Creature\\YoggSaron\\AK_YoggSaron_HowlingFjordWhisper01.wav",
	"Sound\\Creature\\YoggSaron\\AK_YoggSaron_HowlingFjordWhisper01.wav",
	"Sound\\Creature\\YoggSaron\\AK_YoggSaron_HowlingFjordWhisper02.wav",
	"Sound\\Creature\\YoggSaron\\AK_YoggSaron_HowlingFjordWhisper03.wav",
	"Sound\\Creature\\YoggSaron\\AK_YoggSaron_HowlingFjordWhisper04.wav",
	"Sound\\Creature\\YoggSaron\\AK_YoggSaron_HowlingFjordWhisper05.wav",
	"Sound\\Creature\\YoggSaron\\AK_YoggSaron_HowlingFjordWhisper06.wav",
	"Sound\\Creature\\YoggSaron\\AK_YoggSaron_HowlingFjordWhisper07.wav",
	"Sound\\Creature\\YoggSaron\\AK_YoggSaron_HowlingFjordWhisper08.wav",
	"Sound\\Creature\\YoggSaron\\AK_YoggSaron_Whisper01.wav",
	"Sound\\Creature\\YoggSaron\\AK_YoggSaron_Whisper02.wav",
	"Sound\\Creature\\YoggSaron\\AK_YoggSaron_Whisper03.wav",
	"Sound\\Creature\\YoggSaron\\AK_YoggSaron_Whisper04.wav",
	"Sound\\Creature\\CThun\\CThunDeathIsClose.wav",
	"Sound\\Creature\\CThun\\CThunYouAreAlready.wav",
	"Sound\\Creature\\CThun\\CThunYouWillBetray.wav",
	"Sound\\Creature\\CThun\\CThunYouWillDIe.wav",
	"Sound\\Creature\\CThun\\CThunYourCourage.wav",
	"Sound\\Creature\\CThun\\CThunYourFriends.wav",
	"Sound\\Creature\\CThun\\YourHeartWill.wav",
	"Sound\\Creature\\CThun\\YouAreWeak.wav"
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
	local spellEvents = {
	  ["SPELL_AURA_APPLIED"] = true,
	}
	local spamSound = 0
	mainframe:SetScript("OnEvent", function(self, event, ...)
		if event == "ADDON_LOADED" and select(1, ...) == "DBM-Archaeology" then
			self:RegisterEvent("CHAT_MSG_LOOT")
			self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
			-- Update settings of this Addon
			settings = DBM_Archaeology_Settings
			addDefaultOptions(settings, default_settings)

		elseif settings.enabled and event == "CHAT_MSG_LOOT" then
			local lootmsg = select(1, ...)
			local player, itemID = lootmsg:match(L.DBM_LOOT_MSG)
			if player and itemID and (tonumber(itemID) == 52843 or tonumber(itemID) == 63127 or tonumber(itemID) == 63128 or tonumber(itemID) == 64392 or tonumber(itemID) == 64394 or tonumber(itemID) == 64396 or tonumber(itemID) == 64395 or tonumber(itemID) == 64397) and GetTime() - spamSound >= 10 then
				local x = math.random(1, #soundFiles)
				spamSound = GetTime()
				if DBM.Options.UseMasterVolume then
					PlaySoundFile(soundFiles[x], "Master")
				else
					PlaySoundFile(soundFiles[x])
				end
			end

		elseif settings.enabled and event == "COMBAT_LOG_EVENT_UNFILTERED" and spellEvents[select(2, ...)] then
			local fromplayer = select(5, ...)
			local toplayer = select(9, ...)
			local spellid = select(12, ...)
			if spellid == 91754 and toplayer == UnitName("Player") then
				if DBM.Options.UseMasterVolume then
					PlaySoundFile("Sound\\Creature\\YoggSaron\\UR_YoggSaron_Insanity01.wav", "Master")
				else
					PlaySoundFile("Sound\\Creature\\YoggSaron\\UR_YoggSaron_Insanity01.wav")
				end
			end
		elseif settings.enabled and event == "UNIT_SPELLCAST_SUCCEEDED" then
			local unitId = select(1, ...)
			local spellName = select(2, ...)
			if unitId == "player" and spellName == GetSpellInfo(91756) then
				if DBM.Options.UseMasterVolume then
					PlaySoundFile("Sound\\Creature\\YoggSaron\\UR_YoggSaron_Slay01.wav", "Master")
				else
					PlaySoundFile("Sound\\Creature\\YoggSaron\\UR_YoggSaron_Slay01.wav")
				end
			end
		end
	end)
	mainframe:RegisterEvent("ADDON_LOADED")
end
