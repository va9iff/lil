--- modifier keys

local function key(tbl)
  if type(tbl) == "string" then tbl = { modifiers = { tbl } } end
  tbl.modifiers = tbl.modifiers or {}
  tbl.expects = tbl.expects or false
  tbl.key = key -- a unique identifier for us to recognize whether 
  -- a table is created with modifier keys or passed as literal
  local dashedMods = table.concat(tbl.modifiers, '-')
  tbl.pure = dashedMods
  if tbl.expects then
    tbl[1], tbl[2] = '<' .. dashedMods .. '-', '>'
  else
    tbl[1], tbl[2] = '<' .. dashedMods .. '>', ''
  end
  return setmetatable(tbl, {
    __concat = function(t1, t2) 
      if type(t1) == 'string' then -- so the table is the other one
        return t1 .. t2[1] .. t2[2]
      end
      if type(t2) == 'string' then -- so the table is the other one
        return t1[1] .. t1[2] .. t2
      end
      if type(t1) == 'table' and type(t2) == 'table' then
      if type(t2) == 'table' and t2.key ~= key then return { [t1] = t2 } end
        local concat_ = "you cannot concat a key template (_ ..) or (.. _)"
        assert(not t1.expects,concat_)
        assert(not t2.expects,concat_)
        return t1[1] .. t1[2] .. t2[1] .. t2[1]
      end
      error("concat with an unknown type")
    end,
    __add = function (t1, t2)
      if type(t2) == 'table' and t2.key ~= key then return { [t1] = t2 } end
      if type(t2) == 'string' then t2 = { modifiers = { t2 } } end
      if type(t1) == 'string' then t1 = { modifiers = { t1 } } end
      assert(type(t1) == 'table' and type(t2) == 'table', 
        "mod key additions are only supported between mod keys or strings")
      local modifiers = {}
      for _, m in ipairs(t1.modifiers) do table.insert(modifiers, m) end
      for _, m in ipairs(t2.modifiers) do table.insert(modifiers, m) end
      return key({ 
        modifiers = modifiers,
        expects = t1.expects or t2.expects
      })
    end,
    __sub = function(t1, t2)
      return t1 + key { expects = true } + t2
    end,
    __call = function()
      error("cannot call a key. did you mean addition + operator?")
    end
    -- __call = function (t, map) -- ctrl {} equivalent for [ctrl + _] = {}
    --   return { -- works. but I prefer consistent [] syntax
    --     [t + modkey({ expects = true })] = map
    --   }
    -- end
  })
end

return key
