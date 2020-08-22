-- Written by Rabia Alhaffar in 19/August/2020
-- TARGET! score system!
score = rl.LoadStorageValue(HIGHSCORE) or 0
scoretext = ""

function update_score()
  if not (score > 10) then
    scoretext = string.format("%09i", score)
	elseif (score > 10) then
    scoretext = string.format("%08i", score)
	elseif (score > 100) then
    scoretext = string.format("%07i", score)
	elseif (score > 1000) then
    scoretext = string.format("%06i", score)
	elseif (score > 10000) then
    scoretext = string.format("%05i", score)
	elseif (score > 100000) then
    scoretext = string.format("%04i", score)
	elseif (score > 1000000) then
    scoretext = string.format("%03i", score)
	elseif (score > 10000000) then
    scoretext = string.format("%02i", score)
	elseif (score > 100000000) then
    scoretext = string.format("%01i", score)
	elseif (score > 1000000000) then
    scoretext = tostring(score)
  end
end

function draw_score()
  update_score()
	rl.DrawText(scoretext, 32, 32, 32, flash())
end

function reset_score()
  scoretext = "0000000000"
	score = 0
end