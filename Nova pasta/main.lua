require ("inimigos")

function love.load()
    window_w = 1280
    window_h = 640
    inimigoload()
end 

function love.update(dt)
    criaInimigo()
    inimigoMove(dt)
end

function love.draw()
    inimigodraw()
    love.graphics.print("inimigos :" .. #inimigos,0,0) -- bom para saber oq nao ta funcionando
end 
