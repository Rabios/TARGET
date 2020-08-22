-- Written by Rabia Alhaffar in 19/August/2020
-- TARGET! bosses logic!

bosses_timers = { boss_1 = 0, boss_2 = 0, boss_3 = 0 } -- Bosses timers, To do their actions
boss_1 = {
  health = 2000,
  image = enemy1_image,
  moved = false,
  alive = true,
  tint = rl.WHITE,
  speedx = speed,
  speedy = 0,
  helpers = 10
}

boss_2 = {
  health = 4000,
  image = enemy7_image,
  moved = false,
  alive = true,
  tint = rl.WHITE,
  speedx = speed,
  speedy = speed,
  helpers = 10
}

boss_3 = {
  health = 5000,
  image = enemy4_image,
  moved = false,
  alive = true,
  tint = rl.WHITE,
  speedx = speed,
  speedy = 0,
  helpers = 10,
  shot_speed = { x = 0, y = 0 },
  lasers = {
    { start = rl.Vector2(0, 0), finish = rl.Vector2(0, 0) },
    { start = rl.Vector2(0, 0), finish = rl.Vector2(0, 0) },
    { start = rl.Vector2(0, 0), finish = rl.Vector2(0, 0) },
    { start = rl.Vector2(0, 0), finish = rl.Vector2(0, 0) },
    { start = rl.Vector2(0, 0), finish = rl.Vector2(0, 0) },
  }
}

function randomize_laser_position()
  for l in ipairs(boss_3.lasers) do
    boss_3.lasers[l].start = rl.Vector2(boss_3.x, boss_3.y)
    boss_3.lasers[l].finish = rl.Vector2(rl.GetRandomValue(-rl.GetScreenWidth(), rl.GetScreenWidth() / 1.5), rl.GetRandomValue(0, rl.GetScreenHeight()))
  end
end

-- Set enemies positions
boss_1.x = rl.GetScreenWidth() - 256
boss_1.y = (rl.GetScreenHeight() - 256) / 2

boss_2.x = rl.GetScreenWidth() - 256
boss_2.y = (rl.GetScreenHeight() - 256) / 2

boss_3.x = rl.GetScreenWidth() - 256
boss_3.y = (rl.GetScreenHeight() - 256) / 2

-- TODO: Bosses logic
function boss1_logic()
  if boss_1.alive then
    rl.DrawRectangle(0, 0, boss_1.health, 10, rl.RED)
    rl.DrawTexturePro(boss_1.image, rl.Rectangle(0, 0, boss_1.image.width, boss_1.image.height), rl.Rectangle(boss_1.x, boss_1.y, 256, 256), rl.Vector2(0, 0), 0, boss_1.tint)
    if bosses_timers.boss_1 >= fps * 20 then
      for i = 1, boss_1.helpers, 1 do
        table.insert(enemies.level_1, {
          type = "eye",
          x = boss_1.x - (256 * 2),
          y = rl.GetRandomValue(0, 8) * 100,
          health = 100,
          timer = 0,
          dead = false,
          explosion_size = 0,
          enemyspeed = {
            x = speed,
            y = 0,
          }
        })
      end
      bosses_timers.boss_1 = 0
    end
    
    -- Collision with player bullets
    for b in ipairs(bullets) do
      if bullets[b] then
        if rl.CheckCollisionRecs(rl.Rectangle(boss_1.x, boss_1.y, 256, 256), rl.Rectangle(bullets[b].x, bullets[b].y, bullet_size.w, bullet_size.h)) then
          boss_1.tint = rl.RED
          boss_1.health = boss_1.health - 1
          player.combo = player.combo + 1
          score = score + (player.combo * 100)
          table.remove(bullets, b)
        else
          boss_1.tint = rl.WHITE
        end
      end
    end
    
    -- Collision with player
    if rl.CheckCollisionRecs(rl.Rectangle(boss_1.x, boss_1.y, 256, 256), rl.Rectangle(player.x, player.y, player.w, player.h)) then
      decrease()
      player.combo = 0
      play_hit_sound()
    end
  
    if boss_1.health <= 0 then
      boss_1.health = 0
      boss_1.alive = false
      level = 2
      if not scores_saved[1] then
        rl.SaveStorageValue(LEVEL1_FINISHED, 1)
        rl.SaveStorageValue(CURRENT_LEVEL, 2)
        rl.SaveStorageValue(LEVEL1_SCORE, score)
        rl.SaveStorageValue(DIFFICULTY, difficulty)
        scores_saved[1] = true
      end
    end
    
    bosses_timers.boss_1 = bosses_timers.boss_1 + speed
  end
end

