require("colision") -- para utilizar funçoes feitas em outro arquivo
require("movimentaçao")
require("geraçao")
require("vendedor")
require("powerups")

function love.load()
love.math.setRandomSeed(os.time())

-- Temporizador
t = 0
-- Caracteristicas do jogardor 

window_w = 1280
window_h = 640
-- Pontuçao do jogador

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
player.origemy = 0
player.origemx = 0
player.item = 0 

monsters = {}
vendedores = {}

loja = {}
loja.botas = 10
loja.podeComprarB = true
loja.tambor = 10
loja.podeComprarT = true
loja.balasA = 10
loja.podeComprarBa = true

m_bullets = {}
tiros = {}
coins = {}

mousex,mousey = 0, 0

delay_player = player.cd

delay_tiro = 0.10
delay_tiro_aux = delay_tiro

delay_carga = 0

carga_total = 1000
carga_atual = carga_total 

--MENUS--
menu = 0

limite = 10
rounds = 0
podeSummonar = false

arma = {}
arma.x = window_w/2
arma.y = window_h/2
arma.w = 10
arma.h = 10
arma.dano = 25
--FONTES--
fontes = {}
fontes.menu = love.graphics.newFont("assets/fonts/menuFont.TTF",20)
fontes.teste = love.graphics.newFont("assets/fonts/teste.TTF")

--AUDIO--
audio = {}
audio.coin = love.audio.newSource("assets/sonsJogo/coin.WAV","static")
audio.hit = love.audio.newSource("assets/sonsJogo/hit.WAV","static")
audio.tiro = love.audio.newSource("assets/sonsJogo/tiro.WAV","static")
audio.teleport = love.audio.newSource("assets/sonsJogo/teleport.WAV","static")

testmodeflag = false
end

