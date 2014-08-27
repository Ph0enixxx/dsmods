local hutassets =
{
    Asset("ANIM", "anim/fa_dwarfhut.zip"),    
}
local bedassets =
{
    Asset("ANIM", "anim/fa_dwarfbed.zip"),    
}
local standassets =
{
    Asset("ANIM", "anim/fa_dwarfstand.zip"),    
}
local prefabs = 
{
	"fa_dorf",
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
    if(inst.fa_flag)then
        inst.fa_flag:Remove()
    end
	inst:Remove()
end

local function fn()
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    local shadow = inst.entity:AddDynamicShadow()
    shadow:SetSize( 6, 3 )
    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( "fa_dorf.tex" )

    inst:AddTag("structure")
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({ "rocks", "rocks","cutgrass","cutgrass","cutgrass","cutgrass","boards","boards","boards","boards"})
    inst.components.lootdropper:AddFallenLootTable(MergeMaps(FALLENLOOTTABLEMERGED,FALLENLOOTTABLE.keys3),FALLENLOOTTABLE.TABLE_WEIGHT+FALLENLOOTTABLE.TABLE_KEYS3_WEIGHT,0.15)
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(8)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst:AddComponent("inspectable")
    
    MakeSnowCovered(inst, .01)
    return inst
end

local function fnhut(Sim)
    local inst=fn()
    inst.Transform:SetScale(1.4,1.4, 1.4)

--    inst.Transform:SetScale(2,2, 2)
    local light = inst.entity:AddLight()

    light:SetFalloff(2)
    light:SetIntensity(.5)
    light:SetRadius(3)
    light:Enable(true)
    light:SetColour(180/255, 35/255, 50/255)
    
    MakeObstaclePhysics(inst, 2)

    inst.AnimState:SetBank("fa_dwarfhut")
    inst.AnimState:SetBuild("fa_dwarfhut")
    inst.AnimState:PlayAnimation("light_closed",true)

--	inst.components.workable:SetOnWorkCallback(onhit)
	
    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "fa_dorf"
    inst.components.childspawner:SetRegenPeriod(TUNING.SPIDERDEN_REGEN_TIME)
    inst.components.childspawner:SetSpawnPeriod(TUNING.SPIDERDEN_RELEASE_TIME)
    inst.components.childspawner:SetMaxChildren(1)
    inst.components.childspawner:StartSpawning()

    return inst
end

local function fnbed()
    local inst=fn()
     MakeObstaclePhysics(inst, 1)
    inst.Transform:SetScale(1.3,1.3, 1.3)
    inst.AnimState:SetBank("fa_dwarfbed")
    inst.AnimState:SetBuild("fa_dwarfbed")
    inst.AnimState:PlayAnimation("full",true)
    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "fa_dorf"
    inst.components.childspawner:SetRegenPeriod(TUNING.SPIDERDEN_REGEN_TIME)
    inst.components.childspawner:SetSpawnPeriod(TUNING.SPIDERDEN_RELEASE_TIME)
    inst.components.childspawner:SetMaxChildren(1)
    inst.components.childspawner:StartSpawning()
    return inst
end

local function fnstand()
    local inst=fn()
    local light = inst.entity:AddLight()

    light:SetFalloff(2)
    light:SetIntensity(.8)
    light:SetRadius(3)
    light:Enable(true)
    light:SetColour(180/255, 35/255, 50/255)
    inst.Transform:SetScale(1.7,1.7, 1.7)
     MakeObstaclePhysics(inst, 4)
    inst.AnimState:SetBank("fa_dwarfstand")
    inst.AnimState:SetBuild("fa_dwarfstand")
    inst.AnimState:PlayAnimation("idle",true)
    return inst
end

return Prefab( "common/objects/fa_dorfhut", fnhut, hutassets, prefabs ),
Prefab( "common/objects/fa_dorfbed", fnbed, bedassets, prefabs ),
Prefab( "common/objects/fa_dorfstand", fnstand, standassets, prefabs )