function boss2_logic()
  if boss_2.alive then
    rl.DrawRectangle(0, 0, boss_2.health, 10, rl.RED)
    rl.DrawTexturePro(boss_2.image, rl.Rectangle(0, 0, boss_2.image.width, boss_2.image.height), rl.Rectangle(boss_2.x, boss_2.y, 256, 256), rl.Vector2(0, 0), 0, boss_2.tint)
    
    if bosses_timers.boss_2 >= fps * 20 then
      for i = 1, boss_2.helpers * 4, 1 do
        table.insert(enemies.level_2, {
          type = "ship",
          x = boss_2.x - (256 * 2),
          y = rl.GetRandomValue(0, 8) * 100,
          health = 100,
          timer = 0,
          dead = false,
          explosion_size = 0,
          enemyspeed = {
            x = speed,
            y = 0,
          }
        })
      end
      bosses_timers.boss_2 = 0
    end
    
    for b in ipairs(bullets) do
      if bullets[b] then
        if rl.CheckCollisionRecs(rl.Rectangle(boss_2.x, boss_2.y, 256, 256), rl.Rectangle(bullets[b].x, bullets[b].y, bullet_size.w, bullet_size.h)) then
          boss_2.tint = rl.RED
          boss_2.health = boss_2.health - 1
          player.combo = player.combo + 1
          score = score + (player.combo * 100)
          table.remove(bullets, b)
        else
          boss_2.tint = rl.WHITE
        end
      end
    end
    
    -- Collision with player
    if rl.CheckCollisionRecs(rl.Rectangle(boss_2.x, boss_2.y, 256, 256), rl.Rectangle(player.x, player.y, player.w, player.h)) then
      decrease()
      player.combo = 0
      play_hit_sound()
    end
    
    -- If dead, Set to level 3, Which is last one!
    if boss_2.health <= 0 then
      boss_2.health = 0
      boss_2.alive = false
      level = 3
      if not scores_saved[2] then
        rl.SaveStorageValue(LEVEL2_FINISHED, 1)
        rl.SaveStorageValue(CURRENT_LEVEL, 3)
        rl.SaveStorageValue(LEVEL2_SCORE, score - rl.LoadStorageValue(LEVEL1_SCORE))
        rl.SaveStorageValue(DIFFICULTY, difficulty)
        scores_saved[2] = true
      end
    end
    
    bosses_timers.boss_2 = bosses_timers.boss_2 + speed
  end
end

function boss3_logic()
  if boss_3.alive then
    boss_3.y = boss_3.y + boss_3.speedy
    
    rl.DrawRectangle(0, 0, boss_3.health, 10, rl.RED)
    rl.DrawTexturePro(boss_3.image, rl.Rectangle(0, 0, boss_3.image.width, boss_3.image.height), rl.Rectangle(boss_3.x, boss_3.y, 256, 256), rl.Vector2(0, 0), 0, boss_3.tint)
    
    if bosses_timers.boss_3 == fps * 5 then
      boss_3.speedy = rl.GetRandomValue(-speed, speed)
    end
    
    if bosses_timers.boss_3 == fps * 10 then
      boss_3.speedy = rl.GetRandomValue(-speed, speed)
    end
    
    if boss_3.y < 0 then boss_3.y = 0 end
    if (boss_3.y + 256 > rl.GetScreenHeight()) then boss_3.y = rl.GetScreenHeight() - 256 end
    
    if bosses_timers.boss_3 == fps * 20 then
      for i = 1, boss_3.helpers, 1 do
        table.insert(enemies.level_3, {
          type = "lasership",
          x = boss_3.x - (256 * 2),
          y = rl.GetRandomValue(0, 4) * 272,
          health = 100,
          timer = 0,
          dead = false,
          explosion_size = 0,
          enemyspeed = {
            x = speed * 2,
            y = 0,
          }
        })
      end
    end
    
    if bosses_timers.boss_3 >= fps * 20 then
      for l in ipairs(boss_3.lasers) do
        rl.DrawLineEx(boss_3.lasers[l].start, boss_3.lasers[l].finish, 64, rl.PURPLE)
      
        if rl.CheckCollisionLineRec(boss_3.lasers[l].start.x, boss_3.lasers[l].start.y, boss_3.lasers[l].finish.x, boss_3.lasers[l].finish.y, player.x, player.y, player.w, player.h) then
          decrease()
          player.combo = 0
          play_hit_sound()
        end
      end
    end
    
    if bosses_timers.boss_3 >= fps * 60 then
      bosses_timers.boss_3 = 0
      randomize_laser_position()
    end
    
    for b in ipairs(bullets) do
      if bullets[b] then
        if rl.CheckCollisionRecs(rl.Rectangle(boss_3.x, boss_3.y, 256, 256), rl.Rectangle(bullets[b].x, bullets[b].y, bullet_size.w, bullet_size.h)) then
          boss_3.tint = rl.RED
          boss_3.health = boss_3.health - 1
          player.combo = player.combo + 1
          score = score + (player.combo * 100)
          table.remove(bullets, b)
        else
          boss_3.tint = rl.WHITE
        end
      end
    end
    
    -- Collision with player
    if rl.CheckCollisionRecs(rl.Rectangle(boss_3.x, boss_3.y, 256, 256), rl.Rectangle(player.x, player.y, player.w, player.h)) then
      decrease()
      player.combo = 0
      play_hit_sound()
    end
    
    -- If dead, Set to level 3, Which is last one!
    if boss_3.health <= 0 then
      boss_3.health = 0
      boss_3.alive = false
      level = 3
      if not scores_saved[2] then
        rl.SaveStorageValue(LEVEL3_FINISHED, 1)
        rl.SaveStorageValue(CURRENT_LEVEL, 3)
        rl.SaveStorageValue(LEVEL3_SCORE, score - rl.LoadStorageValue(LEVEL2_SCORE))
        rl.SaveStorageValue(DIFFICULTY, difficulty)
        scores_saved[2] = true
        paused = true
        current_scene = 5
      end
    end
    
    bosses_timers.boss_3 = bosses_timers.boss_3 + speed
  end
end