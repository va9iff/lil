
local M = require("lil")

local function test()
  print("test")
  local opts = M.flags.opts
  local func = M.flags.func
  local off = M.flags.off 
  local mode = M.flags.mode
  local log = M.flags.log 
  local raw = M.flags.raw 

  local n = M.modes.n
  local v = M.modes.v
  local c = M.modes.c
  local i = M.modes.i



  M.map {
    [log] = true,
    [{'<M-', '>'}] =  {
      [mode] = { v, i, 'c' },
      j = 'gitoj',
      k = 'gitok',
      i = {
        i={
          i = {
            ooooooooooooooo = {
              [mode] = { 'i' },
              k = "okey"
            },
            9999
          }
        }
      }
    },
    a = {
      [v] = 'jajaka',
      t = 'ji',
      -- [leaf] = {'dsjfai'}
    },
    -- that's awesome !!!!!!!!!!!!!!!!
    -- [ctrl + shift] = {
    -- },
    -- [ctrl] = {}
    ["<L>"] = {
      [opts] = { buf = 9999, quf = 8 },
      f = {
        [c] = 'ji',
        f = {
          -- [n + v] = 'fifo', -- overload arithmetics methods
          -- [{ n, v }] = 'fifo', -- or maybe that?
          [n] = 'fifo'
        }
      }
    },
    u = {
      uuuu = function() end,
      [c] = {
        [func] = function(m,l,r,o,nextData)
          print(m,l,r,o, '(customm)', nextData)
        end,
        a = 0,
        b = 9,
        [opts] = {le = "args"},
        {
          [raw] = true,
          [off] = true,
          [opts] = 'rawbidi raw balam',
          -- [{"~~", "~~~"}] = {
          jio = 'zamazingo',
          -- },
          j = { aaaa = 'argiu' },
          k = "can't see uj",
          -- [{'s'}] = 99 -- should break
        },
        c = 7,
        [opts] = 'reel opti'
      },
      [{mode = { 'opts' }}] = {
        jj = 'fakeup'
      }
    },
    j = 98,

    -- backwards compatibility for weird keys
    ["<C-"] = {
      [off] = true,
      ["S>"] = ":w<cr>"
    }
  }

  M.map { [{'<M-','>'}] = {
    j = {
      [{'<C-','>'}] = {
        j = 'huplet bebem',
        d = 'guplet bebem'
      }
    }
  } }

  -- local function fuzzy_find(buf, telescope)
  local function fuzzy_find(buf, mapper, telescope)
    telescope = {close = function()end}
    mapper = function(...) end
    buf = 9
    M.map {
      [opts] = { buf = buf }, 
      [func] = mapper,
      [n] = {
        y = telescope.close,
        x = 'teto'
      }, -- this also works
      [i] = {
        ['<Esc>'] = '<Esc><Esc>'
      }
    }
  end

  fuzzy_find(9)


  local _ = M.key { expects = true }
  local ctrl = M.key "C"
  local shift = M.key "S"
  local leader = M.key "Leader"

  M.map { 
    [log] = true,
    [{'<M-', ">"}] = {
      K = {
        [mode] = { n, v, 'i' },
        [func] = function(m, l, r, o, d) 
          print('>>>>', m, l, r, o, d, d.mode)
        end,
        [ctrl + _] = {
          T = "puerto rico"
        }
      }
    },
    [ctrl] = {
      O = "OOOO"
    },
    [ctrl + shift + _] = {
      Y = {
        [ctrl + shift + _] = {
          Y = "YAGUUU"
        }
      },
      S = "SUPA NIGA"
    },
    [leader] = {
      [ctrl + shift + _] = {
        Y = {
          [ctrl + shift + _] = {
            Y = "YA YAY A YA"
          }
        },
        S = "SUPA NIGA"
      },
      [ctrl + shift + _] = {
        E = "MEGA NIGA"
      },
      D = {
        [ctrl] = 'diego', -- don't work?
        [ctrl + _] = {
          c = 'caqal',
          [shift] = "cuqal"
        }
      },
      ["s" + _] = {
        [ctrl] = {
          'subparb !! errorcik'
        }
      }
    },
  }

  M.map {
    -- [func] = vim.keymap.set,
    [ctrl + _] = {
      s = ":echo 'suppaa niggggggggaaaaaaaaaaaaaaa'<CR>"
    }
  }
end

test()

return { test = test }
