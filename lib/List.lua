---@diagnostic disable: undefined-field


local function add(self,Element)
    table.insert(self,Element)
end

local function get(self,index)
    if #self < index then error(Type.." List get: Outside range",2) end
    return self[index]
end

local function set(self,index, value)
    if #self < index then error(Type.." List set: Outside range",2) end
    self[index] = value
end

local function remove(self,index)
    if #self < index then error(Type.." List remove: Outside range",2) end
    for i, v in ipairs(self) do
        self[i] = self[i+1] or nil
    end
end

local function clear(self)
    for i, v in ipairs(self) do
        self[i] = nil 
    end
end

function List(type)
    Type = type
    return setmetatable({
        type = Type,
    },{
        __index = {
            clear = clear,
            set = set,
            remove = remove,
            get = get,
            add = add
        }
    })
end
