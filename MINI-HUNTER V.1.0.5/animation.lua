 
function playerAnimationLoad()
    
    animation ={}
    animation.fps = 10
    animation.spframe = 1/animation.fps
    animation.frame = 0 
    animation.xDaImagem = 0
    animation.yDaImagem = 0  
    animation.w = 16
    animation.h = 16
    
    love.graphics.setDefaultFilter("nearest","nearest")
    globalAtlas = love.graphics.newImage("assets/sprites/playerSprite.png")
    spriteHero = love.graphics.newQuad(19,19,16,16,globalAtlas:getDimensions())
end
function playerAnimationUpdate(dt)
    animation.spframe = animation.spframe - dt*1

    if animation.spframe < 0 then
        animation.spframe = 1/animation.fps
        animation.frame = animation.frame + 1
        if animation.frame >= 3 then 
            animation.frame = 0 
        end
        animation.xDaImagem = animation.frame * animation.w
        spriteHero:setViewport(animation.xDaImagem + 19 , animation.yDaImagem+ animation.h + 18, 11, 14)
    end

end
function playerAnimationDraw()
    love.graphics.draw(globalAtlas,spriteHero,25,400, 0, 3, 3, 5, 6.5)
    love.graphics.print(animation.xDaImagem,500,800)
end