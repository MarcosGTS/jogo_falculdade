function roundsLoad()
    vendedores = {}
    
    limite = 0 -- adicionar dificuldade progressiva
    rounds = 0
    podeSummonar = false

end

function roundsUpdate()
    
    if limite == 0 then
        podeSummonar = false
    end

    if podeSummonar == false and #monsters == 0 then 
        if limite == 0 then
            limite = (rounds + 1) * 4 
        end
        
        if love.keyboard.isDown("space") and distanciaDoisPontos(player.x,player.y,window_w/2,window_h/2,100) then
            podeSummonar = true
            rounds = rounds + 1
        end
        vendedor(t,podeSummonar,vendedores, rounds,window_w,window_h)
    end
    
    if podeSummonar then
        if limite > 0 and love.math.random(0,100) < 1 then
            g_monster(dt, monsters,t, window_w, window_h,rounds) 
            limite = limite - 1 
        end
    end

    --AREA VENDEDOR--   
    if love.keyboard.isDown("b") and #vendedores == 1 then
        menu = lojamenu(vendedores,player.origemx,player.origemy,menu)
    end
end

function roundsDraw()
    local rectangle = {}
    rectangle.w = 55
    rectangle.h = 15
    rectangle.x = window_w/2 - rectangle.w/2
    rectangle.y = 20
    
    love.graphics.setColor(1,1,1)
    love.graphics.print("ROUND: ".. rounds, rectangle.x, rectangle.y)
    if podeSummonar == false and #monsters == 0 and testmodeflag then
        love.graphics.setColor(1,1,1)
        love.graphics.circle("line",window_w/2,window_h/2,100)
    end
    
    if distanciaDoisPontos(player.x,player.y,window_w/2,window_h/2,100) and podeSummonar == false and #monsters == 0 then
        love.graphics.setColor(1,1,1)
        love.graphics.print("   APERTE ESPAÇO\nSE ESTIVER PRONTO",window_w/2-60,window_h/2-50)
    end
end