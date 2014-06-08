
local pebble_assets=
{
	Asset("ANIM", "anim/fa_lavapebble.zip"),
    Asset("ATLAS", "images/inventoryimages/fa_lavapebble.xml"),
    Asset("IMAGE", "images/inventoryimages/fa_lavapebble.tex"),
}

local lavapebble_names = {"f1","f2","f3"}

local function pebbleonsave(inst, data)
	data.anim = inst.animname
end

local function pebbleonload(inst, data)
    if data and data.anim then
        inst.animname = data.anim
	    inst.AnimState:PlayAnimation(inst.animname)
	end
end

local function pebblefn(name,animnames)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)
    inst.animname="idle"

    if(animnames)then
	    if(type(animnames) == "table" )then
	    	inst.animname = animnames[math.random(#animnames)]
    	else
    		inst.animname=animnames
    	end
    end
	inst.AnimState:PlayAnimation(inst.animname)

	inst:AddTag("ore")
--    inst.AnimState:SetBank("fa_"..name.."pebble")
	 inst.AnimState:SetBank("fa_lavapebble")
    inst.AnimState:SetBuild("fa_"..name.."pebble")

    inst:AddComponent("edible")
    inst.components.edible.foodtype = "ELEMENTAL"
    inst.components.edible.hungervalue = 1
    inst:AddComponent("tradable")

    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename="fa_"..name.."pebble"
    inst.components.inventoryitem.atlasname="images/inventoryimages/fa_"..name.."pebble.xml"

	inst:AddComponent("repairer")
	inst.components.repairer.repairmaterial = name
	inst.components.repairer.healthrepairvalue = TUNING.REPAIR_ROCKS_HEALTH

    inst.OnSave = pebbleonsave 
    inst.OnLoad = pebbleonload 

	return inst
end

local function lavapebblefn(Sim)
	local inst=pebblefn("lava",lavapebble_names)
    inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )
    return inst
end

local function ironpebblefn(Sim)
	return pebblefn("iron",lavapebble_names)
end

local function coalpebblefn(Sim)
	local inst= pebblefn("coal",lavapebble_names)
	MakeSmallBurnable(inst, TUNING.LARGE_BURNTIME*2)
    MakeSmallPropagator(inst)
    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL*2
    return inst
end

local function limestonepebblefn(Sim)
	return pebblefn("limestone",lavapebble_names)
end

local function adamantinepebblefn(Sim)
	return pebblefn("adamantine",lavapebble_names)
end

local function copperpebblefn(Sim)
	return pebblefn("copper",lavapebble_names)
end

local function silverpebblefn(Sim)
	return pebblefn("silver",lavapebble_names)
end

return Prefab( "common/inventory/fa_lavapebble", lavapebblefn, pebble_assets),
Prefab( "common/inventory/fa_ironpebble", ironpebblefn, pebble_assets),
Prefab( "common/inventory/fa_coalpebble", coalpebblefn, pebble_assets),
Prefab( "common/inventory/fa_limestonepebble", limestonepebblefn, pebble_assets),
Prefab( "common/inventory/fa_adamantinepebble", adamantinepebblefn, pebble_assets),
Prefab( "common/inventory/fa_copperpebble", copperpebblefn, pebble_assets),
Prefab( "common/inventory/fa_silverpebble", silverpebblefn, pebble_assets)