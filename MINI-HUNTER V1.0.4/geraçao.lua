
function g_monster(dt, vetor_monster,t, window_w, window_h,round)
    local multiplicador = 1
    
    multiplicador = multiplicador + ( 1/10 * round)
    
    local monster = {}
    monster.tipo = math.random(1,3)
    if monster.tipo == 1 then
        monster.h = 40
        monster.w = 40
        monster.sp = 120 * multiplicador
        monster.hp = 100
        monster.cor = {0.2,0.8,0.2}
        monster.atq = 15
        monster.delay = 1.5
        monster.movedelay = 0.5
    elseif monster.tipo == 2 then
        monster.h = 40
        monster.w = 40
        monster.sp = 150 * multiplicador
        monster.hp = 60
        monster.cor = {61/255, 0, 153/255}
        monster.atq = 35
        monster.delay = 1.75
        monster.movedelay = 1.25
        monster.contatiro = 0
    elseif monster.tipo == 3 then
        monster.h = 40
        monster.w = 40
        monster.sp = 110 * multiplicador
        monster.hp = 120
        monster.cor = {0,0,0}
        monster.atq = 35
        monster.delay = 1
        monster.podeMover = true
        monster.ricochete = 0
        monster.direcaoX = 1
        monster.direcaoY = 1
        monster.movedelay = 3
        monster.vangulo1 = 0
        monster.pxAtual = 0
        monster.pyAtual = 0
    end
    repeat
        monster.x = love.math.random(0,1) * window_w
    until monster.x > 300  or  monster.x < window_w -300
    repeat
        monster.y = love.math.random(0,1) * window_h
    until monster.y > 300 or monster.y < window_h - 300
    
    monster.origemx = monster.x + monster.w/2
    monster.origemy = monster.y + monster.h/2
    
    table.insert(vetor_monster, monster)
  
end

function monster_death(vetor_monster, vetor_coins)
    for i=#vetor_monster,1, -1 do 
        local monster = vetor_monster[i]
        if monster.hp <= 0 then
            table.remove(vetor_monster,i)
            local droop = math.floor(love.math.random(1,10))
            
            if droop >= 2 and droop <= 4 then
                moedas = 1
            elseif droop >= 1 and droop <= 1.5 then
                moedas = 3
            else 
                moedas = 0 
            end
            
            while moedas > 0 do
                local coin = {}
                coin.w = 10
                coin.h = 10
                coin.sp = 150
                coin.x = love.math.random(monster.x, monster.x + 20) 
                coin.y = love.math.random(monster.y, monster.y + 20)
                coin.origemx = coin.x + coin.w/2
                coin.origemy = coin.y + coin.h/2
                table.insert(vetor_coins,coin)
                
                moedas = moedas - 1
            end
        end
    end
end

function draw_coins(vetor_coins)
    for i=#vetor_coins, 1, -1 do 
        local coin = coins[i]
        love.graphics.setColor(0.8,0.8,0)
        love.graphics.circle("fill",coin.x,coin.y,coin.w/2)
    end
end

function draw_monster(vetor_monster,testmode)
    for i=1 , #vetor_monster, 1 do
        local monster = vetor_monster[i]
      
        love.graphics.setColor(monster.cor[1],monster.cor[2],monster.cor[3])
        
        love.graphics.rectangle("fill", monster.x, monster.y,monster.w, monster.h)
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", monster.x - 7, monster.y - 15, 35 * (monster.hp/100), 5)
        if testmode then
            love.graphics.line(player.origemx,player.origemy,monster.origemx,monster.origemy)
            love.graphics.print(monster.movedelay.." ".. tostring(monster.podeMover),800,0)
        end
    end    
end


function g_tiros(vetor_tiros,vetorArma, mx, my)    
    local arma = vetorArma
    local tiro = {}
    tiro.x = arma.x + 5
    tiro.y = arma.y + 5
    tiro.px = arma.x + 5
    tiro.py = arma.y + 5
    tiro.w = 10
    tiro.h = 10
    tiro.sp = love.math.random(300,450)
    tiro.tx = love.math.random(-arma.precisao,arma.precisao)
    tiro.ty = love.math.random(-arma.precisao,arma.precisao)
    tiro.mx = mx + tiro.tx
    tiro.my = my + tiro.ty
    tiro.dano = arma.dano
    
    table.insert(vetor_tiros,tiro)
