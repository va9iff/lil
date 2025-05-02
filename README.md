# Features
- action names for external functions
- namespaces for action names
- fallbacks for when the given action name is not defined yet
- elegant and nesting key mapping template
- quick flags to change modes or options


```lua
local lil = require "lil"
local keys = lil.keys
local _ = lil._
local alt = keys.alt
local ctrl = keys.ctrl
local shift = keys.shift
local esc = lil.key "Esc"
local leader = keys.leader

local Leader = leader
local Alt = alt

local v = lil.modes.v

local opts = lil.flags.opts
local log = lil.flags.log

lil.map { 
  -- sequences with nesting
  g = {
    k = 'gk',
    j = 'gj'
  },
  -- nesting of special keys
  [leader] = {
    e = '<Leader>e',
    -- nesting of different type keys
    f = {
      g = '<Leader>fg'
    }
  },
  -- cleaner syntax with no []
  leader + {
    e = "<leader>e"
  },
  -- using modifier keys as template
  [ctrl + _] = {
    s = "<C-s>"
  },
  -- operators still work as the same
  ctrl + _ + {
    s = "<C-s>"
  },
  -- with ctrl
  leader + {
    e = '<C-e>'
  },
  -- sequence with modifier keys
  [ctrl + 'k' .. 'j'] = "<c-k>j",
}

```

# Why?
When you define mappings all over your config folder, it's a nightmare to
manage. Thanks to Folke's lazy package manager, some plugins now may or may not
be loaded at a given time. This is a great thing but now I guess we have to set
keymaps in the plugin's config function, which is spread across the config folder 
and I don't like That. I believe a nicer approach would be something like this:

- define **action** with an **action name**
- bind **action name** to a **keymap**

This splits implementation (action) from the meaning (action name) so I can 
easily put them to whatever key I want, see and manage a nice list. Now look, 
I know about Folke's whichKey plugin too, but I didn't want a popper and it
doesn't have (afaik) the thing I'm about to show:

```lua
-- lua/plugins/telescope.lua    (implementations)
fuzzy.files   = function() ... end
fuzzy.grep    = function() ... end
fuzzy.buffers = function() ... end

-- lua/map.lua    (keymappings)
lil.map {
    leader + {
        fg = fuzzy.grep,
        ff = fuzzy.files
    },
    ctrl + _ + {
        p  = fuzzy.buffers
    }
}
```

I don't wanna see implementation details when I'm defining my 
key mappings. So I wanted to define them somewhere else and 
map their names to keys. It evolved into this nesting templating 
mechanism, where you have lua objects as keys and even some flags. 
Let's take a look at some lil map styles.

# Brief glimpse (legacy style)
Local variables of this snippet are skipped. See [example](./extern.lua) 
for the full snippet or end of the readme to see local variables.
```lua
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
```

# Better style with less `[`brackets`]`
```lua
lil.map {
  Leader + {           -- key + {} means sequence
    d = '<CMD>t.<CR>', -- duplicate line
    y = '"+y',         -- copy system clipboard
    p = '"+p',         -- paste system clipboard
  },
  ctrl + _ + {         -- key + _ + {} means together
    s = { '<CMD>w<CR>', [mode] = { i, n } },
    ['/'] = { 'gcc', [opts] = { remap = true }, [v] = 'gc' },
  },
  alt + _ + {
    n = "*",
  },
  ctrl + alt + _ + {
    c = extern.copy_path,
  },
}
```

## Quick start (Lazy)
```lua
return {
	"va9iff/lil",
	config = function()
        local lil = require("lil")
        local opts = lil.flags.opts
        lil.map {
            [opts] = { noremap = true },
            J = 'jjjjj'
        }
    end
}
```

> lil is an action, not config. you can run it anywhere anytime
> as `require "lil".map {}` or use it for the current buffer with 
> `[opts] = { buffer = 0 } ` flag, just like `vim.keymap.set`.



# `extern`
Assign functions to the names of `extern` objects, like `extern.any = foo`.
`extern.any` always evaluates to a function, doesn't matter if the key is 
defined or not. When you call that function, you'll call the latest value
that is assigned to `extern.any`. That code snipped will print `hi` twice:

```lua
local extern = require "lil".extern
extern.hi()             -- does nothing, nor throw an error
local empty = extern.hi -- we capture the empty version
extern.hi = function()
    print("hi")         -- defined a new version that prints hi
end
extern.hi()             -- this prints hi
empty() -- this one also prints hi because it calls the latest extern.hi
```



