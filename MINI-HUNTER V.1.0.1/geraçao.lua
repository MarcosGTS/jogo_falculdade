
function g_monster(dt, limite, vetor_monster,t, window_w, window_h)
    local multiplicador = 1
    if t < 60 then
        dificuldade = 125
    elseif t > 60 and t < 90 then
        dificuldade = 75
    elseif t > 90 then
        dificuldade = 25
    end
    
    multiplicador = multiplicador + math.floor(t  * 0.025)

    if #vetor_monster < limite then
        if love.math.random(0,dificuldade) < 1 then
            local monster = {}
            monster.tipo = love.math.random(1,2.001)
            if monster.tipo < 2 then
                monster.h = 40
                monster.w = 40
                monster.sp = 140 * multiplicador/2.5
                monster.hp = 100
                monster.atq = 15
                monster.delay = 1.5
                monster.movedelay = 0.5
            elseif monster.tipo >= 2 then
                monster.h = 40
                monster.w = 40
                monster.sp = 180 * multiplicador/2.5
                monster.hp = 50
                monster.atq = 35
                monster.delay = 1.75
                monster.movedelay = 1.25
                monster.contatiro = 0
            end
            repeat
                monster.x = love.math.random(-75, window_w + 75)
            until monster.x < -monster.w  or  monster.x > window_w
            repeat
                monster.y = love.math.random(-75, window_h + 75)
            until monster.y < -monster.h or monster.y > window_h
            
            monster.origemx = monster.x + monster.w/2
            monster.origemy = monster.y + monster.h/2
            
            table.insert(vetor_monster, monster)    
        end
    end
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
                
                table.insert(vetor_coins,coin)
                
                moedas = moedas - 1
            end
        end
    end
end

function draw_coins(vetor_coins)
    for i=#vetor_coins, 1, -1 do 
        local coin = coins[i]
        love.graphics.rectangle("fill",coin.x, coin.y, coin.w, coin.h)
    end
end

function draw_monster(vetor_monster)
    for i=1 , #vetor_monster, 1 do
        local monster = vetor_monster[i]
        if monster.tipo < 2 then
            love.graphics.setColor(0.2,0.8,0.2)
        else
            love.graphics.setColor(0,0, 205)
        end
        love.graphics.rectangle("fill", monster.x, monster.y,monster.w, monster.h)
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", monster.x - 7, monster.y - 15, 35 * (monster.hp/100), 5)
    end    
end


function g_tiros(vetor_tiros, px, py, mx, my)    
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
    tiro.dano = 25
    table.insert(vetor_tiros,tiro)
end



function direcao_tiros(dt,vetor_tiros)
    for i=#vetor_tiros, 1, -1 do 
        local tiro = vetor_tiros[i]
      
        x = tiro.mx - tiro.px
        y = tiro.my - tiro.py
        
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
        love.graphics.rectangle("fill", tiro.x, tiro.y, tiro.w, tiro.h)
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
    mbullet.w = 35
    mbullet.h = 35
    mbullet.x = mx  
    mbullet.y = my
    mbullet.mx = mx
    mbullet.my = my
    mbullet.dano = 10  
    mbullet.sp = 260
    mbullet.xr = px
    mbullet.yr = py
    table.insert(vetor_mbullets, mbullet)

end

function monster_bulletd(dt, monster_bullets)
    for i=#monster_bullets, 1, -1 do 
        local mbullet = monster_bullets[i] 
        xm = mbullet.xr - mbullet.mx
        ym = mbullet.yr - mbullet.my

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
        love.graphics.rectangle("fill", mbullet.x, mbullet.y, mbullet.w, mbullet.h)
    end
end

