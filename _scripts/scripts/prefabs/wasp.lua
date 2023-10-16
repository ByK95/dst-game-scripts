local assets =
{
    Asset("ANIM", "anim/bee_queen_basic.zip"),
    Asset("ANIM", "anim/bee_queen_actions.zip"),
    Asset("ANIM", "anim/bee_queen_build.zip"),
}

local prefabs =
{
	"ocean_splash_ripple1",
	"ocean_splash_ripple2",
    "honeycomb",
    "honey",
    "stinger",
}

SetSharedLootTable('wasp',
{
    {'honeycomb',        0.50},
    {'honey',            0.50},
    {'stinger',          1.00},
})

--------------------------------------------------------------------------

local brain = require("brains/waspbrain")

--------------------------------------------------------------------------

WASP_HIT_RANGE = 4

local function UpdatePlayerTargets(inst)
    local toadd = {}
    local toremove = {}
    local pos = inst.components.knownlocations:GetLocation("spawnpoint")

    for k, v in pairs(inst.components.grouptargeter:GetTargets()) do
        toremove[k] = true
    end
    for i, v in ipairs(FindPlayersInRange(pos.x, pos.y, pos.z, TUNING.BEEQUEEN_DEAGGRO_DIST, true)) do
        if toremove[v] then
            toremove[v] = nil
        else
            table.insert(toadd, v)
        end
    end

    for k, v in pairs(toremove) do
        inst.components.grouptargeter:RemoveTarget(k)
    end
    for i, v in ipairs(toadd) do
        inst.components.grouptargeter:AddTarget(v)
    end
end

local function RetargetFn(inst)
    UpdatePlayerTargets(inst)

    local target = inst.components.combat.target
    local inrange = target ~= nil and inst:IsNear(target, TUNING.BEEQUEEN_ATTACK_RANGE + target:GetPhysicsRadius(0))

    if target ~= nil and target:HasTag("player") then
        local newplayer = inst.components.grouptargeter:TryGetNewTarget()
        return newplayer ~= nil
            and newplayer:IsNear(inst, inrange and TUNING.BEEQUEEN_ATTACK_RANGE + newplayer:GetPhysicsRadius(0) or TUNING.BEEQUEEN_AGGRO_DIST)
            and newplayer
            or nil,
            true
    end

    local nearplayers = {}
    for k, v in pairs(inst.components.grouptargeter:GetTargets()) do
        if inst:IsNear(k, inrange and TUNING.BEEQUEEN_ATTACK_RANGE + k:GetPhysicsRadius(0) or TUNING.BEEQUEEN_AGGRO_DIST) then
            table.insert(nearplayers, k)
        end
    end
    return #nearplayers > 0 and nearplayers[math.random(#nearplayers)] or nil, true
end

local function KeepTargetFn(inst, target)
    return inst.components.combat:CanTarget(target)
        and target:GetDistanceSqToPoint(inst.components.knownlocations:GetLocation("spawnpoint")) < TUNING.BEEQUEEN_DEAGGRO_DIST * TUNING.BEEQUEEN_DEAGGRO_DIST
end

local function bonus_damage_via_allergy(inst, target, damage, weapon)
    return (target:HasTag("allergictobees") and TUNING.BEE_ALLERGY_EXTRADAMAGE) or 0
end

local function OnAttacked(inst, data)
    if data.attacker ~= nil then
        local target = inst.components.combat.target
        if not (target ~= nil and
                target:HasTag("player") and
				target:IsNear(inst, (inst.focustarget_cd > 0 or inst.components.stuckdetection:IsStuck()) and TUNING.BEEQUEEN_ATTACK_RANGE + target:GetPhysicsRadius(0) or TUNING.BEEQUEEN_AGGRO_DIST)) then
            inst.components.combat:SetTarget(data.attacker)
        end
    end
end

local function OnAttackOther(inst, data)
	inst.components.stuckdetection:Reset()
end

