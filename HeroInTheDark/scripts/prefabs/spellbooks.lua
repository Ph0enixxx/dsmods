local assets =
{
	Asset("ANIM", "anim/fa_scrolls.zip"),
    Asset("ANIM", "anim/books.zip"),
    Asset("ANIM", "anim/goodberries.zip"),
	--Asset("SOUND", "sound/common.fsb"),
}
 
local prefabs =
{
    "tentacle",
    "splash_ocean",
    "treeguardian",
    "fa_goodberries",
    "book_fx"
}    

local debris =
{
    common = 
    {
        "rocks",
        "flint"
    },
 --[[    rare = 
    {
        "goldnugget",
        "nitre"
    },
   veryrare =
    {
        "redgem",
        "bluegem",
        "marble",
    },]]--
}

local SPELL_HEAL_AMOUNT=150
local EARTHQUAKE_MINING_EFFICIENCY=6
local EARTHQUAKE_DAMAGE=100
local CALL_DIETY_DAMAGE=100
local LIGHTNING_DAMAGE=100
local FLAMESTRIKE_DAMAGE=10
local BUFF_LENGTH=100
local HASTE_LENGTH=60
local LONGSTRIDER_LENGTH=120
local INVISIBILITY_LENGTH=120
local BB_LENGTH=12

local NATURESALLY_SUMMON_TIME=8*60
local  NATURESPAWN_SUMMON_TIME=60

local CURE_LIGHT=10
local CURE_MOD=15
local CURE_SER=20
local CURE_CRIT=25


function curelightfn(inst, reader)
    local cl=1
    if(reader.components.fa_spellcaster)then
        cl=reader.components.fa_spellcaster:GetCasterLevel(FA_SPELL_SCHOOLS.CONJURATION)
    end
    local boom =SpawnPrefab("fa_heal_greenfx")
    local follower = boom.entity:AddFollower()
    follower:FollowSymbol(reader.GUID,reader.components.combat.hiteffectsymbol, 0, 0.1, -0.0001)
    boom.persists=false
    boom:ListenForEvent("animover", function()  boom:Remove() end)

    reader.components.health:DoDelta(CURE_LIGHT*(1+math.floor(cl/4)))
    return true
end

function curemodfn(inst, reader)
    local cl=1
    if(reader.components.fa_spellcaster)then
        cl=reader.components.fa_spellcaster:GetCasterLevel(FA_SPELL_SCHOOLS.CONJURATION)
    end
    local boom =SpawnPrefab("fa_heal_greenfx")
    local follower = boom.entity:AddFollower()
    follower:FollowSymbol(reader.GUID,reader.components.combat.hiteffectsymbol, 0, 0.1, -0.0001)
    boom.persists=false
    boom:ListenForEvent("animover", function()  boom:Remove() end)
    reader.components.health:DoDelta(CURE_MOD*(1+math.floor(cl/4)))
    return true
end

function cureserfn(inst, reader)
    local cl=1
    if(reader.components.fa_spellcaster)then
        cl=reader.components.fa_spellcaster:GetCasterLevel(FA_SPELL_SCHOOLS.CONJURATION)
    end
    local boom =SpawnPrefab("fa_heal_greenfx")
    local follower = boom.entity:AddFollower()
    follower:FollowSymbol(reader.GUID,reader.components.combat.hiteffectsymbol, 0, 0.1, -0.0001)
    boom.persists=false
    boom:ListenForEvent("animover", function()  boom:Remove() end)
    reader.components.health:DoDelta(CURE_SER*(1+math.floor(cl/4)))
    return true
end

function  curecritfn(inst, reader)
    local cl=1
    if(reader.components.fa_spellcaster)then
        cl=reader.components.fa_spellcaster:GetCasterLevel(FA_SPELL_SCHOOLS.CONJURATION)
    end
    local boom =SpawnPrefab("fa_heal_greenfx")
    local follower = boom.entity:AddFollower()
    follower:FollowSymbol(reader.GUID,reader.components.combat.hiteffectsymbol, 0, 0.1, -0.0001)
    boom.persists=false
    boom:ListenForEvent("animover", function()  boom:Remove() end)
    reader.components.health:DoDelta(CURE_CRIT*(1+math.floor(cl/4)))
    return true
