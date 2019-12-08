-- para utilizar funçoes feitas em outro arquivo
require("movimentaçao")
require("geraçao")
require("vendedor")
require("powerups")
require("player")
require("telas")
require("armas")
require("rounds")
require("animation")
require("sfx")

function love.load()
    love.math.setRandomSeed(os.time())
    window_w = 1280
    window_h = 640
   
    playerLoad()
    
    lojaLoad()

    armaLoad()
    
    roundsLoad()
    
    animationLoad()

    cenarioLoad()

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
    sfxLoad()
end

function love.update(dt)
    if testmodeflag then
        if love.keyboard.isDown("escape") then
            love.event.quit()
        end
    end
    mousex,mousey = love.mouse.getPosition()
    
    animationUpdate(dt)
    
    backGroundMusic()
    
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
        armaUpdate(dt,dx,dy)
        
        -- ROUNDS --
        roundsUpdate()

        --AREA MONSTROS--
        monster_move(dt, monsters,window_w,window_h,audio.teleport)
        
        monster_death(monsters, coins, m_bullets)
        
        ataqueCorpo(monsters,player)

        MonsterShoot(monsters,m_bullets)
        
        monster_bulletd(dt, m_bullets)

        --AREA MOEDAS--
        mov_progressivo(dt,coins,player.origemx,player.origemy,200)

        player.dinheiro = coletarMoedas(coins,player.x,player.y,player.dinheiro,audio.coin)
        
        if player.vivo == false then
            menu = 4
        end
    elseif menu == 2 then
        
        menu = lojaUpdate()

    elseif menu == 3 then

        menu = ajudaUpdate()
        
    elseif menu == 0 then
    
        menu = telaInicialUpdate()
    elseif menu == 4 then
        
        menu = pontuacaoUpdate()
    
    end
    
end

function love.draw()
    love.graphics.setFont(fontes.menu)
    if menu == 1 then -- EM PARTIDA
        love.graphics.setFont(fontes.teste)
    
        cenarioDraw()
        
        -- ROUNDS--
        roundsDraw()
        
        draw_coins(coins)  
        
        draw_vendedor(vendedores,player.x, player.y)
        
        draw_monster(monsters,testmodeflag)
        
        mbullet_draw(m_bullets)
        
        bulletDraw()
        
        --PLAYER--
        playerDraw()
        
        animationDraw()

        -- MODO DE TESTES
        if testmodeflag then
            love.graphics.setColor(1,1,1)
            love.graphics.print("QM:"..limite, 0, 220)
            love.graphics.print("sp:"..player.sp.."\ndm:".. arma.dano .."\nitem "..  player.item.."\narma "..arma.tipo,0,450)
            love.graphics.print("inven:"..tostring(player.invencibilidade),0,300)
        end
    elseif menu == 2 then
        lojaDraw()
    elseif menu == 3 then
        ajudaDraw()
    elseif menu == 0 then -- TELA INICIAL
        telaInicialDraw()
    elseif menu == 4 then
        pontuacaoDraw()
    end
end