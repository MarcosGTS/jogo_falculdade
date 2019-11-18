
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

function monster_move(dt, px, py, monster_vetor,window_w,window_h,audio)
    for i=#monster_vetor, 1, -1 do
        local monster = monster_vetor[i]
        vrx = px - monster.origemx
        vry = py - monster.origemy 

        vangulo = math.atan2(vry,vrx)
        
        if monster.tipo == 1 then
            monster.x = monster.x + monster.sp * math.cos(vangulo) * dt
            monster.y = monster.y + monster.sp * math.sin(vangulo) * dt
        elseif monster.tipo == 2 then -- AREA MAGO
            if monster.contatiro >= 3 then
                repeat 
                    monster.x = love.math.random(px - 230 ,px + 230)
                until monster.x > px + 175 or monster.x < px - 175
                repeat
                    monster.y = love.math.random(py - 230 ,py + 230)
                until monster.y > py + 175 or monster.y < py - 175
                audio:play()
                monster.contatiro = 0
                monster.movedelay = 0.75 --<- delay inicial do monstro
                monster.delay = 2
            elseif (((px-monster.origemx)^2 + (py - monster.origemy)^2)^(1/2)) > 450 then
                monster.x = monster.x + monster.sp * math.cos(vangulo) * dt
                monster.y = monster.y + monster.sp * math.sin(vangulo) * dt
                
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
            elseif  (((px-monster.x)^2 + (py - monster.y)^2)^(1/2)) < 175 then
                monster.x = monster.x + monster.sp * math.cos(vangulo) * dt*-1/1.5
                monster.y = monster.y + monster.sp * math.sin(vangulo) * dt*-1/1.5
            end
        elseif monster.tipo == 3 then
            
            if distanciaDoisPontos(monster.origemx,monster.origemy,px,py,400) then

            end
        end
    end
end

function mov_progressivo(dt, vetor,x,y)
    for i=#vetor,1, -1 do
        local objeto = vetor[i]
        local distancia = ((objeto.x - x)^2 + (objeto.y - y)^2)^(1/2)
        
        if distancia <= 200 then
            local cx = x - objeto.origemx 
            local cy = y - objeto.origemy   
            
            an = math.atan2(cy,cx)

            objeto.x = objeto.x +  objeto.sp *math.cos(an) *dt/(distancia/100)
            objeto.y = objeto.y +  objeto.sp *math.sin(an) *dt/(distancia/100)
        end
    end
end

function distanciaDoisPontos(x1,y1,x2,y2,distancia)
    if (((x1-x2)^2 + (y1 - y2)^2)^(1/2)) < distancia then
        return true
    else 
        return false
    end
end