## Fallbacks for `extern` keys

Since we can have an empty `extern.hi` it would make sense to have a fallback 
functionality when it's called empty. You can do that with `/` symbol, 
literally divide, but lil overloads the operation division for `extern`
functions. (in fact I originally wanted to have `|` binop but nvim's lua
version didn't support this :p)

```lua
explore = extern.nvim_tree / extern.idk / ":Explore<CR>"
explore() -- will feed the keys of :Explore<CR> cuz all the others are empty
extern.nvim_tree = require('nvim-tree.api').tree.focus
explore() -- will run nvim-tree's focus function since there's new value at extern.nvim_tree
extern.idk = function() print("idk") end -- there's an already defined one before that, so nothing changes
```

> Always the leftmost non-empty `extern` is run

# `bundle`
`extern` is actually just an instance, constructed with `bundle({})` call, 
attached to lil module, so you can easily access it without having to create 
a file that returns a bundle call. But putting all your functions into a single 
proxy may get cluttered as well, so you better use `bundle` to create your own 
namespaces in another files. They will be identical to `extern` but you would 
need to require that file in your implementation definitions to assign their 
keys. 

> **NOTE:** 
> Don't create your bundles right inside the implementation files.
> Bundles can be used with fallbacks in case the implementation is missing.
> Useful for lazy loading. But coupling them with implementations basically
> makes these features useless, since you'd always have them defined. That's
> why I defined a global `extern` bundle, so in your implementation files
> it's easier to import a pre created bundle directly as `require "lil".extern`

# Flags
Unique values (like Symbol type from JavaScript) to be used as keys.
Stored as `lil.flags.opts`, `lil.flags.log`, `lil.flags.off` etc. Those provides
ways to change behavior and state of a current scope. Scope is essentially the 
table that the flag is put in. A flags' values will cascade to the child 
tables. So if you have `[opts] = { silent = true }` for a table, all the sub 
tables will have the same opts. You can always set a new flag to override the 
previous one. Example, `[opts] = {}` will wipe all opts from parent scope.

- `[log] = false` log the actual mapped keys. Use it to check what mappings 
your tables set. Since the style is lil different it may take a while to 
get comfortable with its nesting thinking model. Until that, you can use log 
to print them, instead of trying the mappings by hand.

- `[off] = false` skip the table so no nothing from it gets mapped. 
Flags are used at mapping time. This flag simply tells the mapper to
ignore the table. So you can't turn off an already mapped table in runtime.

- `[opts] = {}` the 4th argument to `func`. For `vim.keymap.set` it's a table

- `[mode] = { "n" }` modes for table to be mapped for. You can put strings, as
well as mode-changing keys created with `lil.mod "n"`. Those keys can change 
mode for a single assignment too, like `[v] = 'jjjjj'` (see mapping examples)

- `[func] = vim.keymap.set` the function to call in each mappings. This one 
is kinda advanced so I'll skip but note that its default value is 
`vim.keymap.set` and this is the only part that lil uses from neovim. 
Rest is just pure lua.

- `[raw] = false` whether the table values are used to create new scopes or 
to be passed as the arguments directly. This doesn't make sense for 
`vim.keymap.set` but for integrations like whichkey this may be relevant. 
For now I don't know if many people would be interested in lil's development
and supporting other keymappers so it's kinda put off for now.

# Local variables
```lua
local lil = require "lil"
local extern, _ = lil.extern, lil._

-- modifier or special keys that are wrapped in < >
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

-- a custom extern bundle (preferably somewhere else)
local fuzzy  = lil.bundle({})
```

If this plugin gets a lil attention, I plan to add `whichKey` integrations.
Otherwise, it's already useful for me so I'll just use it for myself.

--- 

#### vim compatibility

I wouldn't even call it a neovim plugin. it's just a lua magic, since the 
only thing lil uses from neovim is `vim.keymap.set`. I believe it should be 
easy to port it for vim as well, but I really don't know much about vim or 
its scripting language and I'm not interested in using classic vim. but I'd 
appreciate pr for vim compatibility. it's a really nice way of writing maps
and there is nothing that holds classic vim users from trying them out too. 
yes they would be using strings only, but maybe a glance for opportunities 
would bait them enough to switch to the neo side :d

