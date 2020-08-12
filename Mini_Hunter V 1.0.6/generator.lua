function generator(window_w, window_h, tamanhox, tamanhoy, percent)
    local propx = window_w/tamanhox
    local propy = window_h/tamanhoy
    for i = 0 , propx -1 do
        local posX = tamanhox * i
        for j = 0, propy -1  do
            local posY = tamanhoy * j
            
            --[[
            if vezes == nil then vezes = 0 end
            for k = #coins , 1, -1 do
                local coin = coins[k]
                if coin.x >= posX - tamanhox and coin.x <= posX and coin.y >= posY and coin.y <= posY + tamanhoy then  
                    vezes = 15
                end
            end
            
            for l = 0, vezes do
                if love.math.random(0, 100) < percent then
                    local coin = {}
                    coin.w = 10
                    coin.h = 10
                    coin.sp = 150
                    coin.x = love.math.random(posX, posX + tamanhox- coin.w) 
                    coin.y = love.math.random(posY, posY + tamanhoy - coin.h)
                    coin.origemx = coin.x + coin.w/2
                    coin.origemy = coin.y + coin.h/2
                    table.insert(coins,coin)
                end  
            end
            vezes = 0    
            ]]     
        end
    end
end
