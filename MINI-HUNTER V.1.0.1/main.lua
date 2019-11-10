require("colision") -- para utilizar funçoes feitas em outro arquivo
require("movimentaçao")
require("geraçao")
require("vendedor")

function love.load()
love.math.setRandomSeed(os.time())

-- Temporizador
t = 0
-- Caracteristicas do jogardor 

window_w = 1280
window_h = 640
-- Pontuçao do jogador

dinheiro = 100

player = {} 
player.x = window_w/2
player.y = window_h/2
player.w = 10
player.h = 20
player.vel = 150
player.d = 1
player.hp = 100
player.cd = 0.5
player.origemx = 0
player.origemy = 0
player.item = 0 

monsters = {}
vendedores = {}

loja = {}
loja.botas = 10
loja.tambor = 10
loja.balasA = 10

m_bullets = {}
tiros = {}
coins = {}

mousex,mousey = 0, 0

delay_player = player.cd

delay_tiro = 0.25
delay_tiro_aux = delay_tiro

delay_carga = 0

carga_total = 8
carga_atual = 8

--MENUS--
menu = 2

end

function love.update(dt)
    mousex,mousey = love.mouse.getPosition()
    if menu == 1 then
        --AREA CONTADORES GLOBAIS--
        t = (t + dt*1 )
        
        delay_tiro = (delay_tiro - dt*1)
        
        delay_player = (delay_player - dt*1)       
        
        delay_carga = delay_carga -(dt * 1)


        --AREA PLAYER--
        movimento_player(dt, player.vel, window_w, window_h)
        direcao_player(player)
        
        player.origemx = player.x + player.w/2
        player.origemy = player.y + player.h/2

        --AREA ARMAS--
        
        direcao_tiros(dt,tiros)
        
        if love.keyboard.isDown("r") and carga_atual < 8 and pode_recarregar then
            delay_carga = 1.75  
            pode_recarregar = false  
        end 
        if carga_atual == 0 and love.mouse.isDown(1) and pode_recarregar then
            delay_carga = 2.25
            pode_recarregar = false
        end
        if delay_carga < 0 then
            pode_recarregar = true
        end
        if delay_carga > 0 and delay_carga < 0.1 then
            carga_atual = carga_total 
        end 

        if delay_tiro < 0 and love.mouse.isDown(1) and carga_atual > 0 and delay_carga < 0 then
            g_tiros(tiros, player.x, player.y, mousex, mousey)
            carga_atual = carga_atual - 1
            delay_tiro = delay_tiro_aux
        end
        
        for i=#tiros, 1, -1 do 
            local tiro = tiros[i]
            for j=#monsters ,1 , -1 do 
                local monster = monsters[j]
                if AABB(tiro.x, monster.x, tiro.y, monster.y, tiro.w, monster.w, tiro.h, monster.h) then
                    monster.hp = monster.hp - tiro.dano
                    table.remove(tiros,i)
                    
                end
            end
        end
        
        bullet_death(tiros,window_w, window_h)
        
        --AREA VENDEDOR--(EM TESTE)
        
        vendedor(t,vendedores)
        if love.keyboard.isDown("b") then
            menu = lojamenu(vendedores,player.origemx,player.origemy,menu)
        end
        --

        --AREA MONSTROS--
        
        g_monster(dt, 10, monsters,t, window_w, window_h)
        
        
        monster_move(dt, player.origemx, player.origemy, monsters,window_w,window_h)
        
        
        monster_death(monsters, coins)
        
        for i=#monsters, 1, -1 do 
            local monster = monsters[i]
            
            monster.origemx = monster.x + monster.w/2
            monster.origemy = monster.y + monster.h/2

            monster.delay = monster.delay - dt*1
            monster.movedelay = monster.movedelay - dt*1

            if AABB(player.x, monster.x, player.y, monster.y, player.w, monster.w, player.h, monster.h) and delay_player < 0 then
                player.hp = player.hp - monster.atq
                delay_player = player.cd
            end     
            
            if monster.tipo >= 2 and monster.delay <= 0 and monster.origemx > 0 and monster.origemx < window_w and monster.origemy > 0 and monster.origemy < window_h then 
                local distancia = ((monster.x - player.origemx)^2 + (monster.y - player.origemy)^2)^(1/2)
                if distancia <= 600 and distancia > 300 then
                    gmonster_bullets(m_bullets,  monster.x, monster.y, player.origemx, player.origemy)
                    monster.delay = 1.75
                    monster.contatiro = monster.contatiro + 1
                end
            end
            
        end

        monster_bulletd(dt, m_bullets)

        for i=#m_bullets, 1, -1 do
            local monsterBullet = m_bullets[i]
            
            if AABB(player.x, monsterBullet.x, player.y, monsterBullet.y, player.w, monsterBullet.w, monsterBullet.h, monsterBullet.h) and delay_player < 0 then
                player.hp = player.hp - monsterBullet.dano
                delay_player = player.cd
            end    
            
            if AABB(player.x, monsterBullet.x, player.y, monsterBullet.y, player.w, monsterBullet.w, monsterBullet.h, monsterBullet.h) then
                table.remove(m_bullets, i) 
            end

            if monsterBullet.x > window_w or monsterBullet.x < -20 or monsterBullet.y > window_h or monsterBullet.y < -20 then
                table.remove(m_bullets, i)
            end
        
        end

        mov_progressivo(dt,coins,player.origemx,player.origemy)

        for i=#coins, 1, -1 do
            local coin = coins[i]
            if AABB(player.x, coin.x, player.y, coin.y, player.w, coin.w, player.h, coin.h) then
                table.remove(coins, i)
                dinheiro = dinheiro + 1
            end
        end

        if player.hp <= 0 then
            menu = 0

        end

    elseif menu == 2 then
        if  player.item % 10 < 1 and dinheiro >= loja.botas and mousex > window_w/5 - 150 and mousex < window_w/5 -50 and mousey > window_h/4 - 20 and mousey < window_h/4 + 30 and love.mouse.isDown("1") then
            player.item = player.item + 1
            dinheiro = dinheiro - loja.botas 
        end
        if  player.item % 100 < 11 and dinheiro >= loja.botas and mousex > window_w/5 - 150 and mousex < window_w/5 -50 and mousey > window_h *2/4 - 20 and mousey < window_h * 2/4 + 30 and love.mouse.isDown("1") then
            player.item = player.item + 10
            dinheiro = dinheiro - loja.tambor 
        end
        if  player.item % 1000 < 111 and dinheiro >= loja.botas and mousex > window_w/5 - 150 and mousex < window_w/5 -50 and mousey > window_h * 3/4 - 20 and mousey < window_h * 3/4 + 30 and love.mouse.isDown("1") then
            player.item = player.item + 100
            dinheiro = dinheiro - loja.balasA
        end
        if love.keyboard.isDown("escape") then
            menu = 1
        end
    elseif menu == 0 then
        
        t = 0

        dinheiro = 0

        player = {} 
        player.x = window_w/2
        player.y = window_h/2
        player.w = 10
        player.h = 20
        player.vel = 150
        player.d = 1
        player.hp = 100
        player.cd = 0.5
        
        monsters = {}
        vendedores = {}
        
        m_bullets = {}
        tiros = {}
        coins = {}

        delay_carga = 0

        carga_atual = 8
        
        if mousex > window_w/2 - 100 and mousex < window_w/2 + 100 and mousey > window_h/2 and mousey < window_h/2 + 50 and love.mouse.isDown(1) then
            menu = 1
        end
    end
    
