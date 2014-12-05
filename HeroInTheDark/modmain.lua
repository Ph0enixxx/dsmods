local require = GLOBAL.require
require "class"
require "util"
require "stategraph"
local MergeMaps=GLOBAL.MergeMaps

GLOBAL.FA_DLCACCESS=false
GLOBAL.xpcall(function()
                    GLOBAL.FA_DLCACCESS= GLOBAL.IsDLCEnabled and GLOBAL.REIGN_OF_GIANTS and GLOBAL.IsDLCEnabled(GLOBAL.REIGN_OF_GIANTS)
                end,
                function()
                    --if the calls crashed im assuming outdated code and dlc is off by default
                    print("dlc crash")
                end
            )

GLOBAL.FA_ModCompat={}
GLOBAL.FA_ModCompat.memspikefix_delay=1
--push out the env functions without namespace pollution
GLOBAL.FA_ModUtil={}
GLOBAL.FA_ModUtil.AddPrefabPostInit=AddPrefabPostInit
GLOBAL.FA_ModUtil.AddComponentPostInit=AddComponentPostInit
GLOBAL.FA_ModUtil.GetModConfigData=GetModConfigData
GLOBAL.FA_ModUtil.AddAction=AddAction
GLOBAL.FA_ModUtil.AddStategraphActionHandler=AddStategraphActionHandler

for _, mod in ipairs( GLOBAL.ModManager.mods ) do
        if mod.modinfo.name == "RPG HUD" or mod.modinfo.id == "RPG HUD" then
            GLOBAL.FA_ModCompat.rpghudmod=mod
--            print("hud version",mod,mod.modinfo.id,mod.modinfo.name, mod.modinfo.description)
        elseif mod.modinfo.name == "memspikefix" or mod.modinfo.id == "memspikefix"  then
            GLOBAL.FA_ModCompat.memspikefixed=true
        elseif mod.modinfo.name=="Always On Status" or mod.modinfo.id=="Always On Status" then
            GLOBAL.FA_ModCompat.alwaysonmod=mod
        elseif mod.modinfo.name=="UpAndAway" or mod.modinfo.id=="UpAndAway" then
            GLOBAL.FA_ModCompat.UnA=mod
        end
    end
if(not GLOBAL.FA_ModCompat.memspikefixed and GetModConfigData("memspikefix"))then
    print("patching memory abuse")
    modimport "memspikefix.lua"
    GLOBAL.FA_ModCompat.memspikefixed=true
else
    print("bypassing memspikefix")
end

print("dlc status",GLOBAL.FA_DLCACCESS)
modimport "damage_entity.lua"
GLOBAL.FA_ModUtil.MakeDamageEntity=MakeDamageEntity

local Widget = require "widgets/widget"
local XPBadge= require "widgets/xpbadge"
local TextEdit=require "widgets/textedit"
local ItemTile = require "widgets/itemtile"
local Image = require "widgets/image"
local FA_WarClock = require "widgets/fa_warclock"
local FA_BuffBar=require "widgets/fa_buffbar"
local FA_StatusBar=require "widgets/fa_statusbar"

local FA_CharRenameScreen=require "screens/fa_charrenamescreen"
local FA_SpellBookScreen=require "screens/fa_spellbookscreen"
local StatusDisplays = require "widgets/statusdisplays"
local ImageButton = require "widgets/imagebutton"
local Levels=require("map/levels")

require "constants"
require "fa_constants"
require "widgets/text"
require "buffutil"
require "fa_mobxptable"
require "fa_strings"
require "fa_levelxptable"
require "fa_stealthdetectiontable"
require "fa_actions"
require "fa_inventory_override"
require "fa_inventorybar_override"
require "fa_combat_override"
require "fa_hounded_override"
require "fa_behavior_override"
require "fa_electricalfence"
require "fa_recipes"

--modimport "spelleffects.lua"

--
local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS
local STRINGS = GLOBAL.STRINGS
local ACTIONS = GLOBAL.ACTIONS
local GROUND=GLOBAL.GROUND
local Action = GLOBAL.Action
local ActionHandler=GLOBAL.ActionHandler
local GetPlayer = GLOBAL.GetPlayer
local GetClock=GLOBAL.GetClock
local GetWorld=GLOBAL.GetWorld
local GetSeasonManager=GLOBAL.GetSeasonManager
local SpawnPrefab=GLOBAL.SpawnPrefab
local TheFrontEnd=GLOBAL.TheFrontEnd

local FA_DAMAGETYPE=GLOBAL.FA_DAMAGETYPE


--it should be fixed now
--require "repairabledescriptionfix"

PrefabFiles = {
    "fa_bbq",
    "fa_fx",
    "fa_bars",
    "fa_decor",
    "fa_racks",
    "fa_shrooms",
    "fa_dorfkingstatue",
    "fa_crafting",
    "fa_fireboulder",
    "fa_bags",
    "fa_pebbles",
    "fa_rocks",
    "fa_lavarain",
    "fa_sand",
    "fa_fissures",
    "fa_forcefields",
    "fa_fissurefx",
    "fa_fireflies",
    "fa_teleporter",
    "fa_hats",
    "fa_baseweapons",
    "fa_basearmor",
    "fa_wortox",
    "fa_stickheads",
    "fa_dungeon_walls",
    "goblinsignpost",
    "fa_lavamound",
    "fa_firehoundmound",
    "fa_animatedarmor",
    "fa_bonfire",
    "fa_dungeon_entrance",
    "fa_dungeon_exit",
    "fa_surface_portal",
    "fa_scribescrolls",
    "fa_summons",
    "fa_spell_prefabs",
    "fa_skins",
    "cheats",
    "fa_weaponupgrades",
    "poisonspider",
    "poisonspider_gland",
    "poisonspiderden",
    "poisonspiderqueen",
    "poisonspidereggsack",
    "spellprojectiles",
    "natureshealing",
    "fa_lights",
    "skeletonspawn",
    "boomstickprojectile",
    "fizzleboomstick",
    "fizzlearmor",
    "poopbricks",
    "treeguardian",
    "fizzlepet",
    "fizzlemanipulator",
    "rjk1100",
    "dksword",
    "holysword",
    "thieftraps",
    "fa_menders",
    "fa_arrows",
    "fa_bow",
    "fa_keys",
    "fa_chests",
    "fa_boots",
    "fa_rings",
    "fa_fireaxe",
    "fa_iceaxe",
    "fa_food",
    "fa_potions",
    "spellbooks",
    "shields",
    "armor_fire",
    "armor_frost",
    "fa_totems",
    "dagger",
    "fa_lightningsword",
    "flamingsword",
    "frostsword",
    "undeadbanesword",
    "vorpalaxe",
    "wands",
    "dryad",
    "satyr",
    "unicorn",
    "fa_dorfs",
    "fa_dorfhut",
    "fa_orchut",
    "fa_orc",
    "fa_ogre",
    "fa_troll",
    "goblin",
    "wolf",
    "goblinhut",
    "wolfmound",
	"thief",
	"barb",
	"cleric",
    "fa_druidpet",
	"druid",
	"darkknight",
    "darkknightpet",
    "monk",
    "necromancer",
    "necropet",
    "wizard",
    "tinkerer",
    "paladin",
    "bard",
    "ranger",
}


