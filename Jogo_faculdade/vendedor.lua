function vendedor(t, vetor_vendedor)
    if t > 2 and t < 10  and #vetor_vendedor <= 0 then
        local vendedor = {}
        vendedor.w = 10
        vendedor.h = 20
        vendedor.x = love.math.random(0, 635)
        vendedor.y = love.math.random(0, 315)
        vendedor.itens = {}
        table.insert(vetor_vendedor, vendedor )
    end

    if t > 10 then 
        table.remove(vetor_vendedor, 1)
    end
end


function itens (vetor_vendedor)
    for i=1 , #vetor_vendedor, 1 do
        local vendedor = vetor_vendedor[i]
        if #vendedor.itens == 1 then
            chance = math.random(1,2)
            if chance >= 0 --[[and chance <= 1]] then
                local bota = {}
                bota.preco = 35
                bota.status = 50
                
                table.insert(vendedor.itens, bota)
            end
        end
    end  
end
function compras(vetor_vendedor,coins,player)
    for i=1 , #vetor_vendedor, 1 do
        local vendedor = vetor_vendedor[i]
        if  ((player.x-vendedor.x)^2 + (player.y - vendedor.y)^2)^(1/2) < 100 and love.keyboard.isDown("b") then            
            local itens = vetor_vendedor.itens[1]
            if coins >= itens.bota[1] then
                coins = coins - itens.bota[1]
                player.sp = player.sp + itens.bota[2]
            end
        end
    end
end

function draw_vendedor(vetor_vendedor,px,py)
    for i=1 , #vetor_vendedor, 1 do
        local vendedor = vetor_vendedor[i]

        love.graphics.setColor(0,1, 1 )
        
        love.graphics.rectangle("fill", vendedor.x, vendedor.y, vendedor.w, vendedor.h)
        if ((px-vendedor.x)^2 + (py - vendedor.y)^2)^(1/2) < 100 then
            love.graphics.print("PRESS B", vendedor.x - 15, vendedor.y - 20)
            
        end
    end    
end
 
