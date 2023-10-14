local assets =
{
    Asset("ANIM", "anim/icerocky.zip"),
    Asset("SOUND", "sound/rocklobster.fsb"),
}

local prefabs =
{
    "rocks",
    "meat",
    "flint",
}

local brain = require "brains/icerockybrain"

local colours =
{
    { 1, 1, 1, 1 },
    --{ 174/255, 158/255, 151/255, 1 },
    { 167/255, 180/255, 180/255, 1 },
    { 159/255, 163/255, 146/255, 1 },
}

local function ShouldSleep(inst)
    return inst.components.sleeper:GetTimeAwake() > TUNING.TOTAL_DAY_TIME * 2
end

local function ShouldWake(inst)
    return inst.components.sleeper:GetTimeAsleep() > TUNING.TOTAL_DAY_TIME * .5
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, 20, function(dude) return dude.prefab == inst.prefab end, 2)
end

local function applyscale(inst, scale)
    inst.components.combat:SetDefaultDamage(TUNING.ROCKY_DAMAGE * scale)
    local percent = inst.components.health:GetPercent()
    inst.components.health:SetMaxHealth(TUNING.ROCKY_HEALTH * scale)
    inst.components.health:SetPercent(percent)
    --MakeCharacterPhysics(inst, 200 * scale, scale)
    inst.components.locomotor.walkspeed = TUNING.ROCKY_WALK_SPEED / scale
end

local function ShouldAcceptItem(inst, item)
    return item.components.edible ~= nil and item.components.edible.foodtype == FOODTYPE.ELEMENTAL
end

local function OnGetItemFromPlayer(inst, giver, item)
    if item.components.edible ~= nil and
        item.components.edible.foodtype == FOODTYPE.ELEMENTAL and
        item.components.inventoryitem ~= nil and
        (   --make sure it didn't drop due to pockets full
            item.components.inventoryitem:GetGrandOwner() == inst or
            --could be merged into a stack
            (   not item:IsValid() and
                inst.components.inventory:FindItem(function(obj)
                    return obj.prefab == item.prefab
                        and obj.components.stackable ~= nil
                        and obj.components.stackable:IsStack()
                end) ~= nil)
        ) then
        if inst.components.combat:TargetIs(giver) then
            inst.components.combat:SetTarget(nil)
        elseif giver.components.leader ~= nil then
			if giver.components.minigame_participator == nil then
	            giver:PushEvent("makefriend")
		        giver.components.leader:AddFollower(inst)
			end
            inst.components.follower:AddLoyaltyTime(
                giver:HasTag("polite")
                and TUNING.ROCKY_LOYALTY + TUNING.ROCKY_POLITENESS_LOYALTY_BONUS
                or TUNING.ROCKY_LOYALTY
            )
        end
    end
    if inst.components.sleeper:IsAsleep() then
        inst.components.sleeper:WakeUp()
    end
end

local function OnRefuseItem(inst, item)
    if inst.components.sleeper:IsAsleep() then
        inst.components.sleeper:WakeUp()
    end
    inst:PushEvent("refuseitem")
end

local loot = { "rocks", "rocks", "meat", "flint", "flint" }

local function onsave(inst, data)
    data.colour = inst.colour_idx
end

local function onload(inst, data)
    if data ~= nil and data.colour ~= nil then
        local colour = colours[data.colour]
        if colour ~= nil then
            inst.colour_idx = data.colour
            inst.AnimState:SetMultColour(unpack(colour))
        end
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 200, 1)

    inst.Transform:SetFourFaced()

    inst:AddTag("icerocky")
    inst:AddTag("character")
    inst:AddTag("animal")

    --trader (from trader component) added to pristine state for optimization
    inst:AddTag("trader")

    --herdmember (from herdmember component) added to pristine state for optimization
    inst:AddTag("herdmember")

    inst.AnimState:SetBank("rocky")
    inst.AnimState:SetBuild("icerocky")
    inst.AnimState:PlayAnimation("idle_loop", true)

    inst.DynamicShadow:SetSize(1.75, 1.75)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.colour_idx = math.random(#colours)
    inst.AnimState:SetMultColour(unpack(colours[inst.colour_idx]))

    inst:AddComponent("combat")
    inst.components.combat:SetAttackPeriod(3)
    print(inst.components.combat:SetAttackPeriod(3))
    inst.components.combat:SetRange(4)
    inst.components.combat:SetDefaultDamage(100)

    inst:AddComponent("knownlocations")
    inst:AddComponent("inventory")
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot(loot)

    inst:AddComponent("follower")
    inst.components.follower.maxfollowtime = TUNING.PIG_LOYALTY_MAXTIME

    inst:AddComponent("scaler")
    inst.components.scaler.OnApplyScale = applyscale

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(3)
    inst.components.sleeper:SetWakeTest(ShouldWake)
    inst.components.sleeper:SetSleepTest(ShouldSleep)

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.ROCKY_HEALTH)

    inst:AddComponent("inspectable")

    inst:AddComponent("eater")
    inst.components.eater:SetDiet({ FOODTYPE.ELEMENTAL }, { FOODTYPE.ELEMENTAL })

    inst:AddComponent("locomotor")
    inst.components.locomotor:SetSlowMultiplier( 1 )
    inst.components.locomotor:SetTriggersCreep(false)
    inst.components.locomotor.pathcaps = { ignorecreep = false }
    inst.components.locomotor.walkspeed = TUNING.ROCKY_WALK_SPEED

    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
    inst.components.trader.onrefuse = OnRefuseItem
    inst.components.trader.deleteitemonaccept = false

    if inst._light == nil or not inst._light:IsValid() then
        inst._light = SpawnPrefab("yellowamuletlight")
    end
    inst._light.entity:SetParent(inst.entity)

    inst:SetBrain(brain)
    inst:SetStateGraph("SGicerocky")

    inst:ListenForEvent("attacked", OnAttacked)

    inst.components.scaler:SetScale(2.0)

    inst.OnSave = onsave
    inst.OnLoad = onload

    return inst
end

return Prefab("icerocky", fn, assets, prefabs)