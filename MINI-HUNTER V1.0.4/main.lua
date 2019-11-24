-- para utilizar funçoes feitas em outro arquivo
require("movimentaçao")
require("geraçao")
require("vendedor")
require("powerups")
require("player")
require("telas")
require("armas")
require("rounds")

function love.load()
    love.math.setRandomSeed(os.time())

    -- Temporizador
    t = 0

    window_w = 1280
    window_h = 640

    playerLoad()
    
    lojaLoad()

    armaLoad()
    
    roundsLoad()
    
    monsters = {}
    m_bullets = {}
    coins = {}

    mousex,mousey = 0, 0

    --MENUS--
    menu = 0

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
      
        --AREA PLAYER--
        playerUpdade(dt)

        --POWERUPS--
        powerups(player.item)

        --AREA ARMAS--
        armaUpdate(dt)
        
        -- ROUNDS --
        roundsUpdate()
        
        --AREA MONSTROS--
        monster_move(dt, monsters,window_w,window_h,audio.teleport)
        
        monster_death(monsters, coins)
        
        ataqueCorpo(monsters,player)

        tiroMago(monsters,m_bullets)
        
        monster_bulletd(dt, m_bullets)

        --AREA MOEDAS--
        mov_progressivo(dt,coins,player.origemx,player.origemy,200)

        player.dinheiro = coletarMoedas(coins,player.x,player.y,player.dinheiro,audio.coin)

        if player.hpAtual <= 0 then
            love.event.quit("restart")
        end
    elseif menu == 2 then
        
        menu = lojaUpdate()
        
    elseif menu == 0 then
        
        menu = telaInicialUpdate()
        
    end
    
end

function love.draw()
    if menu == 1 then -- EM PARTIDA
        love.graphics.setFont(fontes.teste)

        love.graphics.setBackgroundColor(0,0.6,0.2)
        love.keyboard.isDown("b")
       
        -- ROUNDS--
        roundsDraw()
        
        draw_coins(coins)  
        
        draw_vendedor(vendedores,player.x, player.y)
        
        draw_monster(monsters,testmodeflag)
        
        mbullet_draw(m_bullets)
        
        bulletDraw()
        
        --PLAYER--
        playerDraw()
        
        -- MODO DE TESTES
        love.graphics.setColor(1,1,1)
        love.graphics.print(limite, 0, 220)
        love.graphics.print(player.sp.." ".. player.item .." ".. arma.dano.." "..arma.tipo.." "..arma.frequenciaTirosAtual,0,450)
        love.graphics.print(tostring(testmodeflag),500,0)
        love.graphics.print(tostring(player.invencibilidade))

    elseif menu == 2 then
        lojaDraw()
    elseif menu == 0 then -- TELA INICIAL
        telaInicialDraw()
    end
   
end