Assets = {
    Asset( "IMAGE", "images/saveslot_portraits/thief.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/thief.xml" ),
    Asset( "IMAGE", "images/saveslot_portraits/barb.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/barb.xml" ),
    Asset( "IMAGE", "images/saveslot_portraits/cleric.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/cleric.xml" ),
    Asset( "IMAGE", "images/saveslot_portraits/druid.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/druid.xml" ),
    Asset( "IMAGE", "images/saveslot_portraits/darkknight.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/darkknight.xml" ),
    Asset( "IMAGE", "images/saveslot_portraits/monk.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/monk.xml" ),
    Asset( "IMAGE", "images/saveslot_portraits/necromancer.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/necromancer.xml" ),
    Asset( "IMAGE", "images/saveslot_portraits/wizard.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/wizard.xml" ),
    Asset( "IMAGE", "images/saveslot_portraits/tinkerer.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/tinkerer.xml" ),
    Asset( "IMAGE", "images/saveslot_portraits/paladin.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/paladin.xml" ),
    Asset( "IMAGE", "images/saveslot_portraits/ranger.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/ranger.xml" ),
    Asset( "IMAGE", "images/saveslot_portraits/bard.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/bard.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/thief.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/thief.xml" ),
    Asset( "IMAGE", "images/selectscreen_portraits/barb.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/barb.xml" ),
    Asset( "IMAGE", "images/selectscreen_portraits/cleric.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/cleric.xml" ),
    Asset( "IMAGE", "images/selectscreen_portraits/druid.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/druid.xml" ),
    Asset( "IMAGE", "images/selectscreen_portraits/darkknight.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/darkknight.xml" ),
    Asset( "IMAGE", "images/selectscreen_portraits/monk.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/monk.xml" ),
    Asset( "IMAGE", "images/selectscreen_portraits/necromancer.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/necromancer.xml" ),
    Asset( "IMAGE", "images/selectscreen_portraits/wizard.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/wizard.xml" ),
    Asset( "IMAGE", "images/selectscreen_portraits/tinkerer.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/tinkerer.xml" ),
    Asset( "IMAGE", "images/selectscreen_portraits/paladin.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/paladin.xml" ),
    Asset( "IMAGE", "images/selectscreen_portraits/ranger.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/ranger.xml" ),
    Asset( "IMAGE", "images/selectscreen_portraits/bard.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/bard.xml" ),


    Asset( "IMAGE", "bigportraits/thief.tex" ),
    Asset( "ATLAS", "bigportraits/thief.xml" ),
    Asset( "IMAGE", "bigportraits/barb.tex" ),
    Asset( "ATLAS", "bigportraits/barb.xml" ),
    Asset( "IMAGE", "bigportraits/cleric.tex" ),
    Asset( "ATLAS", "bigportraits/cleric.xml" ),
    Asset( "IMAGE", "bigportraits/druid.tex" ),
    Asset( "ATLAS", "bigportraits/druid.xml" ),
    Asset( "IMAGE", "bigportraits/monk.tex" ),
    Asset( "ATLAS", "bigportraits/monk.xml" ),
    Asset( "IMAGE", "bigportraits/necromancer.tex" ),
    Asset( "ATLAS", "bigportraits/necromancer.xml" ),
    Asset( "IMAGE", "bigportraits/darkknight.tex" ),
    Asset( "ATLAS", "bigportraits/darkknight.xml" ),
    Asset( "IMAGE", "bigportraits/wizard.tex" ),
    Asset( "ATLAS", "bigportraits/wizard.xml" ),
    Asset( "IMAGE", "bigportraits/tinkerer.tex" ),
    Asset( "ATLAS", "bigportraits/tinkerer.xml" ),
    Asset( "IMAGE", "bigportraits/paladin.tex" ),
    Asset( "ATLAS", "bigportraits/paladin.xml" ),
    Asset( "IMAGE", "bigportraits/ranger.tex" ),
    Asset( "ATLAS", "bigportraits/ranger.xml" ),
    Asset( "IMAGE", "bigportraits/bard.tex" ),
    Asset( "ATLAS", "bigportraits/bard.xml" ),

    Asset("SOUNDPACKAGE", "sound/fa.fev"),
    Asset("SOUND", "sound/fallenangel.fsb"),

    Asset( "IMAGE", "images/xp_background.tex" ),
    Asset( "ATLAS", "images/xp_background.xml" ),
    Asset( "IMAGE", "images/xp_fill.tex" ),
    Asset( "ATLAS", "images/xp_fill.xml" ),
    Asset( "IMAGE", "images/transparent.tex" ),
    Asset( "ATLAS", "images/transparent.xml" ),

    Asset( "IMAGE", "minimap/boneshield.tex" ),
    Asset( "ATLAS", "minimap/boneshield.xml" ),
    Asset( "IMAGE", "minimap/marbleshield.tex" ),
    Asset( "ATLAS", "minimap/marbleshield.xml" ),
    Asset( "IMAGE", "minimap/reflectshield.tex" ),
    Asset( "ATLAS", "minimap/reflectshield.xml" ),
    Asset( "IMAGE", "minimap/rockshield.tex" ),
    Asset( "ATLAS", "minimap/rockshield.xml" ),
    Asset( "IMAGE", "minimap/woodbow.tex" ),
    Asset( "ATLAS", "minimap/woodbow.xml" ),
    Asset( "IMAGE", "minimap/woodshield.tex" ),
    Asset( "ATLAS", "minimap/woodshield.xml" ), 

    Asset("ATLAS", "images/inventoryimages/fa_smeltingfurnace.xml"),
    Asset("IMAGE", "images/inventoryimages/fa_smeltingfurnace.tex"),
    Asset("ATLAS", "images/inventoryimages/fa_forge.xml"),
    Asset("IMAGE", "images/inventoryimages/fa_forge.tex"),
    Asset("ATLAS", "images/inventoryimages/fa_alchemytable.xml"),
    Asset("IMAGE", "images/inventoryimages/fa_alchemytable.tex"),

    Asset("ATLAS", "minimap/fa_smeltingfurnace.xml"),
    Asset("IMAGE", "minimap/fa_smeltingfurnace.tex"),
    Asset("ATLAS", "minimap/fa_forge.xml"),
    Asset("IMAGE", "minimap/fa_forge.tex"),
    Asset("ATLAS", "minimap/fa_alchemytable.xml"),
    Asset("IMAGE", "minimap/fa_alchemytable.tex"),
    Asset("ATLAS", "minimap/fa_keg.xml"),
    Asset("IMAGE", "minimap/fa_keg.tex"),
    Asset("ATLAS", "minimap/fa_distiller.xml"),
    Asset("IMAGE", "minimap/fa_distiller.tex"),

    Asset("ATLAS", "images/inventoryimages/fa_puppet.xml"),
    Asset("IMAGE", "images/inventoryimages/fa_puppet.tex"),

    Asset("ATLAS", "images/inventoryimages/fa_shields.xml"),
    Asset("IMAGE", "images/inventoryimages/fa_shields.tex"),
    Asset("ATLAS", "images/inventoryimages/poisonspidergland.xml"),
    Asset("IMAGE", "images/inventoryimages/poisonspidergland.tex"),
    Asset("ATLAS", "images/inventoryimages/poisonspider_gland_salve.xml"),
    Asset("IMAGE", "images/inventoryimages/poisonspider_gland_salve.tex"),
    Asset("ATLAS", "images/inventoryimages/fa_goblinskin.xml"),
    Asset("IMAGE", "images/inventoryimages/fa_goblinskin.tex"),
    Asset("ATLAS", "images/inventoryimages/fa_wand_case.xml"),
    Asset("IMAGE", "images/inventoryimages/fa_wand_case.tex"),
    Asset("ATLAS", "images/inventoryimages/fa_scroll_case.xml"),
    Asset("IMAGE", "images/inventoryimages/fa_scroll_case.tex"),


    Asset( "IMAGE", "images/inventoryimages/fa_scroll_conjuration.tex" ),
    Asset( "ATLAS", "images/inventoryimages/fa_scroll_conjuration.xml" ),
    Asset( "IMAGE", "images/inventoryimages/fa_scroll_divination.tex" ),
    Asset( "ATLAS", "images/inventoryimages/fa_scroll_divination.xml" ),
    Asset( "IMAGE", "images/inventoryimages/fa_scroll_evocation.tex" ),
    Asset( "ATLAS", "images/inventoryimages/fa_scroll_evocation.xml" ),
    Asset( "IMAGE", "images/inventoryimages/fa_scroll_enchantment.tex" ),
    Asset( "ATLAS", "images/inventoryimages/fa_scroll_enchantment.xml" ),
    Asset( "IMAGE", "images/inventoryimages/fa_scroll_illusion.tex" ),
    Asset( "ATLAS", "images/inventoryimages/fa_scroll_illusion.xml" ),
    Asset( "IMAGE", "images/inventoryimages/fa_scroll_necromancy.tex" ),
    Asset( "ATLAS", "images/inventoryimages/fa_scroll_necromancy.xml" ),
    Asset( "IMAGE", "images/inventoryimages/fa_scroll_transmutation.tex" ),
    Asset( "ATLAS", "images/inventoryimages/fa_scroll_transmutation.xml" ),
    Asset( "IMAGE", "images/inventoryimages/fa_scroll_abjuration.tex" ),
    Asset( "ATLAS", "images/inventoryimages/fa_scroll_abjuration.xml" ),
    Asset("ATLAS", "images/inventoryimages/fa_bottles.xml"),
    Asset("IMAGE", "images/inventoryimages/fa_bottles.tex" ),
    Asset("ATLAS", "images/inventoryimages/fa_pebbles.xml"),
    Asset("IMAGE", "images/inventoryimages/fa_pebbles.tex"),
    Asset("ATLAS", "images/inventoryimages/fa_orebars.xml"),
    Asset("IMAGE", "images/inventoryimages/fa_orebars.tex"),
    Asset("ATLAS", "images/inventoryimages/fa_hats.xml"),
    Asset("IMAGE", "images/inventoryimages/fa_hats.tex"),
  Asset("ATLAS", "images/inventoryimages/fa_basearmors.xml"),
  Asset("IMAGE", "images/inventoryimages/fa_basearmors.tex"),
  Asset("ATLAS", "images/inventoryimages/fa_baseweapons.xml"),
  Asset("IMAGE", "images/inventoryimages/fa_baseweapons.tex"),

    Asset( "IMAGE", "minimap/goblin.tex" ),
    Asset( "ATLAS", "minimap/goblin.xml" ),  
    Asset( "IMAGE", "minimap/fa_orc.tex" ),
    Asset( "ATLAS", "minimap/fa_orc.xml" ),  
    Asset( "IMAGE", "minimap/fa_dorf.tex" ),
    Asset( "ATLAS", "minimap/fa_dorf.xml" ),  
    Asset( "IMAGE", "minimap/cleric.tex" ),
    Asset( "ATLAS", "minimap/cleric.xml" ),  
    Asset( "IMAGE", "minimap/bard.tex" ),
    Asset( "ATLAS", "minimap/bard.xml" ),  
    Asset( "IMAGE", "minimap/wizard.tex" ),
    Asset( "ATLAS", "minimap/wizard.xml" ),  
    Asset( "IMAGE", "minimap/necromancer.tex" ),
    Asset( "ATLAS", "minimap/necromancer.xml" ),  
    Asset( "IMAGE", "minimap/tinkerer.tex" ),
    Asset( "ATLAS", "minimap/tinkerer.xml" ),  
    Asset( "IMAGE", "minimap/barb.tex" ),
    Asset( "ATLAS", "minimap/barb.xml" ),  
    Asset( "IMAGE", "minimap/druid.tex" ),
    Asset( "ATLAS", "minimap/druid.xml" ),  
    Asset( "IMAGE", "minimap/paladin.tex" ),
    Asset( "ATLAS", "minimap/paladin.xml" ),  
    Asset( "IMAGE", "minimap/darkknight.tex" ),
    Asset( "ATLAS", "minimap/darkknight.xml" ), 
    Asset( "IMAGE", "minimap/fa_rocks.tex" ),
    Asset( "ATLAS", "minimap/fa_rocks.xml" ), 
    Asset( "IMAGE", "minimap/fa_wheat.tex" ),
    Asset( "ATLAS", "minimap/fa_wheat.xml" ), 
    Asset( "ANIM", "anim/fa_shieldpuff.zip" ),

    Asset( "ANIM", "anim/generating_goblin_cave.zip" ),
    Asset( "ANIM", "anim/generating_mine_cave.zip" ),
    Asset( "IMAGE", "images/lava3.tex" ),
    Asset( "IMAGE", "images/lava2.tex" ),
    Asset( "IMAGE", "images/lava1.tex" ),
    Asset( "IMAGE", "images/lava.tex" ),

    Asset( "IMAGE", "images/fa_title.tex" ),
    Asset( "ATLAS", "images/fa_title.xml" ), 

    Asset( "IMAGE", "colour_cubes/lavacube.tex" ),
    Asset( "IMAGE", "colour_cubes/identity_colourcube.tex" ),
    Asset( "IMAGE", "colour_cubes/darkvision_cc.tex" ),


    Asset( "IMAGE", "images/equipslots.tex" ),
    Asset( "ATLAS", "images/equipslots.xml" ),  
    Asset( "IMAGE", "images/fa_equipbar_bg.tex" ),
    Asset( "ATLAS", "images/fa_equipbar_bg.xml" ),  


    Asset( "ANIM", "anim/fa_player_anims.zip" ),
    Asset( "ANIM", "anim/player_cage_drop.zip" ),
    Asset( "ANIM", "anim/fa_cagechains.zip" ),
    Asset( "ANIM", "anim/fa_orcfort_cage.zip" ),
--    Asset( "ANIM", "anim/icebomb.zip" ),
--    Asset( "ANIM", "anim/player_test.zip" ),
}

--[[
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("spriter_idle", true)
]]

if(not GLOBAL.FA_DLCACCESS)then
--not gonna rewrite 100 things for one prefab
    table.insert(PrefabFiles,"fa_boneshard_compat")
    table.insert(Assets,Asset("ATLAS", "images/inventoryimages/bone_shards_compat.xml"))
    table.insert(Assets,Asset("IMAGE", "images/inventoryimages/bone_shards_compat.tex"))

--[[
--is the table set before mods are loaded or on the first spawn?
GLOBAL.SetSharedLootTable( 'hound_mound',
{
    {'houndstooth', 1.00},
    {'houndstooth', 1.00},
    {'houndstooth', 1.00},
    {'boneshard',   1.00},
    {'boneshard',   1.00},
    {'redgem',      0.01},
    {'bluegem',     0.01},
})]]
end

AddMinimapAtlas("minimap/boneshield.xml")
AddMinimapAtlas("minimap/marbleshield.xml")
AddMinimapAtlas("minimap/reflectshield.xml")
AddMinimapAtlas("minimap/rockshield.xml")
AddMinimapAtlas("minimap/woodbow.xml")
AddMinimapAtlas("minimap/woodshield.xml")
AddMinimapAtlas("minimap/goblin.xml")
AddMinimapAtlas("minimap/fa_orc.xml")
AddMinimapAtlas("minimap/fa_dorf.xml")
AddMinimapAtlas("minimap/cleric.xml")
AddMinimapAtlas("minimap/bard.xml")
AddMinimapAtlas("minimap/wizard.xml")
AddMinimapAtlas("minimap/necromancer.xml")
AddMinimapAtlas("minimap/tinkerer.xml")
AddMinimapAtlas("minimap/barb.xml")
AddMinimapAtlas("minimap/druid.xml")
AddMinimapAtlas("minimap/paladin.xml")
AddMinimapAtlas("minimap/darkknight.xml")
AddMinimapAtlas("minimap/fa_rocks.xml")
AddMinimapAtlas("minimap/fa_alchemytable.xml")
AddMinimapAtlas("minimap/fa_smeltingfurnace.xml")
AddMinimapAtlas("minimap/fa_forge.xml")
AddMinimapAtlas("minimap/fa_keg.xml")
AddMinimapAtlas("minimap/fa_distiller.xml")
AddMinimapAtlas("minimap/fa_wheat.xml")
AddMinimapAtlas("images/inventoryimages/fa_hats.xml")
AddMinimapAtlas("images/inventoryimages/fa_basearmors.xml")
AddMinimapAtlas("images/inventoryimages/fa_baseweapons.xml")
AddMinimapAtlas("images/inventoryimages/fa_puppet.xml")

