local M = {}

local function copy(tbl) 
  local result = {}
  for key, value in pairs(tbl) do
    result[key] = value
  end
  return result
end
M.copy = copy

local function printable(value, nest)
  if nest == nil then nest = 9 end
  if type(value) == "string" then
    return value
  elseif type(value) == 'table' then
    if nest <= 0 then return '{...}' end
    local result = {}
    for key, val in pairs(value) do
      table.insert(result, printable(key, nest - 1) .. "=" .. printable(val, nest - 1))
    end
    return "{" .. table.concat(result, ", ") .. "}"
  elseif type(value) == "function" then
    return "F" .. string.sub(tostring(value), 12) .. ""
  end
  return tostring(value)
end
M.printable = printable

M.flags = { -- human grabbable names, unique values
  opts = {},
  func = function() end, -- highlight it as funcs:d
  off  = {},
  mode = {}, 
  log  = {},
  raw  = {},
}

M.symbols = { -- unique value table. to check M.symbols[possiblyFlag]
  [M.flags.opts] = true,
  [M.flags.func] = true,
  [M.flags.raw]  = true,
  [M.flags.off]  = true,
  [M.flags.mode] = true,
  [M.flags.log]  = true
}

--- @param target table
--- @param source table
M.cascadeSymbols = function(target, source)
  source = type(source) == 'table' and source or {}
  local result = {}
  for key, value in pairs(target) do
    result[key] = value
  end
  for key, value in pairs(source) do
    if M.symbols[key] then 
        result[key] = value
    end
  end
  return result
end


--- @type fun(m: string, l: string, r: any, o?: any, data?: any)
M.logmap = function(m, l, r, o)
  print(
    printable(m), 
    printable(l), 
    printable(r), 
    printable(o))
end

return M
