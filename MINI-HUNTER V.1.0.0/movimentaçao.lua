
require("geraçao")
function movimento_player(dt, velocidade,window_w, window_h)
    if love.keyboard.isDown("d") then
        if player.x < (window_w - player.w) then
            player.x = player.x + velocidade * dt
        end
    elseif love.keyboard.isDown("a") then
        if  player.x > 0 then      
            player.x = player.x - velocidade * dt
        end
    end
    if love.keyboard.isDown("w") then
        if player.y > 0 then
            player.y = player.y - velocidade * dt
        end
    elseif love.keyboard.isDown("s") then
        if player.y < (window_h - player.h) then
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
        if monster.tipo < 2 then
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
        elseif monster.tipo >= 2 then
            if (((px-monster.x)^2 + (py - monster.y)^2)^(1/2)) > 450 then
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
            --[[ MOVIMENTAÇAO DO ARQUEIRO
            elseif (((px-monster.x)^2 + (py - monster.y)^2)^(1/2)) < 200 and (((px-monster.x)^2 + (py - monster.y)^2)^(1/2)) > 100 then
                if math.abs(px - monster.x) < math.abs(py - monster.y)  then
                    if px > monster.x then
                        monster.x = monster.x + monster.sp/1.5 * dt
                    else
                        monster.x = monster.x - monster.sp/1.5 * dt
                    end
                elseif math.abs(px - monster.x) > math.abs(py - monster.y) then
                    if py > monster.y then
                        monster.y = monster.y + monster.sp/1.5 * dt
                    else 
                        monster.y = monster.y - monster.sp/1.5 * dt
                    end
                end
            ]]--
            elseif  (((px-monster.x)^2 + (py - monster.y)^2)^(1/2)) < 100 then
                if px > monster.x then
                    monster.x = monster.x - monster.sp/1.25 * dt
                end
                if px < monster.x then
                    monster.x = monster.x + monster.sp/1.25 * dt
                end
                if py > monster.y then
                    monster.y = monster.y - monster.sp/1.25 * dt
                end
                if py < monster.y then
                    monster.y = monster.y + monster.sp/1.25 * dt
                end
            end
        end
    end
end

function mov_progressivo(dt, vetor,x,y)
    for i=#vetor,1, -1 do
        local objeto = vetor[i]
        local distancia = ((objeto.x - x)^2 + (objeto.y - y)^2)^(1/2)
        if distancia <= 200 then
            if x >= objeto.x then 
                objeto.x = objeto.x + objeto.sp * 1/distancia 
            end
            if x <= objeto.x then
                objeto.x = objeto.x - objeto.sp * 1/distancia
            end
            if y >= objeto.y then 
                objeto.y = objeto.y + objeto.sp * 1/distancia 
            end
            if y <= objeto.y then 
                objeto.y = objeto.y - objeto.sp * 1/distancia 
            end
        end
    end
end
