
function lojaLoad()
    loja = {}
    loja.botas = 10
    loja.podeComprarB = true
    loja.tambor = 10
    loja.podeComprarT = true
    loja.balasA = 10
    loja.podeComprarBa = true
end

function lojaUpdate()
    
    if  mousex > window_w/5 - 150 and mousex < window_w/5 -50 and mousey > window_h/4 - 20 and mousey < window_h/4 + 30 and love.mouse.isDown("1") then
        if player.dinheiro >= loja.botas and player.item % 10 < 1  then
            audio.compra:stop()
            audio.compra:play()
            player.item = player.item + 1
            player.dinheiro = player.dinheiro - loja.botas 
        elseif player.dinheiro < loja.botas or player.item %10 >= 1 then
            audio.compraErro:stop()
            audio.compraErro:play()
        end
    end
    if mousex > window_w/5 - 150 and mousex < window_w/5 -50 and mousey > window_h *2/4 - 20 and mousey < window_h * 2/4 + 30 and love.mouse.isDown("1") then
        if math.floor(player.item/10) % 10 < 1 and player.dinheiro >= loja.botas then
            audio.compra:stop()
            audio.compra:play()
            player.item = player.item + 10
            player.dinheiro = player.dinheiro - loja.tambor
        elseif player.dinheiro < loja.tambor or player.item >= math.floor(player.item/10) then
            audio.compraErro:stop()
            audio.compraErro:play()
        end
    end
    if mousex > window_w/5 - 150 and mousex < window_w/5 -50 and mousey > window_h * 3/4 - 20 and mousey < window_h * 3/4 + 30 and love.mouse.isDown("1") then
        if  math.floor(player.item/100) % 10 < 1 and player.dinheiro >= loja.balasA then
            audio.compra:stop()
            audio.compra:play()
            player.item = player.item + 100
            player.dinheiro = player.dinheiro - loja.balasA
        elseif player.dinheiro < loja.balasA or math.floor(player.item/100)>= 1 then
            audio.compraErro:stop()
            audio.compraErro:play()
        end
    end

    if mousex > window_w - 125 and mousex < window_w - 25 and mousey > window_h - 75 and mousey < window_h - 25 and love.mouse.isDown("1") then
        return 1
    end

    if love.keyboard.isDown("escape") then
        return 1
    end

    return 2 
    
end

function lojaDraw()
    
    love.graphics.setFont(fontes.teste)
    love.graphics.setBackgroundColor(0,0.5,0.5)
    love.graphics.setColor(1,1,1)
    love.graphics.print("LOJA",window_w/2 - 50,0)
    love.graphics.print("DINHEIRO R$ "..player.dinheiro,0,50)
    
    -- lista de itens
    
    love.graphics.print("botas leves R$ " .. loja.botas, window_w *1/5,window_h* 1/4)
    love.graphics.print("tambor extra grande R$ " .. loja.tambor, window_w *1/5, window_h * 2/4)
    love.graphics.print("balas abençoadas R$ " .. loja.balasA, window_w *1/5, window_h * 3/4)
    
    -- botoes 
    
    love.graphics.setColor(1,1,1)
    if  player.dinheiro >= loja.botas and mousex > window_w/5 - 150 and mousex < window_w/5 -50 and mousey > window_h/4 - 20 and mousey < window_h/4 + 30 then
        love.graphics.rectangle("fill",window_w *1/5 - 150,window_h* 1/4 - 20,100,50)
    else
        love.graphics.rectangle("line",window_w *1/5 - 150,window_h* 1/4 - 20,100,50)
    end
    if  player.dinheiro >= loja.botas and mousex > window_w/5 - 150 and mousex < window_w/5 -50 and mousey > window_h *2/4 - 20 and mousey < window_h * 2/4 + 30 then
        love.graphics.rectangle("fill",window_w *1/5 - 150,window_h * 2/4 - 20,100,50)
    else
        love.graphics.rectangle("line",window_w *1/5 - 150,window_h * 2/4 - 20,100,50)
    end
    if  player.dinheiro >= loja.botas and mousex > window_w/5 - 150 and mousex < window_w/5 -50 and mousey > window_h * 3/4 - 20 and mousey < window_h * 3/4 + 30  then
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

end

function telaInicialUpdate()
    if mousex > window_w/2 - 100 and mousex < window_w/2 + 100 and mousey > window_h/2 and mousey < window_h/2 + 50 then
        if podeTocar then
            audio.menuMove:stop()
            audio.menuMove:play()  
            podeTocar = false
        end
        
        if love.mouse.isDown(1) then
            audio.menuSelection:play()
            return 1
        end
        
    elseif  mousex > window_w/2 - 100 and mousex < window_w/2 + 100 and mousey > window_h/2 +75 and mousey < window_h/2 + 125 then
        if podeTocar then
            audio.menuMove:stop()
            audio.menuMove:play()
            podeTocar = false
        end
        if love.mouse.isDown(1) then
            audio.menuSelection:play()
            return 3
        end
    else 
        podeTocar = true
    end
    return 0
end