end

function tentaclesfn(inst, reader)
    local pt = Vector3(reader.Transform:GetWorldPosition())

    local numtentacles = 3

    reader.components.sanity:DoDelta(-TUNING.SANITY_MED)

    reader:StartThread(function()
        for k = 1, numtentacles do
        
            local theta = math.random() * 2 * PI
            local radius = math.random(3, 8)

            -- we have to special case this one because birds can't land on creep
            local result_offset = FindValidPositionByFan(theta, radius, 12, function(offset)
                local x,y,z = (pt + offset):Get()
                local ents = TheSim:FindEntities(x,y,z , 1)
                return not next(ents) 
            end)

            if result_offset then
                local tentacle = SpawnPrefab("tentacle")
                
                tentacle.Transform:SetPosition((pt + result_offset):Get())
                GetPlayer().components.playercontroller:ShakeCamera(reader, "FULL", 0.2, 0.02, .25, 40)
                
                --need a better effect
                local fx = SpawnPrefab("splash_ocean")
                local pos = pt + result_offset
                fx.Transform:SetPosition(pos.x, pos.y, pos.z)
                --PlayFX((pt + result_offset), "splash", "splash_ocean", "idle")
                tentacle.sg:GoToState("attack_pre")
            end

            Sleep(.33)
        end
    end)
    return true    

end

function growfn(inst, reader)
    print("got into grow")
    reader.components.sanity:DoDelta(-TUNING.SANITY_MED)
    local range = 30
    local pos = Vector3(reader.Transform:GetWorldPosition())
    local ents = TheSim:FindEntities(pos.x,pos.y,pos.z, range)
    for k,v in pairs(ents) do
        if v.components.pickable then
            v.components.pickable:FinishGrowing()
        end

        if v.components.crop then
            v.components.crop:DoGrow(TUNING.TOTAL_DAY_TIME*3)
        end
        
        if v:HasTag("tree") and v.components.growable and not v:HasTag("stump") then
            v.components.growable:DoGrowth()
        end
    end
    return true
end


function flamestrikefn(inst, reader)
    local cl=1
    if(reader.components.fa_spellcaster)then
        cl=reader.components.fa_spellcaster:GetCasterLevel(FA_SPELL_SCHOOLS.EVOCATION)
    end
    local damage=cl*FLAMESTRIKE_DAMAGE
    local pos=Vector3(reader.Transform:GetWorldPosition())
            local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, 20)
            for k,v in pairs(ents) do
                if not v:HasTag("player") and not v:HasTag("companion") and not v:IsInLimbo() then
                    if v.components.burnable and not v.components.fueled then
                     v.components.burnable:Ignite()
                    end

                    if(v.components.combat and not (v.components.health and v.components.health:IsDead())) then
                        v.components.combat:GetAttacked(reader, damage, nil,nil,FA_DAMAGETYPE.FIRE)
                    end
                end
            end
    return true
end

function firefn(inst, reader)

    local num_lightnings =  1
    local pos=Vector3(reader.Transform:GetWorldPosition())
    reader:StartThread(function()
        for k = 0, num_lightnings do
           local lightning = SpawnPrefab("lightning")
            lightning.Transform:SetPosition(pos:Get())
            local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, 20)
            for k,v in pairs(ents) do
                if not v:HasTag("player") and not v:HasTag("companion") and not v:IsInLimbo() then
                    if v.components.burnable and not v.components.fueled then
                     v.components.burnable:Ignite()
                    end

                    if(v.components.combat and not (v.components.health and v.components.health:IsDead())) then
                        v.components.combat:GetAttacked(reader, LIGHTNING_DAMAGE, nil,nil,FA_DAMAGETYPE.ELECTRIC)
                    end
                end
            end
        end
    end)
    return true
end

function healfn(inst, reader)

--    reader.components.sanity:DoDelta(-TUNING.SANITY_MED)
    reader.components.health:DoDelta(SPELL_HEAL_AMOUNT)
    return true
