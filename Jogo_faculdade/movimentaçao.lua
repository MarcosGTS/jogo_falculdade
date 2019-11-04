
require("geraçao")
function movimento_player(dt, velocidade)
    if love.keyboard.isDown("right") then
        if player.x < (640 - player.w) then
            player.x = player.x + velocidade * dt
        end
    elseif love.keyboard.isDown("left") then
        if  player.x > 0 then      
            player.x = player.x - velocidade * dt
        end
    end
    if love.keyboard.isDown("up") then
        if player.y > 0 then
            player.y = player.y - velocidade * dt
        end
    elseif love.keyboard.isDown("down") then
        if player.y < (320 - player.h) then
            player.y = player.y + velocidade * dt
        end
    end
end

function direcao_player(vetor_player)
    if love.keyboard.isDown("right") then
        vetor_player.d = 1
    elseif love.keyboard.isDown("left") then
        vetor_player.d = -1
    end
    if love.keyboard.isDown("up") then
        vetor_player.d = 2
    elseif love.keyboard.isDown("down") then
        vetor_player.d = -2
    end
end

function monster_move(dt, px, py, monster_vetor)
    for i=#monster_vetor, 1, -1 do
        local monster = monster_vetor[i]
        if monster.tipo == 1 then
            if px > monster.x then
                monster.x = monster.x + monster.sp * dt
            end
            if px < monster.x then
                monster.x = monster.x - monster.sp * dt
            end
            if py > monster.y then
                monster.y = monster.y + monster.sp * dt
            end
            if py < monster.y then
                monster.y = monster.y - monster.sp * dt
            end
        elseif monster.tipo == 2 then
            if px > monster.x then
                monster.x = monster.x + monster.sp * dt
            end
            if px < monster.x then
                monster.x = monster.x - monster.sp * dt
            end
            if py > monster.y then
                monster.y = monster.y + monster.sp * dt
            end
            if py < monster.y then
                monster.y = monster.y - monster.sp * dt
            end
            if (px == mx or py == my) then
                
                
            end
        end
    end
end
