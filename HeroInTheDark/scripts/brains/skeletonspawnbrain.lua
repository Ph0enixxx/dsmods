require "behaviours/wander"
require "behaviours/runaway"
require "behaviours/doaction"
require "behaviours/panic"

local SEE_PLAYER_DIST = 5
local SEE_FOOD_DIST = 10
local MAX_WANDER_DIST = 15
local MAX_CHASE_TIME = 10
local MAX_CHASE_DIST = 25
local RUN_AWAY_DIST = 5
local STOP_RUN_AWAY_DIST = 8


local Skeletonspawnbrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local function EatFoodAction(inst)
    local target = nil
    if inst.components.inventory and inst.components.eater then
        target = inst.components.inventory:FindItem(function(item) return inst.components.eater:CanEat(item) end)
    end
    if not target then
        target = FindEntity(inst, SEE_FOOD_DIST, function(item) return inst.components.eater:CanEat(item) end)
        
    end
    if target then
        local act = BufferedAction(inst, target, ACTIONS.EAT)
        act.validfn = function() return not (target.components.inventoryitem and target.components.inventoryitem.owner and target.components.inventoryitem.owner ~= inst) end
        return act
    end
end

local function GetFaceTargetFn(inst)
    return GetClosestInstWithTag("player", inst, SEE_PLAYER_DIST)
end

local function KeepFaceTargetFn(inst, target)
    return inst:GetDistanceSqToInst(target) <= SEE_PLAYER_DIST*SEE_PLAYER_DIST
end


function Skeletonspawnbrain:OnStart()
    local root = PriorityNode(
    {
         WhileNode( function() return self.inst.fa_daze~=nil end, "Daze", StandStill(self.inst)),
        WhileNode( function() return self.inst.fa_stun~=nil end, "Stun", StandStill(self.inst)),
        WhileNode( function() return self.inst.fa_fear~=nil end, "Turning", Panic(self.inst)),
        WhileNode( function() return self.inst.components.health.takingfiredamage and not (self.inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE] and self.inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]>=1) end, 
            "OnFire", Panic(self.inst)),
        WhileNode( function() return self.inst.components.combat.target == nil or not self.inst.components.combat:InCooldown() end, "AttackMomentarily",
            ChaseAndAttack(self.inst, MAX_CHASE_TIME, MAX_CHASE_DIST) ),
        DoAction(self.inst, EatFoodAction, "Eat Food"),
--        FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn),
        Wander(self.inst, function() 
            if(self.inst.components.homeseeker and self.inst.components.homeseeker.home)then
                return self.inst.components.homeseeker:GetHomePos()
            elseif(self.inst.components.knownlocations and self.inst.components.knownlocations:GetLocation("home"))then
                return self.inst.components.knownlocations:GetLocation("home")
            else
                return Vector3(self.inst.Transform:GetWorldPosition())
            end
        end

            , MAX_WANDER_DIST),
    }, .25)
    
    self.bt = BT(self.inst, root)

end

return Skeletonspawnbrain