end

function divinemightfn(inst, reader)
--    reader.components.sanity:DoDelta(-TUNING.SANITY_MED)
    reader.buff_timers["divinemight"]:ForceCooldown(BUFF_LENGTH)
    DivineMightSpellStart( reader,BUFF_LENGTH)
    return true
end

function invisibilityfn(inst,reader)
    --reader.components.sanity:DoDelta(-TUNING.SANITY_MED)
    reader.buff_timers["invisibility"]:ForceCooldown(INVISIBILITY_LENGTH)
    InvisibilitySpellStart( reader,INVISIBILITY_LENGTH)
    return true
end

function hastefn(inst,reader)
    if(reader.buff_timers["haste"])then
        reader.buff_timers["haste"]:ForceCooldown(HASTE_LENGTH)
    end
    HasteSpellStart( reader,HASTE_LENGTH)
    return true
end

function longstriderfn(inst,reader)
    if(reader.buff_timers["longstrider"])then
        reader.buff_timers["longstrider"]:ForceCooldown(LONGSTRIDER_LENGTH)
    end
    FA_LongstriderSpellStart( reader,LONGSTRIDER_LENGTH)
    return true
end


local feast_table={"baconeggs","dragonpie","fishtacos","fishsticks","honeynuggets","honeyham","meatballs","bonestew"}

