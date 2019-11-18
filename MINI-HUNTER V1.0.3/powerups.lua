function powerups (item)
    if item % 10 == 1 and loja.podeComprarB then
        player.vel = player.vel * 1.25
        loja.podeComprarB = false
    end
    if math.floor(item/10) % 10 == 1 and loja.podeComprarT then
        carga_total = 12
        loja.podeComprarT = false
    end
    if math.floor(item/100) % 10 == 1 and loja.podeComprarBa then
        arma.dano = arma.dano * 1.25
        loja.podeComprarBa = false
    end
end