# TARGET!

Space shooter (Shump) game i tried to make in 4 days with [raylib](https://raylib.com) in [Lua](https://lua.org) using my bindings ([raylua](https://github.com/Rabios/raylua)), With simple concepts like shooting and boss fights!

The game features short 3 levels that in total don't last more than over 10 to 20 minutes (Game length).

<img src="https://github.com/Rabios/TARGET/blob/master/image1.png">
<br>

<img src="https://github.com/Rabios/TARGET/blob/master/image2.png">
<br>

<img src="https://github.com/Rabios/TARGET/blob/master/image3.png">
<br>

<img src="https://github.com/Rabios/TARGET/blob/master/image4.png">
<br>

### Running from source code

Just grab LuaJIT compiler distribution/binaries (Like ULua), Then run `main.lua` with it.

The game should work on desktop with any OS and following architectures: x86 and x64.

> WARNING: The game requires OpenGL 3.3 to run.

### Controls (Keyboard)

- WASD/Arrow keys: move.
- SPACE/E key: shoot/select.
- ESCAPE key: Pauses the game if in-game, Back to main menu if in menus.

### Controls (Mouse)

- Move player with mouse.
- Left mouse button: shoot/select.
- Right mouse button: Pauses the game if in-game, Back to main menu if in menus.

> NOTES: You might need to enable mouse controls via `options.lua` (Game options file)

### Controls (Gamepad)

- Move player with DPAD
- Y/Triangle button: shoot/select.
- B/O button: Pauses the game if in-game, Back to main menu if in menus.

> NOTES: You might need to enable gamepad controls via `options.lua` (Game options file)

### About game options

Options menu is in my plans, Currently you can edit game options from `options.lua` and run game again to apply options.

### TODO (Soon)

This game is my second game, I would like to improve it soon when i have time for it.

- [ ] Game songs/soundtrack (Currently game has sounds).
- [ ] Options menu.
- [ ] Adding simple GUI for game over and game pause scenes.
- [ ] Add commented stuff in `assets.lua` (It can be update for game)
- [ ] Better support for game resolutions.
- [ ] Better enemies and boss fights (Bosses and enemies can be better).
- [ ] More levels.
- [ ] Not random levels, Designed from zero.
- [ ] Animations (So game can be more beautiful).