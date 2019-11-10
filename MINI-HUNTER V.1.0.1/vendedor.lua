function vendedor(t, vetor_vendedor)
    if t > 2 and t < 10  and #vetor_vendedor <= 0 then
        local vendedor = {}
        vendedor.w = 10
        vendedor.h = 20
        vendedor.contador = 0
        vendedor.x = love.math.random(0, 635)
        vendedor.y = love.math.random(0, 315)
        vendedor.itens = {}
        table.insert(vetor_vendedor, vendedor )
        
    end
    for i=#vetor_vendedor,1,-1 do
        local vendedor = vetor_vendedor[i]
        if t > 10 or vendedor.contador >= 1 then 
            table.remove(vetor_vendedor, 1)
        end
    end

end

function lojamenu(vetor_vendedor,px,py,menu)
    for i=#vetor_vendedor,1,-1 do
        local vendedor = vetor_vendedor[i]
        local distancia = (((px-vendedor.x)^2 + (py - vendedor.y)^2)^(1/2))
        if distancia < 200 then
            vendedor.contador = vendedor.contador + 1
            return 2
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
 
