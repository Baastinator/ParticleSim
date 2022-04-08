local mathb = import("mathb")
local Grid = import("grid")

local PixelSize = 1 --KEEP AT 2
local debugVer = true

local function lightLevelToCol(D, LinMode)
    if (type(D) ~= "number") then error("first input needs to be number",2) end
    LinMode = LinMode or false
    D = D * 15.99
    D = math.floor(D)
    if LinMode then
        return D
    else
        return 2^D
    end
end

local function drawFromArray1D(x, y, T, Grid)
    local P = {}
    local Pit = 0
    P.currLightLevel = nil
    ---@diagnostic disable-next-line: undefined-field
    for i=1,table.getn(T) do
        if lightLevelToCol(T[i],true) == P.currLightLevel then
           if P[Pit][2] == nil then
               P[Pit][2] = 1
           end
           P[Pit][2] = P[Pit][2] + 1

        else
            Pit = Pit + 1 
            P.currLightLevel = lightLevelToCol(T[i],true)
            P[Pit] = {}
            P[Pit][1] = i
            P[Pit][2] = 1
            P[Pit].col = P.currLightLevel
        end
    end
    P.currLightLevel = nil
---@diagnostic disable-next-line: undefined-field
    for i=1,table.getn(P) do --NOCH NICHT FERTIG
        term.drawPixels(
            (x+P[i][1])*PixelSize,
            y*PixelSize,
            2^P[i].col,
            PixelSize*(P[i][2]),
            PixelSize
        )
    end
    return P
end

local function drawFromArray2D(x, y, Grid) -- FIX THIS
    local oT = {} 
    ---@diagnostic disable-next-line: undefined-field
    for i, v in ipairs(Grid.grid) do
        oT[i] = drawFromArray1D(x-1,y+i-1,v, Grid)
    end

    -- for y1=1,table.getn(Grid.grid) do
    --     oT[y1] = drawFromArray1D(x-1,y+y1-1,Grid.grid[y1], Grid)
    -- end
end

local function f(x)
    return x*255/15--math.floor((-480*(0.83^(x+3.08)))+271)
end

local function setPalette()
    for i=0,15 do
        term.setPaletteColor(2^i, colors.packRGB(f(i)/255,f(i)/255,f(i)/255))
    end
end

local function resetPalette()
    for i=0,15 do
        local r, g, b = term.nativePaletteColor(2^i)
        term.setPaletteColor(2^i, colors.packRGB(r,g,b))
    end
end

return {
    lightLevelToCol = lightLevelToCol,
    PixelSize = PixelSize,
    drawFromArray1D = drawFromArray1D,
    drawFromArray2D = drawFromArray2D,
    resetPalette = resetPalette,
    setPalette = setPalette
}