function summonfeastfn(inst,reader)
    local spawn_point= Vector3(reader.Transform:GetWorldPosition())
    local pt = Vector3(spawn_point.x, 0, spawn_point.z)
    local count=1
    if(reader.prefab=="cleric")then
        count=5
    end
    for i=1,count do
        local drop = SpawnPrefab(feast_table[1+math.floor(math.random()*#feast_table)]) 
        drop.Physics:SetCollides(false)
        drop.Physics:Teleport(pt.x+(math.random()-0.5)*5, pt.y+3, pt.z+(math.random()-0.5)*5) 
        drop.Physics:SetCollides(true)
        reader.SoundEmitter:PlaySound("dontstarve/common/stone_drop")
    end
    return true
end

function summongoodberriesfn(inst,reader)
    local spawn_point= Vector3(reader.Transform:GetWorldPosition())
    local pt = Vector3(spawn_point.x, 0, spawn_point.z)
    local count=5
    for i=1,count do
        local drop = SpawnPrefab("fa_goodberries") 
        drop.Physics:SetCollides(false)
        drop.Physics:Teleport(pt.x+(math.random()-0.5)*5, pt.y, pt.z+(math.random()-0.5)*5) 
        drop.Physics:SetCollides(true)
        reader.SoundEmitter:PlaySound("dontstarve/common/stone_drop")
    end
    return true
end

function lightfn(inst, reader)
    reader.buff_timers["light"]:ForceCooldown(BUFF_LENGTH)
    LightSpellStart( reader,BUFF_LENGTH)
    return true
end

function bladebarrierfn(inst,reader)
--    reader.components.sanity:DoDelta(-TUNING.SANITY_MED)
    reader.buff_timers["bladebarrier"]:ForceCooldown(BB_LENGTH)
    BladeBarrierSpellStart( reader,BB_LENGTH)
    return true
end

local function GetDebris()
    local rng = math.random()
    local todrop = nil
--    if rng < 0.75 then
        todrop = debris.common[math.random(1, #debris.common)]
--    elseif rng >= 0.75 and rng < 0.95 then
--    else
--        todrop = debris.rare[math.random(1, #debris.rare)]
--    else
--        todrop = debris.veryrare[math.random(1, #debris.veryrare)]
--    end
    return todrop
end

local function SpawnDebris(spawn_point)
    local prefab = GetDebris()
    if prefab then
        local db = SpawnPrefab(prefab)
        if math.random() < .5 then
            db.Transform:SetRotation(180)
        end
        spawn_point.y = 35


        db.Physics:Teleport(spawn_point.x,spawn_point.y,spawn_point.z)

        return db
    end
end


local function UpdateShadowSize(inst, height)
    if inst.shadow then
        local scaleFactor = Lerp(0.5, 1.5, height/35)
        inst.shadow.Transform:SetScale(scaleFactor, scaleFactor, scaleFactor)
    end
end

local function GiveDebrisShadow(inst)
    local pt = Vector3(inst.Transform:GetWorldPosition())
    inst.shadow = SpawnPrefab("warningshadow")
    UpdateShadowSize(inst, 35)
    inst.shadow.Transform:SetPosition(pt.x, 0, pt.z)
end

local function quake(inst,reader)
    --mobs can't read books... yet it's bound to cause issues eventually
    local attacker=reader
    local pt=  Point(attacker.Transform:GetWorldPosition())
    local pos=Vector3(reader.Transform:GetWorldPosition())

    local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, 20,nil, {'smashable',"companion","player","INLIMBO"})
    for k,v in pairs(ents) do
 -- quakes shouldn't break the set dressing
                if v.components.workable and v.components.workable.action == ACTIONS.MINE then
                    local numworks=EARTHQUAKE_MINING_EFFICIENCY
                     v.components.workable:WorkedBy(reader, numworks)

                elseif(v.components.combat and not v:IsInLimbo() and not (v.components.health and v.components.health:IsDead()))then
                    v.components.combat:GetAttacked(attacker, EARTHQUAKE_DAMAGE, nil)
               

                local spawn_point= Vector3(v.Transform:GetWorldPosition())
                local db = SpawnDebris(spawn_point)    


                if spawn_point.y < 2 then
                    db.Physics:SetMotorVel(0,0,0)
                end

                if spawn_point.y <= .2 then
                    PlayFallingSound(db)

                    db.Physics:SetDamping(0.9)        

                if math.random() < 0.75 then
                    --spawn break effect
                    db.SoundEmitter:PlaySound("dontstarve/common/stone_drop")
                    local pt = Vector3(db.Transform:GetWorldPosition())
                    local breaking = SpawnPrefab("ground_chunks_breaking")
                    breaking.Transform:SetPosition(pt.x, 0, pt.z)
                    db:Remove()
                end

                end

                end
        end
end

function calldietyfn(inst,reader)
    reader.components.sanity:DoDelta(-TUNING.SANITY_MED)
    TheCamera:Shake("FULL", 0.3, 0.02, .5, 40)
    inst.SoundEmitter:PlaySound("dontstarve/cave/earthquake", "earthquake")
    inst.SoundEmitter:SetParameter("earthquake", "intensity", 1)
    local attacker=reader
    local pos=Vector3(reader.Transform:GetWorldPosition())

        local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, 20,nil, {'smashable',"player","companion","INLIMBO"})
        for k,v in pairs(ents) do
             -- quakes shouldn't break the set dressing
                if(v.components.combat and not v:IsInLimbo() and not (v.components.health and v.components.health:IsDead()))then
                    v.components.combat:GetAttacked(attacker, CALL_DIETY_DAMAGE, nil,nil,FA_DAMAGETYPE.HOLY)
                end
        end
     inst:DoTaskInTime(3, function() inst.SoundEmitter:KillSound("earthquake") end)
    return true
end

function earthquakefn(inst,reader)
    reader.components.sanity:DoDelta(-TUNING.SANITY_MED)
    TheCamera:Shake("FULL", 0.3, 0.02, .5, 40)
    inst.SoundEmitter:PlaySound("dontstarve/cave/earthquake", "earthquake")
    inst.SoundEmitter:SetParameter("earthquake", "intensity", 1)
    local num=1
    reader:StartThread(function()
        for i=1,num do
            quake(inst,reader)
            Sleep(0.5)
        end
    end)

    inst:DoTaskInTime(3, function() inst.SoundEmitter:KillSound("earthquake") end)
    return true
end

function treeguardianfn(inst,reader)

    local spawn_point= Vector3(reader.Transform:GetWorldPosition())
    local tree = SpawnPrefab("treeguardian") 
    local pt = Vector3(spawn_point.x, 0, spawn_point.z)
        tree.Physics:SetCollides(false)
        tree.Physics:Teleport(pt.x, pt.y, pt.z) 
        tree.Physics:SetCollides(true)
        tree.SoundEmitter:PlaySound("dontstarve/common/place_structure_stone")
        reader.components.leader:AddFollower(tree)
        tree.sg:GoToState("spawn")
    tree:ListenForEvent("stopfollowing",function(f)
        f.components.health:Kill()
    end)
     return true

end

function blackspiderspawn(inst,reader)
    local spawn_point= Vector3(reader.Transform:GetWorldPosition())
    local tree = SpawnPrefab("spider") 
    local pt = Vector3(spawn_point.x, 0, spawn_point.z)
        tree.Physics:SetCollides(false)
        tree.Physics:Teleport(pt.x, pt.y, pt.z) 
        tree.Physics:SetCollides(true)
        reader.components.leader:AddFollower(tree)
        tree.sg:GoToState("spawn")
        tree:ListenForEvent("stopfollowing",function(f)
            f.components.health:Kill()
        end)
        --those things have messed up targetting, they'd eat all other followers if not controlled
        tree.components.combat:SetRetargetFunction(1, function(inst)
            return FindEntity(inst, 20, function(guy)
            return  guy.components.combat and 
                    inst.components.combat:CanTarget(guy) and
                    (guy.components.combat.target == reader or reader.components.combat.target == guy)
            end)
            end 
            )

    return tree
end

function naturesallyfn(inst,reader)

    local spider=blackspiderspawn(inst,reader)
    spider.maxfollowtime=NATURESALLY_SUMMON_TIME
    spider.components.follower:AddLoyaltyTime(NATURESALLY_SUMMON_TIME)

     return true

end

function naturespawnfn(inst,reader)

    local spider=blackspiderspawn(inst,reader)
    spider.maxfollowtime=NATURESPAWN_SUMMON_TIME
    spider.components.follower:AddLoyaltyTime(NATURESPAWN_SUMMON_TIME)
    local spider=blackspiderspawn(inst,reader)
    spider.maxfollowtime=NATURESPAWN_SUMMON_TIME
    spider.components.follower:AddLoyaltyTime(NATURESPAWN_SUMMON_TIME)

     return true

end

function faeriefirefn(inst,reader)

    local spawn_point= Vector3(reader.Transform:GetWorldPosition())
    local tree = SpawnPrefab("fa_lavaflies") 
    local pt = Vector3(spawn_point.x, 0, spawn_point.z)
        tree.Physics:SetCollides(false)
        tree.Physics:Teleport(pt.x, pt.y, pt.z) 
        tree.Physics:SetCollides(true)
     return true

end

function daylightfn(inst,reader)
    local spawn_point= Vector3(reader.Transform:GetWorldPosition())
    local fx=SpawnPrefab("fa_daylightfx")
    fx.Transform:SetPosition(spawn_point.x, 0, spawn_point.z)
    return true
end

function curepoisonfn(inst,reader)
    if(reader and reader.fa_poison) then
        reader.fa_poison.components.spell:OnFinished()
        return true
    else
        return false
    end
end

function atonementfn(inst,reader)
    if(reader.components.kramped) then
        reader.components.kramped.actions=0
        return true
    end 
    return false
end

function onfinished(inst)
    inst:Remove()
end

function MakeSpell(name, usefn, bookuses,school )
    
    local function fn(Sim)
        print("make spell",name,usefn,bookuses)
    	local inst = CreateEntity()
    	local trans = inst.entity:AddTransform()
    	local anim = inst.entity:AddAnimState()
        local sound = inst.entity:AddSoundEmitter()
        --need to go through some lists and set all properly
        if(school)then
            anim:SetBank("fa_scrolls")
            anim:SetBuild("fa_scrolls")
            anim:PlayAnimation(school)
        else
            anim:SetBank("books")
            anim:SetBuild("books")
            anim:PlayAnimation("book_birds")
        end
--        anim:PlayAnimation(name)
        MakeInventoryPhysics(inst)
        
        -----------------------------------
        
        inst:AddTag("book")
        inst:AddComponent("inspectable")
        inst:AddComponent("book")
        inst.components.book.onread = usefn

        local assetname=nil
--        inst:AddComponent("characterspecific")
--        inst.components.characterspecific:SetOwner("druid")
        
        inst:AddComponent("inventoryitem")
        if(school)then
            assetname="fa_scroll_"..school

            inst.components.inventoryitem.atlasname="images/inventoryimages/"..assetname..".xml"
            inst.components.inventoryitem.imagename=assetname
        else
            inst.components.inventoryitem.imagename="book_brimstone"
        end

        inst:AddComponent("finiteuses")
        inst.components.finiteuses:SetMaxUses( bookuses )
        inst.components.finiteuses:SetUses( bookuses )
        inst.components.finiteuses:SetOnFinished( onfinished )

        MakeSmallBurnable(inst)
        MakeSmallPropagator(inst)


        return inst
    end

    return Prefab( "common/"..name, fn, assets, prefabs) 
end


return 


--    local r=Recipe("fa_spell_flamestrike", {Ingredient("redgem", 2), Ingredient("ash", 10), Ingredient("gunpowder", 10)}, RECIPETABS.SPELLS,TECH.NONE)


    MakeSpell("fa_spell_curelightwounds",curelightfn,10,FA_SPELL_SCHOOLS.CONJURATION),
    MakeSpell("fa_spell_curemoderatewounds",curemodfn,8,FA_SPELL_SCHOOLS.CONJURATION),
    MakeSpell("fa_spell_cureseriouswounds",cureserfn,7,FA_SPELL_SCHOOLS.CONJURATION),
    MakeSpell("fa_spell_curecriticalwounds",curecritfn,6,FA_SPELL_SCHOOLS.CONJURATION),
    MakeSpell("fa_spell_longstrider", longstriderfn,10,FA_SPELL_SCHOOLS.TRANSMUTATION),
    MakeSpell("fa_spell_faeriefire",faeriefirefn,7,FA_SPELL_SCHOOLS.EVOCATION),
    MakeSpell("fa_spell_naturesally",naturesallyfn,10,FA_SPELL_SCHOOLS.CONJURATION),
    MakeSpell("fa_spell_summonswarm",naturespawnfn,5,FA_SPELL_SCHOOLS.CONJURATION),
    MakeSpell("fa_spell_naturesally2",treeguardianfn,7,FA_SPELL_SCHOOLS.CONJURATION),
    MakeSpell("fa_spell_daylight",daylightfn,12,FA_SPELL_SCHOOLS.EVOCATION),
    MakeSpell("fa_spell_curepoison",curepoisonfn,10,FA_SPELL_SCHOOLS.CONJURATION),
    MakeSpell("fa_spell_grow",growfn,15,FA_SPELL_SCHOOLS.TRANSMUTATION),
    MakeSpell("fa_spell_grow",atonementfn,3,FA_SPELL_SCHOOLS.ABJURATION),
    MakeSpell("fa_spell_lightningstorm",firefn,6,FA_SPELL_SCHOOLS.EVOCATION),
    MakeSpell("fa_spell_flamestrike",flamestrikefn,5,FA_SPELL_SCHOOLS.EVOCATION),


        MakeSpell("spell_lightning", firefn, 10,"conjuration"),
       MakeSpell("spell_earthquake", earthquakefn, 12,"divinantion"),
       MakeSpell("spell_grow", growfn, 15,"evocation"),
       MakeSpell("spell_heal", healfn, 10,"enchantment"),
       MakeSpell("spell_divinemight", divinemightfn, 15,"illusion"),
       MakeSpell("spell_calldiety", calldietyfn, 10,"necromancy"),
       MakeSpell("spell_light", lightfn, 12,"transmutation"),
       MakeSpell("spell_bladebarrier", bladebarrierfn, 5,"abjuration"),
       MakeSpell("spell_guardian", treeguardianfn, 7),
       MakeSpell("spell_summonfeast", summonfeastfn, 5),
       MakeSpell("spell_summongoodberries", summongoodberriesfn, 10),

       MakeSpell("spell_invisibility", invisibilityfn,10),
       MakeSpell("spell_haste", hastefn, 5)