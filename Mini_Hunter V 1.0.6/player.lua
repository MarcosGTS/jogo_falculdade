
function playerLoad()
    player = {} 
    player.x = window_w/2
    player.y = window_h/2
    player.w = 16 * 1.5
    player.h = 16 * 2
    player.sp = 160
    player.hpTotal = 6
    player.hpAtual = player.hpTotal
    player.cd = 0.5
    player.cdAtual = 0
    player.origemy = 0
    player.origemx = 0
    player.item = 0 
    player.dinheiro = 0
    player.dash = true
    player.delayDash = 0.5
    player.delayDashAtual = player.delayDash
    player.anguloDash = 0 
    player.tempoDash = 0.25
    player.tempoDashAtual = player.tempoDash
    player.invencibilidade = false
    player.direction = 0
    player.lastDirection = 7
    player.vivo = true
    player.pontuacao = 0
end

function playerUpdade(dt)

    player.cdAtual = player.cdAtual - 1*dt
    player.origemx = player.x + player.w/2
    player.origemy = player.y + player.h/2  
    player.direction = playerDirection()
    
    if playerDirection() ~= 0 then
        player.lastDirection = playerDirection()
    end

    player.rotation = math.atan2(mousey - player.y, mousex - player.x)
    
    playerDash(dt)
    
    playerMove(dt)
    
    if player.hpAtual <= 0 then
        player.vivo = false
    end

end

function playerDash(dt)
    player.delayDashAtual = player.delayDashAtual - dt*1
    
    if love.mouse.isDown("2") and distanciaDoisPontos(mousex,mousey,player.origemx,player.origemy, 50) == false and player.dash and player.delayDashAtual < 0 then
        
        if player.lastDirection == 1 then
            anguloDash = 2 * math.pi/8 * 5
        elseif player.lastDirection == 2 then
            anguloDash = 2 * math.pi/8 * 7
        elseif player.lastDirection == 3 then
            anguloDash = 2 * math.pi/8 * 3
        elseif player.lastDirection == 4 then
            anguloDash = 2 * math.pi/8 * 1   
        elseif player.lastDirection == 5 then
            anguloDash = 2 * math.pi/8 * 6
        elseif player.lastDirection == 6 then
            anguloDash = 2 * math.pi/8 * 2 
        elseif player.lastDirection == 7 then
            anguloDash = 2 * math.pi/8 * 8
        elseif player.lastDirection == 8 then
            anguloDash = 2 * math.pi/8 * 4
        end
        
        player.dash = false

        player.tempoDashAtual = player.tempoDash
    end
    
    if player.dash == false then
        player.tempoDashAtual = player.tempoDashAtual - dt*1

        if player.tempoDashAtual > 0 then 
            player.x = player.x + player.sp * 25 * math.cos(anguloDash) * dt *player.tempoDashAtual
            player.y = player.y + player.sp * 25 * math.sin(anguloDash) * dt *player.tempoDashAtual
            player.invencibilidade = true
        end
        
        if player.tempoDashAtual <=0 then
            player.dash = true
            player.invencibilidade = false
            player.delayDashAtual = player.delayDash
        end
    end
end

function playerDraw()
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("COINS  ".. player.dinheiro , 10, 60)
    
    
    if player.hpAtual > 0 then
       
        for i = 0, player.hpTotal -1 do 
            local posx = 30 * i
             love.graphics.setColor(0, 0, 0)
            love.graphics.rectangle("fill", posx + 10, 10, 25, 25)
        end
        for i = 0, player.hpAtual -1 do 
            local posx = 30 * i
            love.graphics.setColor(1, 0, 0)
            love.graphics.rectangle("fill", posx + 10, 10, 25, 25)
        end
    end

    if player.delayDashAtual < 0 then
        local comprimentoBarra = -150*(player.delayDashAtual/player.delayDash)
        if comprimentoBarra > 150 then
            comprimentoBarra = 150
        end
        love.graphics.setColor(1,1,1)
        love.graphics.rectangle("fill", 10, 30,comprimentoBarra ,10)
    end
    
    if testmodeflag then
        love.graphics.setColor(0, 0,1)
        love.graphics.rectangle("line", player.x, player.y, player.w, player.h)
    end

    if arma.reloadAtual <= arma.reload and arma.reloadAtual >= 0 then
        love.graphics.setColor(0, 1, 0)
        love.graphics.rectangle("fill", player.x - 5, player.y - 15, 20*(arma.reloadAtual/arma.reload), 5)
    end

    love.graphics.setColor(1,1,1)
    love.graphics.print(playerDirection().." ".. player.lastDirection, 0, 250)
end

function playerDirection()
    
    if love.keyboard.isDown("w") and love.keyboard.isDown("a")then
        return 1
    elseif love.keyboard.isDown("w") and love.keyboard.isDown("d")then
        return 2
    elseif love.keyboard.isDown("a") and love.keyboard.isDown("s")then
        return 3
    elseif love.keyboard.isDown("s") and love.keyboard.isDown("d")then
        return 4
    elseif love.keyboard.isDown("w") then
        return 5
    elseif love.keyboard.isDown("s") then
        return 6
    elseif love.keyboard.isDown("d") then
        return 7
    elseif love.keyboard.isDown("a") then
        return 8
    else
        return 0
    end

end
function playerMove(dt)
       
    if playerDirection() == 1 then
        anguloMoviment = 2 * math.pi/8 * 5
    elseif playerDirection() == 2 then
        anguloMoviment = 2 * math.pi/8 * 7
    elseif playerDirection() == 3 then
        anguloMoviment = 2 * math.pi/8 * 3
    elseif playerDirection() == 4 then
        anguloMoviment = 2 * math.pi/8 * 1   
    elseif playerDirection() == 5 then
        anguloMoviment = 2 * math.pi/8 * 6
    elseif playerDirection() == 6 then
        anguloMoviment = 2 * math.pi/8 * 2 
    elseif playerDirection() == 7 then
        anguloMoviment = 2 * math.pi/8 * 8
    elseif playerDirection() == 8 then
        anguloMoviment = 2 * math.pi/8 * 4
    end
    if playerDirection() ~= 0 then
        audio.stepsSounds:play()
        player.x = player.x + player.sp * math.cos(anguloMoviment) * dt 
        player.y = player.y + player.sp * math.sin(anguloMoviment) * dt 
    else
        audio.stepsSounds:stop()
    end
end