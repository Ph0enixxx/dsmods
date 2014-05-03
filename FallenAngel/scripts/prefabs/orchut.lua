local assets =
{
	Asset("ANIM", "anim/goblinhut.zip"),
    Asset("SOUND", "sound/pig.fsb"),
}

local prefabs = 
{
	"orc",
}


        
local function onhammered(inst, worker)
    if inst.doortask then
        inst.doortask:Cancel()
        inst.doortask = nil
    end
	if inst.components.childspawner then
        inst.components.childspawner:ReleaseAllChildren()
    end
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
end

local function onhit(inst, worker)
--	inst.AnimState:PlayAnimation("hit")
	inst.AnimState:PushAnimation("idle")
end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    local light = inst.entity:AddLight()
    inst.entity:AddSoundEmitter()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon( "goblin.png" )
    light:SetFalloff(1)
    light:SetIntensity(.5)
    light:SetRadius(1)
    light:Enable(false)
    light:SetColour(180/255, 195/255, 50/255)
    
    MakeObstaclePhysics(inst, 1)

    anim:SetBank("goblinhut")
    anim:SetBuild("goblinhut")
    anim:PlayAnimation("idle")

    inst:AddTag("structure")
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({ "rocks", "rocks","cutgrass","cutgrass","cutgrass","cutgrass","boards","boards","boards","boards"})
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(8)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	
    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "orc"
    inst.components.childspawner:SetRegenPeriod(TUNING.SPIDERDEN_REGEN_TIME)
    inst.components.childspawner:SetSpawnPeriod(TUNING.SPIDERDEN_RELEASE_TIME)
--    inst.components.childspawner.spawnoffscreen=true
    inst.components.childspawner:SetMaxChildren(2)
    inst.components.childspawner:StartSpawning()
--        inst.components.childspawner:SetSpawnedFn(onspawnspider)


    inst:AddComponent("inspectable")
    
	MakeSnowCovered(inst, .01)

    --[[
    inst:DoTaskInTime(math.random(), function() 
        --print(inst, "spawn check day")
        if GetClock():IsDay() then 
            OnDay(inst)
        end 
    end)
]]
    return inst
end

return Prefab( "common/objects/orchut", fn, assets, prefabs )