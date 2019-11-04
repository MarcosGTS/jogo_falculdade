require("colision") -- para utilizar funçoes feitas em outro arquivo
require("movimentaçao")
require("geraçao")

function love.load()
love.math.setRandomSeed(os.time())
-- Pontuçao do jogador

dinheiro = 0
-- Temporizador
t = 0
-- Caracteristicas do jogardor 
player = {} 
player.x = 320
player.y = 160
player.w = 5
player.h = 10 
player.vel = 100
player.d = 1
player.hp = 100
player.cd = 0.5

monsters = {}

tiros = {}

coins = {}

delay_player = player.cd

delay_tiro = 0.25
delay_tiro_aux = delay_tiro

delay_carga = 0

carga_total = 8
carga_atual = 8
end

function love.update(dt)
    t = (t + dt*1 )
    delay_tiro = (delay_tiro - dt*1)
    delay_player = (delay_player - dt*1)       
    delay_carga = delay_carga -(dt * 1)
    
    movimento_player(dt, player.vel)
    direcao_player(player)

    g_monster(dt, 10, monsters)

    direcao_tiros(dt, tiros)
    bullet_death(tiros)

    if love.keyboard.isDown("r") and carga_atual < 6 and pode_recarregar then
        delay_carga = 1.75  
        pode_recarregar = false  
    end 
    if delay_carga < 0 then
        pode_recarregar = true
    end
    if delay_carga > 0 and delay_carga < 0.1 then
        carga_atual = carga_total 
    end

    if delay_tiro < 0 and love.keyboard.isDown("q") and carga_atual > 0 and delay_carga < 0 then
        g_tiros(dt, tiros, player.x, player.y, player.d)
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
    
    monster_death(monsters, coins)
    monster_move(dt, player.x, player.y, monsters)
    for i=#monsters, 1, -1 do 
        local monster = monsters[i]
        if AABB(player.x, monster.x, player.y, monster.y, player.w, monster.w, player.h, monster.h) and delay_player < 0 then
            player.hp = player.hp - monster.atq
            delay_player = player.cd
        end
    end

    for i=#coins, 1, -1 do
        local coin = coins[i]
        if AABB(player.x, coin.x, player.y, coin.y, player.w, coin.w, player.h, coin.h) then
            table.remove(coins, i)
            dinheiro = dinheiro + 1
        end
    end
end

function love.draw()
    love.graphics.setBackgroundColor(0,0,0)
    
    love.graphics.setColor(0.8 , 0.8, 0) 
    draw_coins(coins)  
    
    love.graphics.setColor(0.8, 0.8, 0.8) 
    bullet_draw(tiros)
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", player.x, player.y, player.w, player.h)
    
    draw_monster(monsters)
    
    love.graphics.setColor(0.86, 0.08, 0.23)
    love.graphics.print("COINS : ".. dinheiro , 5, 20, 0)
    love.graphics.print("TIMER : ".. math.floor(t), 5, 35, 0)
    love.graphics.print("MUNICAO :".. carga_atual, 540, 0)
    love.graphics.rectangle("fill", 5, 5, 150 *(player.hp/100),10 )
    if delay_carga <= 2.5 and delay_carga >= 0 then
        love.graphics.rectangle("fill", player.x - 5, player.y - 15, 35*(delay_carga/2.5), 5)
    end

end