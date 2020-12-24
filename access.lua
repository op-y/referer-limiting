local kong = kong
local ngx = ngx
local req_get_headers = ngx.req.get_headers

local REFERER = "Referer"
local _M = {}

local function process(conf)
  local referer = req_get_headers()["Referer"]
  kong.log.err("referer is: ", referer)
  -- 不带 Referer Header 的时候默认放行
  if referer == nil or referer == "" then
    if conf.ignore_no_referer then
      return
    end
  end
  -- 带 Referer Header 的时候必须在允许通过的域中
  local is_matched = false
  for k, v in pairs(conf.valid_referer) do
    kong.log.info("try to comapre referer: ", k, "==>", v)
    local m, err = ngx.re.match(referer, v, "o")
    if m then
      is_matched = true
      kong.log.info("matched: ", m[0])
      break
    else
      if err then
        kong.log.err("FAILED to execute regex match: ", err)
      else
        kong.log.info("not match: ", referer, " vs ", v)
      end
    end
  end
  if is_matched then
    return
  else
    ngx.say("Forbidden")
    ngx.exit(ngx.HTTP_FORBIDDEN)
  end
end

function _M.execute(conf)
  process(conf)
end

return _M
