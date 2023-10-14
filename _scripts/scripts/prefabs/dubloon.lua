local assets =
{
    Asset("ANIM", "anim/dubloon.zip"),
}

local function shine(inst)
    inst.task = nil

    if inst.components.floater:IsFloating() then
        inst.AnimState:PlayAnimation("sparkle_water")
        inst.AnimState:PushAnimation("idle_water")
    else
        inst.AnimState:PlayAnimation("sparkle")
        inst.AnimState:PushAnimation("idle")
    end

    if inst.entity:IsAwake() then
        inst.task = inst:DoTaskInTime(4+math.random() * 5, shine)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("dubloon")
    inst.AnimState:SetBuild("dubloon")
    inst.AnimState:PlayAnimation("idle")

    inst.pickupsound = "metal"

    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    MakeInventoryPhysics(inst)

    inst:AddTag("currency")
    inst:AddTag("molebait")

    MakeInventoryFloatable(inst)
    inst.components.floater:UpdateAnimations("idle_water", "idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent('edible')
    inst.components.edible.foodtype = FOODTYPE.ELEMENTAL
    inst.components.edible.hungervalue = 1

    inst:AddComponent("inspectable")

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("appeasement")
    inst.components.appeasement.appeasementvalue = TUNING.APPEASEMENT_TINY

    inst:AddComponent("waterproofer")
    inst.components.waterproofer.effectiveness = 0

    inst:AddComponent("inventoryitem")

    inst:AddComponent("bait")

    inst:AddComponent("tradable")

    shine(inst)

    MakeBlowInHurricane(inst, TUNING.WINDBLOWN_SCALE_MIN.MEDIUM, TUNING.WINDBLOWN_SCALE_MAX.MEDIUM)
    MakeHauntableLaunchAndSmash(inst)

    return inst
end

return Prefab("dubloon", fn, assets)
