local Unlocker, awful, DreamsScriptsCombatPvE = ...

if awful.player.class2 ~= "ROGUE" then return end

local blue = { 0, 181, 255, 1 }
local white = { 255, 255, 255, 1 }
local background = { 0, 13, 49, 1 }

local gui, settings, cmd = awful.UI:New('ds', {
    title = "Dreams{ |cff00B5FFScripts |cffFFFFFF }",
    show = false,
    width = 345,
    height = 220,
    scale = 1,
    colors = {
        title = white,
        primary = white,
        accent = blue,
        background = background,
    }
})

DreamsScriptsCombatPvE.settings = settings

local statusFrame = gui:StatusFrame({
    colors = {
        background = {0, 0, 0, 0},
        enabled = {30, 240, 255, 1},
    },
    maxWidth = 600,
    padding = 12,
})

statusFrame:Button({
    spellId = 13877,
    var = "usebladeflurry",
    text = "Blade Flurry",
    size = 30
})

statusFrame:Button({
    spellId = 1766,
    var = "usekick",
    text = "Kick",
    size = 30
})