RemapSoundEvent( "dontstarve/characters/bard/death_voice", "dontstarve/characters/wilson/death_voice" )
RemapSoundEvent( "dontstarve/characters/bard/hurt", "fa/characters/bard/hurt" )
RemapSoundEvent( "dontstarve/characters/bard/talk_LP", "fa/characters/bard/talk_LP" )
RemapSoundEvent( "dontstarve/characters/barb/death_voice", "dontstarve/characters/wilson/death_voice")
RemapSoundEvent( "dontstarve/characters/barb/hurt", "fa/characters/barb/hurt" )
RemapSoundEvent( "dontstarve/characters/barb/talk_LP", "fa/characters/barb/talk_LP" )
RemapSoundEvent( "dontstarve/characters/paladin/death_voice", "fa/characters/paladin/death_voice")
RemapSoundEvent( "dontstarve/characters/paladin/hurt", "fa/characters/paladin/hurt" )
RemapSoundEvent( "dontstarve/characters/paladin/talk_LP", "fa/characters/paladin/talk_LP" )
RemapSoundEvent( "dontstarve/characters/wizard/death_voice", "fa/characters/wizard/death_voice")
RemapSoundEvent( "dontstarve/characters/wizard/hurt", "fa/characters/wizard/hurt" )
RemapSoundEvent( "dontstarve/characters/wizard/talk_LP", "fa/characters/wizard/talk_LP" )
RemapSoundEvent( "dontstarve/characters/dwarf/talk_LP", "fa/mobs/dwarf/talk_LP" )

local EVIL_SANITY_AURA_OVERRIDE={
    robin=-TUNING.SANITYAURA_MED,
    pigman=-TUNING.SANITYAURA_MED,
    crow=-TUNING.SANITYAURA_MED,
    robin_winter=-TUNING.SANITYAURA_MED,
    beefalo=-TUNING.SANITYAURA_MED,
    babybeefalo=-TUNING.SANITYAURA_MED,
    butterfly=-TUNING.SANITYAURA_MED,
    spider_hider=0,
    spider_spitter=0,
    spider_dropper=0,
    spider=0,
    poisonspider=0,
    flower_evil=TUNING.SANITYAURA_MED,
    ghost=TUNING.SANITYAURA_MED,
    skeletonspawn=TUNING.SANITYAURA_MED,
    fa_drybones=TUNING.SANITYAURA_MED,
    fa_dartdrybones=TUNING.SANITYAURA_MED,
    fa_skull=TUNING.SANITYAURA_MED,
    mound=TUNING.SANITYAURA_MED,
    hound=0,
    icehound=0,
    firehound=0,
    houndfire=0,
    nightlight=TUNING.SANITYAURA_MED,--would have to properly code this
    rabbit=-TUNING.SANITYAURA_MED,--and this
    crawlinghorror=0,
    terrorbeak=0,
    shadowtentacle=0,
    shadowwaxwell=0,
    shadowhand=0,
    slurper=0,
    spiderqueen=-TUNING.SANITYAURA_MED,
    spider_warrior=0,
    tentacle=0,
    tentacle_pillar_arm=0,
    walrus=-TUNING.SANITYAURA_MED,
    little_walrus=-TUNING.SANITYAURA_MED,
    worm=0,
    penguin=-TUNING.SANITYAURA_MED,
    flower=-TUNING.SANITYAURA_MED
}

local FALLENLOOTTABLE=GLOBAL.FALLENLOOTTABLE
local FALLENLOOTTABLEMERGED=GLOBAL.FALLENLOOTTABLEMERGED

           

--[[
    local SGWilson=require "stategraphs/SGwilson"
    SGWilson.states["idle"]= GLOBAL.State{
        name = "idle",
        tags = {"idle", "canrotate"},
        onenter = function(inst, pushanim)
            
            inst.components.locomotor:Stop()

            inst.AnimState:PlayAnimation("fa_cagedrop", true)

        end,        
    }
]]

-- Let the game know Wod is a male, for proper pronouns during the end-game sequence.
-- Possible genders here are MALE, FEMALE, or ROBOT
table.insert(GLOBAL.CHARACTER_GENDERS.FEMALE, "thief")
table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "barb")
table.insert(GLOBAL.CHARACTER_GENDERS.FEMALE, "cleric")
table.insert(GLOBAL.CHARACTER_GENDERS.FEMALE, "druid")
table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "darkknight")
table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "monk")
table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "necromancer")
table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "wizard")
table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "tinkerer")
table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "paladin")
table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "ranger")
table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "bard")

local PetBuff = require "widgets/petbuff"

if(GLOBAL.inventorybarpostconstruct)then
    AddClassPostConstruct("widgets/inventorybar",GLOBAL.inventorybarpostconstruct)
end

if(not GLOBAL.FA_ModCompat.rpghudmod)then

--need to re-initialize the slots and stuff the same way so it doesn't burn on hud active...
--TODO theres gotta be a better way 
local function amuletpostinit(inst)
    inst.components.equippable.equipslot = GLOBAL.EQUIPSLOTS.NECK
end

AddPrefabPostInit("amulet", amuletpostinit)
AddPrefabPostInit("blueamulet", amuletpostinit)
AddPrefabPostInit("purpleamulet", amuletpostinit)
AddPrefabPostInit("orangeamulet", amuletpostinit)
AddPrefabPostInit("greenamulet", amuletpostinit)
AddPrefabPostInit("yellowamulet", amuletpostinit)

local function changetopack(inst)
    inst.components.equippable.equipslot = GLOBAL.EQUIPSLOTS.PACK
end

AddPrefabPostInit("krampus_sack", changetopack)
AddPrefabPostInit("piggyback", changetopack)
AddPrefabPostInit("backpack", changetopack)
AddPrefabPostInit("icepack", changetopack)

local function resurrectableinit(inst)

    local old_findclosestres=inst.FindClosestResurrector
    function inst:FindClosestResurrector ()
        local res = nil
        if self.inst.components.inventory then
            local item = self.inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.NECK)
            if item and item.prefab == "amulet" then
                return item
            end
        end

        return old_findclosestres(self)
    end

    local old_canresurrect=inst.CanResurrect
    function inst:CanResurrect()
        if self.inst.components.inventory then
            local item = self.inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.NECK)
            if item and item.prefab == "amulet" then
                return true
            end
        end

        return old_canresurrect(self)
    end

    local old_DoResurrect=inst.DoResurrect
    function inst:DoResurrect()
        self.inst:PushEvent("resurrect")
        if self.inst.components.inventory then
            local item = self.inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.NECK)
            if item and item.prefab == "amulet" then
                self.inst.sg:GoToState("amulet_rebirth")
                return true
            end
        end
        
        return old_DoResurrect(self)     
    end

end

AddComponentPostInit("resurrectable", resurrectableinit)


local function newOnExit(inst)

    inst.components.hunger:SetPercent(2/3)
    inst.components.health:Respawn(TUNING.RESURRECT_HEALTH)
    
    if inst.components.sanity then
        inst.components.sanity:SetPercent(.5)
    end
    
    local item = inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.NECK)
    if item and item.prefab == "amulet" then
        item = inst.components.inventory:RemoveItem(item)
        if item then
            item:Remove()
            item.persists = false
        end
    end
    --SaveGameIndex:SaveCurrent()
    inst.HUD:Show()
    GLOBAL.TheCamera:SetDefault()
    inst.components.playercontroller:Enable(true)
    inst.AnimState:ClearOverrideSymbol("FX")

end

local function SGWilsonPostInit(sg)
    sg.states["amulet_rebirth"].onexit = newOnExit
end

AddStategraphPostInit("wilson", SGWilsonPostInit)

else


local function hud_inventorypostinit_fix(cmp,inst)
    --assuming postinits happen in order, i should be able to
    --it would be cleaner to just provide versions...
    if(inst.components.inventory.maxslots==55)then
        inst.components.inventory.maxslots=60
    elseif(inst.components.inventory.maxslots==45)then
       inst.components.inventory.maxslots=50
    elseif(inst.components.inventory.maxslots==25 and string.find(GLOBAL.FA_ModCompat.rpghudmod.modinfo.description,"Custom UI"))then
        inst.components.inventory.maxslots=30
    end
end
--this was breaking display BADLY. one would expect he'd use proper w/h numbers for 2 row calculations instead of reliance on the total....
--REWRITE THE WHOLE THING? 
AddComponentPostInit("inventory", hud_inventorypostinit_fix)

if(string.find(GLOBAL.FA_ModCompat.rpghudmod.modinfo.description,"Custom UI"))then
    local function StatusPostInit(self,owner)
    self.heart:SetPosition(0,50,0)
    self.heart.br:SetTint(162/255, 43/255, 37/255, 1)
    self.heart.topperanim:Hide()
    if self.heart.sanityarrow then
        self.heart.sanityarrow:SetPosition(-60,56,0)
        self.heart.sanityarrow:SetScale(.8,.8,0)
    end
    
    self.brain:SetPosition(220,50,0)
    self.brain:SetScale(.75,.75,0)
    self.brain.br:SetTint(202/255, 120/255, 34/255, 1)
    self.brain.topperanim:Hide()

    self.stomach:SetPosition(-220,50,0)
    self.stomach:SetScale(.75,.75,0)
    self.stomach.br:SetTint(85/255, 119/255, 65/255, 1)
    
    end

    AddClassPostConstruct("widgets/statusdisplays", StatusPostInit)
end

end


 local function OpenBackpack(self) 
    
    local oldSetMainCharacter = self.SetMainCharacter

    function self:SetMainCharacter(maincharacter)
        
        oldSetMainCharacter(self, maincharacter)
        
        local bp = maincharacter.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.PACK)
        
        if bp and bp.components.container then
            bp.components.container:Close()
            bp.components.container:Open(maincharacter)
        end

--nothing but equipment is registered at this point... it seems it just gives items again, 
--system does not track if a container was open
    end
    
end

AddClassPostConstruct("screens/playerhud", OpenBackpack)
--SaveGameIndex:GetCurrentCaveLevel()


--table.insert(SGWilson.actionhandlers,ActionHandler(ACTIONS.FA_CRAFTPICKUP, "dolongaction"))



local function newControlsInit(class)
    local under_root=class;
    local inst=GetPlayer()
    if GetPlayer() and GetPlayer().components and GetPlayer().components.xplevel then
--       GetPlayer():ListenForEvent("healthdelta", onhpchange)
        local xpbar = under_root:AddChild(XPBadge(class.owner))
        xpbar:SetPosition(0,-28,0)
        xpbar:SetHAnchor(GLOBAL.ANCHOR_MIDDLE)
        xpbar:SetVAnchor(GLOBAL.ANCHOR_TOP)
        xpbar:SetLevel(GetPlayer().components.xplevel.level)
        xpbar:SetValue(GetPlayer().components.xplevel.currentxp,GetPlayer().components.xplevel.max)
        xpbar:SetPlayername(GetPlayer().fa_playername or GLOBAL.STRINGS.CHARACTER_TITLES[GetPlayer().prefab])
        GetPlayer():ListenForEvent("fa_playernamechanged", function(inst,data)
            xpbar:SetPlayername(data.playername)
        end,class.owner)
        GetPlayer():ListenForEvent("xpleveldelta", function(inst,data)
            xpbar:SetLevel(data.level)
            xpbar:SetValue(data.new,data.max)
        end,class.owner)

        GetPlayer():ListenForEvent("xplevelup", function(inst,data)
            inst.SoundEmitter:PlaySound("fa/levelup/levelup")
            --it could be just when necesary but I doubt this will incurr any serious performance issue to bother
            GetPlayer().HUD.controls.crafttabs:UpdateRecipes()
        end,class.owner)

        GetPlayer():ListenForEvent("killed", function(inst,data)
            local victim=data.victim
            local xp=GLOBAL.FA_MOBXP_TABLE[victim.prefab]
--            print("xp for",victim, xp)
            if(xp)then
                local default=xp.default
                if(xp.tagged)then
                    for k,v in pairs(xp.tagged) do
                        if(victim:HasTag(k))then
                            default=v
                            break
                        end
                    end

                end
                inst.components.xplevel:DoDelta(default)
            end
        end)
         GetPlayer():ListenForEvent("unlockrecipe", function(inst,data)
            inst.components.xplevel:DoDelta(GLOBAL.PROTOTYPE_XP)
        end,class.owner)

        if(GetPlayer().fa_playername==nil or GetPlayer().fa_playername=="")then
        GetPlayer():DoTaskInTime(0,function()
            GLOBAL.TheFrontEnd:PushScreen(FA_CharRenameScreen(GLOBAL.STRINGS.CHARACTER_TITLES[GetPlayer().prefab]))
            
        end)
        end
    end

