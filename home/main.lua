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
local debugMode = false
local gameLoop = true
local framesElapsed = 0
local particles = List("particles")
local scale = 1
local oldtime = ccemux.milliTime()
local startTime = ccemux.milliTime()

-- side functions

local function userInput()
    local event, key, is_held
    while true do
---@diagnostic disable-next-line: undefined-field
        event, key, is_held = os.pullEvent("key")
        if key == keys.space then
            gameLoop = false
        end
        event, key, is_held = nil, nil, nil
    end
end

local yRange = 10
local xRange = 18

local function addParticles(n)
    for i=1,n do
        particles:add(vec({
            2*xRange*math.random()-xRange,
            2*yRange*math.random()-yRange
        }))
    end
end

-- main functions

local function Init()
    tres.x, tres.y = term.getSize(1)
    res.x = math.floor(tres.x / draw.PixelSize)
    res.y = math.floor(tres.y / draw.PixelSize)
    Grid.init(res.x,res.y)
    term.clear()
    term.setGraphicsMode(2)
    draw.setPalette()
    term.drawPixels(0,0,0,tres.x,tres.y)
end

local function Start()
    addParticles(25000)
end

local gd = {}

local function Update()
    local dt = (oldtime-ccemux.milliTime())/1000
    oldtime = ccemux.milliTime()
    local speed = 1
    local indexesToRemove = {}

    local mu = -1.5
    local g = 9.81
    local L = 1
    for i, v in ipairs(particles) do
        local x = v[1]/4
        local y = 3*v[2]/2
        local movement = (dt*speed) * vec({
            y,
            -mu * y - (g/L) * math.sin(x)
        })
        particles[i] = v + movement  
        if (
            function() return false end or
            -- (y)^2+((math.abs(x)-0*math.pi)*100)^2 < 0.5^2 or
            -- (y)^2+((math.abs(x)-2*math.pi)*100)^2 < 0.5^2 or
            -- (y)^2+((math.abs(x)-4*math.pi)*100)^2 < 0.5^2 or
            y^2 + x^2 > 40^2
        ) then
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
        addParticles(1)
    end    
end
 
local function Render()
    scale = 30
    for i, v in ipairs(particles) do
        Grid.SetlightLevel(math.floor((v[1]*scale)+res.x/2),math.floor((v[2]*scale)+res.y/2),
        (i/#particles)
        -- 1
    )
    end
    draw.drawFromArray2D(0,0,Grid)
end

local function Closing()
    term.clear()
    term.setGraphicsMode(0)
    draw.resetPalette()
    debugLog(framesElapsed*1000/(ccemux.milliTime()-startTime),"fps")
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
---@diagnostic disable-next-line: undefined-field
        os.queueEvent("")
---@diagnostic disable-next-line: undefined-field
        os.pullEvent("")
        framesElapsed = framesElapsed + 1;
    end
    Closing()
end

-- execution

local ok, err = pcall(parallel.waitForAny,main,userInput)
if not ok then
    Closing()
    printError(err)
end
