require "recipes"
local Assets =
{
    Asset("ATLAS", "images/inventoryimages/fa_bottles.xml"),
    Asset("IMAGE", "images/inventoryimages/fa_bottles.tex" ),
    Asset("ANIM", "anim/fa_bottles.zip"),
	Asset("ANIM", "anim/frog.zip"),
	Asset("SOUND", "sound/frog.fsb"),
	Asset( "ANIM", "anim/smoke_up.zip" ),
}

local prefabs = {
    "blueprint",
    "fa_blooddownfx"
}

local blueprints={"tools_blueprint","magic_blueprint","town_blueprint","dress_blueprint","survival_blueprint","refine_blueprint","war_blueprint","ancient_blueprint","light_blueprint","farm_blueprint"}


local POISON_LENGTH=10
local POISON_DAMAGE=5
local POISON_PERIOD=2

local WONDER_EFFECTS={
	{
		fn=function(eater)
--		    eater.SoundEmitter:SetParameter("frogger_theme", "intensity", 1)
--			print("polymorph self")
			eater.components.locomotor:Stop()
--			eater.components.playercontroller:Enable(true)
--			eater:AddTag("notarget")
			local pos =eater:GetPosition()
--			eater:RemoveFromScene()
			local frog=SpawnPrefab("frog")
--			frog:ClearStateGraph()
			frog:StopBrain()
			frog:SetBrain(require "brains/froghaxbrain")
			frog:RestartBrain()
			frog:AddTag("notarget")
			frog:AddTag("fa_wonderswap")
			frog.components.health.invincible=true
--frog.brainfn=nil
			frog:AddComponent("follower")
			frog.components.locomotor.runspeed=2*eater.components.locomotor.runspeed
			eater.components.leader:AddFollower(frog)
			

		local boom = CreateEntity()
	    boom.entity:AddTransform()
	    local anim=boom.entity:AddAnimState()
	    boom.Transform:SetScale(1, 1, 1)
	    anim:SetBank("smoke_up")
	    anim:SetBuild("smoke_up")
	    anim:PlayAnimation("idle",false)
		
	    boom.Transform:SetPosition(pos.x, pos.y, pos.z)
    
    	boom:ListenForEvent("animover", function() 
    		frog.Transform:SetPosition(pos.x, pos.y, pos.z) 
    		frog.SoundEmitter:PlaySound("fa/music/frogger","frogger_theme")
    		boom:Remove() 
    	end)

--			frog.components.playercontroller:Enable(true)
			
			for k,v in pairs(eater.components.inventory.equipslots) do
				local item=	eater.components.inventory:Unequip(k)
				eater.components.inventory:GiveItem(item)
			end

--[[
	if eater.Physics then
        eater.Physics:SetActive(false)
    end
]]
--	eater.Physics:SetCollides(false)
    if eater.Light then
        eater.Light:Enable(false)
    end
    if eater.DynamicShadow then
        eater.DynamicShadow:Enable(false)
    end
--[[
--    if eater.AnimState then
 --       eater.AnimState:Pause()
  --  end

		eater:ListenForEvent("animover", function() 
    		eater.AnimState:Pause()
    	end)
	]]
    eater.entity:Hide()
			GetPlayer().HUD:Hide()

	eater:DoTaskInTime(60,function()
				eater:ReturnToScene()
				frog.SoundEmitter:KillSound("frogger_theme")
--				eater.components.playercontroller:Enable(true)
				frog:Remove()    		
--				eater.Physics:SetCollides(true)
				GetPlayer().HUD:Show()

				if eater.Light then
    			    eater.Light:Enable(true)
    			end
    			if eater.DynamicShadow then
        			eater.DynamicShadow:Enable(true)
    			end
    			eater.entity:Show()
--    			eater.AnimState:Resume()
			end)
		end
	},
	{
		fn=function(eater)
--		print("hounded")
		 local hounded = GetWorld().components.hounded
			if(hounded)then
				--go through full warn phase?
				local talk=GetString(eater.prefab, "FA_WONDER_HOUNDED")
				print("talk",talk)
				if(talk and eater.components.talker) then eater.components.talker:Say(talk) end
				hounded.timetoattack=hounded.warnduration+2
			end
		end
	},
	{
		fn=function(eater)
			local talk=GetString(eater.prefab, "FA_WONDER_POISON")
			if(talk and eater.components.talker) then eater.components.talker:Say(talk) end
			local function dopoison(inst,target)
    if(target and not target.components.health:IsDead())then
--        target.components.health:DoDelta(-POISON_DAMAGE)
		 	target.components.combat:GetAttacked(eater, POISON_DAMAGE, nil,nil,FA_DAMAGETYPE.POISON)
		 		local boom =SpawnPrefab("fa_poisonfx")
--                boom.AnimState:SetMultColour(0.3, 1, 0.3,1)
                local follower = boom.entity:AddFollower()
                follower:FollowSymbol(target.GUID, target.components.combat.hiteffectsymbol, 0, 0.1, -0.0001)
                boom.persists=false
                boom:ListenForEvent("animover", function()  boom:Remove() end)
    end
			end
			eater.components.hunger:DoDelta(-50)
			local inst = CreateEntity()
      		local trans = inst.entity:AddTransform()

    		local spell = inst:AddComponent("spell")
    		inst.components.spell.spellname = "fa_poison"
    		inst.components.spell.duration = POISON_LENGTH
    		inst.components.spell.fn = dopoison
    		inst.components.spell.period=POISON_PERIOD
    		inst.components.spell.removeonfinish = true
    		inst.components.spell.ontargetfn = function(inst,target)
        		target.fa_poison = inst
        		target:AddTag(inst.components.spell.spellname)
    		end
    		inst.components.spell.onfinishfn = function(inst)
        		if not inst.components.spell.target then
            		return
        		end
		        inst.components.spell.target.fa_poison = nil
    		end
    		inst.components.spell:SetTarget(eater)
    		inst.components.spell:StartSpell()
		end
	},
	{
		fn=function(eater)
			local talk=GetString(eater.prefab, "FA_WONDER_SPEEDBOOST")
			if(talk and eater.components.talker) then eater.components.talker:Say(talk) end
--			print("haste")
			eater.components.locomotor.runspeed=eater.components.locomotor.runspeed+TUNING.WILSON_RUN_SPEED
			eater:DoTaskInTime(240,function() eater.components.locomotor.runspeed=eater.components.locomotor.runspeed-TUNING.WILSON_RUN_SPEED end)
		end
	},
	{
		fn=function(eater)
			local talk=GetString(eater.prefab, "FA_WONDER_SPEEDNERF")
			if(talk and eater.components.talker) then eater.components.talker:Say(talk) end
--		print("slow")
			eater.components.locomotor.runspeed=eater.components.locomotor.runspeed-TUNING.WILSON_RUN_SPEED/2
			eater:DoTaskInTime(240,function() eater.components.locomotor.runspeed=eater.components.locomotor.runspeed+TUNING.WILSON_RUN_SPEED/2 end)
		end
	},
	{
		fn=function(eater)
			local talk=GetString(eater.prefab, "FA_WONDER_HPRESTORE")
			if(talk and eater.components.talker) then eater.components.talker:Say(talk) end
			eater.components.health:DoDelta(200)
		end
	},
	{
		fn=function(eater)
			local talk=GetString(eater.prefab, "FA_WONDER_HPDAMAGE")
			if(talk and eater.components.talker) then eater.components.talker:Say(talk) end
			eater.components.health:DoDelta(-50)
		end
	},
	{
		fn=function(eater)
			local talk=GetString(eater.prefab, "FA_WONDER_SLEEP")
			if(talk and eater.components.talker) then eater.components.talker:Say(talk) end
			eater.components.hunger:DoDelta(-50)
			eater.components.locomotor:Stop()
			eater.sg:GoToState("sleep")
			eater.components.health:SetInvincible(true)
			eater.components.playercontroller:Enable(false)

			GetPlayer().HUD:Hide()
			TheFrontEnd:Fade(false,1)
			eater:DoTaskInTime(1.2, function() 
		
				GetPlayer().HUD:Show()
				TheFrontEnd:Fade(true,1) 
				eater.components.health:SetInvincible(false)
				eater.components.playercontroller:Enable(true)
				GetClock():MakeNextDay()
				eater.sg:GoToState("wakeup")	
			end)

		end
	},
	{
		fn=function(eater)
			local talk=GetString(eater.prefab, "FA_WONDER_GOLD")
			if(talk and eater.components.talker) then eater.components.talker:Say(talk) end
			local pt= Vector3(eater.Transform:GetWorldPosition())
		    for i=1,10 do
	        local drop = SpawnPrefab("goldnugget") 
    	    drop.Physics:SetCollides(false)
        	drop.Physics:Teleport(pt.x+(math.random()-0.5)*5, pt.y+3, pt.z+(math.random()-0.5)*5) 
        	drop.Physics:SetCollides(true)
        	eater.SoundEmitter:PlaySound("dontstarve/common/stone_drop")
		    end

		end
	},
	{
		fn=function(eater)
			local talk=GetString(eater.prefab, "FA_WONDER_LS")
			if(talk and eater.components.talker) then eater.components.talker:Say(talk) end
			local pos=Vector3(eater.Transform:GetWorldPosition())
			GetSeasonManager():DoLightningStrike(pos)			
--			local lightning = SpawnPrefab("lightning")
--            lightning.Transform:SetPosition(pos:Get())
		end
	},
	{
		fn=function(eater)
			eater.components.sanity:DoDelta(200)
			local talk=GetString(eater.prefab, "FA_WONDER_SANITYRESTORE")
			if(talk and eater.components.talker) then eater.components.talker:Say(talk) end
		end
	},
	{
		fn=function(eater)
			local talk=GetString(eater.prefab, "FA_WONDER_INSANITY")
			if(talk and eater.components.talker) then eater.components.talker:Say(talk) end
			eater.components.sanity:SetPercent(0.05)
		end
	},
	{
		fn=function(eater)
			eater.components.hunger:DoDelta(200)
			local talk=GetString(eater.prefab, "FA_WONDER_HUNGERRESTORE")
			if(talk and eater.components.talker) then eater.components.talker:Say(talk) end
		end
	},
	{
		fn=function(eater)
			local talk=GetString(eater.prefab, "FA_WONDER_NIGHTMAREFUEL")
			if(talk and eater.components.talker) then eater.components.talker:Say(talk) end
			local pt= Vector3(eater.Transform:GetWorldPosition())
		    for i=1,10 do
	        local drop = SpawnPrefab("nightmarefuel") 
    	    drop.Physics:SetCollides(false)
        	drop.Physics:Teleport(pt.x+(math.random()-0.5)*5, pt.y+3, pt.z+(math.random()-0.5)*5) 
        	drop.Physics:SetCollides(true)
        	eater.SoundEmitter:PlaySound("dontstarve/common/stone_drop")
		    end

		end
	},
	{
		fn=function(eater)
			local talk=GetString(eater.prefab, "FA_WONDER_NAUGHTINESS")
			if(talk and eater.components.talker) then eater.components.talker:Say(talk) end
			eater.components.kramped:OnNaughtyAction(30)
		end
	},
	{
		fn=function(eater)
			local talk=GetString(eater.prefab, "FA_WONDER_ITEMDAMAGE")
			if(talk and eater.components.talker) then eater.components.talker:Say(talk) end
			--yawn... can i merge them without breaking anything?
			local merged=MergeMaps(eater.components.inventory.itemslots,eater.components.inventory.equipslots)
    		for k,v in pairs(merged) do
		        if v.components.fueled then
        		    v.components.fueled:SetPercent(v.components.fueled:GetPercent()/2)
        		elseif v.components.armor then
        			v.components.armor:SetPercent(v.components.armor:GetPercent()/2)
        		elseif v.components.finiteuses then
        			v.components.finiteuses:SetPercent(v.components.finiteuses:GetPercent()/2)
        		end
    		end
		end
	},
	{
		fn=function(eater)
			local talk=GetString(eater.prefab, "FA_WONDER_ITEMREPAIR")
			if(talk and eater.components.talker) then eater.components.talker:Say(talk) end
			local merged=MergeMaps(eater.components.inventory.itemslots,eater.components.inventory.equipslots)
    		for k,v in pairs(merged) do
		        if v.components.fueled then
        		    v.components.fueled:SetPercent(v.components.fueled:GetPercent()/2)
        		elseif v.components.armor then
        			v.components.armor:SetPercent(v.components.armor:GetPercent()/2)
        		elseif v.components.finiteuses then
        			v.components.finiteuses:SetPercent(v.components.finiteuses:GetPercent()/2)
        		end
    		end
		end
	},
	{
		fn=function(eater)
			local talk=GetString(eater.prefab, "FA_WONDER_BLUEPRINT")
			if(talk and eater.components.talker) then eater.components.talker:Say(talk) end
			local bptodrop=blueprints[1+math.floor(math.random()*#blueprints)]
			print("bp",bptodrop)
			if(bptodrop)then
				local b=SpawnPrefab(bptodrop)
				local pt= Vector3(eater.Transform:GetWorldPosition())
				b.Transform:SetPosition(pt:Get())
			end
		end
	},
	{
		fn=function(eater)
			local talk=GetString(eater.prefab, "FA_WONDER_GEMS")
			if(talk and eater.components.talker) then eater.components.talker:Say(talk) end
			local pt= Vector3(eater.Transform:GetWorldPosition())
			for k,v in pairs({"redgem","bluegem","purplegem"}) do
				local drop = SpawnPrefab(v) 
    		    drop.Physics:SetCollides(false)
        		drop.Physics:Teleport(pt.x+(math.random()-0.5)*5, pt.y+3, pt.z+(math.random()-0.5)*5) 
        		drop.Physics:SetCollides(true)
        		eater.SoundEmitter:PlaySound("dontstarve/common/stone_drop")
        	end
		end
	}

}

local function oneaten(inst,eater)
end

local function eatwonder(inst,data)
	local eater=data.eater
	if(eater and eater:HasTag("player"))then
		local index=math.floor(1+(math.random() * #WONDER_EFFECTS))
--		index=1
		local effect=WONDER_EFFECTS[index]
		if(effect)then
			effect.fn(eater)
		else
			print("no effect??")
		end
	end
end

local function common(name)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.Transform:SetScale(3,3, 3)


    inst.AnimState:SetBank("fa_"..name)
    inst.AnimState:SetBuild("fa_bottles")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryPhysics(inst)
        
    inst:AddTag("potion")
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/fa_bottles.xml"
    inst.components.inventoryitem.imagename="fa_"..name

	inst:AddComponent("inspectable")	
	
    inst:AddComponent("edible")
    inst.components.edible.healthvalue=0
    inst.components.edible.hungervalue=0
    inst.components.edible.sanityvalue=0
    inst.components.edible.foodtype = "FA_POTION"
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = 20

    inst.components.edible.oneaten=oneaten
--    inst:ListenForEvent("oneaten",oneaten)
    
    return inst
end

local function fnr(Sim)

	local inst = common("bottle_r")
    inst.components.edible.healthvalue = 150
    return inst

end

local function fny(Sim)

	local inst = common("bottle_y")
    inst.components.edible.hungervalue = 150
    return inst

end

local function fng(Sim)

	local inst = common("bottle_g")
    inst.components.edible.sanityvalue = 150
    return inst

end


local function fnb(Sim)

	local inst = common("bottle_b")

	inst:ListenForEvent("oneaten",eatwonder)

    return inst

end

return Prefab( "common/inventory/fa_bottle_r", fnr, Assets),
	Prefab( "common/inventory/fa_bottle_y", fny, Assets),
	Prefab( "common/inventory/fa_bottle_g", fng, Assets),
	Prefab( "common/inventory/fa_bottle_b", fnb, Assets)