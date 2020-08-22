-- Written by Rabia Alhaffar in 19/August/2020
-- TARGET! utilities!
function random_color()
  return rl.Color(rl.GetRandomValue(0, 255), rl.GetRandomValue(0, 255), rl.GetRandomValue(0, 255), 255)
end

-- For lasers when attack player at some scene, Requires 2 values in this function!
function enemy_to_player(e)
  return e.x - player.x, e.y - player.y
end

function set_game_difficulty(d)
  -- Easy mode
  if d == 1 then
    player.alive = true
    paused = false
    health = 100
    ships = 10
    speed = 5
    shot_damage = 20
    hit1_damage = 1
    hit2_damage = 3
    hit3_damage = 5
    hit4_damage = 10
    heal = 50
    shots_limit = 1
    
  -- Hard mode
  elseif d == 2 then
    player.alive = true
    paused = false
    health = 100
    ships = 5
    speed = 8
    shot_damage = 20
    hit1_damage = 3
    hit2_damage = 5
    hit3_damage = 10
    hit4_damage = 13
    heal = 50
    shots_limit = 3
  end
  
end

-- To reset game data
function reset_game_data()
  rl.SaveStorageValue(HIGHSCORE, 0)
  rl.SaveStorageValue(LEVEL2_FINISHED, 0)
  rl.SaveStorageValue(CURRENT_LEVEL, 1)
  rl.SaveStorageValue(LEVEL1_FINISHED, 0)
  rl.SaveStorageValue(LEVEL3_FINISHED, 0)
  rl.SaveStorageValue(LEVEL1_SCORE, 0)
  rl.SaveStorageValue(LEVEL2_SCORE, 0)
  rl.SaveStorageValue(LEVEL3_SCORE, 0)
  bosses_timers = { boss_1 = 0, boss_2 = 0, boss_3 = 0 }
  timers = { level_1 = 0, level_2 = 0, level_3 = 0, game_over = 0 }
  reset_player_position()
  stars = {}
  enemies = { level_1 = {}, level_2 = {}, level_3 = {} }
  bullets = {}
  enemies_bullets = {}
  lasers = {}
  generate_stars(2000)
  set_game_difficulty(difficulty)
  generate_enemies(difficulty)
  score = 0
  paused = false
  level = 1
  player.combo = 0
  current_scene = 3
end

-- Load difficulty, Last level played, etc...
function load_gameplay_info(difficulty)
  stars = {}
  enemies = { level_1 = {}, level_2 = {}, level_3 = {} }
  bosses_timers = { boss_1 = 0, boss_2 = 0, boss_3 = 0 }
  timers = { level_1 = 0, level_2 = 0, level_3 = 0, game_over = 0 }
  bullets = {}
  enemies_bullets = {}
  lasers = {}
  generate_stars(2000)
  reset_player_position()
  set_game_difficulty(difficulty)
  generate_enemies(difficulty)
  level = rl.LoadStorageValue(CURRENT_LEVEL)
  paused = false
  current_scene = 3
end

function close_game()
  unload_assets()
  rl.CloseAudioDevice()
  rl.CloseWindow()
  os.exit(0)  
end

stars = {} -- Moving stars with color
function generate_stars(n)
  for s = 1, n, 1 do
    table.insert(stars, {
      x = rl.GetScreenWidth() + rl.GetRandomValue(0, rl.GetScreenWidth()),
      y = rl.GetRandomValue(0, rl.GetScreenHeight()),
      size = rl.GetRandomValue(1, 16),
      tint = random_color()
    })
  end
end

-- Update and move stars with basic physics
function update_stars()
  for s in ipairs(stars) do
    stars[s].x = stars[s].x - speed
    rl.DrawTexturePro(star_image, rl.Rectangle(0, 0, star_image.width, star_image.height), rl.Rectangle(stars[s].x, stars[s].y, stars[s].size, stars[s].size), rl.Vector2(0, 0), 0.0, stars[s].tint)
    if (stars[s].x < 0) then
      stars[s] = {
        x = rl.GetScreenWidth() + rl.GetRandomValue(0, rl.GetScreenWidth()),
        y = rl.GetRandomValue(0, rl.GetScreenHeight()),
        size = rl.GetRandomValue(1, 16),
        tint = random_color()
      }
    end
  end
end

-- Play random hit sound
function play_hit_sound()
  onetime = 0
  number = rl.GetRandomValue(1, 4)
  if onetime == 0 then
    rl.PlaySound(_G["hit"..tostring(number).."_sound"])
    onetime = 1
  end
end

-- Line-Rectangle and Line-Line collision detection
-- Port to Lua
-- http://www.jeffreythompson.org/collision-detection/line-rect.php
-- Line-Line collision
rl.CheckCollisionLineLine = function(x1, y1, x2, y2, x3, y3, x4, y4)

  -- calculate the direction of the lines
  uA = ((x4 - x3) * (y1 - y3) - (y4 - y3) * (x1 - x3)) / ((y4 - y3) * (x2 - x1) - (x4 - x3) * (y2 - y1))
  uB = ((x2 - x1) * (y1 - y3) - (y2 - y1) * (x1 - x3)) / ((y4 - y3) * (x2 - x1) - (x4 - x3) * (y2 - y1))

  -- if uA and uB are between 0-1, lines are colliding
  if (uA >= 0 and uA <= 1 and uB >= 0 and uB <= 1) then return true end
  return false
end

-- Line-Rectangle collision
rl.CheckCollisionLineRec = function(x1, y1, x2, y2, rx, ry, rw, rh)

  -- check if the line has hit any of the rectangle's sides
  -- uses the Line/Line function below
  left =   rl.CheckCollisionLineLine(x1, y1, x2, y2, rx, ry, rx, ry + rh)
  right =  rl.CheckCollisionLineLine(x1, y1, x2, y2, rx + rw, ry, rx + rw, ry + rh)
  top =    rl.CheckCollisionLineLine(x1, y1, x2, y2, rx, ry, rx + rw, ry)
  bottom = rl.CheckCollisionLineLine(x1, y1, x2, y2, rx, ry + rh, rx + rw, ry + rh)

  -- if ANY of the above are true, the line
  -- has hit the rectangle
  if (left or right or top or bottom) then return true end
  return false
end

-- Returns color depending on flash effects if enabled or disabled
function flash()
  if flash_effects then
    return random_color()
  else
    return rl.WHITE
  end
end