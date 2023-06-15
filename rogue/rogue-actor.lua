local Unlocker, awful, DreamsScriptsCombatPvE = ...
local combat = DreamsScriptsCombatPvE.rogue.combat
local player = awful.player

if awful.player.class2 ~= "ROGUE" then return end

awful.print("|cffFFFFFFDreams{ |cff00B5FFScripts |cffFFFFFF} - Combat PvE Loaded!")
awful.print("|cffFFFFFFDreams{ |cff00B5FFScripts |cffFFFFFF} - Version: 1.0.0")

combat:Init(function()
    if player.mounted or
        player.dead or
        player.buff("Food") or
        not player.combat then
        return
    end

    auto_attack()

    -- AoE Rotation
    blade_flurry("aoe")
    fan_of_knives("aoe")
    -- Single Target Rotation
    rupture()
    slice_and_dice()
    expose_armor()
    blade_flurry()
    killing_spree()
    engineer_gloves()
    adrenaline_rush()
    tricks_of_the_trade()
    sinister_strike()
    feint()
end)