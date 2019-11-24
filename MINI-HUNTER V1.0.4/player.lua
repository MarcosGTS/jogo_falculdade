
function playerLoad()
    player = {} 
    player.x = window_w/2
    player.y = window_h/2
    player.w = 10
    player.h = 20
    player.sp = 160
    player.d = 1
    player.hpTotal = 100
    player.hpAtual = player.hpTotal
    player.cd = 0.5
    player.cdAtual = 0
    player.origemy = 0
    player.origemx = 0
    player.item = 0 
    player.dinheiro = 100
    player.dash = true
    player.delayDash = 0.5
    player.delayDashAtual = player.delayDash
    player.tempoDash = 0.25
    player.tempoDashAtual = player.tempoDash
    player.invencibilidade = false
end

function playerUpdade(dt)

    player.cdAtual = player.cdAtual - 1*dt
    player.origemx = player.x + player.w/2
    player.origemy = player.y + player.h/2  

    if love.keyboard.isDown("d") then
        if player.x < (window_w - player.w) then
            player.x = player.x + player.sp * dt
        end
    elseif love.keyboard.isDown("a") then
        if  player.x > 0 then      
            player.x = player.x - player.sp * dt
        end
    end
    if love.keyboard.isDown("w") then
        if player.y > 0 then
            player.y = player.y - player.sp * dt
        end
    elseif love.keyboard.isDown("s") then
        if player.y < (window_h - player.h) then
            player.y = player.y + player.sp * dt
        end
    end

    playerDash(dt)

end

function playerDash(dt)
    player.delayDashAtual = player.delayDashAtual - dt*1
    
    if love.mouse.isDown("2") and distanciaDoisPontos(mousex,mousey,player.origemx,player.origemy, 50) == false and player.dash and player.delayDashAtual < 0 then
        anguloDash = math.atan2( mousey - player.y, mousex - player.x)
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
    love.graphics.print("COINS  ".. player.dinheiro , 10,40 )
    love.graphics.print("TIMER  ".. math.floor(t), 10, 55, 0)
    love.graphics.print("MUNICAO ".. arma.cargaAtual, window_w - 100, 0)
    
    if player.hpAtual > 0 then
        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("fill", 10, 10, 300 *(player.hpAtual/player.hpTotal),25 )
    end

    if player.delayDashAtual < 0 then
        local comprimentoBarra = -150*(player.delayDashAtual/player.delayDash)
        if comprimentoBarra > 150 then
            comprimentoBarra = 150
        end
        love.graphics.setColor(1,1,1)
        love.graphics.rectangle("fill", 10, 30,comprimentoBarra ,10)
    end
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", player.x, player.y, player.w, player.h)
    
    if arma.reloadAtual <= arma.reload and arma.reloadAtual >= 0 then
        love.graphics.setColor(0, 1, 0)
        love.graphics.rectangle("fill", player.x - 5, player.y - 15, 20*(arma.reloadAtual/arma.reload), 5)
    end
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("fill",arma.x,arma.y,arma.h,arma.w)
end