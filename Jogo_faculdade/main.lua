require("colision") -- para utilizar funçoes feitas em outro arquivo
require("movimentaçao")
require("geraçao")
require("vendedor")

function love.load()
love.math.setRandomSeed(os.time())
-- Pontuçao do jogador

dinheiro = 1000
-- Temporizador
t = 0
-- Caracteristicas do jogardor 

window_w = 1280
window_h = 640


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

tiros = {}
coins = {}

mousex,mousey = 0, 0

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

    movimento_player(dt, player.vel, window_w, window_h)
    direcao_player(player)
     
    mousex,mousey = love.mouse.getPosition()
    direcao_tiros(dt,tiros)
    vendedor(t,vendedores)
    itens(vendedores)
    compras(vendedores,dinheiro,player)

    --g_monster(dt, 10, monsters,t, window_w, window_h)
 
    bullet_death(tiros,window_w, window_h)

    if love.keyboard.isDown("r") and carga_atual < 8 and pode_recarregar then
        delay_carga = 1.75  
        pode_recarregar = false  
    end 
    if delay_carga < 0 then
        pode_recarregar = true
    end
    if delay_carga > 0 and delay_carga < 0.1 then
        carga_atual = carga_total 
    end

    if delay_tiro < 0 and love.keyboard.isDown("space") and carga_atual > 0 and delay_carga < 0 then
        g_tiros(dt, tiros, player.x, player.y, mousex, mousey)
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
        
        if monster.tipo >= 2 and #monster.bullets <= 0 then 
            local distancia = ((monster.x - player.x)^2 + (monster.y - player.y)^2)^(1/2)
            if distancia <= 200 and distancia > 100 then
                gmonster_bullets(monster.bullets,  monster.x, monster.y, player.x, player.y)
            end
        end
        
        for i=#monster.bullets, 1, -1 do
            local monsterBullet = monster.bullets[i]
            
            if AABB(player.x, monsterBullet.x, player.y, monsterBullet.y, player.w, monsterBullet.w, monsterBullet.h, monsterBullet.h) and delay_player < 0 then
                player.hp = player.hp - monsterBullet.dano
                delay_player = player.cd
            end    
            
            if AABB(player.x, monsterBullet.x, player.y, monsterBullet.y, player.w, monsterBullet.w, monsterBullet.h, monsterBullet.h) then
                table.remove(monster.bullets, i) 
            end

            if monsterBullet.x > window_w or monsterBullet.x < -20 or monsterBullet.y > window_h or monsterBullet.y < -20 then
                table.remove(monster.bullets, i)
            end
        
            monster_bulletd(dt, monster.bullets, monsterBullet.xr, monsterBullet.yr)

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
    draw_vendedor(vendedores,player.x, player.y)
    draw_monster(monsters)
    
    love.graphics.setColor(0.86, 0.08, 0.23)
    love.graphics.print("COINS : ".. dinheiro , 5, 20, 0)
    love.graphics.print("TIMER : ".. math.floor(t), 5, 35, 0)
    love.graphics.print("MUNICAO :".. carga_atual, 540, 0)
    if player.hp > 0 then
        love.graphics.rectangle("fill", 5, 5, 150 *(player.hp/100),10 )
    end
    if delay_carga <= 2.5 and delay_carga >= 0 then
        love.graphics.rectangle("fill", player.x - 5, player.y - 15, 35*(delay_carga/2.5), 5)
    end
    for i=#monsters, 1, -1 do
        local monster = monsters[i]
        mbullet_draw(monster.bullets)
    end
    love.graphics.print(#vendedores, 300,0)
    for i= #vendedores, 1, -1 do
        local vendedor = vendedores[i]
        love.graphics.print(#vendedor.itens,800,0)
    end

end