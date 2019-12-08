function armaLoad()
    
    tiros = {}
    multiplicadorD = 1
    multiplicadorC = 1
    
    arma = {} -- adicionar tipos de armas 
    arma.tipo = 1
    arma.x = window_w/2
    arma.y = window_h/2
    arma.w = 10
    arma.h = 10
    arma.dano = 15 * multiplicadorD
    arma.frequenciaTiros = 0.15
    arma.frequenciaTirosAtual = arma.frequenciaTiros
    arma.balasPorVez = 1
    arma.cargaTotal = math.floor(8 * multiplicadorC)
    arma.cargaAtual = arma.cargaTotal
    arma.reload = 1.25
    arma.reloadAtual = 0
    arma.podeRecarregar = true
    arma.precisao = 15
    arma.duracao = 1.5
    arma.sp = 300
   
   
    delayTrocaArma = 0
    
    love.graphics.setDefaultFilter("nearest", "nearest")
    ArmasAtlas = love.graphics.newImage("assets/sprites/iconesArmas.png")
    pistolImage = love.graphics.newQuad(0, 0, 20, 12, ArmasAtlas:getDimensions())
    shotgunImage = love.graphics.newQuad(0, 12, 35, 13, ArmasAtlas:getDimensions())
    uziImage = love.graphics.newQuad(0, 25, 24, 16, ArmasAtlas:getDimensions())
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
    if arma.reloadAtual > 0 then
        audio.reload:stop()
        audio.reload:play()
        if arma.reloadAtual < 0.1 then
            arma.cargaAtual = arma.cargaTotal
        end
    end 
    
    if arma.frequenciaTirosAtual < 0 and love.mouse.isDown(1) and arma.cargaAtual > 0 and arma.podeRecarregar and distanciaDoisPontos(player.origemx,player.origemy,mousex,mousey,25)==false then
        
        for i=1 ,arma.balasPorVez do
            g_tiros(tiros, arma , mousex, mousey)
        end
        arma.cargaAtual = arma.cargaAtual - 1
        arma.frequenciaTirosAtual = arma.frequenciaTiros
        if arma.tipo == 0 then
            audio.shotgun:stop()
            audio.shotgun:play()
        elseif arma.tipo == 1 then
            audio.tiro:stop()
            audio.tiro:play()
        elseif arma.tipo == 2 then
            audio.machineGun:stop()
            audio.machineGun:play()
        end
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
    love.graphics.setColor(1,1,1)
    iconesArmas()
    for i=#tiros,1,-1 do
        local tiro = tiros[i] 
        
        if testmodeflag then
            love.graphics.setColor(0, 0, 1)
            love.graphics.rectangle("line", tiro.x, tiro.y, tiro.w, tiro.h)
        end
        love.graphics.setColor(0.8, 0.8, 0.8)
        love.graphics.circle("fill", tiro.x + tiro.w/2, tiro.y + tiro.h/2, tiro.w/2)
    end
end

function armaAtual(dt)
    
    delayTrocaArma = delayTrocaArma - dt*1
    
    if arma.tipo < 0 then arma.tipo = 2 end
    if arma.tipo > 2 then arma.tipo = 0 end
    
    if arma.tipo == 0 and delayTrocaArma > 0.4 then
        arma.dano = 20 * multiplicadorD
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
        arma.sp = 250
        
    elseif arma.tipo == 1 and delayTrocaArma > 0.4 then
        arma.dano = 15 * multiplicadorD
        arma.frequenciaTiros = 0.15
        arma.frequenciaTirosAtual = arma.frequenciaTiros
        arma.balasPorVez = 1
        arma.cargaTotal = math.floor(8 * multiplicadorC)
        arma.cargaAtual = arma.cargaTotal
        arma.reload = 1.25
        arma.reloadAtual = 0
        arma.podeRecarregar = true
        arma.precisao = 15
        arma.duracao = 1.5
        arma.sp = 300

    elseif arma.tipo == 2 and delayTrocaArma > 0.4 then
        arma.dano = 7.5 * multiplicadorD
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
        audio.trocaArma:stop()
        audio.trocaArma:play()
        delayTrocaArma = 0.5
    end
