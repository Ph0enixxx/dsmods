local assets=
{
	Asset("ANIM", "anim/armor_frost.zip"),
  Asset("ATLAS", "images/inventoryimages/frostarmor.xml"),
  Asset("IMAGE", "images/inventoryimages/frostarmor.tex"),
}

local function OnBlocked(owner) 
    owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_armour")
end

local function onequip(inst, owner) 
--    owner.AnimState:OverrideSymbol("swap_body", "armor_marble", "swap_body")
    inst:ListenForEvent("blocked", OnBlocked, owner)
end

local function onunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_body")
    inst:RemoveEventCallback("blocked", OnBlocked, owner)
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
    
    inst.AnimState:SetBank("armor_marble")
    inst.AnimState:SetBuild("armor_frost")
    inst.AnimState:PlayAnimation("anim")
    
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.foleysound = "dontstarve/movement/foley/marblearmour"
     inst.components.inventoryitem.atlasname = "images/inventoryimages/frostarmor.xml"
    inst.components.inventoryitem.imagename="frostarmor"
    
    inst:AddComponent("armor")
    inst.components.armor:InitCondition(TUNING.ARMORMARBLE, TUNING.ARMORMARBLE_ABSORPTION)
    
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable.walkspeedmult = TUNING.ARMORMARBLE_SLOW
    
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
    
    return inst
end

return Prefab( "common/inventory/armorfrost", fn, assets) 