--this so i can cut on copy pasting, the details can be reconfigured on per-char basis
    local xabilitybar = under_root:AddChild(Widget("abilitybar"))
        local buffbar=FA_BuffBar(xabilitybar.owner)
        buffbar:SetPosition(250,0,0)
        xabilitybar:AddChild(buffbar)
        xabilitybar.buffbar=buffbar

        inst:ListenForEvent("fa_rebuildbuffs",function(inst,data)
            buffbar:RegisterBuffs(data.buffs)
        end)
        inst:ListenForEvent("fa_addbuff",function(inst,data)
            buffbar:AddBuff(data.id,data.buff)
        end)
        inst:ListenForEvent("fa_removebuff",function(inst,data)
            buffbar:RemoveBuff(data.id)
        end)

        local statusbar=FA_StatusBar(xabilitybar.owner)
        xabilitybar:AddChild(statusbar)
        xabilitybar.statusbar=statusbar
        statusbar:SetPosition(-300,-30,0)

        inst:ListenForEvent("fa_temphpdelta",function(inst,data)
            statusbar:TempHPDelta(data.old, data.new)
        end)
        inst:ListenForEvent("fa_protectiondelta",function(inst,data)
            statusbar:ProtectionDelta(data.old,data.new,data.damagetype)
        end)

    if GetPlayer() and GetPlayer().newControlsInit then
        xabilitybar:SetPosition(0,-76,0)
        xabilitybar:SetScaleMode(GLOBAL.SCALEMODE_PROPORTIONAL)
        xabilitybar:SetMaxPropUpscale(1.25)
        xabilitybar:SetHAnchor(GLOBAL.ANCHOR_MIDDLE)
        xabilitybar:SetVAnchor(GLOBAL.ANCHOR_TOP)
        GetPlayer().newControlsInit(xabilitybar)
    end

    statusbar:RegisterBuffs()
    buffbar:RegisterBuffs(inst.components.fa_bufftimers.buff_timers)
    --[[
    GetPlayer():DoPeriodicTask(10, function()
                 GetPlayer().AnimState:PlayAnimation("test1")
            end)]]
end
--AddClassPostConstruct("screens/playerhud",newControlsInit)
AddClassPostConstruct("widgets/statusdisplays", newControlsInit)

local crafttabsPostConstruct=function(self,owner,top_root)
    if(not GetPlayer().fa_spellcraft) then return end
    local spelltab=nil
    for k,v in pairs(self.tabbyfilter) do
        if(v.filter.str=="SPELLS")then
            spelltab=v
            break
        end
    end

    if(not spelltab) then
        print("not a spellcaster?")
    else
        spelltab.selectfn = function()
           GLOBAL.TheFrontEnd:PushScreen(FA_SpellBookScreen())
        end
        --self.deselectfn = deselectfn
    end
end

if(GetModConfigData("spellbooks"))then
    AddClassPostConstruct("widgets/crafttabs",crafttabsPostConstruct)
end


local function playerhudPostContruct(self)
    
    function self:UpdateClouds(dt)
            local TheCamera = GLOBAL.TheCamera
            TheCamera.should_push_down = false
            self.clouds_on = false
            if(self.clouds)then
                self.clouds:Hide()
            end
    end
end


if(GetModConfigData("extrazoom"))then
    AddClassPostConstruct ("screens/playerhud", playerhudPostContruct)

    --resetting cave zoom levels - could do it just for mine i suppose, but the limited zoom is annoying overall
    local FollowCamera=require "cameras/followcamera"
    local cameradefault=FollowCamera.SetDefault
    function FollowCamera:SetDefault(...)
        cameradefault(self,...)

        if GetWorld() and GetWorld():IsCave() then
        self.distancetarget = 30
        self.mindist = 15
        self.maxdist = 50 
        self.mindistpitch = 30
        self.maxdistpitch = 60
        end
    end

end

if(GetModConfigData("extracontrollerrange"))then
    AddClassPostConstruct ("screens/playerhud", playerhudPostContruct)
end


local doSkeletonSpawn=function(inst)
    local skel=SpawnPrefab("skeletonspawn")
    skel:AddComponent("homeseeker")
    skel.components.homeseeker:SetHome(inst)
    skel.Transform:SetPosition(inst.Transform:GetWorldPosition())
    return skel
end

local startSkeletonSpawnTask=function(inst)
     local rng=math.random()*480*5
         inst:DoTaskInTime(rng, function() 
            inst:AddTag("hasSpawnedSkeleton")
            local skel=doSkeletonSpawn(inst)
            skel:ListenForEvent("death",function(skel) 
                inst:RemoveTag("hasSpawnedSkeleton") 
                startSkeletonSpawnTask(inst)
            end)
        end)
end

local spoiledSkeletonSpawn=function(inst)
    if(math.random()>0.5)then
        doSkeletonSpawn(inst)
    end
end

AddPrefabPostInit("meat",function(inst)
    if(inst.components.perishable)then
        inst.components.perishable:SetOnPerishFn(spoiledSkeletonSpawn)
    end
end)
AddPrefabPostInit("cookedmeat",function(inst)
    if(inst.components.perishable)then
        inst.components.perishable:SetOnPerishFn(spoiledSkeletonSpawn)
    end
end)
AddPrefabPostInit("meat_dried",function(inst)
    if(inst.components.perishable)then
        inst.components.perishable:SetOnPerishFn(spoiledSkeletonSpawn)
    end
end)
AddPrefabPostInit("monstermeat",function(inst)
    if(inst.components.perishable)then
        inst.components.perishable:SetOnPerishFn(spoiledSkeletonSpawn)
    end
end)
AddPrefabPostInit("cookedmonstermeat",function(inst)
    if(inst.components.perishable)then
        inst.components.perishable:SetOnPerishFn(spoiledSkeletonSpawn)
    end
end)
AddPrefabPostInit("monstermeat_dried",function(inst)
    if(inst.components.perishable)then
        inst.components.perishable:SetOnPerishFn(spoiledSkeletonSpawn)
    end
end)
--[[
AddPrefabPostInit("hambat",function(inst)
    if(inst.components.perishable)then
        inst.components.perishable:SetOnPerishFn(spoiledSkeletonSpawn)
    end
end)]]

local mound_digcallback
-- could use new dlc code but that wouldnt work in non dlc version
local mound_reset=function(inst)
    print("in mound reset")
    if(inst.components.spawner)then
        inst.components.spawner:CancelSpawning()
    end
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetWorkLeft(1)
    inst.AnimState:PlayAnimation("gravedirt")
    inst.fa_digtime=nil
    if(GLOBAL.FA_DLCACCESS)then
        if(inst.components.hole)then
            inst.components.hole.canbury = false
        end
    end
    inst.components.workable:SetOnFinishCallback(mound_digcallback)
end

mound_digcallback=function(inst,worker)
    --                  who thought hardcoding stuff is great idea.... brute force override
--                onfinishcallback(inst,worker)
                
    inst.AnimState:PlayAnimation("dug")
    inst:RemoveComponent("workable")
    if(GLOBAL.FA_DLCACCESS)then
        if(inst.components.hole)then
            inst.components.hole.canbury = true
        end
    end
    if worker then
        if worker.components.sanity then
           if(worker:HasTag("evil"))then
---------------------
            else
                worker.components.sanity:DoDelta(-TUNING.SANITY_SMALL)
            end
        end     
        local roll=math.random()
        if roll < GLOBAL.GHOST_MOUND_SPAWN_CHANCE then
                local ghost = SpawnPrefab("ghost")
                local pos = Point(inst.Transform:GetWorldPosition())
                pos.x = pos.x -.3
                pos.z = pos.z -.3
                if ghost then
                    ghost.Transform:SetPosition(pos.x, pos.y, pos.z)
                end
        elseif worker.components.inventory then
                local item = nil
                if math.random() < GLOBAL.GHOST_MOUND_ITEM_CHANCE then
                    local loots = 
                    {
                        nightmarefuel = 1,
                        amulet = 1,
                        gears = 1,
                        redgem = 5,
                        bluegem = 5,
                    }
                    item = GLOBAL.weighted_random_choice(loots)
                else
                    item = "trinket_"..tostring(math.random(GLOBAL.NUM_TRINKETS))
                end

                if item then
                    inst.components.lootdropper:SpawnLootPrefab(item)
                end
                if(math.random()<GLOBAL.GHOST_MOUND_SCROLL_CHANCE)then
                    inst.components.lootdropper:SpawnLootPrefab("fa_scroll_12")
                end
        end
    end
                inst.fa_digtime=GLOBAL.GetTime()
                inst.fa_digresettask=inst:DoTaskInTime(GLOBAL.MOUND_RESET_PERIOD,function() print("should reset mound") mound_reset(inst) end)
                inst.components.spawner:Configure( "skeletonspawn",GLOBAL.SKELETONSPAWNDELAY,GLOBAL.SKELETONSPAWNDELAY*math.random())
end

AddPrefabPostInit("mound",function(inst)
    inst:AddComponent( "spawner" )
    inst.components.spawner.spawnoffscreen=false
    inst.components.spawner.childname="skeletonspawn"
    inst.components.spawner.delay=GLOBAL.SKELETONSPAWNDELAY

    local oldsave=inst.OnSave
    inst.OnSave = function(inst, data)
        if(oldsave)then
            oldsave(inst,data)
        end
        if not inst.components.workable and inst.fa_digtime then
            data.fa_digtime=inst.fa_digtime
        end
    end        
    local oldload=inst.OnLoad
    inst.OnLoad = function(inst, data)
--    print("mound onload")
        if(oldload)then
            oldload(inst,data)
        end
        if data and data.dug or not inst.components.workable then
--        print("digtime", data.fa_digtime)
            if(data.fa_digtime)then
                inst.fa_digtime=data.fa_digtime
                inst.fa_digresettask=inst:DoTaskInTime(GLOBAL.MOUND_RESET_PERIOD-GLOBAL.GetTime()+inst.fa_digtime,function() mound_reset(inst) end)
            else
                inst.fa_digtime=GLOBAL.GetTime()
                inst.fa_digresettask=inst:DoTaskInTime(GLOBAL.MOUND_RESET_PERIOD,function() mound_reset(inst) end)
            end
        end
    end    

--i dont know if it's dug or not until after load... configure is starting the process... so i have to type same thing 3 times
    inst:DoTaskInTime(0,function()
--[[
        if(inst.components.spawner and inst.components.spawner.nextspawntime)then
--            print("spawner active: ",inst.components.spawner.nextspawntime)
--        return
        end
]]
        if(inst.components.workable )then
            local onfinishcallback=inst.components.workable.onfinish
            inst.components.workable:SetOnFinishCallback(mound_digcallback)      
        else
            local nexttime=inst.components.spawner.nextspawntime or GLOBAL.SKELETONSPAWNDELAY*math.random()
            inst.components.spawner:Configure( "skeletonspawn",GLOBAL.SKELETONSPAWNDELAY,nexttime)
        end
    end)

end)

AddPrefabPostInit("gravestone",function(inst)
    --[[ nah I so ain't doing this
    local old_loadpostpass=inst.OnLoadPostPass

    inst.OnLoadPostPass=function(inst,newents, data)
    --WARN i should probably return here... if they ever fix the mess they made... this will end up with double inits
        if(old_loadpostpass)then old_loadpostpass(inst,newents,data) end
        if data then
            if inst.mound and data.mounddata then
                inst.mound:LoadPostPass(data.mounddata.data, newents)
            end
        end
    end
]]
    if(inst.mound)then
--        inst:RemoveChild(inst.mound)
        inst.mound:Remove()
        inst.mound=nil
    end

    inst:DoTaskInTime(0,function()

        if(not inst.fa_mounded)then
            local mound=SpawnPrefab("mound")
            local pos=inst:GetPosition()+(GLOBAL.TheCamera:GetDownVec()*.5)
            mound.Transform:SetPosition(pos:Get())
            inst.fa_mounded=true
        end
    end)

    local old_onsave=inst.OnSave
    inst.OnSave= function (inst, data)
        if(old_onsave) then old_onsave(inst,data) end
        if data and data.mounddata then
            --kill off manual saving
            data.mounddata=nil
        end
        data.fa_mounded=inst.fa_mounded
    end

    local old_onload=inst.OnLoad
    inst.OnLoad= function (inst, data)
        if(old_onload) then old_onload(inst,data) end
        if(data)then
            inst.fa_mounded=data.fa_mounded
        end
    end
end)