end

function iconesArmas()
    local angle = math.atan2(mousey - player.origemy, mousex - player.origemx)
    love.graphics.setColor(1,1,1)
    if testmodeflag then
        love.graphics.rectangle("fill",arma.x - arma.w/2, arma.y- arma.h/2, arma.h,arma.w)
    end
    love.graphics.print(arma.cargaTotal.."/".. arma.cargaAtual, window_w - 100, window_h - 110)
    
    if arma.tipo == 0 then
        for i=1, arma.cargaAtual do
            local posy = 15 * i
            love.graphics.rectangle("fill", window_w-50, window_h - 100 - posy, 20, 12.5)
        end
    elseif arma.tipo == 2 then
        for i=1, arma.cargaAtual do
            local posy = 5 * i
            love.graphics.rectangle("fill", window_w-50, window_h - 100 - posy, 20, 2.5)
        end
    elseif arma.tipo == 1 then
        for i=1, arma.cargaAtual do
            local posy = 10 * i
            love.graphics.rectangle("fill", window_w-50, window_h - 100 - posy, 20, 5)
        end
    end
    love.graphics.rectangle("line",  window_w - 170, window_h - 85, 160, 72, 10)
    if arma.tipo == 0 then
        love.graphics.draw(ArmasAtlas, shotgunImage, window_w - 160, window_h - 75, 0, 4, 4)
        if  angle > -math.pi/2 and angle < math.pi/2 then
            love.graphics.draw(ArmasAtlas, shotgunImage, arma.x, arma.y, angle, 1, 1, 30, 8)
        else
            love.graphics.draw(ArmasAtlas, shotgunImage, arma.x, arma.y, angle, 1, -1, 30, 8)
        end
    end
    if arma.tipo == 1 then
        love.graphics.draw(ArmasAtlas, pistolImage, window_w - 125, window_h - 75, 0, 4, 4)
        
        if  angle > -math.pi/2 and angle < math.pi/2 then
            love.graphics.draw(ArmasAtlas, pistolImage, arma.x, arma.y, angle, 1, 1, 15, 6)
        else
            love.graphics.draw(ArmasAtlas, pistolImage, arma.x, arma.y, angle, 1, -1, 15, 6)
        end
    end
    if arma.tipo == 2 then
        love.graphics.draw(ArmasAtlas, uziImage, window_w - 135, window_h - 80, 0, 4, 4)
        if  angle > -math.pi/2 and angle < math.pi/2 then
            love.graphics.draw(ArmasAtlas, uziImage, arma.x, arma.y, angle, 1, 1, 20, 6)
        else
            love.graphics.draw(ArmasAtlas, uziImage, arma.x, arma.y, angle, 1, -1, 20, 6)
        end
    end
end

function posicaoArma(mousex,mousey,px,py)
    xa = mousex - px 
    ya = mousey - py

    angulo = math.atan2(ya,xa)
    propxa = math.cos(angulo)
    propya = math.sin(angulo)
    
    if arma.tipo == 1 then
        armay = propya * 30 + py 
        armax = propxa * 30 + px 
    elseif arma.tipo == 2 then
        armay = propya * 35 + py 
        armax = propxa * 35 + px 
    elseif arma.tipo == 0 then
        armay = propya * 43 + py 
        armax = propxa * 43 + px 
    end
    return armay,armax
end

function g_tiros(vetor_tiros,vetorArma, mx, my)    
    local arma = vetorArma
    local tiro = {}
    tiro.x = arma.x - 5 
    tiro.y = arma.y - 5
    tiro.px = arma.x -5
    tiro.py = arma.y -5
    tiro.w = 10
    tiro.h = 10
    tiro.sp = love.math.random(arma.sp,arma.sp + 50)
    tiro.tx = love.math.random(-arma.precisao,arma.precisao)
    tiro.ty = love.math.random(-arma.precisao,arma.precisao)
    tiro.mx = mx 
    tiro.my = my 
    tiro.dano = arma.dano 
    tiro.duracao = love.math.random(arma.duracao,arma.duracao + 0.5)
    
    table.insert(vetor_tiros,tiro)
end