function love.update(dt)
    mousex,mousey = love.mouse.getPosition()
    
    if menu == 1 then -- EM PARTIDA 
        if love.keyboard.isDown("t") and testmodeflag == false then
            testmodeflag = true
        elseif love.keyboard.isDown("t") and testmodeflag == true then
            testmodeflag = false
        end
        --AREA CONTADORES GLOBAIS--
        --[[
        if podeSummonar then
            t = (t + dt*1 )
        end
        ]]
        delay_tiro = (delay_tiro - dt*1)
        
        delay_player = (delay_player - dt*1)       
        
        delay_carga = delay_carga -(dt * 1)


        --AREA PLAYER--
        movimento_player(dt, player.vel, window_w, window_h)
        direcao_player(player)
        
        player.origemx = player.x + player.w/2
        player.origemy = player.y + player.h/2

        --POWERUPS--

        powerups(player.item)

        --AREA ARMAS--
        
        direcao_tiros(dt,tiros)
        
        if love.keyboard.isDown("r") and carga_atual < carga_total and pode_recarregar then
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

        if delay_tiro < 0 and love.mouse.isDown(1) and carga_atual > 0 and delay_carga < 0 and distanciaDoisPontos(player.origemx,player.origemy,mousex,mousey,50)==false then
            g_tiros(tiros, arma.x + 5, arma.y + 5, mousex, mousey,arma.dano)
            carga_atual = carga_atual - 1
            delay_tiro = delay_tiro_aux
            audio.tiro:play()
        end
        
        for i=#tiros, 1, -1 do 
            local tiro = tiros[i]
            for j=#monsters ,1 , -1 do 
                local monster = monsters[j]
                if AABB(tiro.x, monster.x, tiro.y, monster.y, tiro.w, monster.w, tiro.h, monster.h) then
                    monster.hp = monster.hp - tiro.dano
                    table.remove(tiros,i) 
                    audio.hit:play()
                end
            end
        end
        
        bullet_death(tiros,window_w, window_h)

        arma.y,arma.x = posicaoArma(mousex,mousey,player.origemx,player.origemy)

        --AREA VENDEDOR--(EM TESTE)
            
        if love.keyboard.isDown("b") and #vendedores == 1 then
            menu = lojamenu(vendedores,player.origemx,player.origemy,menu)
        end
        
        -- ROUNDS --
        if limite == 0 then
            podeSummonar = false
        end

        if podeSummonar == false and #monsters == 0 then
            
            if limite == 0 then
                limite = (rounds + 1) * 5 
            end
            
            if love.keyboard.isDown("space") and distanciaDoisPontos(player.x,player.y,window_w/2,window_h/2,100) then
                podeSummonar = true
                rounds = rounds + 1
            end
            vendedor(t,podeSummonar,vendedores, rounds,window_w,window_h)
            
        end
        
        if podeSummonar then

            if limite > 0 and love.math.random(0,100) < 1 then
                g_monster(dt, monsters,t, window_w, window_h,rounds) 
                limite = limite - 1 
            end
        
        end
        
        --AREA MONSTROS--
        
        monster_move(dt, player.origemx, player.origemy, monsters,window_w,window_h,audio.teleport)
        
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
            
            
            if monster.tipo >= 2 then
                if monster.delay <= 0 and monster.origemx > 0 and monster.origemx < window_w and monster.origemy > 0 and monster.origemy < window_h then 
                    local distancia = ((monster.x - player.origemx)^2 + (monster.y - player.origemy)^2)^(1/2)
                   
                    if distancia <= 600 and distancia >= 175 then
                        gmonster_bullets(m_bullets,  monster.x, monster.y, player.origemx, player.origemy)
                        monster.contatiro = monster.contatiro + 1
                        monster.delay = 0.75
                    end
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

            coin.origemx = coin.x + coin.w/2
            coin.origemy = coin.y + coin.h/2
            
            if AABB(player.x, coin.x, player.y, coin.y, player.w, coin.w, player.h, coin.h) then
                table.remove(coins, i)
                audio.coin:play()
                dinheiro = dinheiro + 1
            end
        end

        if player.hp <= 0 then
            menu = 0
        end

    elseif menu == 2 then -- LOJA --
        if  player.item % 10 < 1 and dinheiro >= loja.botas and mousex > window_w/5 - 150 and mousex < window_w/5 -50 and mousey > window_h/4 - 20 and mousey < window_h/4 + 30 and love.mouse.isDown("1") then
            player.item = player.item + 1
            dinheiro = dinheiro - loja.botas 
        end
        if  math.floor(player.item/10) % 10 < 1 and dinheiro >= loja.botas and mousex > window_w/5 - 150 and mousex < window_w/5 -50 and mousey > window_h *2/4 - 20 and mousey < window_h * 2/4 + 30 and love.mouse.isDown("1") then
            player.item = player.item + 10
            dinheiro = dinheiro - loja.tambor 
        end
        if  math.floor(player.item/100) % 10 < 1 and dinheiro >= loja.botas and mousex > window_w/5 - 150 and mousex < window_w/5 -50 and mousey > window_h * 3/4 - 20 and mousey < window_h * 3/4 + 30 and love.mouse.isDown("1") then
            player.item = player.item + 100
            dinheiro = dinheiro - loja.balasA
        end

        if mousex > window_w - 125 and mousex < window_w - 25 and mousey > window_h - 75 and mousey < window_h - 25 and love.mouse.isDown("1") then
            menu = 1
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
        player.item = 0
        
        monsters = {}
        vendedores = {}
        
        m_bullets = {}
        tiros = {}
        coins = {}

        delay_carga = 0

        carga_atual = 8

        podeSummonar = false
        limite = 10
        rounds = 0
        
        if mousex > window_w/2 - 100 and mousex < window_w/2 + 100 and mousey > window_h/2 and mousey < window_h/2 + 50 and love.mouse.isDown(1) then
            menu = 1
        end
    end
    
end