local function dappernessPostContruct(component)
    local dapperness_getdapperness_def=component.GetDapperness
    function component:GetDapperness(owner)
        local d=dapperness_getdapperness_def(self,owner)
        if(owner and owner:HasTag("player") and owner.prefab=="cleric" and d<0)then
          --  print("got in dapperness nerf")
            d=d*2
        end
        return d
    end
end

AddClassPostConstruct("components/dapperness",dappernessPostContruct)
if(FA_DLCACCESS)then
    AddClassPostConstruct("components/equippable",dappernessPostContruct)
end
--AddComponentPostInit("armor",function(component,inst)
AddClassPostConstruct("components/armor",function(component)
    component.fa_resistances=component.fa_resistances or {}
end)
--why the heck doesnt it have a default?
AddClassPostConstruct("components/combat",function(component)
    component.damagemultiplier=1
end)
AddClassPostConstruct("components/health",function(component)
    component.fa_resistances=component.fa_resistances or {}
    component.fa_protection=component.fa_protection or {}
    component.fa_dodgechance=component.fa_dodgechance or 0
    component.fa_temphp=component.fa_temphp or 0
end)

local function onFishingCollect(inst,data)
    local spawnPos = GLOBAL.Vector3(inst.Transform:GetWorldPosition() )
    if(math.random()<=GLOBAL.FISHING_MERM_SPAWN_CHANCE)then
        local merm=SpawnPrefab("merm")
        merm.Transform:SetPosition(spawnPos:Get() )
    end
    if(math.random()<=GLOBAL.FISHING_SCROLL_SPAWN_CHANCE)then
        local merm=SpawnPrefab("fa_scroll_1")
        merm.Transform:SetPosition(spawnPos:Get() )
    end
end

AddClassPostConstruct("screens/loadgamescreen", function(self)
    self.MakeSaveTile = (function()
        local MakeSaveTile = self.MakeSaveTile
 
        return function(self, slotnum, ...)
            local tile = MakeSaveTile(self, slotnum, ...)

            local cavelevel=GLOBAL.SaveGameIndex:GetCurrentCaveLevel(slotnum)
            local mode = GLOBAL.SaveGameIndex:GetCurrentMode(slotnum)

            if(mode == "cave")then
                print("cavelevel",cavelevel)
                local data=Levels.cave_levels[cavelevel]
                --second check just to exclude other mods or default caves etc..
                if(data and GLOBAL.FA_LEVELS[data.id])then
                    local day = GLOBAL.SaveGameIndex:GetSlotDay(slotnum)
--                    tile.text:SetString(("%s-%d"):format(data.name, day))
                    tile.text:SetString(("%s"):format(data.name))
                end
            end    
 
            return tile
        end
    end)()
end)
 
AddClassPostConstruct("screens/slotdetailsscreen", function(self)
    self.BuildMenu = (function()
        local BuildMenu = self.BuildMenu
 
        return function(self, ...)
            BuildMenu(self, ...)

            local cavelevel=GLOBAL.SaveGameIndex:GetCurrentCaveLevel(self.saveslot)
            local mode = GLOBAL.SaveGameIndex:GetCurrentMode(self.saveslot)

            if(mode == "cave")then
                print("cavelevel",cavelevel)
                local data=Levels.cave_levels[cavelevel]
                --second check just to exclude other mods or default caves etc..
                if(data and GLOBAL.FA_LEVELS[data.id])then
                    local day = GLOBAL.SaveGameIndex:GetSlotDay(slotnum)
                    self.text:SetString(("%s"):format(data.name))
                end
            end    

        end
    end)()
end)

AddClassPostConstruct("components/terraformer",function(self)
local old_canterraformpoint=self.CanTerraformPoint
function self:CanTerraformPoint(pt)
    if(old_canterraformpoint(self,pt))then
        -- since it's blocking just hardcoded crap... one day I'll move this
        local ground = GetWorld()
        if ground then
            local tile = ground.Map:GetTileAtPoint(pt.x, pt.y, pt.z)
            return tile~=GROUND.FA_LAVA_ASH and tile~=GROUND.FA_LAVA_GREEN and tile~=GROUND.FA_LAVA_SHINY and tile~=FA_LAVA_TERRAIN2
        end
    else
        return false
    end
end

end)

AddPrefabPostInit("world", function(inst)

--    GLOBAL.assert( GLOBAL.GetPlayer() == nil )
    local player_prefab = GLOBAL.SaveGameIndex:GetSlotCharacter()
 
    -- Unfortunately, we can't add new postinits by now. So we have to do
    -- it the hard way...
 
    GLOBAL.TheSim:LoadPrefabs( {player_prefab} )
    local oldfn = GLOBAL.Prefabs[player_prefab].fn
    GLOBAL.Prefabs[player_prefab].fn = function()
        local inst = oldfn()

        inst:AddComponent("fa_bufftimers")

        if(GLOBAL.FA_ModCompat.alwaysonmod)then
            print("alwayson", GLOBAL.FA_ModCompat.alwaysonmod.version)
            --cba to care about failures, if it fails oh well i did what i could
            if(not inst.components.switch)then
                GLOBAL.pcall(function()
                    inst:AddComponent("switch")
                    print("alwayson failsafe")
                end)

            end
        end
 
        local oldsavefn=inst.OnSave
        local oldloadfn=inst.OnLoad

        local onloadfn = function(inst, data)
            if(oldloadfn)then
                oldloadfn(inst,data)
            end
            inst.fa_prevcavelevel=data.fa_prevcavelevel
            print("prevcavelevel",inst.fa_prevcavelevel)
        end

        local onsavefn = function(inst, data)
            if(oldsavefn)then
                oldsavefn(inst,data)
            end
            data.fa_prevcavelevel=inst.fa_prevcavelevel
        end
        inst.OnLoad = onloadfn
        inst.OnSave = onsavefn
        inst.fa_prevcavelevel=0--should really default to current topology or so but meh
 
        return inst
    end
end)

local function UpdateWorldGenScreen(self, profile, cb, world_gen_options)
        print("level",world_gen_options.level_world)
        local data=Levels.cave_levels[world_gen_options.level_world]
        if(world_gen_options.level_type and world_gen_options.level_type=="adventure")then return end
        if(data and GLOBAL.FA_LEVELS[data.id])then
             GLOBAL.TheSim:LoadPrefabs {"MOD_"..modname}
            --TODO this crap should really be done differently
            if(data.id=="GOBLIN_CAVE" or data.id=="GOBLIN_CAVE_2" or data.id=="GOBLIN_CAVE_3" or data.id=="GOBLIN_CAVE_BOSSLEVEL")then
                self.bg:SetTint(GLOBAL.BGCOLOURS.RED[1],GLOBAL.BGCOLOURS.RED[2],GLOBAL.BGCOLOURS.RED[3], 1)
                self.worldanim:GetAnimState():SetBank("generating_goblin_cave")
                self.worldanim:GetAnimState():SetBuild("generating_goblin_cave")
                self.worldanim:GetAnimState():PlayAnimation("idle", true)

                self.verbs = GLOBAL.shuffleArray(GLOBAL.STRINGS.UI.WORLDGEN.GOBLIN.VERBS)
                self.nouns = GLOBAL.shuffleArray(GLOBAL.STRINGS.UI.WORLDGEN.GOBLIN.NOUNS)

--separate thread... cant do anything about it atm
--                self:ChangeFlavourText()
    
            elseif(data.id=="ORC_MINES" or data.id=="ORC_FORTRESS" or data.id=="DWARF_FORTRESS")then
--                self.bg:SetTint(GLOBAL.BGCOLOURS.RED[1],GLOBAL.BGCOLOURS.RED[2],GLOBAL.BGCOLOURS.RED[3], 1)
                self.worldanim:GetAnimState():SetBank("generating_mine_cave")
                self.worldanim:GetAnimState():SetBuild("generating_mine_cave")
                self.worldanim:GetAnimState():PlayAnimation("idle", true)
                self.verbs = GLOBAL.shuffleArray(GLOBAL.STRINGS.UI.WORLDGEN.MINES.VERBS)
                self.nouns = GLOBAL.shuffleArray(GLOBAL.STRINGS.UI.WORLDGEN.MINES.NOUNS)
            end
        end
       

        
end

AddClassPostConstruct("screens/worldgenscreen", UpdateWorldGenScreen)

local function UpdateMainScreen(self,...)
    if(self.shield) then self.shield:Kill() end
    self.shield = self.fixed_root:AddChild(Image())
    self.shield:SetTexture("images/fa_title.xml", "fa_title.tex")
end

AddClassPostConstruct("screens/mainscreen",UpdateMainScreen)

local function setTopologyType(inst,type)
    local oldLoadPostPass = inst.LoadPostPass
    function inst:LoadPostPass(...)
        self.topology.level_type = type
        if oldLoadPostPass then
            return oldLoadPostPass(self, ...)
        end
    end
end

local function OrcMinesPostInit(inst)
    local waves = inst.entity:AddWaveComponent()

    waves:SetRegionSize( 40, 20 )
    waves:SetRegionNumWaves( 8 )
    waves:SetWaveTexture(GLOBAL.resolvefilepath("images/lava2.tex"))--GLOBAL.resolvefilepath("images/lava.tex")
    waves:SetWaveEffect( "shaders/waves.ksh" ) -- texture.ksh
    waves:SetWaveSize( 2048, 512 )
--[[ this will collide with other overrides, turning default back to standard cc manager
    the other option is to rely on the knowledge of how level is set which is not ideal
    GLOBAL.GetWorld().components.colourcubemanager:SetOverrideColourCube(
        GLOBAL.resolvefilepath "colour_cubes/lavacube.tex"
    )]]

    local SEASONS=GLOBAL.SEASONS
    if(FA_DLCACCESS)then
        GLOBAL.GetWorld().components.colourcubemanager.SEASON_CCS[SEASONS.SUMMER]["DUSK"]=GLOBAL.resolvefilepath "colour_cubes/lavacube.tex"
    else
        GLOBAL.GetWorld().components.colourcubemanager.SEASON_CCS[SEASONS.SUMMER]["DUSK"]=GLOBAL.resolvefilepath "colour_cubes/lavacube.tex"
    end

--                setTopologyType(inst,"mines")        
--[[
                if(not inst.components.seasonmanager)then
                    inst:AddComponent("SeasonManager")
                end
                inst.components.seasonmanager:AlwaysDry()
                    inst.components.seasonmanager.current_season = GLOBAL.SEASONS.SUMMER
                    inst.components.seasonmanager:AlwaysSummer()

]]
                local startLavaRain=function()
                    if(not inst.fa_lavarain)then
                        inst.fa_lavarain=SpawnPrefab("fa_lavarain")
                        inst.fa_lavarain.persists=false
                    end
                    inst.fa_lavarain.entity:SetParent( GetPlayer().entity )
                    inst.fa_lavarain.particles_per_tick = 20
                    inst.fa_lavarain.splashes_per_tick = 10
                end

                local old_load=inst.OnLoad
                inst.OnLoad=function(inst,data)
                    if(old_load)then
                        old_load(inst,data)
                    end
                    if(data and data.fa_lavarain)then
                        startLavaRain()
                    end
                end
                local old_save=inst.OnSave
                inst.OnSave=function(inst,data)
                    if(old_save)then
                        old_save(inst,data)
                    end
                    if(inst.fa_lavarain)then
                        data.fa_lavarain=true
                    end
                end
                inst:ListenForEvent("startquake",function()
                    startLavaRain()
                end)
                inst:ListenForEvent("endquake",function()
                    inst.fa_lavarain:Remove()
                    inst.fa_lavarain=nil
                end)   

    
end

AddPrefabPostInit("cave", function(inst)

    local level=GLOBAL.SaveGameIndex:GetCurrentCaveLevel()
    print("in cave postinit",level)
    if(level>3)then
        inst:RemoveComponent("periodicthreat")
        local data=Levels.cave_levels[level]
        if(data and GLOBAL.FA_LEVELS[data.id])then
            if(data.id=="ORC_MINES")then
                inst.IsCave=function() return false end
                inst:AddComponent("fa_warzone")
                    AddClassPostConstruct("widgets/controls", function(self, owner)
                    self.clock:Kill()
                    self.clock=self.sidepanel:AddChild(FA_WarClock(owner))
                end)
            end
            if(data.id=="ORC_MINES" or data.id=="DWARF_FORTRESS" or data.id=="ORC_FORTRESS")then
                OrcMinesPostInit(inst)
            end

            local quakerlootoverride=GLOBAL.FA_QUAKER_LOOT_OVERRIDE[data.id]
            if(quakerlootoverride)then
--                local quaker=require("components/quaker")
                local quaker=inst.components.quaker

                function quaker:GetDebris()
                    local rng = math.random()
                    local todrop = nil
                    if rng < 0.75 then
                            todrop = quakerlootoverride.common[math.random(1, #quakerlootoverride.common)]
                    elseif rng >= 0.75 and rng < 0.95 then
                            todrop = quakerlootoverride.rare[math.random(1, #quakerlootoverride.rare)]
                    else
                            todrop = quakerlootoverride.veryrare[math.random(1, #quakerlootoverride.veryrare)]
                    end
                    return todrop
                end
            end


            local threats=GLOBAL.FA_LEVEL_THREATS[data.id]
            local threatlist = require("fa_periodicthreats")
            if(threats)then
            for k,v in pairs(threats) do
                if(not inst.components.periodicthreat)then
                    inst:AddComponent("periodicthreat")
                end
                inst.components.periodicthreat:AddThreat(v,threatlist[v])
            end
            end
        end
    end
end)

local function evilSanityMod(inst)
    local sanitymod=inst.components.sanity
    function sanitymod:Recalc(dt)
                
                    local total_dapperness = self.dapperness or 0
                    local mitigates_rain = false
                    for k,v in pairs (self.inst.components.inventory.equipslots) do
                        --might as well fix the compat PROPERLY while here eh
                        local dapperness=nil
                        if(v.components.equippable and v.components.equippable.GetDapperness) then
                            dapperness= v.components.equippable:GetDapperness(self.inst)
                        end
                        if(not dapperness and v.components.dapperness)then
                            dapperness=v.components.dapperness:GetDapperness(self.inst)
                            if v.components.dapperness.mitigates_rain then
                              mitigates_rain = true
                            end
                        end
                        if dapperness then
                            total_dapperness = total_dapperness + dapperness 
                        end     
                    end
    
                    local dapper_delta = total_dapperness*TUNING.SANITY_DAPPERNESS
    
                    local day = GetClock():IsDay() and not GetWorld():IsCave()
                    local light_delta=0
                    if day then 
                        light_delta = GLOBAL.SANITY_DAY_LOSS
                    end
    
                    local aura_delta = 0
                    local x,y,z = self.inst.Transform:GetWorldPosition()
                    local ents = GLOBAL.TheSim:FindEntities(x,y,z, TUNING.SANITY_EFFECT_RANGE, nil, {"FX", "NOCLICK", "DECOR","INLIMBO"} )
                    for k,v in pairs(ents) do 

                        local override=EVIL_SANITY_AURA_OVERRIDE[v.prefab]
                        local aura_val=0
                        if(override~=nil)then
                            aura_val=override
                        elseif v.components.sanityaura and v ~= self.inst then
                            aura_val = v.components.sanityaura:GetAura(self.inst)
                        end
                        if(aura_val~=0)then
                            local distsq = self.inst:GetDistanceSqToInst(v)
                            aura_val = aura_val/math.max(1, distsq)
                            if aura_val < 0 then
                                aura_val = aura_val * self.neg_aura_mult
                            end
                            aura_delta = aura_delta + aura_val
                        end
                    end

                    local rain_delta = 0
                    if(not GLOBAL.FA_DLCACCESS)then
                    if GetSeasonManager() and GetSeasonManager():IsRaining() and not mitigates_rain then
                        rain_delta = -TUNING.DAPPERNESS_MED*1.5* GetSeasonManager():GetPrecipitationRate()
                    end
                    end

                    self.rate = (dapper_delta + light_delta + aura_delta + rain_delta)  
    
                    if self.custom_rate_fn then
                        self.rate = self.rate + self.custom_rate_fn(self.inst)
                    end

                    self:DoDelta(self.rate*dt, true)
    end
end

AddSimPostInit(function(inst)

    if(inst:HasTag("player"))then



    inst.AnimState:OverrideSymbol("chains", "fa_cagechains", "chains")
    inst.AnimState:OverrideSymbol("cage", "fa_orcfort_cage", "cage")

--        GLOBAL.trace_flow()
        --why the hell did they even add this...
        if(inst.components.eater.ablefoods)then
            table.insert( inst.components.eater.ablefoods, "FA_POTION" )
        end
        table.insert( inst.components.eater.foodprefs, "FA_POTION" )

        local sg=inst.sg.sg
        local old_onexit=sg.states["amulet_rebirth"].onexit
        sg.states["amulet_rebirth"].onexit=function(inst)
            old_onexit(inst)
            inst.components.health.invincible=true

            local boom = GLOBAL.CreateEntity()
            boom.entity:AddTransform()
            local anim=boom.entity:AddAnimState()
            boom:AddTag("NOCLICK")
            boom:AddTag("FX")
            boom.persists=false
            anim:SetBank("fa_shieldpuff")
            anim:SetBuild("fa_shieldpuff")
            anim:PlayAnimation("idle",false)
            local pos1 =inst:GetPosition()
            boom.Transform:SetPosition(pos1.x, pos1.y, pos1.z)
            boom:ListenForEvent("animover", function()  boom:Remove() end)

            inst:DoTaskInTime(10, function() inst.components.health.invincible=false end)
            return true
        end

        if inst:HasTag("evil") then

            evilSanityMod(inst)

        end
        if (inst.prefab=="darkknight" or inst.prefab=="cleric" or inst.prefab=="paladin") then
            --add shields
            local r=Recipe("woodenshield", {Ingredient("log", 20),Ingredient("rope", 5) }, RECIPETABS.WAR,  GLOBAL.TECH.SCIENCE_ONE)
            r.image="fa_woodshield.tex"
            r.atlas = "images/inventoryimages/fa_shields.xml"
            local r=Recipe("rockshield", {Ingredient("rocks", 20),Ingredient("rope", 5)}, RECIPETABS.WAR,  GLOBAL.TECH.SCIENCE_TWO)    
            r.image="fa_rockshield.tex"
            r.atlas = "images/inventoryimages/fa_shields.xml"
            local r=Recipe("marbleshield", {Ingredient("marble", 20),Ingredient("rope", 5) }, RECIPETABS.WAR,  GLOBAL.TECH.SCIENCE_TWO)
            r.image="fa_marbleshield.tex"
            r.atlas = "images/inventoryimages/fa_shields.xml"
            local r=Recipe("boneshield", {Ingredient("houndstooth", 10),Ingredient("rope", 5) }, RECIPETABS.WAR,  GLOBAL.TECH.SCIENCE_ONE)
            r.image="fa_boneshield.tex"
            r.atlas = "images/inventoryimages/fa_shields.xml"
        end
        inst:ListenForEvent("fishingcollect",onFishingCollect)

            local leader=inst.components.leader
            for k,v in pairs(leader.followers) do
                if(k.prefab=="frog")then
--why is tag being lost?
--                if k:HasTag("fa_wonderswap") then

                    print("removing frog")
                    k:Remove()
                end
            end
            


    end
end)
--\
function lootdropperPostInit(component)
    local old_generateloot=component.GenerateLoot
    if(not component.fallenLootTables)then
            component.fallenLootTables={}
    end
    function component:AddFallenLootTable(lt,weight,chance)
        table.insert(self.fallenLootTables,{loottable=lt,weight=weight,chance=chance})
    end
    function component:GenerateLoot()
        local loots=old_generateloot(self)
        for ind,tabledata in pairs(self.fallenLootTables) do
            local chance=math.random()
            if(chance<=tabledata.chance)then
                local newloot=nil
                --pick one of...
                local rnd = math.random()*tabledata.weight
                for k,v in pairs(tabledata.loottable) do
                    rnd = rnd - v
                    if rnd <= 0 then
                        newloot=k
                        break
                    end
                end
                table.insert(loots, newloot)
            end
        end
        return loots
    end

    function component:DropLoot(pt)
    local prefabs = self:GenerateLoot()
    local burn=false
    if not self.inst.components.fueled and self.inst.components.burnable and self.inst.components.burnable:IsBurning() then
        burn=true
        for k,v in pairs(prefabs) do
            local cookedAfter = v.."_cooked"
            local cookedBefore = "cooked"..v
            if GLOBAL.PrefabExists(cookedAfter) then
                prefabs[k] = cookedAfter
            elseif GLOBAL.PrefabExists(cookedBefore) then
                prefabs[k] = cookedBefore 
            else   
            --this was burning everything in list regardless of wether it can be actually burned        
--                prefabs[k] = "ash"               
            end
        end
    end
    for k,v in pairs(prefabs) do
        local loot=self:SpawnLootPrefab(v, pt)
        --now i have to check if it should burn instead, is there anything else i should be checking here?
        if(burn and loot and loot.components.burnable)then
            loot.components.burnable:Ignite()
        end
    end
    end

end

AddComponentPostInit("lootdropper",lootdropperPostInit)

local nonEvilDapperFn=function(inst1,owner,dapperness)
            if(owner and owner:HasTag("evil"))then
                return 0
            else
                return dapperness
            end
end

local nonEvilSanityPostinit=function(inst)
    if(GLOBAL.FA_DLCACCESS)then
        inst.components.equippable.dapperfn=function(inst1,owner)
            return nonEvilDapperFn(inst1,owner,inst.components.equippable.dapperness)
        end
    else
        inst.components.dapperness.dapperfn=function(inst1,owner)
            return nonEvilDapperFn(inst1,owner,inst.components.dapperness.dapperness)
        end
    end
end

local function AddRingAsTradeOption(inst)

    local shouldacceptitem=inst.components.trader.test
    inst.components.trader.test=function(inst, item)
        if(item and item.components.equippable and item.components.equippable.equipslot == GLOBAL.EQUIPSLOTS.RING)then
            return true
        else 
            return shouldacceptitem(inst,item)
        end
    end
    local onacceptitem=inst.components.trader.onaccept
    inst.components.trader.onaccept=function(inst, giver, item)
        if item.components.equippable and item.components.equippable.equipslot == GLOBAL.EQUIPSLOTS.RING then
            local current = inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.RING)
            if current then
                inst.components.inventory:DropItem(current)
            end
            inst.components.inventory:Equip(item)
        end
        return onacceptitem(inst,giver,item)
    end
end

AddPrefabPostInit("nightsword",nonEvilSanityPostinit)
AddPrefabPostInit("armor_sanity",nonEvilSanityPostinit)
AddPrefabPostInit("spiderhat",nonEvilSanityPostinit)

local newFlowerPicked=function(inst,picker)

    if(picker and picker.components.sanity)then
        local delta=TUNING.SANITY_TINY
        local prefab=inst.prefab
        if(picker:HasTag("evil"))then
            if(prefab=="flower")then
                delta=-TUNING.SANITY_TINY
            elseif (prefab=="flower_evil")then
                delta=TUNING.SANITY_TINY
            end
        else
            if(prefab=="flower")then
                delta=TUNING.SANITY_TINY
            elseif (prefab=="flower_evil")then
                delta=-TUNING.SANITY_TINY
            end
        end
        picker.components.sanity:DoDelta(delta)
    end
    inst:Remove()
end

AddPrefabPostInit("flower", function(inst) inst.components.pickable.onpickedfn=newFlowerPicked end)
AddPrefabPostInit("flower_evil", function(inst) inst.components.pickable.onpickedfn=newFlowerPicked end)
AddPrefabPostInit("petals_evil", function(inst) 
    local old_oneaten=inst.components.edible.oneaten
    inst.components.edible:SetOnEatenFn(function(inst,eater)
        if(eater and eater:HasTag("evil"))then
            if eater.components.sanity then
                eater.components.sanity:DoDelta(TUNING.SANITY_SMALL)
            end
        elseif(old_oneaten)then
            old_oneaten(inst,eater)
        end
    end)
end)

AddPrefabPostInit("gunpowder", function(inst) 
    inst:AddComponent("reloading") 
    inst.components.reloading.ammotype="gunpowder"
    inst.components.reloading.returnuses=1
end)

function makestackablePrefabPostInit(inst)
    if(not inst.components.stackable)then
    inst:AddComponent("stackable")
        inst.components.stackable.maxsize = 99
    end
end

AddPrefabPostInit("rabbit", makestackablePrefabPostInit)


function addT1LootPrefabPostInit(inst,chance)
    if(not inst.components.lootdropper)then
        inst:AddComponent("lootdropper")
    end
    inst.components.lootdropper:AddFallenLootTable(FALLENLOOTTABLE.tier1,FALLENLOOTTABLE.TABLE_TIER1_WEIGHT,chance)
end


function addT1T2LootPrefabPostInit(inst,chance)
    if(not inst.components.lootdropper)then
        inst:AddComponent("lootdropper")
    end
    inst.components.lootdropper:AddFallenLootTable(MergeMaps(FALLENLOOTTABLE["tier1"],FALLENLOOTTABLE["tier2"]),FALLENLOOTTABLE.TABLE_TIER1_WEIGHT+FALLENLOOTTABLE.TABLE_TIER2_WEIGHT,chance)
end

function addFullLootPrefabPostInit(inst,chance)
    if(not inst.components.lootdropper)then
        inst:AddComponent("lootdropper")
    end
    inst.components.lootdropper:AddFallenLootTable(FALLENLOOTTABLEMERGED,FALLENLOOTTABLE.TABLE_WEIGHT,chance)
end

function addFullStructureLootPrefabPostInit(inst,chance)
    if(not inst.components.lootdropper)then
        inst:AddComponent("lootdropper")
    end
    inst.components.lootdropper:AddFallenLootTable(MergeMaps(FALLENLOOTTABLEMERGED,FALLENLOOTTABLE.keys3),FALLENLOOTTABLE.TABLE_WEIGHT+FALLENLOOTTABLE.TABLE_KEYS3_WEIGHT,chance)
end

function addKeyTable1PostInit(inst,chance)
    if(not inst.components.lootdropper)then
        inst:AddComponent("lootdropper")
    end
    inst.components.lootdropper:AddFallenLootTable(FALLENLOOTTABLE.keys1,FALLENLOOTTABLE.TABLE_KEYS1_WEIGHT,chance)
end

function addKeyTable2PostInit(inst,chance)
    if(not inst.components.lootdropper)then
        inst:AddComponent("lootdropper")
    end
    inst.components.lootdropper:AddFallenLootTable(FALLENLOOTTABLE.keys2,FALLENLOOTTABLE.TABLE_KEYS2_WEIGHT,chance)
end

--this has to be the only non-fx thing that doesn't have one...
AddPrefabPostInit("thulecite_pieces", function(inst) 
    if(not inst.SoundEmitter)then
        inst.entity:AddSoundEmitter() 
    end
end)

AddPrefabPostInit("rabbithole", function(inst) addT1LootPrefabPostInit(inst,0.05) end)


AddPrefabPostInit("bee",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.2
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=-0.1
end)
AddPrefabPostInit("killerbee",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.2
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=-0.1
end)
AddPrefabPostInit("mosquito",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.2
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=-0.1
end)
AddPrefabPostInit("spider",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_evil")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.25
end)
AddPrefabPostInit("spider_warrior",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_evil")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.25
end)
AddPrefabPostInit("frog",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
    if(not inst.components.follower)then
        inst:AddComponent("follower")
    end
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=-0.5
end)
AddPrefabPostInit("merm",function(inst)
    inst:AddTag("fa_humanoid")
    inst:AddTag("fa_evil")
    inst:AddTag("pickpocketable")
    if(not inst.components.follower)then
        inst:AddComponent("follower")
    end
    addKeyTable1PostInit(inst,0.05)
    addFullLootPrefabPostInit(inst,0.1) 
    inst.components.lootdropper:AddChanceLoot("fa_scroll_1",0.1)
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=-0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.PHYSICAL]=0.25
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=0.2
end)
AddPrefabPostInit("pigguard",function(inst)
    inst:AddTag("fa_humanoid")
    inst:AddTag("fa_evil")
    inst:AddTag("pickpocketable")
    if(not inst.components.follower)then
        inst:AddComponent("follower")
    end
    addKeyTable1PostInit(inst,0.05)
    addFullLootPrefabPostInit(inst,0.1) 
    inst.components.lootdropper:AddChanceLoot("fa_scroll_1",0.1)
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.PHYSICAL]=0.5
end)
AddPrefabPostInit("pigman",function(inst)
    inst:AddTag("fa_humanoid")
    inst:AddTag("fa_good")
    inst:AddTag("pickpocketable")
    addKeyTable1PostInit(inst,0.05)
    addFullLootPrefabPostInit(inst,0.1)
    inst.components.lootdropper:AddChanceLoot("fa_scroll_1",0.1)
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.PHYSICAL]=0.2

    local onsetwerefn_old=inst.components.werebeast.onsetwerefn
    inst.components.werebeast:SetOnWereFn(function(inst)
        if onsetwerefn_old then onsetwerefn_old(inst) end
        inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.2
        inst.components.health.fa_resistances[FA_DAMAGETYPE.PHYSICAL]=0.6
    end)
    local onsetnormalfn_old=inst.components.werebeast.onsetnormalfn
    inst.components.werebeast:SetOnNormalFn(function(inst)
        if onsetnormalfn_old then onsetnormalfn_old(inst) end
        inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.1
        inst.components.health.fa_resistances[FA_DAMAGETYPE.PHYSICAL]=0.2
    end)
    AddRingAsTradeOption(inst)

end)
AddPrefabPostInit("pigking",function(inst)
    local shouldacceptitem=inst.components.trader.test
    inst.components.trader.test=function(inst, item)
    --yeah this is dirty
        if(item and item.components.equippable and item.components.equippable.equipslot == GLOBAL.EQUIPSLOTS.RING and item.prefab=="fa_ring_demon")then
            return true
        else 
            return shouldacceptitem(inst,item)
        end
    end

    local onacceptitem=inst.components.trader.onaccept
    inst.components.trader.onaccept=function(inst, giver, item)
        if item.components.equippable and item.components.equippable.equipslot == GLOBAL.EQUIPSLOTS.RING and item.prefab=="fa_ring_demon" then
            local wortox=SpawnPrefab("fa_cursedpigking")
--            wortox.components.inventory:GiveItem(item)
            wortox.Transform:SetPosition(inst.Transform:GetWorldPosition())
            inst:Remove()
        end
        return onacceptitem(inst,giver,item)
    end
end)
AddPrefabPostInit("tentacle",function(inst)
    inst:AddTag("fa_magicalbeast")
    inst:AddTag("fa_evil")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.HOLY]=-0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=0.5
end)
AddPrefabPostInit("hound",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_evil")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=0.1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=-0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=-0.5
end)
AddPrefabPostInit("firehound",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_evil")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=1.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=-1
end)
AddPrefabPostInit("icehound",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_evil")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=1.5
end)
AddPrefabPostInit("tallbird",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
    if(not inst.components.follower)then
        inst:AddComponent("follower")
    end
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=0.1
end)
AddPrefabPostInit("walrus",function(inst)
    inst:AddTag("fa_humanoid")
    inst:AddTag("fa_evil")
    inst:AddTag("pickpocketable")
    if(not inst.components.follower)then
        inst:AddComponent("follower")
    end
    addKeyTable1PostInit(inst,0.05)
    inst.components.health.fa_resistances[FA_DAMAGETYPE.PHYSICAL]=0.4
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=0.5
end)
AddPrefabPostInit("little_walrus",function(inst)
    inst:AddTag("fa_humanoid")
    inst:AddTag("fa_evil")
    if(not inst.components.follower)then
        inst:AddComponent("follower")
    end
    addKeyTable1PostInit(inst,0.05)
    inst.components.health.fa_resistances[FA_DAMAGETYPE.PHYSICAL]=0.2
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=0.2
end)
AddPrefabPostInit("krampus",function(inst)
    inst:AddTag("fa_humanoid")
    inst:AddTag("fa_evil")
    addKeyTable1PostInit(inst,0.05)
    inst.components.health.fa_resistances[FA_DAMAGETYPE.HOLY]=-0.1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.DEATH]=0.1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.PHYSICAL]=0.2
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.1
end)
AddPrefabPostInit("monkey",function(inst)
    inst:AddTag("fa_humanoid")
    inst:AddTag("fa_evil")
    addKeyTable1PostInit(inst,0.05)
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.1
end)
AddPrefabPostInit("knight",function(inst)
    inst:AddTag("fa_construct")
    inst:AddTag("fa_evil")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=1.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.DEATH]=1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=-0.25
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FORCE]=-0.3
end)
AddPrefabPostInit("knight_nightmare",function(inst)
    inst:AddTag("fa_construct")
    inst:AddTag("fa_evil")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=1.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.DEATH]=1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=-0.25
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FORCE]=-0.3
end)
AddPrefabPostInit("bishop",function(inst)
    inst:AddTag("fa_construct")
    inst:AddTag("fa_evil")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=1.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.DEATH]=1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=-0.25
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FORCE]=-0.3
end)
AddPrefabPostInit("bishop_nightmare",function(inst)
    inst:AddTag("fa_construct")
    inst:AddTag("fa_evil")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=1.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.DEATH]=1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=-0.25
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FORCE]=-0.3
end)
AddPrefabPostInit("rook",function(inst)
    inst:AddTag("fa_construct")
    inst:AddTag("fa_evil")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=1.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.DEATH]=1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=-0.25
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FORCE]=-0.3
end)
AddPrefabPostInit("rook_nightmare",function(inst)
    inst:AddTag("fa_construct")
    inst:AddTag("fa_evil")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=1.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.DEATH]=1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=-0.25
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FORCE]=-0.3
end)
AddPrefabPostInit("tentacle_pillar_arm",function(inst)
    inst:AddTag("fa_magicalbeast")
    inst:AddTag("fa_evil")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.HOLY]=-0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=0.5
