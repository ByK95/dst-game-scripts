require "prefabutil"

local assets = 
{
	Asset("ANIM", "anim/slot_machine.zip"),
	-- Asset("MINIMAP_IMAGE", "slot_machine"),
}

local prefabs =
{
	"armormarble",
	"armor_sanity",
	"armorsnurtleshell",
	"resurrectionstatue",
	"icestaff",
	"firestaff",
	"telestaff",
	"thulecite",
	"orangestaff",
	"greenstaff",
	"yellowstaff",
	"amulet",
	"blueamulet",
	"purpleamulet",
	"orangeamulet",
	"greenamulet",
	"yellowamulet",
	"redgem",
	"bluegem",
	"orangegem",
	"greengem",
	"purplegem",
	"stafflight",
	"gears",
	"collapse_small",
}

-- weighted_random_choice for bad, ok, good prize lists 
local prizevalues =
{
	bad = 2,
	ok = 3,
	good = 1,
}

local sounds = 
{
	ok = "ia/common/slotmachine/mediumresult",
	good = "ia/common/slotmachine/goodresult",
	bad = "ia/common/slotmachine/badresult",
}

local function SpawnCritter(inst, player, critter, lootdropper, pt, delay)
	delay = delay or GetRandomWithVariance(1,0.8)
	inst:DoTaskInTime(delay, function() 
		SpawnPrefab("collapse_small").Transform:SetPosition(pt:Get())
		local spawn = lootdropper:SpawnLootPrefab(critter, pt)
		if spawn then
			if spawn.components.combat then
				spawn.components.combat:SetTarget(player)
			end
		end
	end)
end

local function SpawnReward(inst, player, reward, lootdropper, pt, delay)
	delay = delay or GetRandomWithVariance(1,0.8)

	local loots = GetTreasureLootList(reward)
	for k, v in pairs(loots) do
		for i = 1, v, 1 do

			inst:DoTaskInTime(delay, function(inst) 
				-- local down = TheCamera:GetDownVec()
				-- local spawnangle = math.atan2(down.z, down.x)
				-- local angle = math.atan2(down.z, down.x) + (math.random()*90-45)*DEGREES
				-- local sp = math.random()*3+2
				--ripped right from our Octopus implementation
				local angle
				local spawnangle
				local sp = math.random()*3+2
				local x, y, z = inst.Transform:GetWorldPosition()
				
				if player ~= nil and player:IsValid() then
					angle = (225 - math.random()*90 - player:GetAngleToPoint(x, 0, z))*DEGREES
					spawnangle = player:GetAngleToPoint(x, 0, z)*DEGREES
				else
					local down = TheCamera:GetDownVec()
					angle = math.atan2(down.z, down.x) + (math.random()*90-45)*DEGREES
					spawnangle = math.atan2(down.z, down.x)
					player = nil
				end
				
				local item = SpawnPrefab(k)
				
				if  item and item:IsValid() then
					if item.components.inventoryitem and not item.components.health and not item:HasTag("heavy") and not item:HasTag("firefly") then
						local pt = Vector3(inst.Transform:GetWorldPosition()) + Vector3(1*math.cos(angle), 3, 1*math.sin(angle))
						inst.SoundEmitter:PlaySound("ia/common/slotmachine/reward")
						item.Transform:SetPosition(pt:Get())
						item.Physics:SetVel(sp*math.cos(angle), math.random()*2+9, sp*math.sin(angle))
						item.components.inventoryitem:SetLanded(false, true)
					else
						local pt = Vector3(inst.Transform:GetWorldPosition()) + Vector3(2*math.cos(angle), 0, 2*math.sin(angle))
						pt = pt + Vector3(sp*math.cos(angle), 0, sp*math.sin(angle))
						item.Transform:SetPosition(pt:Get())
						if not item:HasTag("FX") then
							SpawnPrefab("collapse_small").Transform:SetPosition(pt:Get())
						end
					end
				end
				
			end)
			delay = delay + 0.25
		end
	end
end

local function PickPrize(inst)

	local prizevalue = weighted_random_choice(prizevalues)
	-- print("slotmachine prizevalue", prizevalue)
	if prizevalue == "ok" then
		inst.prize = weighted_random_choice(SLOTMACHINE_LOOT.okspawns)
	elseif prizevalue == "good" then
		inst.prize = weighted_random_choice(SLOTMACHINE_LOOT.goodspawns)
	elseif prizevalue == "bad" then
		inst.prize = weighted_random_choice(SLOTMACHINE_LOOT.badspawns)
	else
		-- impossible!
		print("impossible slot machine prizevalue!", prizevalue)
	end

	inst.prizevalue = prizevalue
end

