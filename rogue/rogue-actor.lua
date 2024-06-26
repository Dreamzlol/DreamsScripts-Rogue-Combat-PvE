local Unlocker, awful, DreamsScriptsCombatPvE = ...
local combat = DreamsScriptsCombatPvE.rogue.combat
local player = awful.player

if awful.player.class2 ~= "ROGUE" then return end

awful.print("|cffFFFFFFDreams{ |cff00B5FFScripts |cffFFFFFF} - Combat PvE Loaded!")
awful.print("|cffFFFFFFDreams{ |cff00B5FFScripts |cffFFFFFF} - Version: 1.0.3")

combat:Init(function()
    if player.mounted or
        player.dead or
        player.buff("Food") or
        not player.combat then
        return
    end

    auto_attack()
    kick()
    riposte()

    -- AoE Rotation
    blade_flurry("aoe")
    fan_of_knives("aoe")

    -- Single Target Rotation
    rupture()
    slice_and_dice()
    expose_armor()
    feint()
    tricks_of_the_trade()
    killing_spree()
    blade_flurry()
    engineer_gloves()
    adrenaline_rush()
    sinister_strike()
end)