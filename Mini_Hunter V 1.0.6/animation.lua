anim8 = require 'anim8'

function newAnimation(arg)
    local vArg = arg or {}
    local vAnim = {}
    if vArg.imagem then
        vAnim.imagem = love.graphics.newImage(vArg.imagem)
        local g = anim8.newGrid(vArg.frameWidth, vArg.frameHeight, vAnim.imagem:getWidth(), vAnim.imagem:getHeight(), vArg.left or 0, vArg.top or 0, vArg.border or 0 )
        vAnim.animation = anim8.newAnimation(g(vArg.frames, 1), vArg.speed or 0.1)
        return vAnim 
    end
end

function animationLoad()
    love.graphics.setDefaultFilter("nearest", "nearest")
    -- criar todas as animaçoes do jogo
    playerA = {}
    playerA.andar = newAnimation({imagem = "assets/sprites/playerSprite.png", frames = '1-3', frameWidth = 16, frameHeight = 16, left = 16, top = 2* 16})
    playerA.parado = newAnimation({imagem = "assets/sprites/playerSprite.png", speed = 0.2, frames = '1-4', frameWidth = 16, frameHeight = 16, left = 16, top = 7* 16 + 1})
    playerA.dash = newAnimation({imagem = "assets/sprites/playerSprite.png", frames = '1-2', frameWidth = 16, frameHeight = 16, left = 16, top = 4* 16})

end

function animationUpdate(dt)
    -- rodar todas as animaçoes do jogo 
    playerA.andar.animation: update(dt)
    playerA.parado.animation: update(dt)
    playerA.dash.animation: update(dt)

end

function animationDraw()
    -- condicionais para as animaçoes serem
    if player.dash == false and (player.lastDirection == 7 or player.lastDirection == 4 or player.lastDirection == 2  or player.lastDirection == 5 or player.lastDirection == 6) then
        playerA.dash.animation:draw(playerA.dash.imagem, player.x + 5, player.y + 13 , 0, 2.5, 2.5, 8, 8)
    
    elseif player.dash == false and (player.lastDirection == 1 or player.lastDirection == 8 or player.lastDirection == 3) then
        playerA.dash.animation:draw(playerA.dash.imagem, player.x + 14, player.y + 13 , 0, -2.5, 2.5, 8, 8)
    
    elseif player.direction == 7 or player.direction == 4 or player.direction == 2  or player.direction == 5 or player.direction == 6 then 
        playerA.andar.animation:draw(playerA.andar.imagem, player.x- 10,player.y - 5, 0, 2.5, 2.5)
    
    elseif player.direction == 8 or player.direction == 1 or player.direction == 3 then
        playerA.andar.animation:draw(playerA.andar.imagem, player.x + 34 ,player.y- 5, 0, -2.5, 2.5)
    
    elseif player.direction == 0 and (player.lastDirection == 7 or player.lastDirection == 4 or player.lastDirection == 2  or player.lastDirection == 5 or player.lastDirection == 6) then
        playerA.parado.animation:draw(playerA.parado.imagem, player.x- 10,player.y - 4, 0, 2.5, 2.5)
    
    elseif  player.direction == 0 and (player.lastDirection == 8 or player.lastDirection == 1 or player.lastDirection == 3) then
        playerA.parado.animation:draw(playerA.parado.imagem, player.x + 34, player.y - 4, 0, -2.5, 2.5)
    end
end

function cenarioLoad()
    gramasAtlas = love.graphics.newImage("assets/sprites/gramas.png")
    trilha1 = love.graphics.newQuad(0, 0, 32, 32, gramasAtlas:getDimensions())
    trilha2 = love.graphics.newQuad(16, 0, 32, 32, gramasAtlas:getDimensions())
    trilha3 = love.graphics.newQuad(0, 16, 32, 32, gramasAtlas:getDimensions())
    trilha4 = love.graphics.newQuad(16, 16, 32, 32, gramasAtlas:getDimensions())
    grama1 = love.graphics.newQuad(48, 0, 32, 32, gramasAtlas:getDimensions())
    grama2 = love.graphics.newQuad(80, 0, 32, 32, gramasAtlas:getDimensions())
    grama3 = love.graphics.newQuad(112, 0, 32, 32, gramasAtlas:getDimensions())
end

function cenarioDraw(windowW,windowH)
    for i = 0, 9 do
        local posY = i * 64 
        for j = 0, 19 do
            local posX = j * 64
            -- PRIMEIRA LINHA
            if  i == 0 and j > 0 and j < 19 then
                love.graphics.draw(gramasAtlas, grama2, posX, posY, 0, 2, 2)
            end
            -- MEIO
            if i > 0 and i < 9 then
                if j == 0 then
                    love.graphics.draw(gramasAtlas, grama2, posX + 64, posY, 1.5*math.pi, 2, 2, 32, 32)
                elseif j == 19 then
                    love.graphics.draw(gramasAtlas, grama2, posX , posY + 64, 0.5*math.pi, 2, 2, 32, 32)
                elseif i == 4 and j == 9 then
                    love.graphics.draw(gramasAtlas, trilha1, posX , posY, 0, 2, 2)
                elseif i == 4 and j == 10 then
                    love.graphics.draw(gramasAtlas, trilha2, posX , posY, 0, 2, 2)
                elseif i == 5 and j == 9 then
                    love.graphics.draw(gramasAtlas, trilha3, posX , posY, 0, 2, 2)
                elseif i == 5 and j == 10 then
                    love.graphics.draw(gramasAtlas, trilha4, posX , posY, 0, 2, 2)
                else
                    love.graphics.draw(gramasAtlas, grama3, posX, posY, 0, 2, 2)
                end
            end
            -- ULTIMA LINHA
            if  i == 9 and j > 0 and j < 19 then
                love.graphics.draw(gramasAtlas, grama2, posX, posY, math.pi, 2, 2, 32, 32)
            end
            -- CANTOS 
            if (i == 0 and j == 0)  then
                love.graphics.draw(gramasAtlas, grama1, posX, posY + 64, 0, -2, 2, 32, 32)
            end
            if (i == 0 and j == 19) then
                love.graphics.draw(gramasAtlas, grama1, posX, posY, 0, 2, 2)
            end
            if (i == 9 and j == 0)  then
                love.graphics.draw(gramasAtlas, grama1, posX, posY, 0, -2, -2, 32, 32)
            end
            if (i == 9 and j == 19) then
                love.graphics.draw(gramasAtlas, grama1, posX + 64, posY, 0, 2, -2, 32, 32)
            end
            if testmodeflag then
                love.graphics.setColor(1,0,0)
                love.graphics.line(posX, posY, posX + 64, posY)
                love.graphics.line(posX, posY, posX, posY + 64)
            end
            love.graphics.setColor(1,1,1)
        end
    
    end
   
end

