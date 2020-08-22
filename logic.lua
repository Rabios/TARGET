-- Written by Rabia Alhaffar in 20/August/2020
-- TARGET! game logic!
player = {
  image = ship_image,
  w = 64,
  h = 64,
  tint = rl.WHITE,
  input_allowed = true,
  alive = true,
  combo = 0
}

-- Enemies list
enemies = {
  level_1 = {},
  level_2 = {},
  level_3 = {},
}

enemies_bullets = {} -- When enemies shoot bullets, It stored here!

function decrease()
  if difficulty == 1 then
    health = health - hit1_damage
  elseif difficulty == 2 then
    health = health - hit2_damage
  end  
end

-- Generates level (Randomoly, Depending on algorithms and some stuff)
function generate_enemies(difficulty)
  if difficulty == 1 then
    for i = 1, 50, 1 do
      table.insert(enemies.level_1, {
        type = "eye",
        x = rl.GetScreenWidth() + (i * 200),
        y = rl.GetRandomValue(1, 8) * 100,
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
    
    for i = 1, 50, 1 do
      table.insert(enemies.level_2, {
        type = "ship",
        x = rl.GetScreenWidth() + (i * 400),
        y = rl.GetRandomValue(1, 8) * 100,
        health = 200,
        timer = 0,
        dead = false,
        explosion_size = 0,
        enemyspeed = {
          x = speed,
          y = 0,
        }
      })
    end
    
    for i = 1, 25, 1 do
      table.insert(enemies.level_3, {
        type = "lasership",
        x = rl.GetScreenWidth() + (i * 500),
        y = rl.GetRandomValue(0, 4) * 272,
        health = 300,
        timer = 0,
        dead = false,
        explosion_size = 0,
        enemyspeed = {
          x = speed,
          y = 0,
        }
      })
    end
  elseif difficulty == 2 then
    for i = 1, 100, 1 do
      table.insert(enemies.level_1, {
        type = "eye",
        x = rl.GetScreenWidth() + (i * 400),
        y = rl.GetRandomValue(1, 8) * 100,
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
    
    for i = 1, 25, 1 do
      table.insert(enemies.level_2, {
        type = "ship",
        x = rl.GetScreenWidth() + (i * 600),
        y = rl.GetRandomValue(1, 8) * 100,
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
    
    for i = 1, 50, 1 do
      table.insert(enemies.level_3, {
        type = "lasership",
        x = rl.GetScreenWidth() + (i * 800),
        y = rl.GetRandomValue(1, 8) * 100,
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
  end
end

function update_enemies()
  current_level_enemies = enemies["level_"..level]
  for e in ipairs(current_level_enemies) do
    if not current_level_enemies[e].dead then
      
      -- Update enemies position then draw them
      current_level_enemies[e].x = current_level_enemies[e].x - current_level_enemies[e].enemyspeed.x
      current_level_enemies[e].y = current_level_enemies[e].y + current_level_enemies[e].enemyspeed.y
      if (current_level_enemies[e].type == "ship") then
        rl.DrawTexturePro(enemy3_image, rl.Rectangle(0, 0, enemy3_image.width, enemy3_image.height), rl.Rectangle(current_level_enemies[e].x, current_level_enemies[e].y, 64, 64), rl.Vector2(0, 0), 0.0, rl.WHITE)
      elseif (current_level_enemies[e].type == "lasership") then
        rl.DrawTexturePro(enemy5_image, rl.Rectangle(0, 0, enemy5_image.width, enemy5_image.height), rl.Rectangle(current_level_enemies[e].x, current_level_enemies[e].y, enemy5_image.width, enemy5_image.height), rl.Vector2(0, 0), 0.0, rl.WHITE)
      elseif (current_level_enemies[e].type == "eye") then
        rl.DrawTexturePro(enemy1_image, rl.Rectangle(0, 0, enemy1_image.width, enemy1_image.height), rl.Rectangle(current_level_enemies[e].x, current_level_enemies[e].y, 64, 64), rl.Vector2(0, 0), 0.0, rl.WHITE)
      end
    end
    
    -- Eyes collision with player, Decreases player health
    if current_level_enemies[e].type == "eye" and not current_level_enemies[e].dead then
      if rl.CheckCollisionRecs(rl.Rectangle(player.x, player.y, player.w, player.h), rl.Rectangle(current_level_enemies[e].x, current_level_enemies[e].y, 64, 64)) then
        decrease()
        play_hit_sound()
        player.combo = 0
        if current_level_enemies[e] then table.remove(current_level_enemies, e) end
      end
    end
    
    -- Ships collision with player, Decreases player health
    if current_level_enemies[e] then
      if current_level_enemies[e].type == "ship" and not current_level_enemies[e].dead then
        if rl.CheckCollisionRecs(rl.Rectangle(player.x, player.y, player.w, player.h), rl.Rectangle(current_level_enemies[e].x, current_level_enemies[e].y, 64, 64)) then
          decrease()
          play_hit_sound()
          player.combo = 0
          if current_level_enemies[e] then table.remove(current_level_enemies, e) end
        end
    
      -- Laserships collision with player, Decreases player health
      elseif current_level_enemies[e].type == "lasership" and not current_level_enemies[e].dead then
        if rl.CheckCollisionRecs(rl.Rectangle(player.x, player.y, player.w, player.h), rl.Rectangle(current_level_enemies[e].x, current_level_enemies[e].y, 272, 136)) then
          decrease()
          play_hit_sound()
          player.combo = 0
        end
      end
    
      -- When an enemy is dead, Left explosion!
        if current_level_enemies[e].dead then
          if not (current_level_enemies[e].explosion_size >= 128) then
            rl.DrawTexturePro(explosion_image, rl.Rectangle(0, 0, explosion_image.width, explosion_image.height), rl.Rectangle(current_level_enemies[e].x, current_level_enemies[e].y, current_level_enemies[e].explosion_size, current_level_enemies[e].explosion_size), rl.Vector2(0, 0), 0, rl.WHITE)
          else
            if current_level_enemies[e] then
              player.combo = player.combo + 1
              score = score + player.combo * 100
              table.remove(current_level_enemies, e)
            end
          end
        if current_level_enemies[e] then current_level_enemies[e].explosion_size = current_level_enemies[e].explosion_size + 2 end
      end
    
      -- Health lol
      if current_level_enemies[e] then
        if (current_level_enemies[e].health <= 0) then
          current_level_enemies[e].health = 0
          current_level_enemies[e].dead = true
        end
      end
    end
    
    -- TODO: Improve lose game
    if health <= 0 then
      if ships > 0 then
        ships = ships - 1
        health = 100
        paused = false
        alive = true
      else
        paused = true
        alive = false
        current_scene = 7
      end
    end
    
    -- Delete them once they get out of screen, Or destroyed
    if current_level_enemies[e] then
      if (current_level_enemies[e].x < 0) or (current_level_enemies[e].y < 0) or (current_level_enemies[e].y > rl.GetScreenHeight()) then
        table.remove(current_level_enemies, e)
      end
    end
  end
end

function update_enemies_bullets()
  current_bullets = enemies_bullets
  current_level_enemies = enemies["level_"..level]
  if (#current_bullets >= 1) then
    for eb in ipairs(current_bullets) do
      current_bullets[eb].x = current_bullets[eb].x - current_bullets[eb].speedx
      current_bullets[eb].y = current_bullets[eb].y + current_bullets[eb].speedy
      rl.DrawTexturePro(shot_image, rl.Rectangle(0, 0, shot_image.width, shot_image.height), rl.Rectangle(current_bullets[eb].x, current_bullets[eb].y, current_bullets[eb].size, current_bullets[eb].size), rl.Vector2(0, 0), 0, rl.WHITE)
      
      -- Shots collision with player
      if rl.CheckCollisionRecs(rl.Rectangle(player.x, player.y, player.w, player.h), rl.Rectangle(current_bullets[eb].x, current_bullets[eb].y, current_bullets[eb].size, current_bullets[eb].size)) then
        decrease()
        play_hit_sound()
        player.combo = 0
        if current_bullets[eb] then table.remove(current_bullets, eb) end
      end
      
      -- Shots collision with player bullets
      for b in ipairs(bullets) do
        if current_bullets[eb] and bullets[b] then
          if rl.CheckCollisionRecs(rl.Rectangle(current_bullets[eb].x, current_bullets[eb].y, current_bullets[eb].size, current_bullets[eb].size), rl.Rectangle(bullets[b].x, bullets[b].y, bullet_size.w, bullet_size.h)) then
            table.remove(current_bullets, eb)
            table.remove(bullets, b)
          end
        end
      end
      
      -- Remove them once they get out of game screen!
      if current_bullets[eb] then
        if (current_bullets[eb].x < 0) or (current_bullets[eb].y < 0) or (current_bullets[eb].y >= rl.GetScreenHeight() - 64) then
          table.remove(current_bullets, eb)
        end
      end
    end
  end
end

-- Each enemy has logic, All in one function
function enemy_logic()
  current_level_enemies = enemies["level_"..level]
  for e in ipairs(current_level_enemies) do
    if (current_level_enemies[e].timer >= fps * 10) then
      if not current_level_enemies[e].dead then
        if current_level_enemies[e].type == "eye" then
          for i = 1, shots_limit, 1 do
            table.insert(enemies_bullets, {
                x = current_level_enemies[e].x,
                y = current_level_enemies[e].y,
                speedx = speed * 2,
                speedy = rl.GetRandomValue(-speed * 2, speed * 2),
                size = 32
            })
          end
        elseif current_level_enemies[e].type == "ship" then
          for i = 1, shots_limit, 1 do
            table.insert(enemies_bullets, {
              x = current_level_enemies[e].x,
              y = current_level_enemies[e].y,
              speedx = speed * 2,
              speedy = rl.GetRandomValue(-speed * 2, speed * 2),
              size = 32
            })
          end
        elseif current_level_enemies[e].type == "lasership" then
          table.insert(lasers, {
            start = rl.Vector2(current_level_enemies[e].x, current_level_enemies[e].y + (enemy5_image.height / 1.2)),
            finish = rl.Vector2(current_level_enemies[e].x - current_level_enemies[e].enemyspeed.x, current_level_enemies[e].y + (enemy5_image.height / 1.2)),
            speed = { x = -speed / 2, y = 0 },
            size = 10,
            timer = 0
          })
          table.insert(lasers, {
            start = rl.Vector2(current_level_enemies[e].x, current_level_enemies[e].y + (enemy5_image.height / 5.5)),
            finish = rl.Vector2(current_level_enemies[e].x - current_level_enemies[e].enemyspeed.x, current_level_enemies[e].y + (enemy5_image.height / 5.5)),
            speed = { x = -speed / 2, y = 0 },
            size = 10,
            timer = 0
          })
        end
        current_level_enemies[e].timer = 0
      end
    end
    current_level_enemies[e].timer = current_level_enemies[e].timer + speed
  end
end

bullets = {}
bullet_size = { w = 10, h = 10 }

function reset_player_position()
  player.x = player.w * 2
  player.y = (rl.GetScreenHeight() / 2) - player.h
end

function draw_player()
  if player.alive then
    
    -- Draw player
    rl.DrawTexturePro(player.image, rl.Rectangle(0, 0, player.image.width, player.image.height), rl.Rectangle(player.x, player.y, player.w, player.h), rl.Vector2(0, 0), 0, player.tint)
    
    -- Draw stats (Health, Level)
    rl.DrawRectangle(32, 64, health, 16, rl.RED)
    rl.DrawRectangleLines(32, 64, max_health, 16, rl.WHITE)
    rl.DrawText("LEVEL "..level, 148, 64, 16, rl.WHITE)
  end
end

-- Shoot logic
function shoot()
  table.insert(bullets, { x = player.x + 64, y = player.y })
  table.insert(bullets, { x = player.x + 64, y = player.y + 48 })
end

function update_bullets()
  if (#bullets >= 1) and player.alive then
    for b in ipairs(bullets) do
      rl.DrawRectangle(bullets[b].x, bullets[b].y, bullet_size.w, bullet_size.h, rl.WHITE)
      rl.DrawRectangleLines(bullets[b].x, bullets[b].y, bullet_size.w, bullet_size.h, rl.BLUE)
      bullets[b].x = bullets[b].x + speed * 2
      bullets[b].y = bullets[b].y
      
      -- Remove bullets got out of game scene so we can keep memory!
      if (bullets[b].x >= rl.GetScreenWidth()) or (bullets[b].y >= rl.GetScreenHeight()) or (bullets[b].y <= 0) or ((bullets[b].x <= player.x) and not mouse_input) then
        table.remove(bullets, b)
      end
      
      -- Collision with enemies
      current_level_enemies = enemies["level_"..level]
      for e in ipairs(current_level_enemies) do
        if bullets[b] then
          
          if current_level_enemies[e].type == "eye" then
            if rl.CheckCollisionRecs(rl.Rectangle(bullets[b].x, bullets[b].y, bullet_size.w, bullet_size.h), rl.Rectangle(current_level_enemies[e].x, current_level_enemies[e].y, 64, 64)) then
              current_level_enemies[e].health = current_level_enemies[e].health - shot_damage
              table.remove(bullets, b)
            end
          end
          
          if current_level_enemies[e].type == "ship" then
            if rl.CheckCollisionRecs(rl.Rectangle(bullets[b].x, bullets[b].y, bullet_size.w, bullet_size.h), rl.Rectangle(current_level_enemies[e].x, current_level_enemies[e].y, 64, 64)) then
              current_level_enemies[e].health = current_level_enemies[e].health - shot_damage
              table.remove(bullets, b)
            end
          end
          
          if current_level_enemies[e].type == "lasership" then
            if rl.CheckCollisionRecs(rl.Rectangle(bullets[b].x, bullets[b].y, bullet_size.w, bullet_size.h), rl.Rectangle(current_level_enemies[e].x, current_level_enemies[e].y, enemy5_image.width, enemy5_image.height)) then
              current_level_enemies[e].health = current_level_enemies[e].health - shot_damage
              table.remove(bullets, b)
            end
          end

        end
      end
    end
  end
end

-- Updates lasers moved and shoot by spaceships!
lasers = {}
function update_lasers()
  current_level_enemies = enemies["level_"..level]
  for l in ipairs(lasers) do
    -- Update and move lasers
    if lasers[l] then
      for e in ipairs(current_level_enemies) do
        if current_level_enemies[e].type == "lasership" then
          lasers[l].start.x = lasers[l].start.x + lasers[l].speed.x
        end
      end
      lasers[l].finish.x = lasers[l].finish.x + lasers[l].speed.x
      lasers[l].finish.y = lasers[l].finish.y + lasers[l].speed.y
    
      -- Draw!
      if not (lasers[l].timer >= fps * 2) then
        rl.DrawLineEx(lasers[l].start, lasers[l].finish, lasers[l].size, rl.PURPLE)
      else
        -- Remove it after each 3 seconds or when enemy gets out of screen (Seriously)
        if lasers[l] then
          lasers[l].timer = 0
          table.remove(lasers, l)
        end
      end
      
      if lasers[l] then
        if (rl.CheckCollisionLineRec(lasers[l].start.x, lasers[l].start.y, lasers[l].finish.x, lasers[l].finish.y, player.x, player.y, player.w, player.h)) then
          decrease()
          play_hit_sound()
          player.combo = 0
        end
      end
      
      if lasers[l] then lasers[l].timer = lasers[l].timer + (speed / 2) end
    end
  end
end

-- This holds player movement and shooting controls
function player_logic()  
  if player.input_allowed then
    
    if not mouse_input and not gamepad_input then
      -- Movement and shooting, Speed depends on game speed
      if rl.IsKeyDown(rl.KEY_W) or rl.IsKeyDown(rl.KEY_UP) then player.y = player.y - speed end
      if rl.IsKeyDown(rl.KEY_A) or rl.IsKeyDown(rl.KEY_LEFT) then player.x = player.x - speed end
      if rl.IsKeyDown(rl.KEY_S) or rl.IsKeyDown(rl.KEY_DOWN) then player.y = player.y + speed end
      if rl.IsKeyDown(rl.KEY_D) or rl.IsKeyDown(rl.KEY_RIGHT) then player.x = player.x + speed end
      if rl.IsKeyDown(rl.KEY_SPACE) or rl.IsKeyDown(rl.KEY_E) then
        shoot()
        rl.SetSoundVolume(select_sound, 0.1)
        rl.PlaySound(select_sound)
      end
    else
      if mouse_input then
        rl.HideCursor()
        player.x = rl.GetMouseX()
        player.y = rl.GetMouseY()
        if rl.IsMouseButtonDown(0) then
          shoot()
          rl.SetSoundVolume(select_sound, 0.1)
          rl.PlaySound(select_sound)
        end
      elseif gamepad_input then
        if rl.IsGamepadAvailable(rl.GAMEPAD_PLAYER1) then
          if rl.IsGamepadButtonDown(rl.GAMEPAD_PLAYER1, rl.GAMEPAD_BUTTON_LEFT_FACE_UP) then player.y = player.y - speed end
          if rl.IsGamepadButtonDown(rl.GAMEPAD_PLAYER1, rl.GAMEPAD_BUTTON_LEFT_FACE_LEFT) then player.x = player.x - speed end
          if rl.IsGamepadButtonDown(rl.GAMEPAD_PLAYER1, rl.GAMEPAD_BUTTON_LEFT_FACE_DOWN) then player.y = player.y + speed end
          if rl.IsGamepadButtonDown(rl.GAMEPAD_PLAYER1, rl.GAMEPAD_BUTTON_LEFT_FACE_RIGHT) then player.x = player.x + speed end
          if rl.IsGamepadButtonDown(rl.GAMEPAD_PLAYER1, rl.GAMEPAD_BUTTON_RIGHT_FACE_UP) then
            shoot()
            rl.SetSoundVolume(select_sound, 0.1)
            rl.PlaySound(select_sound)
          end
        end
      end
    end
  end
  
  
  -- Physical borders, We don't want player to get out of map!
  if (player.y + player.h >= rl.GetScreenHeight()) then
    player.y = rl.GetScreenHeight() - player.h
  elseif player.y <= 0 then
    player.y = 0
  elseif player.x <= 0 then
    player.x = 0
  elseif (player.x + player.w) >= rl.GetScreenWidth() then
    player.x = rl.GetScreenWidth() - player.w
  end
  
end