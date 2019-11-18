
function g_monster(dt, vetor_monster,t, window_w, window_h,round)
    local multiplicador = 1
    
    multiplicador = multiplicador + ( 1/10 * round)
    

    local monster = {}
    monster.tipo = math.floor(math.random(1,2))
    if monster.tipo == 1 then
        monster.h = 40
        monster.w = 40
        monster.sp = 80 * multiplicador
        monster.hp = 100
        monster.cor = {0.2,0.8,0.2}
        monster.atq = 15
        monster.delay = 1.5
        monster.movedelay = 0.5
    elseif monster.tipo == 2 then
        monster.h = 40
        monster.w = 40
        monster.sp = 110 * multiplicador
        monster.hp = 50
        monster.cor = {0,0, 205}
        monster.atq = 35
        monster.delay = 1.75
        monster.movedelay = 1.25
        monster.contatiro = 0
    elseif monster.tipo == 3 then
        monster.h = 40
        monster.w = 40
        monster.sp = 110 * multiplicador
        monster.hp = 50
        monster.cor = {0,0,0}
        monster.atq = 35
        monster.delay = 1.75
        monster.movedelay = 1.25
        monster.contatiro = 0
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
        end
    end    
end


function g_tiros(vetor_tiros, px, py, mx, my,dano)    
    local tiro = {}
    tiro.x = px
    tiro.y = py
    tiro.px = px
    tiro.py = py
    tiro.w = 10
    tiro.h = 10
    tiro.sp = 450
    tiro.mx = mx
    tiro.my = my
    tiro.dano = dano
    tiro.tx = math.random(-30,30)
    tiro.ty = math.random(-30,30)
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

function direcao_tiros(dt,vetor_tiros)
    for i=#vetor_tiros, 1, -1 do 
        local tiro = vetor_tiros[i]
      
        x = tiro.mx - tiro.px + tiro.tx
        y = tiro.my - tiro.py + tiro.ty
        angulo = math.atan2(y,x)
        propx = math.cos(angulo) 
        propy = math.sin(angulo)

        tiro.x = tiro.x + tiro.sp *propx * dt 
        tiro.y = tiro.y + tiro.sp *propy * dt 
       
    end
end

function bullet_draw(vetor_tiros)
    for i=#vetor_tiros,1,-1 do
        local tiro = vetor_tiros[i] 
        love.graphics.circle("fill", tiro.x, tiro.y, tiro.w/2)
    end
end

function bullet_death (vetor_tiros, window_w, window_h )
    for i= #vetor_tiros, 1, -1 do
        local tiro = vetor_tiros[i]
        if tiro.x > window_w or tiro.x < 0 then
            table.remove(vetor_tiros,i)
        elseif tiro.y < 0 or tiro.y > window_h then
            table.remove(vetor_tiros,i)
        end
    end
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
    mbullet.sp = 140
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