function love.draw()
    if menu == 1 then -- EM PARTIDA
        love.graphics.setFont(fontes.teste)

        love.graphics.setBackgroundColor(0,0.6,0.2)
        love.keyboard.isDown("b")
        -- ROUNDS--
        
        love.graphics.print("ROUND: ".. rounds, 0,200)
        if podeSummonar == false and #monsters == 0 then
            love.graphics.setColor(1,1,1)
            love.graphics.circle("line",window_w/2,window_h/2,100)
        end
        
        if distanciaDoisPontos(player.x,player.y,window_w/2,window_h/2,100) and podeSummonar == false and #monsters == 0 then
            love.graphics.setColor(1,1,1)
            love.graphics.print("   APERTE ESPAÇO\nSE ESTIVER PRONTO",window_w/2-60,window_h/2-50)
        end
        
        love.graphics.setColor(0.8 , 0.8, 0) 
        draw_coins(coins)  
        
        love.graphics.setColor(0.8, 0.8, 0.8) 
        bullet_draw(tiros)
        
        draw_vendedor(vendedores,player.x, player.y)
        draw_monster(monsters,testmodeflag)
        
        love.graphics.setColor(0.86, 0.08, 0.23)
        love.graphics.print("COINS  ".. dinheiro , 10,40 )
        love.graphics.print("TIMER  ".. math.floor(t), 10, 55, 0)
        love.graphics.print("MUNICAO ".. carga_atual, window_w - 100, 0)
        
        if player.hp > 0 then
            love.graphics.rectangle("fill", 10, 10, 300 *(player.hp/100),25 )
        end
        
        if delay_carga <= 2.5 and delay_carga >= 0 then
            love.graphics.rectangle("fill", player.x - 5, player.y - 15, 35*(delay_carga/2.5), 5)
        end
        
        mbullet_draw(m_bullets)
        
        love.graphics.print(limite, 0, 220)
       
        --PLAYER--
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", player.x, player.y, player.w, player.h)
        love.graphics.rectangle("fill",arma.x,arma.y,arma.h,arma.w)
        
    elseif menu == 2 then
        --LOJA--
        
        love.graphics.setFont(fontes.teste)
        love.graphics.setBackgroundColor(0,0.5,0.5)
        love.graphics.setColor(1,1,1)
        love.graphics.print("LOJA",window_w/2 - 50,0)
        love.graphics.print("DINHEIRO R$ "..dinheiro,0,50)
        
        -- lista de itens
        
        love.graphics.print("botas leves R$ " .. loja.botas, window_w *1/5,window_h* 1/4)
        love.graphics.print("tambor extra grande R$ " .. loja.tambor, window_w *1/5, window_h * 2/4)
        love.graphics.print("balas abençoadas R$ " .. loja.balasA, window_w *1/5, window_h * 3/4)
        
        -- botoes 
        
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
        if mousex > window_w - 125 and mousex < window_w - 25 and mousey > window_h - 75 and mousey < window_h - 25 then
            love.graphics.rectangle("fill",window_w- 125, window_h - 75,100,50)
        else
            love.graphics.rectangle("line",window_w- 125, window_h - 75,100,50)
        end
     
        love.graphics.setColor(0,0,0.8)
        love.graphics.print("COMPRAR",window_w *1/5 - 130,window_h* 1/4  )
        love.graphics.print("COMPRAR",window_w *1/5 - 130,window_h* 2/4  )
        love.graphics.print("COMPRAR",window_w *1/5 - 130,window_h* 3/4  )
        love.graphics.print("SAIR", window_w - 90, window_h - 55)

    elseif menu == 0 then -- TELA INICIAL
        love.graphics.setColor(1,1,1)
        love.graphics.setFont(fontes.menu)
        love.graphics.print("MINI HUNTER",window_w/2 - 225,0,r,4,4)
        if mousex > window_w/2 - 100 and mousex < window_w/2 + 100 and mousey > window_h/2 and mousey < window_h/2 + 50 then
            love.graphics.setColor(1,0,0)
            love.graphics.rectangle("fill",window_w/2 - 100,window_h/2,200,50)
        else
            love.graphics.setColor(1,1,1)
            love.graphics.rectangle("line",window_w/2 - 100,window_h/2,200,50)
        end
        love.graphics.setColor(1,1,1)
        love.graphics.print("START",window_w/2 - 20, window_h/2 + 10)
    end
    love.graphics.print(player.vel.." ".. player.item .." ".. arma.dano,0,450)
    love.graphics.print(tostring(testmodeflag),500,0)
end