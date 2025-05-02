local M = {}

local utils = require "lil.utils"
M.map = require "lil.map" -- the main mapper function
M.flags = utils.flags     -- acces flags from the keys of this table

local function mod(s)
  if type(s) == 'table' then return { mode = s } end
  return { mode = { s } }
end

M.mod = mod

M.key = require"lil.key"  -- modifier key generator function

M.modes = {
  n = mod 'n',
  v = mod 'v',
  c = mod 'c',
  i = mod 'i',
}

M._ = M.key { expects = true }
M.keys = {
  _      = M._,
  ctrl   = M.key "C",
  shift  = M.key "S",
  leader = M.key "Leader",
  alt    = M.key "M",
  enter  = M.key "CR",
  super  = M.key "D",
}

local extern = require "lil.extern"
M.extern = extern.bundle({})
M.bundle = extern.bundle

M.setup = function(args) 
  if args.map then
    M.map(args.map)
  end
end

return M
