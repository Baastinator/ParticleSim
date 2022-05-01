---@diagnostic disable: lowercase-global
function import(name)
	return dofile("lib/"..name..".lua")
end