function armaLoad()
    tiros = {}
    
    arma = {} -- adicionar tipos de armas 
    arma.tipo = 0
    arma.x = window_w/2
    arma.y = window_h/2
    arma.w = 10
    arma.h = 10
    arma.dano = 12
    arma.frequenciaTiros = 0.35
    arma.frequenciaTirosAtual = arma.frequenciaTiros
    arma.balasPorVez = 12
    arma.cargaTotal = 5
    arma.cargaAtual = arma.cargaTotal
    arma.reload = 1.5
    arma.reloadAtual = 0
    arma.podeRecarregar = true
    arma.precisao = 60
    arma.duracao = 0.6
    arma.sp = 300
    
    multiplicadorD = 1
    multiplicadorC = 1
    delayTrocaArma = 0
end

function armaUpdate(dt)
    
    armaAtual(dt)

    arma.reloadAtual = arma.reloadAtual - dt * 1
    arma.frequenciaTirosAtual = arma.frequenciaTirosAtual - dt * 1   
        
    if love.keyboard.isDown("r") and arma.reloadAtual < arma.reload and arma.podeRecarregar and arma.cargaAtual < arma.cargaTotal then
        arma.reloadAtual = arma.reload  
        arma.podeRecarregar = false  
    end 
    if arma.cargaAtual == 0 and love.mouse.isDown(1) and arma.podeRecarregar then
        arma.reloadAtual = arma.reload
        arma.podeRecarregar = false
    end
    if arma.reloadAtual < 0 then
        arma.podeRecarregar = true
    end
    if arma.reloadAtual > 0 and arma.reloadAtual < 0.1 then
        arma.cargaAtual = arma.cargaTotal
    end 

    if arma.frequenciaTirosAtual < 0 and love.mouse.isDown(1) and arma.cargaAtual > 0 and arma.podeRecarregar and distanciaDoisPontos(player.origemx,player.origemy,mousex,mousey,75)==false then
        
        for i=1 ,arma.balasPorVez do
            g_tiros(tiros, arma , mousex, mousey)
        end
        arma.cargaAtual = arma.cargaAtual - 1
        arma.frequenciaTirosAtual = arma.frequenciaTiros
        audio.tiro:stop()
        audio.tiro:play()
    end
    
    for i=#tiros, 1, -1 do 
        local tiro = tiros[i]
        
        -- COLISAO DA BALA COM MONSTROS
        for j=#monsters ,1 , -1 do 
            local monster = monsters[j]
            if AABB(tiro.x, monster.x, tiro.y, monster.y, tiro.w, monster.w, tiro.h, monster.h) then
                monster.hp = monster.hp - tiro.dano
                table.remove(tiros,i) 
                audio.hit:stop()
                audio.hit:play()
            end
        end
        
        -- VERIFICAÇAO DA POSIÇAO DA BALA E DURAÇAO DOS TIROS 
        if dentroDaTela(window_w,window_h,tiro.x,tiro.y,tiro.w,tiro.h) == false or tiro.duracao < 0 then
      
            table.remove(tiros,i)
    
        end
        -- CONTADOR DURAÇAO DOS TIROS 
        tiro.duracao = tiro.duracao - dt 
        
        -- DIREÇAO DAS BALAS

        local distanciaMouse = (((tiro.px - tiro.mx)^2 + (tiro.py - tiro.my)^2)^(1/2))
        local x = tiro.mx - tiro.px + (tiro.tx * distanciaMouse/100)
        local y = tiro.my - tiro.py + (tiro.ty * distanciaMouse/100)
        
        angulo = math.atan2(y,x)
        propx = math.cos(angulo) 
        propy = math.sin(angulo)

        tiro.x = tiro.x + tiro.sp *propx * dt 
        tiro.y = tiro.y + tiro.sp *propy * dt 
        
    end
    
    arma.y,arma.x = posicaoArma(mousex,mousey,player.origemx,player.origemy)

end

function bulletDraw()
    for i=#tiros,1,-1 do
        local tiro = tiros[i] 
        love.graphics.setColor(0.8, 0.8, 0.8)
        love.graphics.circle("fill", tiro.x, tiro.y, tiro.w/2)
    end
end

function armaAtual(dt)
    
    delayTrocaArma = delayTrocaArma - dt*1
    
    if arma.tipo < 0 then arma.tipo = 0 end
    if arma.tipo > 2 then arma.tipo = 2 end
    
    if arma.tipo == 0 and delayTrocaArma > 0.4 then
        arma.dano = 7.5 * multiplicadorD
        arma.frequenciaTiros = 0.35
        arma.frequenciaTirosAtual = arma.frequenciaTiros
        arma.balasPorVez = 12 
        arma.cargaTotal = math.floor(5 * multiplicadorC)
        arma.cargaAtual = arma.cargaTotal
        arma.reload = 1.5
        arma.reloadAtual = 0
        arma.podeRecarregar = true
        arma.precisao = 60
        arma.duracao = 0.6
        arma.sp = 300
        
    elseif arma.tipo == 1 and delayTrocaArma > 0.4 then
        arma.dano = 25 * multiplicadorD
        arma.frequenciaTiros = 0.2
        arma.frequenciaTirosAtual = arma.frequenciaTiros
        arma.balasPorVez = 1
        arma.cargaTotal = math.floor(25 * multiplicadorC)
        arma.cargaAtual = arma.cargaTotal
        arma.reload = 3
        arma.reloadAtual = 0
        arma.podeRecarregar = true
        arma.precisao = 5
        arma.duracao = 3
        arma.sp = 550

    elseif arma.tipo == 2 and delayTrocaArma > 0.4 then
        arma.dano = 5 * multiplicadorD
        arma.frequenciaTiros = 0.025
        arma.frequenciaTirosAtual = arma.frequenciaTiros
        arma.balasPorVez = 1
        arma.cargaTotal = math.floor(65 * multiplicadorC)
        arma.cargaAtual = arma.cargaTotal
        arma.reload = 0.75
        arma.reloadAtual = 0
        arma.podeRecarregar = true
        arma.precisao = 50
        arma.duracao = 0.75
        arma.sp = 300

    end
end

function love.wheelmoved( dx,dy )
    if delayTrocaArma < 0 then
        arma.tipo = arma.tipo + dy
        delayTrocaArma = 0.5
    end
end