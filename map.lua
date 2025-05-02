local builtin = require "lil.core"
local defaults = require "lil.config"

return function (map)
  return builtin(defaults, '', map)
end

