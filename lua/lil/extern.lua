local M = {}

local function feed(foodString)
  if false then return end
  local modified = 'feedkeys("' .. foodString:gsub('[<]', '\\<') .. '")'
  vim.cmd.call(modified)
end -- feed '<C-S-L>' -- no need to put \<C-S-L>

local function prints(s) return function() print(s) end end

local Pack = {}
Pack.__index = Pack

function Pack:__call(...)
  self:run(...)
end

function Pack:new()
  return setmetatable({ 
  }, Pack)
end

local function runval(val, ...)
  if type(val) == nil then
    return false
  elseif type(val) == 'nil' then
    return false
  elseif type(val) == "function" then
    val(...)
    return true
  elseif type(val) == "string" then
    feed(val)
    return true
  end
  error("wrong type " .. type(val))
end

function Pack:run(...)
  local passeds = {}
  for _, val in ipairs(self) do
    if type(val) == 'table' then
      if runval(val[1][val[2]], ...) then
        return true
      end
      table.insert(passeds, val[2])
    elseif runval(val, ...) then return nil end
  end
  table.insert(passeds, "?")
  print(table.concat(passeds, ' / '))
end

function Pack:x(alt)
  if type(alt) == 'table' then
    for _, value in ipairs(alt) do
      table.insert(self, value)
    end
  else
    table.insert(self, alt)
  end
  return self
end

function Pack:__div(alt)
  return self:x(alt)
end

--- @param vals table
local function bundle(vals)
  return setmetatable({ vals = vals or {} }, {
    __index = function (t, k)
      return Pack:new() / { { rawget(t, 'vals'), k } }
    end,
    __newindex = function (t, k, v)
      rawget(t, 'vals')[k] = v
    end
  })
end

M.bundle = bundle

-- local extern = bundle({})
-- M.extern = extern

---------------------------------------

-- ;(Pack:new() / Pack:new() / prints "hi" / prints 'noni'):run()
--
-- local fuz = Pack:new() / prints "byeistan"
-- local dull = Pack:new()
--
-- ;(fuz / prints "gugil"):run()
--
-- ;(dull / nil / fuz):run()
--
--
-- print('---')
-- local grabbed = extern.fuzzy
-- grabbed:run()
-- _ = grabbed / prints "fuzmuz"
-- grabbed:run()
-- extern.fuzzy = prints "assigned fuz"
-- grabbed:run()
--
--
-- extern.jiko = "jjj"
-- extern.jiko:run()

return M