local function DoneSpinning(inst)

	local pos = inst:GetPosition()
	local item = inst.prize
	local doaction = SLOTMACHINE_LOOT.actions[item]
	local player = FindClosestPlayerToInst(inst, 20, true)

	local cnt = (doaction and doaction.cnt) or 1
	local func = (doaction and doaction.callback) or nil
	local radius = (doaction and doaction.radius) or 4
	local treasure = (doaction and doaction.treasure) or nil

	if doaction and doaction.var then
		cnt = GetRandomWithVariance(cnt,doaction.var)
		if cnt < 0 then cnt = 0 end
	end

	if cnt == 0 and func then
		func(inst,item,doaction)
	end

	for i=1,cnt do
		local offset, check_angle, deflected = FindWalkableOffset(pos, math.random()*2*PI, radius , 8, true, false, nil, true) -- try to avoid walls
		if offset then
			if treasure then
				-- print("Slot machine treasure "..tostring(treasure))
				-- SpawnTreasureLoot(treasure, inst.components.lootdropper, pos+offset)
				-- SpawnPrefab("collapse_small").Transform:SetPosition((pos+offset):Get())
				SpawnReward(inst, player, treasure)
			elseif func then
				func(inst,item,doaction)
			elseif item == "trinket" then
				if math.random() < .5 then
					SpawnCritter(inst, player, "trinket_ia_"..tostring(math.random(13,23)), inst.components.lootdropper, pos+offset)
				else
					SpawnCritter(inst, player, "trinket_"..tostring(math.random(NUM_TRINKETS)), inst.components.lootdropper, pos+offset)
				end
			elseif item == "nothing" then
				-- do nothing
				-- print("Slot machine says you lose.")
			else
				-- print("Slot machine item "..tostring(item))
				SpawnCritter(inst, player, item, inst.components.lootdropper, pos+offset)
			end
		end
	end

	-- the slot machine collected more coins
	inst.coins = inst.coins + 1

	--inst.AnimState:PlayAnimation("idle")
	inst.prize = nil
	inst.prizevalue = nil
	
	-- print("Slot machine has "..tostring(inst.coins).." dubloons.")
end

local function StartSpinning(inst)
	inst.sg:GoToState("spinning") --"busy" statetag blocks trader component
end

local function ShouldAcceptItem(inst, item)
	
	if not inst.sg.HasStateTag("busy") and item.prefab == "dubloon" then
		return true
	else
		return false
	end
end

local function OnGetItemFromPlayer(inst, giver, item)

	local sanityloss = math.clamp(inst.coins/2.5, 5, 40) -- Max out at 100 coins.
	giver.components.sanity:DoDelta(-sanityloss)

	PickPrize(inst)
	StartSpinning(inst)
end

local function OnRefuseItem(inst, item)
	-- print("Slot machine refuses "..tostring(item.prefab))
end

local function OnLoad(inst,data)
	if not data then
		return
	end
	
	inst.coins = data.coins or 0
	inst.prize = data.prize
	inst.prizevalue = data.prizevalue

	if inst.prize ~= nil then
		StartSpinning(inst)
	end
end

local function OnSave(inst,data)
	data.coins = inst.coins
	data.prize = inst.prize
	data.prizevalue = inst.prizevalue
end

local function onStartFlooded(inst)
	inst.components.trader:Disable()
end

local function onStopFlooded(inst)
	inst.components.trader:Enable()
end

local function OnHaunt(inst)
	if math.random() <= TUNING.HAUNT_CHANCE_RARE then
		inst.prizevalue = "bad"
		inst.prize = weighted_random_choice(SLOTMACHINE_LOOT.badspawns)
		inst.sg:GoToState("prize_bad")
	end
end

local function fn()
	local inst = CreateEntity()

	inst.sounds = sounds

	inst.entity:AddTransform()
	
	inst.entity:AddAnimState()
	inst.AnimState:SetBank("slot_machine")
	inst.AnimState:SetBuild("slot_machine")
	inst.AnimState:PlayAnimation("idle")
	
	inst.entity:AddSoundEmitter()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddNetwork()

	inst.MiniMapEntity:SetPriority(5)
	inst.MiniMapEntity:SetIcon("slot_machine.tex")

    MakeObstaclePhysics(inst, 0.8, 1.2)

	inst:AddTag("slotmachine")
	
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst.DoneSpinning = DoneSpinning

	-- keeps track of how many dubloons have been added
	inst.coins = 0
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = function(inst)
		return "WORKING"
	end

	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	inst.components.hauntable.onhaunt = OnHaunt
	
	inst:AddComponent("lootdropper")

	-- "payable" was identical to trader, we're lazy and will use trader directly :P
	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(ShouldAcceptItem)
	inst.components.trader.onaccept = OnGetItemFromPlayer
	inst.components.trader.onrefuse = OnRefuseItem

	inst:SetStateGraph("SGslotmachine")
	
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad

	return inst
end

return Prefab("slotmachine", fn, assets, prefabs)
