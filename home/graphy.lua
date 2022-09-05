-- imports
package.path = "/lib/?.lua;/?.lua"

local Grid = require("grid")
local draw = require("draw")
require("tblclean")
require("linalg")
require("List")
-- require("vec2")

-- globals

local res = {}
local tres = {}
local debugMode = false
local gameLoop = true
local framesElapsed = 0
local particles = List("particles")
local scale = 1
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

local function addParticles(res,haha)
    local rMax = (function() 
        local max = 0 
        for i,v in ipairs(haha) do 
            max = math.max(max, v.r)
        end 
        return max 
    end)()
    for i=1,#haha do
        particles:add(vec({
            (haha[i].t/360 + 0.5)*res.x,
            haha[i].r/rMax*res.y
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
    local file = fs.open("home/debug/sounds.txt","r")
    local bruh = file.readAll()
    file.close()
    local graphy = textutils.unserialise(bruh)
    addParticles(res,graphy)
end

local gd = {}

local function Update()
 
end
 
local function Render()
    scale = 1
    for i, v in ipairs(particles) do
        Grid.SetlightLevel(math.floor((v[1]*scale)),math.floor((v[2])),1)
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
