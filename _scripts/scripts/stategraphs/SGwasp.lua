require("stategraphs/commonstates")

--------------------------------------------------------------------------
local FOCUSTARGET_MUST_TAGS = { "_combat", "_health" }
local FOCUSTARGET_CANT_TAGS = { "INLIMBO", "player", "bee" }

local function ShakeIfClose(inst)
    ShakeAllCameras(CAMERASHAKE.FULL, .5, .02, .15, inst, 30)
end

local function StartFlapping(inst)
    inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/wings_LP", "flying")
end

local function RestoreFlapping(inst)
    if not inst.SoundEmitter:PlayingSound("flying") then
        StartFlapping(inst)
    end
end

local function StopFlapping(inst)
    inst.SoundEmitter:KillSound("flying")
end

local function DoScreech(inst)
    ShakeAllCameras(CAMERASHAKE.FULL, 1, .015, .3, inst, 30)
    inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/taunt")
end

local function DoScreechAlert(inst)
    inst.components.epicscare:Scare(5)
    inst.components.commander:AlertAllSoldiers()
end

--------------------------------------------------------------------------

local function ChooseAttack(inst)
    inst.sg:GoToState("attack")
    return true
end

local function FaceTarget(inst)
    local target = inst.components.combat.target
    if inst.sg.mem.focustargets ~= nil then
        local mindistsq = math.huge
        for i = #inst.sg.mem.focustargets, 1, -1 do
            local v = inst.sg.mem.focustargets[i]
            if v:IsValid() and v.components.health ~= nil and not v.components.health:IsDead() and not v:HasTag("playerghost") then
                local distsq = inst:GetDistanceSqToInst(v)
                if distsq < mindistsq then
                    mindistsq = distsq
                    target = v
                end
            else
                table.remove(inst.sg.mem.focustargets, i)
                if #inst.sg.mem.focustargets <= 0 then
                    inst.sg.mem.focustargets = nil
                    break
                end
            end
        end
    end
    if target ~= nil and target:IsValid() then
        inst:ForceFacePoint(target.Transform:GetWorldPosition())
    end
end

--------------------------------------------------------------------------

local events =
{
    CommonHandlers.OnLocomote(false, true),
    CommonHandlers.OnDeath(),
    CommonHandlers.OnFreeze(),
    CommonHandlers.OnSleepEx(),
    CommonHandlers.OnWakeEx(),
    EventHandler("doattack", function(inst)
        if not (inst.sg:HasStateTag("busy") or inst.components.health:IsDead()) then
            ChooseAttack(inst)
        end
    end),
    EventHandler("attacked", function(inst)
        if not inst.components.health:IsDead() and
            (not inst.sg:HasStateTag("busy") or inst.sg:HasStateTag("caninterrupt")) and
            not CommonHandlers.HitRecoveryDelay(inst, nil, TUNING.BEEQUEEN_MAX_STUN_LOCKS) then
            inst.sg:GoToState("hit")
        end
    end),
    EventHandler("focustarget", function(inst)
        if not (inst.sg:HasStateTag("busy") or inst.components.health:IsDead()) then
            inst.sg:GoToState("focustarget")
        elseif not inst.sg:HasStateTag("focustarget") then
            inst.sg.mem.wantstofocustarget = true
        end
    end),
}

