-- Written by Rabia Alhaffar in 19/August/2020
-- TARGET! game scenes!
scenes_timer = 0  -- Timer to switch between some of game scenes
started = 0
gameover_sound1 = 0
gameover_sound2 = 0
difficulty = 0
selecting = 1
level = 1
difficulty_menu = false
paused = false
textfade = 0.0
choices = 4

-- For drawing using for-loop
local menu_texts = { "NEW GAME", "LOAD GAME", "CREDITS", "EXIT" }
local difficulty_texts = { "EASY", "HARD" }
local difficulty_colors = { rl.GREEN, rl.RED }
local timers = { level_1 = 0, level_2 = 0, level_3 = 0, game_over = 0 }
local bosses_summoned = { level_1 = false, level_2 = false, level_3 = false }
local pause_menu_texts = { "RESUME", "BACK TO MENU", "OPTIONS", "EXIT" }

local function update_game()
  update_stars()
  enemy_logic()
  update_bullets()
  update_lasers()
  update_enemies()
  update_enemies_bullets()
  draw_player()
  player_logic()  
  draw_score()
end

function reset_game()
  reset_game_data()
end

function mouse_gui()
  if rl.CheckCollisionRecs(rl.Rectangle(rl.GetMouseX(), rl.GetMouseY(), 1, 1), rl.Rectangle(0, 300, rl.GetScreenWidth(), 100)) then
    selecting = 1
  end
  
  if rl.CheckCollisionRecs(rl.Rectangle(rl.GetMouseX(), rl.GetMouseY(), 1, 1), rl.Rectangle(0, 400, rl.GetScreenWidth(), 100)) then
    selecting = 2
  end
  
  if choices > 2 then
    if rl.CheckCollisionRecs(rl.Rectangle(rl.GetMouseX(), rl.GetMouseY(), 1, 1), rl.Rectangle(0, 500, rl.GetScreenWidth(), 100)) then
      selecting = 3
    end
  
    if rl.CheckCollisionRecs(rl.Rectangle(rl.GetMouseX(), rl.GetMouseY(), 1, 1), rl.Rectangle(0, 600, rl.GetScreenWidth(), 100)) then
      selecting = 4
    end
  end
end

