local PlaceIDs = {
    ["286090429"] = "Arsenal",
    ["2788229376"] = "DaHood",
    ["6808489605"] = "Aimblox",
}

local place = PlaceIDs[tostring(game.PlaceId)] or "Universal"
loadstring(game:HttpGet("https://raw.githubusercontent.com/0rxpt/Loadstrings/main/Games/" .. place .. "/init.lua"))()