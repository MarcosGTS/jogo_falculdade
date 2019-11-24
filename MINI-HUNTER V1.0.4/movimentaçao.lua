
require("geraçao")

function monster_move(dt, monster_vetor,window_w,window_h,audio)
   
    for i=#monster_vetor, 1, -1 do
        local monster = monster_vetor[i]
        
        monster.origemx = monster.x + monster.w/2
        monster.origemy = monster.y + monster.h/2
        
        vrx = player.origemx - monster.origemx
        vry = player.origemy - monster.origemy 

        vangulo = math.atan2(vry,vrx)
        
        if monster.tipo == 1 then
            monster.x = monster.x + monster.sp * math.cos(vangulo) * dt
            monster.y = monster.y + monster.sp * math.sin(vangulo) * dt
        elseif monster.tipo == 2 then -- AREA MAGO
            
            monster.delay = monster.delay - dt*1
            
            if monster.contatiro >= 3 then
                repeat 
                    monster.x = love.math.random(player.origemx - 230 ,player.origemx + 230)
                until monster.x > player.origemx + 175 or monster.x < player.origemx - 175
                repeat
                    monster.y = love.math.random(player.origemy - 230 ,player.origemy + 230)
                until monster.y > player.y + 175 or monster.y < player.y - 175
                audio:play()
                monster.contatiro = 0
                monster.movedelay = 0.75 --<- delay inicial do monstro
                monster.delay = 2
            elseif (((player.origemx - monster.origemx)^2 + (player.origemy - monster.origemy)^2)^(1/2)) > 450 then
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
            elseif  (((player.origemx-monster.origemx)^2 + (player.origemy - monster.origemy)^2)^(1/2)) <= 175 then
                monster.x = monster.x + monster.sp * math.cos(vangulo) * dt*-1/1.5
                monster.y = monster.y + monster.sp * math.sin(vangulo) * dt*-1/1.5
            end
        elseif monster.tipo == 3 then
            
            monster.colisao = AABB(monster.x,player.x,monster.y,player.y,monster.w,player.w,monster.h,player.h)
            
            if distanciaDoisPontos(monster.origemx,monster.origemy,player.origemx,player.origemy,300) and monster.podeMover == true and dentroDaTela(window_w,window_h,monster.x,monster.y,monster.w,monster.h)then
                monster.pxAtual = player.origemx
                monster.pyAtual = player.origemy 
                
                monster.podeMover = false 
                monster.movedelay = 3

                monster.vangulo1 = math.atan2(monster.pyAtual - monster.origemy,monster.pxAtual - monster.origemx)
                
            elseif monster.podeMover == true then
                monster.x = monster.x + monster.sp * math.cos(vangulo) * dt
                monster.y = monster.y + monster.sp * math.sin(vangulo) * dt 
            end

            if monster.podeMover == false then
                
                monster.delay = monster.delay - dt*1
                
                if monster.delay <= 0 then
                    
                    if monster.ricochete > 2 then
                        monster.movedelay = monster.movedelay - dt*1    
                    end
                    
                    if monster.x >= window_w - monster.w or monster.x <= 0 or collisionX(monster.colisao,monster.x,player.x) then
                        monster.direcaoX = monster.direcaoX * -1 
                        monster.ricochete = monster.ricochete + 1
                    end
                    
                    if monster.y >= window_h - monster.h or monster.y <= 0 or collisionY(monster.colisao,monster.y,player.y) then
                        monster.direcaoY = monster.direcaoY * -1
                        monster.ricochete = monster.ricochete + 1
                    end
                    
                    if monster.movedelay <= 0 then
                        monster.delay = 1.75
                        monster.podeMover = true
                        monster.direcaoX = 1
                        monster.direcaoY = 1
                        monster.ricochete = 0
                    end
                    
                    monster.x = monster.x + monster.sp* math.cos(monster.vangulo1) * dt * monster.direcaoX *monster.movedelay^2
                    monster.y = monster.y + monster.sp* math.sin(monster.vangulo1) * dt * monster.direcaoY *monster.movedelay^2

                end

            end
            
        end
    end
end

function mov_progressivo(dt, vetor,x,y, area)
    for i=#vetor,1, -1 do
        local objeto = vetor[i]
        local distancia = ((objeto.x - x)^2 + (objeto.y - y)^2)^(1/2)
        
        if distancia <= area then
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

function dentroDaTela(window_w,window_h,x,y,w,h)
    if x > 0 and x + w < window_w and y > 0 and y + h < window_h then
        return true
    else
        return false
    end
end

function AABB(x1 ,x2, y1, y2, w1, w2, h1, h2)
    return  (x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1)
end

function collisionX(AABB,x1,x2)
    if AABB and (x1 < x2  or x2 < x1)then
        return true
    end
end

function collisionY(AABB,y1,y2)
    if AABB and (y1 < y2  or y2 < y1) then
        return true
    end
end