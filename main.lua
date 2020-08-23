-- Written by Rabia Alhaffar in 19/August/2020
-- TARGET! main source code
local rl = require("raylib")  -- Load raylib library

-- Game info
TARGET = {
  _AUTHOR = "Rabia Alhaffar",
  _URL = "https://github.com/Rabios/TARGET",
  _DATE = "23/August/2020",
  _VERSION = "v0.2 BETA",
  _INFO = "INFO: OpenGL: 3.3, OS: "..ffi.os..", ARCH: "..ffi.arch
}

HIGHSCORE = 0                 -- Highscore saving score position to storage
CURRENT_LEVEL = 1             -- Current level saving position to storage
LEVEL1_FINISHED = 2           -- If game level 1 finished position to storage
LEVEL2_FINISHED = 3           -- If game level 2 finished position to storage
LEVEL3_FINISHED = 4           -- If game level 3 finished position to storage
DIFFICULTY = 5                -- Difficulty to get saved/loaded by game position to storage
LEVEL1_SCORE = 6              -- Level 1 score position to storage
LEVEL2_SCORE = 7              -- Level 2 score position to storage
LEVEL3_SCORE = 8              -- Level 3 score position to storage
HEALTH = 9                    -- Health position to storage
SHIPS = 10                    -- Ships position to storage

scores_saved = { false, false, false } -- For not loop score saving

-- Load part 1 of game scripts!
dofile("options.lua")         -- Get game options
dofile("assets.lua")          -- Load game assets

-- Difficulty options, Template to be used by utils.lua (Game utilities script)
health = 100
max_health = health
ships = 1
speed = 5
shot_damage = 20        -- Damage caused by player shooting
hit1_damage = 1         -- Damage by simple enemies and potato difficulty enemies
hit2_damage = 5         -- Damage by boss 1 and easy difficulty enemies
hit3_damage = 10        -- Damage by boss 2 and medium difficulty enemies
heal = 50               -- Heal to be healed by stuff
shots_limit = 2         -- Limit of shots by eye monster

-- Get antialiasing and VSync options
if antialiasing_enabled then rl.SetConfigFlags(rl.FLAG_MSAA_4X_HINT) end
if vsync_enabled then rl.SetConfigFlags(rl.FLAG_VSYNC_HINT) end

-- Start game
rl.InitWindow(rl.GetScreenWidth(), rl.GetScreenHeight(), "TARGET!")
rl.SetExitKey(-1000) -- Disable escape key to close game, So i can use escape key in game without being closed!
rl.InitAudioDevice()

-- Get fullscreen and FPS options
if fullscreen_enabled then rl.ToggleFullscreen() end
rl.SetTargetFPS(fps)

-- Load game assets and set graphics so it not let texts drawn blurry
rl.SetTextureFilter(rl.GetFontDefault().texture, rl.FILTER_POINT)
load_assets()

-- Load part 2 of game scripts!
dofile("utils.lua")           -- Utilities
dofile("scenes.lua")          -- Load game scenes
dofile("score.lua")           -- Score drawing system
dofile("logic.lua")           -- Main game logic
dofile("bosses.lua")          -- Bosses game logic

-- Set starting scene, 1 for first one (Splashscreen)
current_scene = 1
current_level = 1

-- Game loop, Check other game files
while not rl.WindowShouldClose() do
  scenes[current_scene]() -- Run current scene from scenes array
end

-- Unload game content when closing game
close_game()