local states =
{
    State{
        name = "idle",
        tags = { "idle", "canrotate" },

        onenter = function(inst)
            if inst.sg.mem.sleeping then
                inst.sg:GoToState("sleep")
            elseif inst.sg.mem.focuscount ~= nil then
                inst.sg:GoToState("focustarget_loop")
            elseif inst.sg.mem.wantstofocustarget then
                inst.sg:GoToState("focustarget")
            else
                inst.Physics:Stop()
                inst.AnimState:PlayAnimation("idle_loop")
            end
        end,

        timeline =
        {
            TimeEvent(0, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/breath")
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },

    State{
        name = "walk_start",
        tags = { "moving", "canrotate" },

        onenter = function(inst)
            inst.components.locomotor:WalkForward()
            inst.AnimState:PlayAnimation("walk_pre")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("walk")
                end
            end),
        },
    },

    State{
        name = "walk",
        tags = { "moving", "canrotate" },

        onenter = function(inst)
            inst.components.locomotor:WalkForward()
            inst.AnimState:PlayAnimation("walk_loop")
        end,

        timeline =
        {
            TimeEvent(0, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/breath")
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("walk")
                end
            end),
        },
    },

    State{
        name = "walk_stop",
        tags = { "canrotate" },

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("walk_pst")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },

    State{
        name = "hit",
        tags = { "hit", "busy" },

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("hit")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/hit")
			CommonHandlers.UpdateHitRecoveryDelay(inst)
        end,

        timeline =
        {
            TimeEvent(10 * FRAMES, function(inst)
                if inst.sg.statemem.doattack then
                    if not inst.components.health:IsDead() and ChooseAttack(inst) then
                        return
                    end
                    inst.sg.statemem.doattack = nil
                end
                inst.sg:RemoveStateTag("busy")
            end),
        },

        events =
        {
            EventHandler("doattack", function(inst)
                inst.sg.statemem.doattack = true
            end),
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    if inst.sg.statemem.doattack and ChooseAttack(inst) then
                        return
                    end
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },

    State{
        name = "death",
        tags = { "busy" },

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("death")
            inst:AddTag("NOCLICK")
            inst.SoundEmitter:KillSound("flying")
        end,

        timeline =
        {
            TimeEvent(28 * FRAMES, function(inst)
                LandFlyingCreature(inst)
                inst.components.sanityaura.aura = 0
                inst.SoundEmitter:PlaySound("dontstarve/bee/beehive_hit")
                ShakeIfClose(inst)
                if inst.persists then
                    inst.persists = false
                    inst.components.lootdropper:DropLoot(inst:GetPosition())
                end
            end),
            TimeEvent(3, function(inst)
                if inst.sg.mem.focuscount ~= nil then
                    inst.sg.mem.focuscount = nil
                    inst.sg.mem.focustargets = nil
                end
            end),
            TimeEvent(5, function(inst)
                ErodeAway(inst)
                RaiseFlyingCreature(inst)
            end),
        },

        onexit = function(inst)
            --Should NOT happen!
            if inst.sg.mem.focuscount ~= nil then
                inst.components.sanityaura.aura = -TUNING.SANITYAURA_HUGE
            end
            inst:RemoveTag("NOCLICK")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/wings_LP", "flying")
        end,
    },

    State{
        name = "attack",
        tags = { "attack", "busy", "nosleep", "nofreeze" },

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("atk")
            inst.components.combat:StartAttack()
            inst.sg.statemem.target = inst.components.combat.target
        end,

        timeline =
        {
            TimeEvent(0, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/attack_pre")
            end),
            TimeEvent(14 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/attack")
                inst.components.combat:DoAttack(inst.sg.statemem.target)
            end),
            CommonHandlers.OnNoSleepTimeEvent(23 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
                inst.sg:RemoveStateTag("nosleep")
                inst.sg:RemoveStateTag("nofreeze")
            end),
        },

        events =
        {
            CommonHandlers.OnNoSleepAnimOver("idle"),
        },
    },

}

local function CleanupIfSleepInterrupted(inst)
    if not inst.sg.statemem.continuesleeping then
        RestoreFlapping(inst)
    end
    RaiseFlyingCreature(inst)
end
CommonStates.AddSleepExStates(states,
{
    starttimeline =
    {
        TimeEvent(8 * FRAMES, StopFlapping),
        TimeEvent(28 * FRAMES, function(inst)
            inst.sg:RemoveStateTag("caninterrupt")
            inst.components.sanityaura.aura = 0
            LandFlyingCreature(inst)
        end),
        TimeEvent(31 * FRAMES, function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/bee/beehive_hit")
            ShakeIfClose(inst)
        end),
    },
    waketimeline =
    {
        TimeEvent(19 * FRAMES, StartFlapping),
        CommonHandlers.OnNoSleepTimeEvent(24 * FRAMES, function(inst)
            inst.sg:RemoveStateTag("busy")
            inst.sg:RemoveStateTag("nosleep")
            RaiseFlyingCreature(inst)
        end),
    },
},
{
    onsleep = function(inst)
        inst.sg:AddStateTag("caninterrupt")
        inst.sg.mem.wantstododge = true
    end,
    onexitsleep = CleanupIfSleepInterrupted,
    onsleeping = function(inst)
        inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/sleep")
        LandFlyingCreature(inst)
    end,
    onexitsleeping = CleanupIfSleepInterrupted,
    onwake = function(inst)
        StopFlapping(inst)
        LandFlyingCreature(inst)
    end,
    onexitwake = function(inst)
        RestoreFlapping(inst)
        RaiseFlyingCreature(inst)
    end,
})

local function OnOverrideFrozenSymbols(inst)
    inst.components.sanityaura.aura = 0
    StopFlapping(inst)
    inst.sg.mem.wantstododge = true
    inst.sg.mem.wantstoalert = true
    LandFlyingCreature(inst)
end
local function OnClearFrozenSymbols(inst)
    StartFlapping(inst)
    RaiseFlyingCreature(inst)
end
CommonStates.AddFrozenStates(states, OnOverrideFrozenSymbols, OnClearFrozenSymbols)

return StateGraph("SGwasp", states, events, "idle")
