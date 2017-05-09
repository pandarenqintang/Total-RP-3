---
--- Just to make sure we don't mess with each other, editing the same locale_enUS.lua file for the locales,
--- this file will contain the locales for the Automator module while I'm working on it :)
--- I will of course copy its content to the correct locale file later
---

local locale = {
	ATM_MODULE_NAME = "Automator",
	ATM_MODULE_DESCRIPTION = "Automated profile variations for Total RP 3.",
	ATM_MENU = "Variations",
	ATM_DEFAULT_TRIGGER_DECORATOR = "When %s is %s.",
	ATM_TRIGGER_UNAVAILABLE = "The trigger for this variation is not available for this character, the variation will never be triggered.",


	--- EQUIPMENT SETS TRIGGER
	ATM_SETS_NAME = "Equipment sets",
	ATM_SETS_DESCRIPTION = "Adapt your profile when switching equipment sets",
	ATM_SETS_EQUIP = "equip",
	ATM_SETS_UNEQUIP = "unequip",
	ATM_SETS_UNKNOWN = "Unknown equipment set",
	ATM_SETS_DECORATOR = "When you %s equipment set %s.",

	--- WORGEN FORM TRIGGER
	ATM_WORG_WORG = "a worgen",
	ATM_WORG_HUMAN = "a human",
	ATM_WORG_DECORATOR = "When you %s into %s.",
	ATM_WORG_DECORATOR_VERB = "you transform",
	ATM_WORG_DESCRIPTION = "Adapt your profile when going into your human or your worgen form",
	ATM_WORG_NAME = "Worgen form",

	--- SPECIALIZATION TRIGGER
	ATM_SPEC_DECORATOR = "When you %s to your %s specialization.",
	ATM_SPEC_DECORATOR_VERB = "switching specialization",
	ATM_SPEC_NAME = "Specializations",
	ATM_SPEC_DESCRIPTION = "Adapt your profile when you switch specializations.",

	--- SHAPESHIFTING TRIGGER
	ATM_SHAPE_NAME = "Shapeshifting",
	ATM_SHAPE_DESCRIPTION = "Adapt your profile when shapeshifting",
	ATM_SHAPE_UNKNOWN = "Unknown shapeshift form",
	ATM_SHAPE_DECORATOR = "When %s into %s.",
	ATM_SHAPE_DECORATOR_VERB = "shapeshifting",
	ATM_SHAPE_FORM_CAT = "Cat Form",
	ATM_SHAPE_FORM_TRAVEL = "Travel Form",
	ATM_SHAPE_FORM_AQUATIC = "Aquatic Form",
	ATM_SHAPE_FORM_BEAR = "Bear Form",
	ATM_SHAPE_FORM_FLIGHT = "Flight Form",
	ATM_SHAPE_FORM_MOONKIN = "Moonkin Form",
	ATM_SHAPE_FORM_AFFINITY = "Affinity Form",
	ATM_SHAPE_FORM_TREANT = "Treant Form",

	--- CUSTOM TRIGGER
	ATM_CUSTOM_NAME = "Custom trigger",
	ATM_CUSTOM_DESCRIPTION = "Adapt your profile according to custom a custom trigger.",
	ATM_CUSTOM_DECORATOR = "When your custom trigger %s returns %s",
}

local locale = TRP3_API.locale.getLocale("enUS");
for localeKey, text in pairs(locale) do
	locale.localeContent[localeKey] = text;
end