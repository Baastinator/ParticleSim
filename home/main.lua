-- imports

dofile("lib/import.lua")

local Grid = import("grid")
local draw = import("draw")
import("tblclean")
import("linalg")
import("List")
-- import("vec2")

-- globals

local res = {}
local tres = {}
local key
local debugMode = false
local gameLoop = true
local FPS = 100
local framesElapsed = 0
local particles = List("particles")
local scale = 1
local oldtime = ccemux.milliTime()

-- side functions

local function userInput()
    local event, is_held
    while true do
---@diagnostic disable-next-line: undefined-field
        event, key, is_held = os.pullEvent("key")
        if key == keys.space then
            gameLoop = false
        end
        event, is_held = nil, nil
    end
end

local function setVertices()
    local mult = 0.1
    local yRange = 5
    local xRange = 5
    for x=-xRange,xRange,mult do
        for y = -yRange, yRange,mult do
            particles:add(vec({
                2*xRange*math.random()-xRange,
                2*yRange*math.random()-yRange
            }))
        end
    end
end

-- main functions

local function Init()
    tres.x, tres.y = term.getSize(1)
    res.x = math.floor(tres.x / draw.PixelSize)
    res.y = math.floor(tres.y / draw.PixelSize)
    Grid.init(res.x,res.y)
    term.clear()
    term.setGraphicsMode(1)
    draw.setPalette()
    term.drawPixels(0,0,1,tres.x,tres.y)
end

local function Start()
    setVertices()
end

local gd = {}

local function Update()
    local dt = (oldtime-ccemux.milliTime())/1000
    oldtime = ccemux.milliTime()
    local timeScale = 1/10
    local indexesToRemove = {}
    for i, v in ipairs(particles) do
        local new = (dt*timeScale) * vec({
            -- -0.05*v[1]-v[2],
            -- v[1]     -0.05*v[2]
            v[2]^3-9*v[2],
            v[1]^3-9*v[1]
        })
        particles[i] = v + new 
        if (math.abs(v[1]) > 6 or math.abs(v[2]) > 6) then
           table.insert(indexesToRemove,i) 
        end
    end
    local indexReverse = {}
    for i, v in ipairs(indexesToRemove) do
        local length = #indexesToRemove
        indexReverse[length-i+1] = v
    end
    for i, v in ipairs(indexReverse) do
        particles:remove(v)
    end    
end
 
local function Render()
    scale = 30
    for i, v in ipairs(particles) do
        Grid.SetlightLevel(math.floor((v[1]*scale)+res.x/2),math.floor((v[2]*scale)+res.y/2),1)
    end
    local g = {}
    for i, v in ipairs(g) do
        g[i] = {}
        for i2, v2 in ipairs(v) do
            if (v2 ~= 0) then g[i][i2] = v2 end
        end
    end
    draw.drawFromArray2D(0,0,Grid)
end

local function Closing()
    term.clear()
    term.setGraphicsMode(0)
    draw.resetPalette()
    if not debugMode then
        term.clear()
        term.setCursorPos(1,1)
    end
end

-- main structure

local function main()
    Init()
    Start()
    while gameLoop do
        Grid.init(res.x,res.y)
        Update()
        Render()
        sleep(1/FPS)
        framesElapsed = framesElapsed + 1;
    end
    Closing()
end

-- execution

parallel.waitForAny(main,userInput)
