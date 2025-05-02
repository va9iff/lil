local lil = require "lil"
local extern, _ = lil.extern, lil._

-- modifier or special keys wrapped in < >
local ctrl   = lil.key "C"
local shift  = lil.key "S"
local alt    = lil.key "M"
local leader = lil.key "Leader"

-- mode changers for [n] = {} or [modes] = { n, v } usage
local n  = lil.mod "n"
local v  = lil.mod "v"
local i  = lil.mod "i"

-- unique flag keys to set different options
local mode = lil.flags.mode
local log  = lil.flags.log
local raw  = lil.flags.raw
local off  = lil.flags.off
local opts = lil.flags.opts
local func = lil.flags.func

local fuzzy  = lil.bundle({})

local loads = function(str) return function() require(str) end end

lil.map {
  J = 'jjjjj',            -- simple mappings
  K = {
    [v] = "kkkkk",        -- easy mode changes for a single key mappings
    [n] = vim.lsp.buf.hover
  },
  [ctrl + "z"] = "u",     -- simple modifier keys
  [ctrl + shift + _] = {  -- elegant templating for modifier keys
    s = ":w ",
    q = ":qa!"
  },
  [leader] = {                  -- simple nesting logic for sequentials mappings
    [opts] = { silent = true }, -- cascading opts for the scope and inner scopes
    f = {
      f = extern.fuzzy_find, -- define implementation somewhere else. be clean.
    },
    fb = extern.fuzzy_bufs,  -- or define sequances without nestings
  },
  [leader .. 'e'] = '<CMD>Expl<CR>', -- sequance expressions with modifier keys
  ["s" + _] = { -- other ways around? sure thing. you shall decide the style
    [ctrl] = "<CMD>w<CR>",
  },
  [ctrl + _] = {     -- <C-...>        visual nesting of sequance and modifiers.
    k = {            -- <C-K>...       anything nestable is infinitely nestable.
      [ctrl + _] = { -- <C-K><C-...>
        n = "bnext", -- <C-K><C-N>               you can map at any nest level.
        l = {        -- <C-K><C-l>...            then continue nesting again.
          l = ":LspStart<CR>", -- <C-k><C-l>l    sequance and then modifieds,
          s = ":LspStop<CR>"   -- <C-k><C-l>s    or sequances of modifieds.
        }
      }
    },
    b = extern.bookmark, -- the latest assigned `extern.bookmark` will be called
    l = loads "bookmark_define", -- so you can load extern definitions any time
    e = extern.tree / extern.explore / ":Explore", -- fallbacks for when empty
    p = fuzzy.commands / ":", -- custom extern bundles for namespacing
    { -- you can open directly a new table without any keys.
      [log] = true,   -- this will cascade all the options from the parent. it's
      [mode] = { 'i' }, -- useful for when you wanna quickly use different flags
      c = "<Esc>"   -- since it uses the nest's keys and the flags of the parent
    },
  },
}

