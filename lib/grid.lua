local grid = {}
local res = {}

local function init(X, Y)
    res.x = X
    res.y = Y
    for y=1,Y do
        grid[y] = {}
        for x=1,X do
            grid[y][x] = 0
        end
    end
end

local function GetlightLevel(X,Y)
    return grid[Y][X].lightLevel
end

local function SetlightLevel(X,Y,Value)
    if (X > 0 and Y > 0 and Y < res.y and X < res.x) then
        grid[Y][X] = Value
    end
end

local function AddlightLevel(X,Y,Value)
    if (X > 0 and Y > 0 and Y < res.y and X < res.x) then
        if (grid[Y][X] + Value > 1) then
            grid[Y][X] = 1
        elseif (grid[Y][X] + Value < 0) then
            grid[Y][X] = 0
        else
            grid[Y][X] = grid[Y][X] + Value
        end
    end
end

local function fill(X,Y,W,H,L,D)
    for y=1,H do
        for x=1,W do
            SetlightLevel(X+x-1,Y+y-1,L)
        end
    end
end

return {
    fill = fill,
    GetlightLevel = GetlightLevel,
    AddlightLevel = AddlightLevel,
    SetlightLevel = SetlightLevel,
    grid = grid,
    init = init
}
