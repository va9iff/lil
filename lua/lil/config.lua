local outside = 
  type(vim) == 'table' and
  type(vim.keymap) == 'table' and
  type(vim.keymap.set) == 'function' and
  vim.keymap.set 

  or function() print("config.lua: you have no mapper function") end

local utils = require "lil.utils"
local flags = utils.flags

local func = flags.func
local opts = flags.opts
local mode = flags.mode
local off  = flags.off 
local raw  = flags.raw 
local log  = flags.log 

return {
    [func] = outside or function() end,
    [opts] = {},
    [off ] = false,
    [raw ] = false,
    [log ] = false,
    '', '',
    [mode] = { 'n' },
    key = '', -- the accumulated value in `next` and `prev`
  }
