local mods = {}

for _, mod in getloadedmodules() do
    if mod.Name:match("Enemies") then
        if not mods[mod.Name] then
            mods[mod.Name] = require(mod)
        end
    end
end

for i, v in mods.Enemies do
    print(i)

    for i2, v2 in mods.Enemies.Gamemodes do
        print(i2)
        for i3, v3 in mods.Enemies.Gamemodes.InvasionShip do
            print(i3)
            for i4, v4 in v3 do
                print(i4, v4)
            end
        end
        break
    end

    break
end