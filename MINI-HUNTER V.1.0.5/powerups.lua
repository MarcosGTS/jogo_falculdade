function powerups (item)
    if item % 10 == 1 and loja.podeComprarB then
        player.sp = player.sp * 1.25
        loja.podeComprarB = false
    end
    if math.floor(item/10) % 10 == 1 and loja.podeComprarT then
        multiplicadorC = 1.5
        loja.podeComprarT = false
    end
    if math.floor(item/100) % 10 == 1 and loja.podeComprarBa then
        multiplicadorD = 1.25
        loja.podeComprarBa = false
    end
end