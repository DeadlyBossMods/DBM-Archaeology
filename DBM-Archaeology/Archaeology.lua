DBM_Archaeology_Settings = {}
local settings = {
	enabled = true
}

local L = DBM_Archaeology_Translations

local soundFiles = {
	564858, -- "Sound\\Creature\\YoggSaron\\AK_YoggSaron_HowlingFjordWhisper01.ogg"
	564838, -- "Sound\\Creature\\YoggSaron\\AK_YoggSaron_HowlingFjordWhisper02.ogg",
	564877, -- "Sound\\Creature\\YoggSaron\\AK_YoggSaron_HowlingFjordWhisper03.ogg",
	564865, -- "Sound\\Creature\\YoggSaron\\AK_YoggSaron_HowlingFjordWhisper04.ogg",
	564834, -- "Sound\\Creature\\YoggSaron\\AK_YoggSaron_HowlingFjordWhisper05.ogg",
	564862, -- "Sound\\Creature\\YoggSaron\\AK_YoggSaron_HowlingFjordWhisper06.ogg",
	564868, -- "Sound\\Creature\\YoggSaron\\AK_YoggSaron_HowlingFjordWhisper07.ogg",
	564857, -- "Sound\\Creature\\YoggSaron\\AK_YoggSaron_HowlingFjordWhisper08.ogg",
	564870, -- "Sound\\Creature\\YoggSaron\\AK_YoggSaron_Whisper01.ogg",
	564856, -- "Sound\\Creature\\YoggSaron\\AK_YoggSaron_Whisper02.ogg",
	564845, -- "Sound\\Creature\\YoggSaron\\AK_YoggSaron_Whisper03.ogg",
	564823, -- "Sound\\Creature\\YoggSaron\\AK_YoggSaron_Whisper04.ogg",
	546627, -- "Sound\\Creature\\CThun\\CThunDeathIsClose.ogg",
	546621, -- "Sound\\Creature\\CThun\\CThunYouAreAlready.ogg",

	-- Cannot seem to get sound to play with the following FDID's
	--546626, -- "Sound\\Creature\\CThun\\CThunYourCourage.ogg",
	--546620, -- "Sound\\Creature\\CThun\\CThunYourFriends.ogg",
	--546623, -- "Sound\\Creature\\CThun\\CThunYouWillBetray.ogg",
	--546633, -- "Sound\\Creature\\CThun\\CThunYouWillDie.ogg",
	--546636, -- "Sound\\Creature\\CThun\\YouAreWeak.ogg"
	--546628, -- "Sound\\Creature\\CThun\\YourHeartWill.ogg",
}

DBM:RegisterOnGuiLoadCallback(function()
	local panel = DBM_GUI:CreateNewPanel(L.TabCategory_Archaeology, "option")
	local generalarea = panel:CreateArea(L.AreaGeneral)

	local enabled = generalarea:CreateCheckButton(L.Enable, true)
	enabled:SetScript("OnShow", function(self) self:SetChecked(settings.enabled) end)
	enabled:SetScript("OnClick", function(self) settings.enabled = not not self:GetChecked() end)
end, 19)

do
	local IsInInstance = IsInInstance
	local mRandom, type, pairs, select = math.random, type, pairs, select

	local itemIds = {
		[52843]		= true,
		[63127]		= true,
		[63128]		= true,
		[64392]		= true,
		[64395]		= true,
		[64396]		= true,
		[64397]		= true,
		[79868]		= true,
		[79869]		= true,
		[95373]		= true,
		[109584]	= true,
		[108439]	= true,
		[109585]	= true,
		-- Legion
		[130903]	= true,
		[130904]	= true,
		[130905]	= true,
		-- BfA
		[154990]	= true,
		[154989]	= true,
	}

	local mainframe = CreateFrame("frame", "DBM_Archaeology", UIParent)
	local spamSound = 0

	mainframe:SetScript("OnEvent", function(self, event, ...)
		if event == "ADDON_LOADED" and select(1, ...) == "DBM-Archaeology" then
			self:RegisterEvent("CHAT_MSG_LOOT")
			self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
			settings = DBM_Archaeology_Settings
			if settings.enabled == nil then
				settings.enabled = true
			end
		elseif settings.enabled and event == "CHAT_MSG_LOOT" then
			if IsInInstance() then return end -- There are no keystones in dungeons/raids so save cpu
			local player, itemID = select(1, ...):match(L.DBM_LOOT_MSG)
			if player and itemID and itemIds[tonumber(itemID)] and GetTime() - spamSound >= 10 then
				spamSound = GetTime()
				DBM:PlaySoundFile(soundFiles[mRandom(1, #soundFiles)])
			end
		elseif settings.enabled and event == "UNIT_SPELLCAST_SUCCEEDED" then
			local spellId = select(3, ...)
			if spellId == 91756 then -- Puzzle Box of Yogg-Saron
				DBM:PlaySoundFile(564859) -- "Sound\\Creature\\YoggSaron\\UR_YoggSaron_Slay01.ogg"
			elseif spellId == 91754 then -- Blessing of the Old God
				DBM:PlaySoundFile(564844) -- "Sound\\Creature\\YoggSaron\\UR_YoggSaron_Insanity01.ogg"
			end
		end
	end)
	mainframe:RegisterEvent("ADDON_LOADED")
end
