local mathb = require("mathb")
local Grid = require("grid")

local PixelSize = 1 --KEEP AT 2

local debugB = false

local function lightLevelToCol(D, LinMode)
    if (type(D) ~= "number") then error("first input needs to be number",2) end
    return D*255
end

local function drawFromArray1D(x, y, T, Grid)
    local P = {}
    local Pit = 0
    P.currLightLevel = nil
    for i,v in ipairs(T) do
        if lightLevelToCol(v,true) == P.currLightLevel then
           if P[Pit][2] == nil then
               P[Pit][2] = 1
           end
           P[Pit][2] = P[Pit][2] + 1

        else
            Pit = Pit + 1 
            P.currLightLevel = lightLevelToCol(v,true)
            P[Pit] = {}
            P[Pit][1] = i
            P[Pit][2] = 1
            P[Pit].col = P.currLightLevel
        end
    end
    P.currLightLevel = nil
    for i,v in ipairs(P) do
        term.drawPixels(
            (x+v[1])*PixelSize,
            y*PixelSize,
            v.col,
            PixelSize*(v[2]),
            PixelSize
        )
    end
    return P
end

local function drawFromArray2D(x, y, Grid) -- FIX THIS
    local oT = {} 
    for i, v in ipairs(Grid.grid) do
        oT[i] = drawFromArray1D(x-1,y+i-1,v, Grid)
    end
    if debugB then
        debugLog(oT,"DFA2D")
        debugB = false
    end
end

local function f(x)
    return
    x
    -- math.floor((-480*(0.83^(x+3.08)))+271)
end

local function rgb(x)
    return 255^2/x
end

local function setPalette()
    local i = 0
    for r=0,7 do
        for g=0,7 do
            for b=0,3 do
                local rgbMode = false
                local color 
                if (rgbMode) then
                    color = colors.packRGB(r/7,g/7,b/3)
                else
                    color = colors.packRGB(i/255,i/255,i/255)
                end
                term.setPaletteColor(i, color)
                i = i + 1
            end
        end
    end
end

local function resetPalette()
    for i=0,15 do
        local r, g, b = term.nativePaletteColor(2^i)
        term.setPaletteColor(2^i, colors.packRGB(r,g,b))
    end
end

return {
    debugB = debugB,
    lightLevelToCol = lightLevelToCol,
    PixelSize = PixelSize,
    drawFromArray1D = drawFromArray1D,
    drawFromArray2D = drawFromArray2D,
    resetPalette = resetPalette,
    setPalette = setPalette
}