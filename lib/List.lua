---@diagnostic disable: undefined-field


local function add(a,Element)
    table.insert(a,Element)
    return table.getn(a)
end

local function get(a,index)
    if #a < index then error(Type.." List get: Outside range",2) end
    return a[index]
end

local function set(a,index, value)
    if #a < index then error(Type.." List set: Outside range",2) end
    a[index] = value
end

local function remove(a,index)
    if #a < index then error(Type.." List remove: Outside range",2) end
    for i=index,table.getn(a) do
        a[i] = a[i+1] or nil
    end
end

local function clear(a)
    for i, v in ipairs(a) do
        a[i] = nil 
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
