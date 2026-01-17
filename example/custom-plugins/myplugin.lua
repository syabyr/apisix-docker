local core     = require("apisix.core")
local io       = require("io")
local ngx      = ngx

local plugin_name = "myplugin"

local plugin_schema = {
    type = "object",
    properties = {
        path = {
            type = "string"
        },
    },
    required = {"path"}
}

local _M = {
    version = 1.0,
    priority = 1000,
    name = plugin_name,
    schema = plugin_schema
}

function _M.check_schema(conf)
    local ok, err = core.schema.check(plugin_schema, conf)
    if not ok then
        return false, err
    end
    return true
end


function _M.log(conf, ctx)
    -- Log the plugin configuration and the request context
    core.log.warn("conf: ", core.json.encode(conf))
    core.log.warn("ctx: ", core.json.encode(ctx, true))
end

function _M.access(conf, ctx)
    ngx.log(ngx.INFO, "Access phase of myplugin")
	-- 可以访问请求头、请求体等数据 
	local headers = ngx.req.get_headers()
	ngx.log(ngx.INFO, "Request headers: ", ngx.encode_base64(ngx.encode_args(headers)))
	-- 可以修改请求头、请求体等数据 
	ngx.req.set_header("X-Custom-Header", "Custom Value")
end

return _M