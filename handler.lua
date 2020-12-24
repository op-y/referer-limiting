local BasePlugin = require "kong.plugins.base_plugin"

local access = require "kong.plugins.referer-limiting.access"

local RefererLimitingHandler = BasePlugin:extend()

RefererLimitingHandler.PRIORITY = 799

function RefererLimitingHandler:new()
  RefererLimitingHandler.super.new(self, "referer-limiting")
end

function RefererLimitingHandler:access(conf)
  RefererLimitingHandler.super.access(self)
  access.execute(conf)
end

return RefererLimitingHandler