end)
AddPrefabPostInit("spider_hider",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_evil")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.HOLY]=-0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=0.5
end)
AddPrefabPostInit("spider_spitter",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_evil")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.HOLY]=-0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=0.5
end)
AddPrefabPostInit("spider_dropper",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_evil")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.HOLY]=-0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=0.5
end)
AddPrefabPostInit("crawlinghorror",function(inst)
    inst:AddTag("undead")
    inst:AddTag("fa_evil")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.HOLY]=-1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.DEATH]=1
end)
AddPrefabPostInit("terrorbeak",function(inst)
    inst:AddTag("undead")
    inst:AddTag("fa_evil")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.HOLY]=-1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.DEATH]=1
end)
AddPrefabPostInit("eyeplant",function(inst)
    inst:AddTag("fa_plant")
    inst:AddTag("fa_neutral")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=0.1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=0.1
end)
AddPrefabPostInit("worm",function(inst)
    inst:AddTag("fa_magicalbeast")
    inst:AddTag("fa_evil")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.HOLY]=-0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=0.5
end)
AddPrefabPostInit("koalefant_summer",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
    if(not inst.components.follower)then
        inst:AddComponent("follower")
    end
    inst.components.health.fa_resistances[FA_DAMAGETYPE.PHYSICAL]=0.2
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=-0.5
end)
AddPrefabPostInit("koalefant_winter",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
    if(not inst.components.follower)then
        inst:AddComponent("follower")
    end
    inst.components.health.fa_resistances[FA_DAMAGETYPE.PHYSICAL]=0.2
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.3
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=1.5
end)
AddPrefabPostInit("smallbird",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.1
end)
AddPrefabPostInit("teenbird",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.1
end)
AddPrefabPostInit("slurtle",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
    if(not inst.components.follower)then
        inst:AddComponent("follower")
    end
    inst.components.health.fa_resistances[FA_DAMAGETYPE.HOLY]=-0.1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=0.2
end)
AddPrefabPostInit("snurtle",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
    if(not inst.components.follower)then
        inst:AddComponent("follower")
    end
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=-0.3
end)
AddPrefabPostInit("beefalo",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
    if(not inst.components.follower)then
        inst:AddComponent("follower")
    end
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=0.2
    inst.components.health.fa_resistances[FA_DAMAGETYPE.PHYSICAL]=0.2
end)
AddPrefabPostInit("penguin",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
    if(not inst.components.follower)then
        inst:AddComponent("follower")
    end
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.2
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=0.5
end)
AddPrefabPostInit("bunnyman",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
    inst:AddTag("pickpocketable")
    addKeyTable1PostInit(inst,0.05)
    addFullLootPrefabPostInit(inst,0.1) 
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.2
    inst.components.health.fa_resistances[FA_DAMAGETYPE.PHYSICAL]=0.2
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=-0.2
    AddRingAsTradeOption(inst)
end)
AddPrefabPostInit("rocky",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_good")
    addKeyTable1PostInit(inst,0.05)
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.DEATH]=0.25
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=-0.25
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FORCE]=-0.3
    AddRingAsTradeOption(inst)
