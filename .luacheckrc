std = "lua51"
max_line_length = false
exclude_files = {
	".luacheckrc"
}
ignore = {
	"11./SLASH_.*", -- Setting an undefined (Slash handler) global variable
	"11./BINDING_.*", -- Setting an undefined (Keybinding header) global variable
	"11./DBM_.*", -- Setting an undefined (DBM) global variable
	"113/LE_.*", -- Accessing an undefined (Lua ENUM type) global variable
	"113/NUM_LE_.*", -- Accessing an undefined (Lua ENUM type) global variable
	"113/DBM_.*", -- Accessing an undefined (DBM) global variable
	"211", -- Unused local variable
	"211/L", -- Unused local variable "L"
	"211/CL", -- Unused local variable "CL"
	"212", -- Unused argument
	"213", -- Unused loop variable
	"231/_.*", -- unused variables starting with _
	"311", -- Value assigned to a local variable is unused
--	"431", -- shadowing upvalue
	"43.", -- Shadowing an upvalue, an upvalue argument, an upvalue loop variable.
	"542", -- An empty if branch
}
globals = {
	"_G",
	"math",
	"type",
	"pairs",
	"select",
	"GetTime",

	-- DBM
	"DBM",
	"DBM_DISABLE_ZONE_DETECTION",
	"DBM_GUI",

	-- Archaeology
	"DBM_Archaeology_Settings",
	"DBM_Archaeology_Translations",

	-- WoW
	"GameFontDisableSmall",
	"GameFontHighlightSmall",
	"GameFontNormalSmall",
	"UIParent",

	-- FrameXML
	"CreateFrame",
	"IsInInstance",
	"GetLocale",
}
