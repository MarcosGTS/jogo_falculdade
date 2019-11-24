
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
    
    if  player.item % 10 < 1 and player.dinheiro >= loja.botas and mousex > window_w/5 - 150 and mousex < window_w/5 -50 and mousey > window_h/4 - 20 and mousey < window_h/4 + 30 and love.mouse.isDown("1") then
        player.item = player.item + 1
        player.dinheiro = player.dinheiro - loja.botas 
    end
    if  math.floor(player.item/10) % 10 < 1 and player.dinheiro >= loja.botas and mousex > window_w/5 - 150 and mousex < window_w/5 -50 and mousey > window_h *2/4 - 20 and mousey < window_h * 2/4 + 30 and love.mouse.isDown("1") then
        player.item = player.item + 10
        player.dinheiro = player.dinheiro - loja.tambor 
    end
    if  math.floor(player.item/100) % 10 < 1 and player.dinheiro >= loja.botas and mousex > window_w/5 - 150 and mousex < window_w/5 -50 and mousey > window_h * 3/4 - 20 and mousey < window_h * 3/4 + 30 and love.mouse.isDown("1") then
        player.item = player.item + 100
        player.dinheiro = player.dinheiro - loja.balasA
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
    if mousex > window_w/2 - 100 and mousex < window_w/2 + 100 and mousey > window_h/2 and mousey < window_h/2 + 50 and love.mouse.isDown(1) then
       return 1
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
        love.graphics.rectangle("fill",window_w/2 - 100,window_h/2,200,50)
    else
        love.graphics.setColor(1,1,1)
        love.graphics.rectangle("line",window_w/2 - 100,window_h/2,200,50)
    end
    love.graphics.setColor(1,1,1)
    love.graphics.print("START",window_w/2 - 20, window_h/2 + 10)
end