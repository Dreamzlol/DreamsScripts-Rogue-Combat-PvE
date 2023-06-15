local Unlocker, awful, DreamsScriptsCombatPvE = ...
local combat = DreamsScriptsCombatPvE.rogue.combat

local Spell = awful.Spell
local player, target, focus = awful.player, awful.target, awful.focus

awful.Populate({
    blade_flurry = Spell(13877),
    fan_of_knives = Spell(51723),
    slice_and_dice = Spell(6774),
    sinister_strike = Spell(48638),
    eviscerate = Spell(48668),
    rupture = Spell(48672),
    adrenaline_rush = Spell(13750),
    kick = Spell(1766),
    killing_spree = Spell(51690),
    expose_armor = Spell(8647),
    tricks_of_the_trade = Spell(57934),
    auto_attack = Spell(6603),
    engineer_gloves = Spell(6603),
    feint = Spell(48659)
}, combat, getfenv(1))

local Draw = awful.Draw
Draw(function(draw)
    local px, py, pz = target.position()
    local pAngle = target.rotation
    if not pAngle then return end
    if not px or not py or not pz then return end

    local arcRotation = pAngle - math.pi

    arcRotation = (arcRotation + 2 * math.pi) % (2 * math.pi)
    draw:SetWidth(2)
    draw:SetColor(255, 255, 255, 30)
    draw:Arc(px, py, pz, 5, 180, arcRotation)
end)

local function unitFilter(obj)
    return obj.los
        and obj.exists
        and not obj.dead
end

local function useInventoryItem()
    RunMacroText("/use 10");
end

engineer_gloves:Callback(function(spell)
    return target.exists
        and target.meleeRange
        and target.level == -1
        and useInventoryItem()
        and awful.alert(spell.name, spell.id)
end)

auto_attack:Callback(function(spell)
    return target.exists
        and not spell.current
        and spell:Cast()
end)

-- AoE Rotation
blade_flurry:Callback("aoe", function(spell)
    return target.exists
        and awful.enemies.around(player, 5, unitFilter) >= 2
        and spell:Cast()
        and awful.alert(spell.name, spell.id)
end)

fan_of_knives:Callback("aoe", function(spell)
    return target.exists
        and awful.enemies.around(player, 8, unitFilter) >= 3
        and spell:Cast()
        and awful.alert(spell.name, spell.id)
end)

-- Single Target Rotation
kick:Callback(function(spell)
    return target.exists
        and target.casting
        and target.castint
        and spell:Cast(target)
        and awful.alert(spell.name, spell.id)
end)

slice_and_dice:Callback(function(spell)
    return target.exists
        and target.cp() >= 1
        and player.buffRemains("Slice and Dice") <= 2
        and spell:Cast()
        and awful.alert(spell.name, spell.id)
end)

tricks_of_the_trade:Callback(function(spell)
    return focus.exists
        and target.exists
        and spell:Cast(focus)
        and awful.alert(spell.name, spell.id)
end)

sinister_strike:Callback(function(spell)
    if target.exists and target.cp() == 5 and player.energy >= 100 then
        spell:Cast(target)
    end

    if target.exists and target.cp() < 5 then
        spell:Cast(target)
        awful.alert(spell.name, spell.id)
        return
    end
end)

feint:Callback(function(spell)
    return target.exists
        and player.hasGlyph("Glyph of Feint")
        and target.meleeRange
        and spell:Cast(target)
        and awful.alert(spell.name, spell.id)
end)

rupture:Callback(function(spell)
    return target.exists
        and target.cp() >= 5
        and target.debuffRemains("Rupture") <= 4
        and (player.buffRemains("Slice and Dice") >= 2 or player.buffRemains("Expose Armor") >= 2)
        and spell:Cast(target)
        and awful.alert(spell.name, spell.id)
end)

expose_armor:Callback(function(spell)
    return target.exists
        and player.hasGlyph("Glyph of Expose Armor")
        and target.cp() >= 1
        and target.debuffRemains("Expose Armor") <= 2
        and spell:Cast(target)
        and awful.alert(spell.name, spell.id)
end)

adrenaline_rush:Callback(function(spell)
    return target.exists
        and target.meleeRange
        and target.level == -1
        and player.energy <= 20
        and player.buffRemains("Slice and Dice") >= 2
        and spell:Cast()
        and awful.alert(spell.name, spell.id)
end)

blade_flurry:Callback(function(spell)
    return target.exists
        and target.meleeRange
        and target.level == -1
        and player.buffRemains("Slice and Dice") >= 2
        and spell:Cast()
        and awful.alert(spell.name, spell.id)
end)

killing_spree:Callback(function(spell)
    return target.exists
        and target.meleeRange
        and target.level == -1
        and player.energy < 60
        and player.buffRemains("Slice and Dice") >= 2
        and spell:Cast(target)
        and awful.alert(spell.name, spell.id)
end)