end

function posicaoArma(mousex,mousey,px,py)
    xa = mousex - px 
    ya = mousey - py

    angulo = math.atan2(ya,xa)
    propxa = math.cos(angulo)
    propya = math.sin(angulo)

    armay = propya *25 + py - 5
    armax = propxa * 25 + px - 5
    return armay,armax
end



function gmonster_bullets(vetor_mbullets, mx, my, px, py)
    local mbullet = {}
    mbullet.w = 25
    mbullet.h = 25
    mbullet.x = mx  
    mbullet.y = my
    mbullet.mx = mx
    mbullet.my = my
    mbullet.dano = 10  
    mbullet.sp = love.math.random(120,160)
    mbullet.xr = px
    mbullet.yr = py
    mbullet.precisionx = math.random(-60,60)
    mbullet.precisiony = math.random(-60,60)
    table.insert(vetor_mbullets, mbullet)

end

function monster_bulletd(dt, monster_bullets)
    for i=#monster_bullets, 1, -1 do 
        local mbullet = monster_bullets[i] 
        xm = mbullet.xr - mbullet.mx + mbullet.precisionx
        ym = mbullet.yr - mbullet.my + mbullet.precisiony

        angm = math.atan2(ym,xm)
        propxm = math.cos(angm)
        propym = math.sin(angm)
        
        mbullet.x = mbullet.x + propxm * dt * mbullet.sp
        mbullet.y = mbullet.y + propym * dt * mbullet.sp
    end
end

function mbullet_draw(mbvetor)
    for i=#mbvetor,1, -1 do
        local mbullet = mbvetor[i]
        love.graphics.circle("fill", mbullet.x, mbullet.y,mbullet.w/2)
    end
end

function tiroMago(vetorMonstro,vetorMonstroB)
    for i=#vetorMonstro , 1, -1 do 
        local monster = vetorMonstro [i]
        if monster.tipo == 2 then
            if monster.delay <= 0  then 
                local distancia = ((monster.x - player.origemx)^2 + (monster.y - player.origemy)^2)^(1/2)
               
                if distancia <= 600 and distancia >= 175 then
                    gmonster_bullets(m_bullets,  monster.x, monster.y, player.origemx, player.origemy)
                    monster.contatiro = monster.contatiro + 1
                    monster.delay = 0.3
                end
            end
        end
    end
    for i=#vetorMonstroB, 1, -1 do
        local monsterBullet = vetorMonstroB[i]
       
        if AABB(player.x, monsterBullet.x, player.y, monsterBullet.y, player.w, monsterBullet.w, monsterBullet.h, monsterBullet.h) and player.cdAtual < 0 and player.invencibilidade == false then
            player.hpAtual = player.hpAtual - monsterBullet.dano
            player.cdAtual = player.cd
        end    
       
        if AABB(player.x, monsterBullet.x, player.y, monsterBullet.y, player.w, monsterBullet.w, monsterBullet.h, monsterBullet.h) then
            table.remove(m_bullets, i) 
        end

        if dentroDaTela(window_w,window_h,monsterBullet.x,monsterBullet.y,monsterBullet.w,monsterBullet.h) == false then
            table.remove(m_bullets, i)
        end
      
    end

end

function ataqueCorpo(vetorMonstro,vetorPlayer)
    local player = vetorPlayer
    for i=#vetorMonstro, 1, -1 do 
        local monster = vetorMonstro[i]

        if AABB(player.x, monster.x, player.y, monster.y, player.w, monster.w, player.h, monster.h) and player.cdAtual < 0 and player.invencibilidade == false then
            player.hpAtual = player.hpAtual - monster.atq
            player.cdAtual = player.cd
            
        end     
        
    end    
end

function coletarMoedas(vetorMoedas,px,py,dinheiroAtual,audio)
    for i=#vetorMoedas, 1, -1 do
        local coin = vetorMoedas[i]

        coin.origemx = coin.x + coin.w/2
        coin.origemy = coin.y + coin.h/2
        
        if AABB(player.x, coin.x, player.y, coin.y, player.w, coin.w, player.h, coin.h) then
            table.remove(coins, i)
            audio:play()
            dinheiroAtual = dinheiroAtual + 1
        end
    end
    return dinheiroAtual
end