-- All game scenes in one array, So i don't waste time with checking scenes!
scenes = {
  
  function()
    rl.BeginDrawing()
    rl.ClearBackground(rl.BLACK)
    rl.DrawText("MADE WITH", (rl.GetScreenWidth() - rl.MeasureText("MADE WITH", 32)) / 2, (rl.GetScreenHeight() - 32) / 4, 32, rl.WHITE)
    rl.DrawTexture(raylua_logo, (rl.GetScreenWidth() - raylua_logo.width) / 2, (rl.GetScreenHeight() - raylua_logo.height) / 2, flash())
    rl.EndDrawing()
    
    -- Play sound one time!
    if (started == 0) then
      rl.PlaySound(powerup_sound)
      started = 1
    end
    
    
    -- Go to menu after 2 seconds
    if scenes_timer >= fps * 2 then
      current_scene = 2
    end
    
    scenes_timer = scenes_timer + 1
    if draw_fps then rl.DrawFPS(10, 10) end
  end,
  
  function()
    -- Menu
    rl.BeginDrawing()
    rl.ClearBackground(rl.BLACK)
    rl.DrawText("TARGET!", (rl.GetScreenWidth() - rl.MeasureText("TARGET!", 96)) / 2, rl.GetScreenHeight() / 10, 96, flash())
    rl.DrawRectangle(0, (selecting * 100) + 200, rl.GetScreenWidth(), 100, rl.GRAY)
    
    -- Draw centered selections
    -- NOTE: 24 is 48 (Font size) divided by 2 here, Which make layout awesome!
    if not difficulty_menu then
      choices = 4
      for t in ipairs(menu_texts) do
        rl.DrawText(menu_texts[t], (rl.GetScreenWidth() - rl.MeasureText(menu_texts[t], 48)) / 2, (t * 100) + 200 + 24, 48, rl.WHITE)
      end
    else
      choices = 2
      rl.DrawText("SELECT DIFFICULTY", (rl.GetScreenWidth() - rl.MeasureText("SELECT DIFFICULTY", 48)) / 2, 224, 48, rl.WHITE)
      for d in ipairs(difficulty_texts) do
        rl.DrawText(difficulty_texts[d], (rl.GetScreenWidth() - rl.MeasureText(difficulty_texts[d], 48)) / 2, (d * 100) + 200 + 24, 48, difficulty_colors[d])
      end
    end
    rl.DrawText("[ESCAPE KEY]: BACK", (rl.GetScreenWidth() - rl.MeasureText("[ESCAPE KEY]: BACK", 32)) / 1.02, 32, 32, rl.WHITE)
    rl.EndDrawing()
    
    if mouse_input then mouse_gui() end
    
    -- If Arrow up/W key pressed or Arrow down/S, Go in selections!
    -- Gamepad and mouse integration supported!
    if ((not mouse_input and not gamepad_input) and (rl.IsKeyPressed(rl.KEY_UP) or rl.IsKeyPressed(rl.KEY_W))) or (gamepad_input and rl.IsGamepadAvailable(rl.GAMEPAD_PLAYER1) and rl.IsGamepadButtonPressed(rl.GAMEPAD_PLAYER1, rl.GAMEPAD_BUTTON_LEFT_FACE_UP)) then
      if not ((selecting - 1) == 0) then
        selecting = selecting - 1
      else
        selecting = choices
      end
      rl.PlaySound(select_sound)
    end
    
    if ((not mouse_input and not gamepad_input) and (rl.IsKeyPressed(rl.KEY_DOWN) or rl.IsKeyPressed(rl.KEY_S))) or (gamepad_input and rl.IsGamepadAvailable(rl.GAMEPAD_PLAYER1) and rl.IsGamepadButtonPressed(rl.GAMEPAD_PLAYER1, rl.GAMEPAD_BUTTON_LEFT_FACE_DOWN)) then
      if not ((selecting + 1) > choices) then
        selecting = selecting + 1
      else
        selecting = 1
      end
      rl.PlaySound(select_sound)
    end
    
    if ((not mouse_input and not gamepad_input and rl.IsKeyPressed(rl.KEY_ESCAPE) or rl.IsKeyPressed(rl.KEY_E))) or (gamepad_input and rl.IsGamepadAvailable(rl.GAMEPAD_PLAYER1) and rl.IsGamepadButtonPressed(rl.GAMEPAD_PLAYER1, rl.GAMEPAD_BUTTON_RIGHT_FACE_RIGHT)) or (mouse_input and rl.IsMouseButtonPressed(1)) then
      if difficulty_menu then
        current_scene = 2
        difficulty_menu = false
      else
        close_game()
      end
    end
    
    -- If space key pressed, Select!
    if ((not mouse_input and not gamepad_input) and (rl.IsKeyPressed(rl.KEY_SPACE))) or (gamepad_input and rl.IsGamepadAvailable(rl.GAMEPAD_PLAYER1) and rl.IsGamepadButtonPressed(rl.GAMEPAD_PLAYER1, rl.GAMEPAD_BUTTON_RIGHT_FACE_UP)) or (mouse_input and rl.IsMouseButtonPressed(0)) then
      if not difficulty_menu then
        
        if selecting == 1 then
          difficulty_menu = true
        end
      
        -- Load game from latest level!
        if selecting == 2 then
          if rl.LoadStorageValue(LEVEL3_FINISHED) == 1 then
            bosses_summoned = { level_1 = true, level_2 = true, level_3 = true }
            bosses_timers = { boss_1 = 0, boss_2 = 0, boss_3 = 0 }
            boss_1.alive = false
            boss_2.alive = false
            boss_3.alive = false
            boss_1.health = 0
            boss_2.health = 0
            boss_3.health = 0
            started = 0
            timers = { level_1 = 0, level_2 = 0, level_3 = 0, game_over = 0 }
            current_scene = 5 -- Game finished! No talk about that!
          elseif rl.LoadStorageValue(LEVEL2_FINISHED) == 1 then
            bosses_summoned = { level_1 = true, level_2 = true, level_3 = false }
            bosses_timers = { boss_1 = 0, boss_2 = 0, boss_3 = 0 }
            boss_1.alive = false
            boss_2.alive = false
            boss_3.alive = true
            boss_1.health = 0
            boss_2.health = 0
            started = 0
            timers = { level_1 = 0, level_2 = 0, level_3 = 0, game_over = 0 }
            difficulty = rl.LoadStorageValue(DIFFICULTY)
            load_gameplay_info(difficulty)
            level = 3
            current_scene = 3
          elseif rl.LoadStorageValue(LEVEL1_FINISHED) == 1 then
            bosses_summoned = { level_1 = true, level_2 = false, level_3 = false }
            bosses_timers = { boss_1 = 0, boss_2 = 0, boss_3 = 0 }
            boss_1.alive = false
            boss_2.alive = true
            boss_3.alive = true
            boss_1.health = 0
            started = 0
            timers = { level_1 = 0, level_2 = 0, level_3 = 0, game_over = 0 }
            difficulty = rl.LoadStorageValue(DIFFICULTY)
            load_gameplay_info(difficulty)
            level = 2
            current_scene = 3
          else
            --error("GAME FAILURE!", 1)
            current_scene = 2
            difficulty_menu = false
            started = 0
          end
        end
      
        -- Go to credits!
        if selecting == 3 then 
          current_scene = 8
        end
      
        -- Exit game!
        if selecting == 4 then 
          close_game()
        end
      else
        if selecting == 1 then
          difficulty = selecting
          bosses_timers = { boss_1 = 0, boss_2 = 0, boss_3 = 0 }
          reset_game_data()
        end
          
        if selecting == 2 then
          difficulty = selecting
          bosses_timers = { boss_1 = 0, boss_2 = 0, boss_3 = 0 }
          reset_game_data()
        end
      end
      rl.PlaySound(select_sound)
    end
    if draw_fps then rl.DrawFPS(10, 10) end
  end,
  
  function()
    if not paused then
      rl.BeginDrawing()
      rl.ClearBackground(rl.BLACK)
      -- Level 1
      if level == 1 then
        update_game()
        if (timers.level_1 > fps * 200) then
          boss1_logic()
          bosses_summoned.level_1 = true
        end
        timers.level_1 = timers.level_1 + speed
      
      -- Level 2
      elseif level == 2 then
        update_game()
        if (timers.level_2 > fps * 400) then
          boss2_logic()
          bosses_summoned.level_2 = true
        end
        timers.level_2 = timers.level_2 + speed
        
      -- Level 3
      elseif level == 3 then
        update_game()
        if (timers.level_3 > fps * 500) then
          boss3_logic()
          bosses_summoned.level_3 = true
        end
        timers.level_3 = timers.level_3 + speed
        
      else
        error("LEVEL NOT FOUND!", 1)
      end
      rl.EndDrawing()
      -- Game logic
      if draw_fps then rl.DrawFPS(10, 10) end
    end
    
    if ((not mouse_input and not gamepad_input and rl.IsKeyPressed(rl.KEY_ESCAPE))) or (gamepad_input and rl.IsGamepadAvailable(rl.GAMEPAD_PLAYER1) and rl.IsGamepadButtonPressed(rl.GAMEPAD_PLAYER1, rl.GAMEPAD_BUTTON_RIGHT_FACE_RIGHT)) or (mouse_input and rl.IsMouseButtonPressed(1)) then
      paused = true
      current_scene = 4
    end
  end,
  
  -- Paused menu
  function()
    rl.BeginDrawing()
    rl.ClearBackground(rl.BLUE)
    rl.DrawText("GAME PAUSED", (rl.GetScreenWidth() - rl.MeasureText("GAME PAUSED", 128)) / 2, (rl.GetScreenHeight() - 128) / 2, 128, rl.WHITE)
    rl.DrawText("[ESCAPE KEY]: RESUME", (rl.GetScreenWidth() - rl.MeasureText("[ESCAPE KEY]: RESUME", 32)) / 1.02, 32, 32, rl.WHITE)
    rl.EndDrawing()
    
    -- Get back to the game once escape key pressed!
    if ((not mouse_input and not gamepad_input and rl.IsKeyPressed(rl.KEY_ESCAPE))) or (gamepad_input and rl.IsGamepadAvailable(rl.GAMEPAD_PLAYER1) and rl.IsGamepadButtonPressed(rl.GAMEPAD_PLAYER1, rl.GAMEPAD_BUTTON_RIGHT_FACE_RIGHT)) or (mouse_input and rl.IsMouseButtonPressed(1)) then
      paused = false
      current_scene = 3
    end
    
    if draw_fps then rl.DrawFPS(10, 10) end
  end,
  
  -- Game completed!
  function()
    total = rl.LoadStorageValue(LEVEL1_SCORE) + rl.LoadStorageValue(LEVEL2_SCORE) + rl.LoadStorageValue(LEVEL3_SCORE)
    
    if (started == 0) then
      rl.PlaySound(powerup_sound)
      started = 1
    end
    
    rl.BeginDrawing()
    rl.ClearBackground(rl.BLACK)
    rl.DrawText("THANKS FOR PLAYING!", (rl.GetScreenWidth() - rl.MeasureText("THANKS FOR PLAYING!", 96)) / 2, 128, 96, flash())
    rl.DrawText("YOUR SCORE IS: "..total, (rl.GetScreenWidth() - rl.MeasureText("YOUR SCORE IS: "..total , 32)) / 2, 256, 32, flash())
    
    rl.DrawText("PRESS ESCAPE KEY TO GO TO MENU!", (rl.GetScreenWidth() - rl.MeasureText("PRESS SPACE/ESCAPE KEY TO GO TO MENU!", 32)) / 2, rl.GetScreenHeight() - 64, 32, flash())
    rl.EndDrawing()
    
    if ((not mouse_input and not gamepad_input and rl.IsKeyPressed(rl.KEY_ESCAPE))) or (gamepad_input and rl.IsGamepadAvailable(rl.GAMEPAD_PLAYER1) and rl.IsGamepadButtonPressed(rl.GAMEPAD_PLAYER1, rl.GAMEPAD_BUTTON_RIGHT_FACE_RIGHT)) or (mouse_input and rl.IsMouseButtonPressed(1)) then
      current_scene = 2
      difficulty_menu = false
      paused = true
      timers.game_over = 0
      textfade = 0.0
      gameover_sound1 = 0
      gameover_sound2 = 0
    end
    
    if draw_fps then rl.DrawFPS(10, 10) end
  end,
  
  -- Options scene, Planned...
  function()
    
  end,
  
  -- Game over scene
  function()
    rl.BeginDrawing()
    rl.ClearBackground(BLACK)
    
    if (gameover_sound1 == 0) then
      rl.PlaySound(death_sound)
      gameover_sound1 = 1
    end
    
    if not (timers.game_over > rl.GetScreenWidth()) then
      recwidth = timers.game_over
    end
    
    rl.DrawRectangle(0, 0, recwidth, rl.GetScreenHeight(), rl.RED)
    
    -- Draw text
    if (timers.game_over >= rl.GetScreenWidth()) then
      rl.DrawText("GAME OVER!", (rl.GetScreenWidth() - rl.MeasureText("GAME OVER!", 128)) / 2, (rl.GetScreenHeight() - 128) / 2, 128, rl.Fade(rl.WHITE, textfade))
      
      if (gameover_sound2 == 0) then
        rl.PlaySound(gameover_sound)
        gameover_sound2 = 1
      end
    
      if not (textfade >= 1.0) then
        textfade = textfade + 0.01
      end
      
      if (timers.game_over >= rl.GetScreenWidth() + (fps * 20)) then
        current_scene = 2
        difficulty_menu = false
        paused = true
        timers.game_over = 0
        textfade = 0.0
        gameover_sound1 = 0
        gameover_sound2 = 0
      end
    end
    
    rl.EndDrawing()
    timers.game_over = timers.game_over + speed
    if draw_fps then rl.DrawFPS(10, 10) end
  end,
  
  -- Credits
  function()
    rl.BeginDrawing()
    rl.ClearBackground(rl.BLACK)
    rl.DrawText("TARGET!", (rl.GetScreenWidth() - rl.MeasureText("TARGET!", 96)) / 2, rl.GetScreenHeight() / 10, 96, flash())
    rl.DrawText("MADE BY", (rl.GetScreenWidth() - rl.MeasureText("MADE BY", 48)) / 3, rl.GetScreenHeight() / 4, 48, rl.WHITE)
    rl.DrawText("RABIA ALHAFFAR", (rl.GetScreenWidth() - rl.MeasureText("RABIA ALHAFFAR", 48)) / 1.5, rl.GetScreenHeight() / 4, 48, rl.RED)
    rl.DrawText("MADE WITH", (rl.GetScreenWidth() - rl.MeasureText("MADE WITH", 32)) / 2, rl.GetScreenHeight() / 2.6, 32, rl.WHITE)
    rl.DrawTexture(raylua_logo, (rl.GetScreenWidth() - raylua_logo.width) / 2, (rl.GetScreenHeight() - raylua_logo.height) / 1.5, rl.WHITE)
    rl.DrawText("[ESCAPE KEY]: BACK", (rl.GetScreenWidth() - rl.MeasureText("[ESCAPE KEY]: BACK", 32)) / 1.02, 32, 32, rl.WHITE)
    rl.EndDrawing()
    
    if ((not mouse_input and not gamepad_input and rl.IsKeyPressed(rl.KEY_ESCAPE))) or (gamepad_input and rl.IsGamepadAvailable(rl.GAMEPAD_PLAYER1) and rl.IsGamepadButtonPressed(rl.GAMEPAD_PLAYER1, rl.GAMEPAD_BUTTON_RIGHT_FACE_RIGHT)) or (mouse_input and rl.IsMouseButtonPressed(1)) then
      current_scene = 2
      difficulty_menu = false
      rl.PlaySound(select_sound)
    end
    
    if (mouse_input and rl.IsMouseButtonPressed(0)) then
      if rl.CheckCollisionRecs(rl.Rectangle(rl.GetMouseX(), rl.GetMouseY(), 1, 1), rl.Rectangle((rl.GetScreenWidth() - rl.MeasureText("RABIA ALHAFFAR", 48)) / 1.5, rl.GetScreenHeight() / 4, 48, rl.MeasureText("RABIA ALHAFFAR", 48))) then
        rl.OpenURL("https://github.com/Rabios")
      end
      if rl.CheckCollisionRecs(rl.Rectangle(rl.GetMouseX(), rl.GetMouseY(), 1, 1), rl.Rectangle((rl.GetScreenWidth() - raylua_logo.width) / 2, (rl.GetScreenHeight() - raylua_logo.height) / 2, raylua_logo.width, raylua_logo.height)) then
        rl.OpenURL("https://github.com/Rabios/raylua")
      end
    end
    
    if draw_fps then rl.DrawFPS(10, 10) end
  end,
}