function telaInicialDraw()
    love.graphics.setBackgroundColor(0,0,0)
    love.graphics.setColor(1,1,1)
    love.graphics.setFont(fontes.menu)
    love.graphics.print("MINI HUNTER",window_w/2 - 225,0,r,4,4)
    if mousex > window_w/2 - 100 and mousex < window_w/2 + 100 and mousey > window_h/2 and mousey < window_h/2 + 50 then
        love.graphics.setColor(1,0,0)
        love.graphics.rectangle("line",window_w/2 - 100,window_h/2,200,50)
    else
        love.graphics.setColor(1,1,1)
        love.graphics.rectangle("line",window_w/2 - 100,window_h/2,200,50)
    end
    if mousex > window_w/2 - 100 and mousex < window_w/2 + 100 and mousey > window_h/2 +75 and mousey < window_h/2 + 125 then
        love.graphics.setColor(1,0,0)
        love.graphics.rectangle("line",window_w/2 - 100, window_h/2 + 75,200, 50)
    else
        love.graphics.setColor(1,1,1)
        love.graphics.rectangle("line",window_w/2 - 100, window_h/2 + 75,200, 50)
    end
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end
    love.graphics.setColor(1,1,1)
    love.graphics.print("START",window_w/2 - 20, window_h/2 + 10)
    love.graphics.print("AJUDA", window_w/2 - 20, window_h/2 + 85)
end

function ajudaUpdate()
    if mousex > window_w - 125 and mousex < window_w - 25 and mousey > window_h - 75 and mousey < window_h - 25  then
        if podeTocar then
            audio.menuMove:stop()
            audio.menuMove:play()
            podeTocar = false
        end
        if love.mouse.isDown("1") then
            return 0
        end
    else
        podeTocar = true
    end
    if love.keyboard.isDown("escape") then
        return 0
    end
    return 3
end

function ajudaDraw()
    love.graphics.setColor(1,1,1)
    love.graphics.print("INSTRUCOES  DE  JOGO",60,0)
    love.graphics.print("W A S D  para  a  MOVIMENTACAO",20 ,25)
    love.graphics.print("botao  esquerdo  do  mouse  para  ATIRAR",20,50)
    love.graphics.print("botao  direito  do  mouse  para  o  DASH",20,75)
    love.graphics.print("scrow  do  mouse  para  TROCAR  DE  ARMA",20,100)
    love.graphics.print("SAIR", window_w - 100, window_h - 60)    
    if mousex > window_w - 125 and mousex < window_w - 25 and mousey > window_h - 75 and mousey < window_h - 25 then
        love.graphics.setColor(1,0,0)
        love.graphics.rectangle("line",window_w- 125, window_h - 75,100,50)
    else
        love.graphics.setColor(1,1,1)
        love.graphics.rectangle("line",window_w- 125, window_h - 75,100,50)
    end
end

function pontuacaoUpdate()
    if love.keyboard.isDown("space") then
        love.event.quit("restart")
    end
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end
    if AABB(window_w/2 - 115  ,mousex, 400, mousey, 230, 1, 45, 1) then
        if podeTocar then
            audio.menuMove:stop()
            audio.menuMove:play()
            podeTocar = false
        end
        if love.mouse.isDown("1") then
            love.event.quit("restart")
        end
    
    elseif AABB(window_w/2 - 115  ,mousex, 450, mousey, 230, 1, 45, 1) then
        if podeTocar then
            audio.menuMove:stop()
            audio.menuMove:play()
            podeTocar = false
        end
        if love.mouse.isDown("1") then
            love.event.quit()    
        end
    else
        podeTocar = true
    end

    return 4
end
function pontuacaoDraw()
    local rectangle = {}
    rectangle.w = 230
    rectangle.h = 45
    rectangle.x = window_w/2 - rectangle.w/2
    rectangle.y = 25
    
    --love.graphics.rectangle("line", rectangle.x, rectangle.y, rectangle.w, rectangle.h )
    love.graphics.setBackgroundColor(0, 0, 0)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Round   Alcancado ".. rounds.."\nMonstros   expurgardos ".. player.pontuacao, rectangle.x, rectangle.y)
    love.graphics.print("restart", rectangle.x + 80, 410)
    love.graphics.print("sair", rectangle.x + 95, 460)
    
    if AABB(window_w/2 - 115  ,mousex, 400, mousey, 230, 1, 45, 1) then
        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("line", rectangle.x, 400, rectangle.w, rectangle.h)
    else
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("line", rectangle.x, 400, rectangle.w, rectangle.h) 
    end
    if AABB(window_w/2 - 115  ,mousex, 450, mousey, 230, 1, 45, 1) then
        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("line", rectangle.x, 450, rectangle.w, rectangle.h)
    else
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("line", rectangle.x, 450, rectangle.w, rectangle.h)
    end
   
end
function backGroundMusic()
    if menu == 0 or menu == 3 then
        audio.intro:play()
    else
        audio.intro:stop()
    end
    if podeSummonar == false and #monsters == 0 and (menu == 1 or menu == 2) then
        audio.entreRounds:play()
    else
        audio.entreRounds:stop()
    end
    if (podeSummonar == true or #monsters > 0) and menu == 1 then
        audio.batalha:play()
    else
        audio.batalha:stop()
    end
end