function	inimigoload()
	inimigos = {}
end 

function criaInimigo()
		
	if math.random(0,100) < 2 then -- criando geraçao aleatoria 	
		local nave = {} 					-- criando um inimigo com suas caracteristicas 
		nave.x = love.math.random(0, window_w)
		nave.y = love.math.random(0, window_h)
		nave.w = 10
		nave.h = 10
		nave.velocidade = 100
		nave.direcao = love.math.random(0, 2* math.pi)
		table.insert(inimigos,nave) 		-- inserindo no vetor inimigos 
	end 

end
function inimigoMove(dt)
	for i=#inimigos,1,-1 do 				-- loop para acessar todos os inimigos individualmente
		local nave = inimigos[i] 		--passando todas as caracteriscas de um inimigo para uma variavel
		nave.x = nave.x + math.cos(nave.direcao)* nave.velocidade * dt
		nave.y = nave.y + math.sin(nave.direcao)* nave.velocidade * dt
		if nave.x > window_w or nave.x < 0 or nave.y > window_h or nave.y < 0 then
			table.remove(inimigos, i)
		end
	end
	
end

function inimigodraw()
	for i=#inimigos,1,-1 do
		local inimigo = inimigos[i] 
		love.graphics.setColor(0,1,0)
		love.graphics.rectangle("fill",inimigo.x,inimigo.y, inimigo.w,inimigo.h) 
	end
end



function AABB(x1,x2,y1,y2,w1,w2,h1,h2) -- colisao AABB
	return (x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1)  
end