local Unlocker, awful, DreamsScriptsCombatPvE = ...
local combat = DreamsScriptsCombatPvE.rogue.combat

if awful.player.class2 ~= "ROGUE" then return end

local Spell = awful.Spell
local player, target, focus = awful.player, awful.target, awful.focus

awful.Populate({
    blade_flurry        = Spell(13877),
    fan_of_knives       = Spell(51723),
    slice_and_dice      = Spell(6774),
    sinister_strike     = Spell(48638),
    eviscerate          = Spell(48668),
    rupture             = Spell(48672),
    adrenaline_rush     = Spell(13750),
    kick                = Spell(1766),
    killing_spree       = Spell(51690),
    expose_armor        = Spell(8647),
    tricks_of_the_trade = Spell(57934),
    auto_attack         = Spell(6603),
    engineer_gloves     = Spell(6603),
    feint               = Spell(48659)
}, combat, getfenv(1))

local function isBoss(unit)
    return unit.enemy and unit.level == -1
end

local Draw = awful.Draw
Draw(function(draw)
    local tx, ty, tz = target.position()
    local targetRotation = target.rotation
    if not tx or not target.enemy then return end

    local arcRotation = targetRotation - math.pi

    arcRotation = (arcRotation + 2 * math.pi) % (2 * math.pi)
    draw:SetWidth(2)
    draw:SetColor(255, 255, 255, 30)
    draw:Arc(tx, ty, tz, 5, 180, arcRotation)
end)

local function unitFilter(obj)
    return obj.enemy and obj.combat and not obj.dead
end

local function useInventoryItem()
    RunMacroText("/use 10");
end

engineer_gloves:Callback(function(spell)
    if not target.enemy then return end
    if not target.meleeRange then return end
    local start = GetInventoryItemCooldown("player", 10)

    if isBoss(target) and start == 0 then
        if useInventoryItem() then
            awful.alert(spell.name, spell.id)
            return
        end
    end
end)

auto_attack:Callback(function(spell)
    if not target.enemy then return end
    if not target.meleeRange then return end

    if not spell.current then
        spell:Cast(target)
        return
    end
end)

-- AoE Rotation
blade_flurry:Callback("aoe", function(spell)
    if not target.enemy then return end
    if not target.meleeRange then return end
    local unit = awful.enemies.around(player, 5, unitFilter)

    if unit >= 2 then
        if spell:Cast() then
            awful.alert(spell.name, spell.id)
            return
        end
    end
end)

fan_of_knives:Callback("aoe", function(spell)
    if not target.enemy then return end
    if not target.meleeRange then return end
    local unit = awful.enemies.around(player, 8, unitFilter)

    if unit >= 3 then
        if spell:Cast() then
            awful.alert(spell.name, spell.id)
            return
        end
    end
end)

-- Single Target Rotation
kick:Callback(function(spell)
    if not DreamsScriptsCombatPvE.settings.usekick then return end
    if not target.enemy then return end
    if not target.meleeRange then return end

    if target.casting and not target.casting9 then
        if spell:Cast(target) then
            awful.alert(spell.name, spell.id)
            return
        end
    end
end)

slice_and_dice:Callback(function(spell)
    if not target.enemy then return end
    if not target.meleeRange then return end

    if target.cp() >= 1 and player.buffRemains("Slice and Dice") <= 2 then
        if spell:Cast() then
            awful.alert(spell.name, spell.id)
            return
        end
    end
end)

tricks_of_the_trade:Callback(function(spell)
    if not focus.exists then return end

    if spell:Cast(focus) then
        awful.alert(spell.name, spell.id)
        return
    end
end)

sinister_strike:Callback(function(spell)
    if not target.enemy then return end
    if not target.meleeRange then return end

    if target.cp() == 5 and player.energy >= 100 then
        if spell:Cast(target) then
            awful.alert(spell.name, spell.id)
            return
        end
    elseif target.cp() < 5 then
        if spell:Cast(target) then
            awful.alert(spell.name, spell.id)
            return
        end
    end
end)

feint:Callback(function(spell)
    if not target.enemy then return end
    if not target.meleeRange then return end
    if not player.hasGlyph("Glyph of Feint") then return end

    if player.energy < 80 then
        if spell:Cast(target) then
            awful.alert(spell.name, spell.id)
            return
        end
    end
end)

rupture:Callback(function(spell)
    if not target.enemy then return end
    if not target.meleeRange then return end

    if target.cp() == 5 then
        if target.debuffRemains("Rupture") <= 4 and (player.buff("Slice and Dice") or player.buff("Expose Armor")) then
            if spell:Cast(target) then
                awful.alert(spell.name, spell.id)
                return
            end
        end
    end
end)

expose_armor:Callback(function(spell)
    if not target.enemy then return end
    if not target.meleeRange then return end
    if not player.hasGlyph("Glyph of Expose Armor") then return end

    if target.cp() >= 1 then
        if target.debuffRemains("Expose Armor") <= 2 then
            if spell:Cast(target) then
                awful.alert(spell.name, spell.id)
                return
            end
        end
    end
end)

adrenaline_rush:Callback(function(spell)
    if not target.enemy then return end
    if not target.meleeRange then return end
    if not isBoss(target) then return end
    if player.energy >= 40 then return end

    if player.buffRemains("Slice and Dice") >= 2 then
        if spell:Cast() then
            awful.alert(spell.name, spell.id)
            return
        end
    end
end)

blade_flurry:Callback(function(spell)
    if not DreamsScriptsCombatPvE.settings.usebladeflurry then return end
    if not target.enemy then return end
    if not target.meleeRange then return end
    if not isBoss(target) then return end

    if player.buffRemains("Slice and Dice") >= 2 then
        if spell:Cast() then
            awful.alert(spell.name, spell.id)
            return
        end
    end
end)

killing_spree:Callback(function(spell)
    if not target.enemy then return end
    if not target.meleeRange then return end
    if not isBoss(target) then return end
    if player.energy > 60 then return end

    if player.buffRemains("Slice and Dice") >= 2 then
        if spell:Cast(target) then
            awful.alert(spell.name, spell.id)
            return
        end
    end
end)
