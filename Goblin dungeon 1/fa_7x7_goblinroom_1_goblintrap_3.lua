return {
  version = "1.1",
  luaversion = "5.1",
  orientation = "orthogonal",
  width = 28,
  height = 28,
  tilewidth = 16,
  tileheight = 16,
  properties = {},
  tilesets = {
    {
      name = "tiles",
      firstgid = 1,
      tilewidth = 64,
      tileheight = 64,
      spacing = 0,
      margin = 0,
      image = "../tiles.png",
      imagewidth = 512,
      imageheight = 128,
      properties = {},
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "BG_TILES",
      x = 0,
      y = 0,
      width = 28,
      height = 28,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0
      }
    },
    {
      type = "objectgroup",
      name = "FG_OBJECTS",
      visible = true,
      opacity = 1,
      properties = {},
      objects = {
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 8,
          y = 10,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 155,
          y = 12,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 181,
          y = 435,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 156,
          y = 435,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 132,
          y = 435,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 109,
          y = 435,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 84,
          y = 436,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 61,
          y = 436,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 36,
          y = 436,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 12,
          y = 435,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 13,
          y = 337,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 13,
          y = 312,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 12,
          y = 287,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 13,
          y = 263,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 13,
          y = 241,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 13,
          y = 218,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 12,
          y = 195,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 13,
          y = 171,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 13,
          y = 148,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 12,
          y = 125,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 11,
          y = 102,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 10,
          y = 79,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 10,
          y = 56,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 10,
          y = 34,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 435,
          y = 58,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 435,
          y = 80,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 436,
          y = 104,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 436,
          y = 126,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 436,
          y = 147,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 436,
          y = 169,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 436,
          y = 192,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 435,
          y = 217,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 435,
          y = 241,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 436,
          y = 265,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 435,
          y = 290,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 435,
          y = 315,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 276,
          y = 435,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 436,
          y = 339,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 229,
          y = 436,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 205,
          y = 435,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 296,
          y = 12,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 319,
          y = 12,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 342,
          y = 11,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 365,
          y = 11,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 389,
          y = 11,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 412,
          y = 12,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 435,
          y = 12,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 435,
          y = 34,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 179,
          y = 11,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 202,
          y = 11,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 225,
          y = 11,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 248,
          y = 11,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 272,
          y = 11,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 105,
          y = 11,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 130,
          y = 11,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 253,
          y = 436,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 437,
          y = 436,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 349,
          y = 435,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 326,
          y = 435,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 301,
          y = 436,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 394,
          y = 435,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 414,
          y = 435,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "fa_dungeon_wall",
          shape = "rectangle",
          x = 372,
          y = 435,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "armorfire3",
          shape = "rectangle",
          x = 217,
          y = 230,
          width = 0,
          height = 0,
          visible = true,
          properties = {
            ["scenario"] = "fa_pickup_item_goblintrap"
          }
        },
        {
          name = "",
          type = "skeleton",
          shape = "rectangle",
          x = 146,
          y = 105,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "skeleton",
          shape = "rectangle",
          x = 372,
          y = 338,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "skeleton",
          shape = "rectangle",
          x = 134,
          y = 358,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 55,
          y = 81,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 373,
          y = 51,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 315,
          y = 47,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 283,
          y = 99,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 283,
          y = 158,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 213,
          y = 174,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 163,
          y = 230,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 107,
          y = 263,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 55,
          y = 248,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 99,
          y = 218,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 153,
          y = 188,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 178,
          y = 137,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 106,
          y = 159,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 46,
          y = 182,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 232,
          y = 59,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 165,
          y = 48,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 231,
          y = 102,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 104,
          y = 80,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 71,
          y = 124,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 69,
          y = 312,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 33,
          y = 398,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 31,
          y = 363,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 85,
          y = 44,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 41,
          y = 44,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 93,
          y = 392,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 82,
          y = 350,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 178,
          y = 286,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 146,
          y = 298,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 397,
          y = 241,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 381,
          y = 161,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 339,
          y = 132,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 346,
          y = 190,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 245,
          y = 218,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 242,
          y = 246,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 217,
          y = 258,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 192,
          y = 247,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 201,
          y = 200,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 245,
          y = 194,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 289,
          y = 220,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 354,
          y = 94,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 170,
          y = 366,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 319,
          y = 255,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 321,
          y = 220,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 284,
          y = 277,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 263,
          y = 310,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 273,
          y = 192,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 274,
          y = 247,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 249,
          y = 278,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 243,
          y = 164,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 178,
          y = 166,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 219,
          y = 312,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 187,
          y = 329,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 412,
          y = 408,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 265,
          y = 410,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 163,
          y = 399,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 211,
          y = 397,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 269,
          y = 381,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 315,
          y = 371,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 365,
          y = 380,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 341,
          y = 284,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 305,
          y = 306,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 277,
          y = 342,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "trap_teeth_maxwell",
          shape = "rectangle",
          x = 232,
          y = 354,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
