
function g_monster(dt, vetor_monster,t, window_w, window_h,round)
    local multiplicador = 1
    
    multiplicador = multiplicador + ( 1/10 * round)
    
    local monster = {}
    local spawn = love.math.random(0, 100)
    
    if spawn < 50 then 
        monster.tipo = 1
    elseif spawn < 70 then
        monster.tipo = 2 
    elseif spawn < 95 then
        monster.tipo = 3
    elseif spawn <= 100 then
        monster.tipo = 4 
    end
    
    if monster.tipo == 1 then 
        monster.h = 40
        monster.w = 40
        monster.sp = 100 * multiplicador
        monster.hp = 180
        monster.cor = {0.2,0.8,0.2}
        monster.delay = 0.75
        monster.movedelay = 0
        monster.explosion = love.math.random(0, 3 + round)
    elseif monster.tipo == 2 then 
        monster.h = 40
        monster.w = 40
        monster.sp = 150 * multiplicador
        monster.hp = 60
        monster.cor = {61/255, 0, 153/255}
        monster.delay = 1.75
        monster.movedelay = 1.25
        monster.contatiro = 0
        monster.range = 430 
        monster.Rmedo = 120
        monster.medo = false
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
    elseif monster.tipo == 4 then -- balancear xama
        monster.h = 40
        monster.w = 40
        monster.sp = 240 * multiplicador
        monster.hp = 100
        monster.cor = {0,90/255,0}
        monster.delay = 1.5
        monster.summonflag = false 
        monster.minionsPVez = 4
        monster.contaMinion = 0
        monster.movedelay = 0
        repeat
            monster.xAleatorio = love.math.random(0,window_w-monster.w)
            monster.yAleatorio = love.math.random(0,window_h-monster.h)
        until  distanciaDoisPontos(monster.xAleatorio,monster.yAleatorio,player.x,player.y,400) == false
    elseif monster.tipo == 5 then
        monster.rx = 0
        monster.ry = 0
        monster.spR = love.math.random(0.125,0.150)
        monster.h = 20
        monster.w = 20
        monster.sp = 250
        monster.hp = 5
        monster.cor = {1,1,0}
        monster.delay = 1.75
        monster.movedelay = 1.25
        monster.angle = 0
        monster.rotacionR = love.math.random(20,50)
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

function monster_death(vetor_monster, vetor_coins, vetor_mBullets)
    for i=#vetor_monster,1, -1 do 
        local monster = vetor_monster[i]
        if monster.hp <= 0 then
            table.remove(vetor_monster,i)
            player.pontuacao = player.pontuacao + 1
            local droop = math.floor(love.math.random(1,10))
            if monster.tipo ~= 5 then
                if droop >= 2 and droop <= 6 then
                    moedas = 1
                elseif droop >= 1 and droop <= 1.5 then
                    moedas = 5
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
            if monster.tipo == 1 then
                for i = 1, monster.explosion do
                    gmonster_bullets(vetor_mBullets, monster.x, monster.y, love.math.random(0, 2*math.pi), monster.tipo)
                end
            end
        end
    end
end

function draw_coins(vetor_coins)
    for i=#vetor_coins, 1, -1 do 
        local coin = coins[i]
        if testmodeflag then
            love.graphics.setColor(0,0,1)
            love.graphics.rectangle("line", coin.x, coin.y, coin.w, coin.h)
        end
          love.graphics.setColor(0.8,0.8,0)
        love.graphics.circle("fill",coin.x + coin.w/2,coin.y+ coin.h/2,coin.w/2)
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
            if monster.tipo ~= 4 then
                love.graphics.line(player.origemx,player.origemy,monster.origemx,monster.origemy)
                love.graphics.print(monster.movedelay.." ".. tostring(monster.podeMover),800,0)
            else
                love.graphics.line(monster.x,monster.y,monster.xAleatorio,monster.yAleatorio)
            end
        end
    end
   
end



function gmonster_bullets(vetor_mbullets, mx, my, mA, mt)
    local mbullet = {}
    mbullet.w = 25
    mbullet.h = 25
    mbullet.x = mx - mbullet.w/2 
    mbullet.y = my - mbullet.h/2
    mbullet.angle = mA
    
    
    mbullet.dano = 10  
    mbullet.sp = 160--love.math.random(120,160)


    table.insert(vetor_mbullets, mbullet)

end

function monster_bulletd(dt, monster_bullets)
    for i=#monster_bullets, 1, -1 do 
        local mbullet = monster_bullets[i] 
        mbullet.x = mbullet.x + math.cos(mbullet.angle) * dt * mbullet.sp
        mbullet.y = mbullet.y + math.sin(mbullet.angle) * dt * mbullet.sp
    end
end

function mbullet_draw(mbvetor)
    for i=#mbvetor,1, -1 do
        local mbullet = mbvetor[i]
        if testmodeflag then
            love.graphics.setColor(0,0,1)
            love.graphics.rectangle("line", mbullet.x, mbullet.y, mbullet.w, mbullet.h)
        end
        love.graphics.setColor(1,0,0)
        love.graphics.circle("fill", mbullet.x+ mbullet.w/2, mbullet.y+mbullet.h/2,mbullet.w/2)
    end
end

function MonsterShoot(vetorMonstro,vetorMonstroB)
    for i=#vetorMonstro , 1, -1 do 
        local monster = vetorMonstro [i]
        if monster.tipo == 2 then
            if distanciaDoisPontos(monster.x, monster.y, player.x, player.y, 450) and monster.delay < 0 and monster.medo == false then
                local angleI = math.atan2(player.origemy - monster.origemy, player.origemx - monster.origemx) - math.pi/4
                for i = 0, 10 do 
                    local ang = angleI + i * (math.pi/20)
                    gmonster_bullets(m_bullets, monster.origemx, monster.origemy, ang, monster.tipo)
                    audio.Monstertiro:stop()
                    audio.Monstertiro:play()
                end
                monster.delay = 2.75
            end
        elseif monster.tipo == 1 then
            if distanciaDoisPontos(monster.x, monster.y, player.x, player.y, 120) and monster.delay < 0  then
                local angleI = math.atan2(player.origemy - monster.origemy, player.origemx - monster.origemx)
                gmonster_bullets(m_bullets, monster.origemx, monster.origemy, angleI, monster.tipo)
                audio.Monstertiro:stop()
                audio.Monstertiro:play()
                monster.delay = 1
            end  
        end
    end
    for i=#vetorMonstroB, 1, -1 do
        local monsterBullet = vetorMonstroB[i]
       
        if AABB(player.x, monsterBullet.x, player.y, monsterBullet.y, player.w, monsterBullet.w, monsterBullet.h, monsterBullet.h) and player.cdAtual < 0 and player.invencibilidade == false then
            if podeTocar then
                audio.hitPlayer:stop()
                audio.hitPlayer:play()
                podeTocar = false
            end
            player.hpAtual = player.hpAtual - 1
            player.cdAtual = player.cd
        else
            podeTocar = true
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
            if podeTocar then
                audio.hitPlayer:stop()
                audio.hitPlayer:play()
                podeTocar = false
            end
            player.hpAtual = player.hpAtual - 1
            player.cdAtual = player.cd
            
        else
            podeTocar = true
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
            audio:stop()
            audio:play()
            dinheiroAtual = dinheiroAtual + 1
        end
    end
    return dinheiroAtual
end