end)
AddPrefabPostInit("crow",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
end)
AddPrefabPostInit("robin",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
end)
AddPrefabPostInit("robin_winter",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
end)
AddPrefabPostInit("babybeefalo",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
    if(not inst.components.follower)then
        inst:AddComponent("follower")
    end
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.1
end)
AddPrefabPostInit("perd",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
    if(not inst.components.follower)then
        inst:AddComponent("follower")
    end
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.1
end)
AddPrefabPostInit("butterfly",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
end)
AddPrefabPostInit("rabbit",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
end)
AddPrefabPostInit("spiderqueen",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_evil")
    addKeyTable2PostInit(inst,0.15)
    addFullLootPrefabPostInit(inst,0.15) 
    inst.components.lootdropper:AddChanceLoot("fa_scroll_35",0.25)
    inst.components.lootdropper:AddChanceLoot("fa_scroll_35",0.25)
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=-0.1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.1
end)
AddPrefabPostInit("leif",function(inst)
    inst:AddTag("fa_plant")
    inst:AddTag("fa_giant")
    inst:AddTag("fa_evil")
    inst.components.lootdropper:AddChanceLoot("fa_scroll_35",0.25)
    inst.components.lootdropper:AddChanceLoot("fa_scroll_35",0.25)
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.DEATH]=0.1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=-0.2
end)
AddPrefabPostInit("leif_sparse",function(inst)
    inst:AddTag("fa_plant")
    inst:AddTag("fa_giant")
    inst:AddTag("fa_evil")
    inst.components.lootdropper:AddChanceLoot("fa_scroll_35",0.25)
    inst.components.lootdropper:AddChanceLoot("fa_scroll_35",0.25)
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.DEATH]=0.1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=-0.2

