function vendedor(t, combate,vetor_vendedor,rounds,window_w, window_h)
    if combate == false and #vetor_vendedor <= 0 and rounds > 0 then
        local vendedor = {}
        vendedor.w = 10
        vendedor.h = 20
        vendedor.x = window_w/2
        vendedor.y = window_h/2 - 175
        vendedor.itens = {}
        table.insert(vetor_vendedor, vendedor )
        
    end
    for i=#vetor_vendedor,1,-1 do
        local vendedor = vetor_vendedor[i]
        if combate == true  then 
            table.remove(vetor_vendedor, 1)
        end
    end

end

function lojamenu(vetor_vendedor,px,py,menu)
    for i=#vetor_vendedor,1,-1 do
        local vendedor = vetor_vendedor[i]
        local distancia = (((px-vendedor.x)^2 + (py - vendedor.y)^2)^(1/2))
        if distancia < 200 then
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
 
