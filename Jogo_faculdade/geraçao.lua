
function g_monster(dt, limite, vetor_monster)
    if #vetor_monster < limite then
        if love.math.random(0,100) < 1 then
            local monster = {}
            monster.h = 20
            monster.w = 20
            monster.sp = 30
            monster.hp = 100
            monster.atq = 10
            monster.tipo = math.floor(love.math.random(1,2.99))
            repeat
                monster.x = love.math.random(-40, 680)
            until monster.x < 0 or  monster.x > 640
            repeat
                monster.y = love.math.random(-40, 360)
            until monster.y < 0 or monster.y > 320
            table.insert(vetor_monster, monster)    
        end
    end
end

function monster_death(vetor_monster, vetor_coins)
    for i=#vetor_monster,1, -1 do 
        local monster = vetor_monster[i]
        if monster.hp <= 0 then
            table.remove(vetor_monster,i)
            local droop = love.math.random(1,10)
            if droop >= 2 and droop <= 4 then
                moedas = 1
            elseif droop >= 1 and droop <= 1.5 then
                moedas = 3
            else 
                moedas = 0 
            end
            while moedas > 0 do
                local coin = {}
                coin.w = 5
                coin.h = 5
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
        love.graphics.setColor(0.2,0.8,0.2)
        love.graphics.rectangle("fill", monster.x, monster.y,monster.w, monster.h)
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", monster.x - 7, monster.y - 15, 35 * (monster.hp/100), 5)
    end    
end


function g_tiros(dt, vetor_tiros, px, py, pd)    
    local tiro = {}
    tiro.x = px
    tiro.y = py
    tiro.w = 10
    tiro.h = 10
    tiro.sp = 250
    tiro.d = pd
    tiro.dano = 25
    table.insert(vetor_tiros,tiro)
end

function direcao_tiros(dt, vetor_tiros)
    for i = #vetor_tiros, 1, -1 do
        local tiro = vetor_tiros[i]
        if tiro.d == 1 then
            tiro.x = tiro.x + tiro.sp * dt
        elseif tiro.d == -1 then
            tiro.x = tiro.x - tiro.sp * dt
        end
        if tiro.d == 2 then
            tiro.y = tiro.y - tiro.sp * dt
        elseif tiro.d == -2 then
            tiro.y = tiro.y + tiro.sp * dt
        end
    end
end
    
function bullet_draw(vetor_tiros)
    for i=#vetor_tiros,1,-1 do
        local tiro = vetor_tiros[i] 
        love.graphics.rectangle("fill", tiro.x, tiro.y, tiro.w, tiro.h)
    end
end

function bullet_death (vetor_tiros, contato)
    for i= #vetor_tiros, 1, -1 do
        local tiro = vetor_tiros[i]
        if tiro.x > 640 or tiro.x < 0 then
            table.remove(vetor_tiros,i)
        elseif tiro.y < 0 or tiro.y > 320 then
            table.remove(vetor_tiros,i)
        end
    end
end

function gmonster_bullets(vetor_mbullets, mx, my, md)
    local mbullet = {}
    mbullet.w = 50
    mbullet.h = 50
    mbullet.x = mx  
    mbullet.y = my
    mbullet.dano = 10  
    mbullet.sp = 120
    mbullet.d = md
    table.insert(vetor_mbullets, mbullet)
end

function monster_bulletd(dt, monster_bullets)
    for i=#monster_bullets, 1, -1 do 
        local mbullet = monster_bullets[i]
        if mbullet.d == 1 then
            mbullet.x = mbullet.x + mbullet.sp * dt
        elseif mbullet.d == -1 then
            mbullet.x = mbullet.x - mbullet.sp * dt
        end
        if mbullet.d == 2 then
            mbullet.y = mbullet.y - mbullet.sp * dt
        elseif mbullet.d == -2 then
            mbullet.y = mbullet.y + mbullet.sp * dt
        end
    end
end