end)
AddPrefabPostInit("deerclops",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_giant")
    inst:AddTag("fa_evil")
    addKeyTable2PostInit(inst,0.15)
    inst.components.lootdropper:AddChanceLoot("fa_scroll_35",0.25)
    inst.components.lootdropper:AddChanceLoot("fa_scroll_35",0.25)
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=1.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.5
end)
AddPrefabPostInit("minotaur",function(inst)
    inst:AddTag("fa_construct")
    inst:AddTag("fa_giant")
    inst:AddTag("fa_evil")
    --should not happen
    if not inst.components.lootdropper.loot then
        inst.components.lootdropper.loot={}
    end
    addKeyTable2PostInit(inst,0.15)
    table.insert(inst.components.lootdropper.loot,"fa_scroll_45")
    table.insert(inst.components.lootdropper.loot,"fa_scroll_45")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=2
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=0.75
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=-0.25
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.DEATH]=1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=-0.3
end)
AddPrefabPostInit("dragonfly",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_giant")
    inst:AddTag("fa_evil")
    addKeyTable2PostInit(inst,0.15)
    inst.components.lootdropper:AddChanceLoot("fa_scroll_35",0.25)
    inst.components.lootdropper:AddChanceLoot("fa_scroll_35",0.25)
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=1.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=-1
end)
AddPrefabPostInit("bearger",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_giant")
    inst:AddTag("fa_evil")
    addKeyTable2PostInit(inst,0.15)
    inst.components.lootdropper:AddChanceLoot("fa_scroll_35",0.25)
    inst.components.lootdropper:AddChanceLoot("fa_scroll_35",0.25)
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=-0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=0.2
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=-0.1
end)
AddPrefabPostInit("moose",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_giant")
    inst:AddTag("fa_evil")
    addKeyTable2PostInit(inst,0.15)
    inst.components.lootdropper:AddChanceLoot("fa_scroll_35",0.25)
    inst.components.lootdropper:AddChanceLoot("fa_scroll_35",0.25)
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=1.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.2
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=-0.2
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=-0.3
end)
AddPrefabPostInit("mossling",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_evil")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.1
end)
AddPrefabPostInit("buzzard",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
end)
AddPrefabPostInit("catcoon",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
    addKeyTable1PostInit(inst,0.05)
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.1
end)
AddPrefabPostInit("glommer",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_good")
end)
AddPrefabPostInit("mole",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
end)
AddPrefabPostInit("bat",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
    if(not inst.components.follower)then
        inst:AddComponent("follower")
    end
end)
AddPrefabPostInit("lightninggoat",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
    if(not inst.components.follower)then
        inst:AddComponent("follower")
    end
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=1.5
end)
AddPrefabPostInit("warg",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_evil")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=-0.2
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=0.1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.PHYSICAL]=0.2
end)
AddPrefabPostInit("birchnutdrake",function(inst)
    inst:AddTag("fa_animal")
    inst:AddTag("fa_neutral")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.2
end)
--[[
AddPrefabPostInit("deciduous_root",function(inst)
    inst:AddTag("fa_plant")
    inst:AddTag("fa_neutral")
--    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.5
end)
]]
AddPrefabPostInit("ghost",function(inst)
    if(not inst.components.lootdropper)then
        inst:AddComponent("lootdropper")
    end
    if(not inst.components.follower)then
        inst:AddComponent("follower")
    end
    inst.components.health.fa_resistances[FA_DAMAGETYPE.DEATH]=1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.HOLY]=-1
    inst.components.lootdropper:AddChanceLoot("nightmarefuel",0.75)
    inst.components.lootdropper:AddChanceLoot("nightmarefuel",0.18) 
    inst:AddTag("undead")
    inst:AddTag("fa_evil")
end)


AddPrefabPostInit("mermhouse", function(inst) 
    addFullStructureLootPrefabPostInit(inst,0.2) 
    inst.components.lootdropper:AddChanceLoot("fa_scroll_1",0.15)
end)
AddPrefabPostInit("pighouse", function(inst) 
    addFullStructureLootPrefabPostInit(inst,0.2) 
    inst.components.lootdropper:AddChanceLoot("fa_scroll_1",0.15)
end)
AddPrefabPostInit("rabbithouse", function(inst) addFullStructureLootPrefabPostInit(inst,0.2) end)

AddPrefabPostInit("spiderden", function(inst) 
    addT1LootPrefabPostInit(inst,0.15) 
    inst.components.lootdropper:AddChanceLoot("fa_scroll_1",0.05)
end)
AddPrefabPostInit("poisonspiderden", function(inst) 
    addT1LootPrefabPostInit(inst,0.15) 
    inst.components.lootdropper:AddChanceLoot("fa_scroll_1",0.05)
end)
AddPrefabPostInit("spiderden_2", function(inst) 
    addT1T2LootPrefabPostInit(inst,0.15) 
    inst.components.lootdropper:AddChanceLoot("fa_scroll_1",0.05)
end)
AddPrefabPostInit("poisonspiderden_2", function(inst) 
    addT1T2LootPrefabPostInit(inst,0.15) 
    inst.components.lootdropper:AddChanceLoot("fa_scroll_1",0.05)
end)
AddPrefabPostInit("spiderden_3", function(inst) 
    addFullStructureLootPrefabPostInit(inst,0.15) 
    inst.components.lootdropper:AddChanceLoot("fa_scroll_1",0.05)
end)
AddPrefabPostInit("poisonspiderden_3", function(inst) 
    addFullStructureLootPrefabPostInit(inst,0.15) 
    inst.components.lootdropper:AddChanceLoot("fa_scroll_1",0.05)
end)


--staff tags so they can go into wand bags
AddPrefabPostInit("icestaff", function(inst) inst:AddTag("staff") end)
AddPrefabPostInit("firestaff", function(inst) inst:AddTag("staff") end)
AddPrefabPostInit("telestaff", function(inst) inst:AddTag("staff") end)
AddPrefabPostInit("orangestaff", function(inst) 
    inst:AddTag("staff") 
    local canblink=inst.components.blinkstaff.CanBlinkToPoint
    function inst.components.blinkstaff:CanBlinkToPoint(pt)
        local level=GLOBAL.SaveGameIndex:GetCurrentCaveLevel()
        if(level>3)then
--            local data=Levels.cave_levels[level]
            local ground = GetWorld()
            if ground then
                local owner = self.inst.components.inventoryitem.owner
                local ownerpt=owner:GetPosition()
                local clear=ground.Pathfinder:IsClear(ownerpt.x, ownerpt.y, ownerpt.z,
                                                         pt.x, pt.y, pt.z,
                                                         {ignorewalls = false, ignorecreep = true})
                if(not clear) then return false end
            end
        end
        return canblink(self,pt)
    end
end)
AddPrefabPostInit("greenstaff", function(inst) inst:AddTag("staff") end)
AddPrefabPostInit("yellowstaff", function(inst) inst:AddTag("staff") end)

--why would spells ignore longupdate? This will collide with any other postconstructs i assume, but it's not exactly something where i can stack calls
local Spell=require "components/spell"
local old_spelllongupdate=Spell.LongUpdate
if(old_spelllongupdate)then
        print("WARNING: found old spell.longupdate, bypassing override")
else
    function Spell:LongUpdate(dt)
--TODO periodic tics should fire appropriate amount of times, not just once, fix onupdate bug
        self:OnUpdate(dt)
    end
end

--DLC PATCHUP
if(GLOBAL.FA_DLCACCESS)then

    TUNING.NIGHTSTICK_DAMAGE=(TUNING.NIGHTSTICK_DAMAGE or 0)*1.5
    AddPrefabPostInit("nightstick",function(inst)
        inst.components.weapon.stimuli=nil
        inst.components.weapon.fa_damagetype=FA_DAMAGETYPE.ELECTRIC
    end)
    TUNING.ARMORDRAGONFLY_FIRE_RESIST=0
    AddPrefabPostInit("armordragonfly",function(inst)
        inst.components.armor.fa_resistances[FA_DAMAGETYPE.FIRE]=0.85
    end)
end
--[[
AddClassPostConstruct("screens/characterselectscreen", function(self)
    self:SelectCharacter "barb"
end)
]]
AddClassPostConstruct("screens/newgamescreen", function(self)
    self.character = "barb"          
    local atlas = "images/saveslot_portraits/"..self.character..".xml"
    self.portrait:SetTexture(atlas, self.character..".tex")
end)


AddModCharacter("barb")
AddModCharacter("druid")
AddModCharacter("paladin")
AddModCharacter("cleric")
AddModCharacter("darkknight")
AddModCharacter("wizard")

AddModCharacter("ranger")
AddModCharacter("thief")
AddModCharacter("monk")
AddModCharacter("necromancer")
AddModCharacter("tinkerer")
AddModCharacter("bard")