local function OnMissOther(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local angle = -inst.Transform:GetRotation() * DEGREES
	x = x + TUNING.BEEQUEEN_ATTACK_RANGE * math.cos(angle)
	z = z + TUNING.BEEQUEEN_ATTACK_RANGE * math.sin(angle)
end

--------------------------------------------------------------------------

local function ShouldSleep(inst)
    return false
end

local function ShouldWake(inst)
    return true
end

--------------------------------------------------------------------------

local function OnEntitySleep(inst)
    if inst._sleeptask ~= nil then
        inst._sleeptask:Cancel()
    end
    inst._sleeptask = not inst.components.health:IsDead() and inst:DoTaskInTime(10, inst.Remove) or nil

end

local function OnEntityWake(inst)
    if inst._sleeptask ~= nil then
        inst._sleeptask:Cancel()
        inst._sleeptask = nil
    end

end

--------------------------------------------------------------------------

local function PushMusic(inst)
    if ThePlayer == nil or inst:HasTag("flight") then
        inst._playingmusic = false
    elseif ThePlayer:IsNear(inst, inst._playingmusic and 40 or 20) then
        inst._playingmusic = true
        ThePlayer:PushEvent("triggeredevent", { name = "beequeen" })
    elseif inst._playingmusic and not ThePlayer:IsNear(inst, 50) then
        inst._playingmusic = false
    end
end

--------------------------------------------------------------------------

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddLight()
    inst.entity:AddDynamicShadow()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.Transform:SetSixFaced()
    inst.Transform:SetScale(1.2, 1.2, 1.2)

    inst.DynamicShadow:SetSize(4, 2)

    MakeFlyingGiantCharacterPhysics(inst, 500, 1.4)

    inst.AnimState:SetBank("bee_queen")
    inst.AnimState:SetBuild("bee_queen_build")
    inst.AnimState:PlayAnimation("idle_loop", true)

    inst:AddTag("epic")
    inst:AddTag("noepicmusic")
    inst:AddTag("wasp")
    inst:AddTag("insect")
    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("scarytoprey")
    inst:AddTag("largecreature")
    inst:AddTag("flying")
    inst:AddTag("ignorewalkableplatformdrowning")

    inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/wings_LP", "flying")

    MakeInventoryFloatable(inst, "large", 0.1, {0.6, 1.0, 0.6})

    inst.entity:SetPristine()

    --Dedicated server does not need to trigger music
    if not TheNet:IsDedicated() then
        inst._playingmusic = false
        inst:DoPeriodicTask(1, PushMusic, 0)
    end

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst.components.inspectable:RecordViews()

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('wasp')

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(4)
    inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetWakeTest(ShouldWake)
    inst.components.sleeper.diminishingreturns = true

    inst:AddComponent("locomotor")
    inst.components.locomotor:EnableGroundSpeedMultiplier(false)
    inst.components.locomotor:SetTriggersCreep(false)
    inst.components.locomotor.pathcaps = { ignorewalls = true, allowocean = true }
    inst.components.locomotor.walkspeed = TUNING.BEEQUEEN_SPEED

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(6000)
    inst.components.health.nofadeout = true

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING.BEEQUEEN_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.BEEQUEEN_ATTACK_PERIOD)
    inst.components.combat.playerdamagepercent = .5
    inst.components.combat:SetRange(TUNING.BEEQUEEN_ATTACK_RANGE, WASP_HIT_RANGE)
    inst.components.combat:SetRetargetFunction(3, RetargetFn)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
    inst.components.combat.battlecryenabled = false
    inst.components.combat.hiteffectsymbol = "hive_body"
    inst.components.combat.bonusdamagefn = bonus_damage_via_allergy

	inst:AddComponent("stuckdetection")
	inst.components.stuckdetection:SetTimeToStuck(2)

    inst:AddComponent("explosiveresist")

    inst:AddComponent("timer")

    inst:AddComponent("sanityaura")

    inst:AddComponent("epicscare")
    inst.components.epicscare:SetRange(TUNING.BEEQUEEN_EPICSCARE_RANGE)

    inst:AddComponent("knownlocations")
    inst:AddComponent("grouptargeter")

    MakeLargeBurnableCharacter(inst, "swap_fire")
    MakeHugeFreezableCharacter(inst, "hive_body")
    inst.components.freezable.diminishingreturns = true

    inst:SetStateGraph("SGwasp")
    inst:SetBrain(brain)

    inst.hit_recovery = TUNING.BEEQUEEN_HIT_RECOVERY
    inst.spawnguards_chain = 0
    inst.focustarget_cd = 0

    inst.OnEntitySleep = OnEntitySleep
    inst.OnEntityWake = OnEntityWake

    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("onattackother", OnAttackOther)
    inst:ListenForEvent("onmissother", OnMissOther)

    return inst
end

return Prefab("wasp", fn, assets, prefabs)