end

function love.draw()
    if menu == 1 then
        love.graphics.setBackgroundColor(0,0,0)
        
        love.graphics.setColor(0.8 , 0.8, 0) 
        draw_coins(coins)  
        
        love.graphics.setColor(0.8, 0.8, 0.8) 
        bullet_draw(tiros)
        
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", player.x, player.y, player.w, player.h)
        
        draw_vendedor(vendedores,player.x, player.y)
        draw_monster(monsters)
        
        love.graphics.setColor(0.86, 0.08, 0.23)
        love.graphics.print("COINS : ".. dinheiro , 5, 20, 0)
        love.graphics.print("TIMER : ".. math.floor(t), 5, 35, 0)
        love.graphics.print("MUNICAO :".. carga_atual, window_w - 100, 0)
        
        if player.hp > 0 then
            love.graphics.rectangle("fill", 5, 5, 150 *(player.hp/100),10 )
        end
        
        if delay_carga <= 2.5 and delay_carga >= 0 then
            love.graphics.rectangle("fill", player.x - 5, player.y - 15, 35*(delay_carga/2.5), 5)
        end
        
        for i=#monsters, 1, -1 do
            local monster = monsters[i]
        end
        
        mbullet_draw(m_bullets)
    elseif menu == 2 then
        love.graphics.setBackgroundColor(0,0.5,0.5)
        love.graphics.setColor(1,1,1)
        love.graphics.print("LOJA",window_w/2 - 50,0,r,2,4)
        love.graphics.print("DINHEIRO: R$ "..dinheiro,0,50)
        -- lista de itens
        love.graphics.print("botas leves R$:" .. loja.botas, window_w *1/5,window_h* 1/4)
        love.graphics.print("tambor extra grande R$:" .. loja.tambor, window_w *1/5, window_h * 2/4)
        love.graphics.print("balas abençoadas R$:" .. loja.balasA, window_w *1/5, window_h * 3/4)
        
        love.graphics.setColor(1,1,1)
        if  dinheiro >= loja.botas and mousex > window_w/5 - 150 and mousex < window_w/5 -50 and mousey > window_h/4 - 20 and mousey < window_h/4 + 30 then
            love.graphics.rectangle("fill",window_w *1/5 - 150,window_h* 1/4 - 20,100,50)
        else
            love.graphics.rectangle("line",window_w *1/5 - 150,window_h* 1/4 - 20,100,50)
        end
        if  dinheiro >= loja.botas and mousex > window_w/5 - 150 and mousex < window_w/5 -50 and mousey > window_h *2/4 - 20 and mousey < window_h * 2/4 + 30 then
            love.graphics.rectangle("fill",window_w *1/5 - 150,window_h * 2/4 - 20,100,50)
        else
            love.graphics.rectangle("line",window_w *1/5 - 150,window_h * 2/4 - 20,100,50)
        end
        if  dinheiro >= loja.botas and mousex > window_w/5 - 150 and mousex < window_w/5 -50 and mousey > window_h * 3/4 - 20 and mousey < window_h * 3/4 + 30  then
            love.graphics.rectangle("fill",window_w *1/5 - 150,window_h * 3/4 - 20,100,50)
        else
            love.graphics.rectangle("line",window_w *1/5 - 150,window_h * 3/4 - 20,100,50)
        end
        
        -- botoes 
        love.graphics.setColor(0,0,0.8)
        love.graphics.print("COMPRAR",window_w *1/5 - 130,window_h* 1/4  )
        love.graphics.print("COMPRAR",window_w *1/5 - 130,window_h* 2/4  )
        love.graphics.print("COMPRAR",window_w *1/5 - 130,window_h* 3/4  )

        

    elseif menu == 0 then
        love.graphics.setColor(1,1,1)
        love.graphics.print("MINI HUNTER",window_w/2 - 200,0,r,5,15)
        if mousex > window_w/2 - 100 and mousex < window_w/2 + 100 and mousey > window_h/2 and mousey < window_h/2 + 50 then
            love.graphics.setColor(1,0,0)
            love.graphics.rectangle("fill",window_w/2 - 100,window_h/2,200,50)
        else
            love.graphics.setColor(1,1,1)
            love.graphics.rectangle("line",window_w/2 - 100,window_h/2,200,50)
        end
        love.graphics.setColor(1,1,1)
        love.graphics.print("START",window_w/2 - 20, window_h/2 + 10,r,1,2)
    end

    love.graphics.print(#monsters,0,400)
end