local assets=
{
    Asset("ANIM", "anim/vorpalaxe.zip"),
    Asset("ANIM", "anim/swap_vorpalaxe.zip"),    
    Asset("ATLAS", "images/inventoryimages/vorpalaxe.xml"),
    Asset("IMAGE", "images/inventoryimages/vorpalaxe.tex"),
}

local VORPALAXE_DAMAGE_T1=60
local VORPALAXE_DAMAGE_T2=70
local VORPALAXE_DAMAGE_T3=85
local VORPALAXE_PROC_T1=0.03
local VORPALAXE_PROC_T2=0.07
local VORPALAXE_PROC_T3=0.12
local VORPALAXE_USES_T1=50
local VORPALAXE_USES_T2=100
local VORPALAXE_USES_T3=150

local function onfinished(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/gem_shatter")
    inst:Remove()
end

local function onattack(inst, attacker, target)
    local rng=math.random()
    if(target and (not target:HasTag("epic") and target.components.health and target.components.combat  and math.random()<=inst.procRate) then
          target.components.health:Kill()
     end
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_vorpalaxe", "swap_vorpalaxe")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal") 
end

local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
end


local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)
  
    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( "vorpalaxe.tex" )

    inst.AnimState:SetBank("vorpalaxe")
    inst.AnimState:SetBuild("vorpalaxe")
    inst.AnimState:PlayAnimation("idle")

    inst.Transform:SetScale(2, 2, 1)
    
    inst:AddTag("sharp")
    
    inst:AddComponent("weapon")
    inst.components.weapon:SetOnAttack(onattack)
    
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished( onfinished )

    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename="vorpalaxe"
    inst.components.inventoryitem.atlasname="images/inventoryimages/vorpalaxe.xml"
--    inst:AddComponent("dapperness")
--    inst.components.dapperness.dapperness = TUNING.CRAZINESS_MED,
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
    
    return inst
end

local function t1()
    local inst =fn()
    inst:AddTag("tier1")
    inst.procRate=VORPALAXE_PROC_T1
    inst.components.weapon:SetDamage(VORPALAXE_DAMAGE_T1)
    inst.components.finiteuses:SetMaxUses(VORPALAXE_USES_T1)
    inst.components.finiteuses:SetUses(VORPALAXE_USES_T1)
    return inst
end

local function t2()
    local inst =fn()
    inst:AddTag("tier2")
    inst.procRate=VORPALAXE_PROC_T2
    inst.components.weapon:SetDamage(VORPALAXE_DAMAGE_T2)
    inst.components.finiteuses:SetMaxUses(VORPALAXE_USES_T2)
    inst.components.finiteuses:SetUses(VORPALAXE_USES_T2)
    return inst
end

local function t3()
    local inst =fn()
    inst:AddTag("tier3")
    inst.procRate=VORPALAXE_PROC_T3
    inst.components.weapon:SetDamage(VORPALAXE_DAMAGE_T3)
    inst.components.finiteuses:SetMaxUses(VORPALAXE_USES_T3)
    inst.components.finiteuses:SetUses(VORPALAXE_USES_T3)
    return inst
end
return Prefab( "common/inventory/vorpalaxe", t1, assets),
    Prefab( "common/inventory/vorpalaxe2", t2, assets),
    Prefab( "common/inventory/vorpalaxe3", t3, assets)
