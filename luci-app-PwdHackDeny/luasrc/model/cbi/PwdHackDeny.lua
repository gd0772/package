local fs  = require "nixio.fs"
local sys = require "luci.sys"
local uci = require "luci.model.uci".cursor()
local ipc = require "luci.ip"
local button = ""
local state_msg = ""
local m,s,n
local running=(luci.sys.call("pidof PwdHackDeny.sh > /dev/null") == 0)
local button = ""
local state_msg = ""

if running then
        state_msg = "<b><font color=\"green\">" .. translate("正在运行") .. "</font></b>"
else
        state_msg = "<b><font color=\"red\">" .. translate("没有运行") .. "</font></b>"
end

m = Map("PwdHackDeny", translate("PwdHackDeny"))
m.description = translate("<font style='color:green'>用于监控SSH以及路由异常登录情况，频率为10分钟一次，密码错误历史纪录达到5次的IP，不论内外网，都永久禁止连接dropbear以及uhttp的登录端口，不会因为重启而停止，直到手动删除禁止名单里相应的IP为止。</font>" .. button
        .. "<br/><br/>" .. translate("运行状态").. " : "  .. state_msg .. "<br />")

s = m:section(TypedSection, "PwdHackDeny")
s.anonymous=true
s.addremove=false
enabled = s:option(Flag, "enabled", translate("启用"), translate("启用或禁用功能。要先禁用、再去更改相关功能的端口、再启用。"))
enabled.default = 0
enabled.rmempty = true

s = m:section(TypedSection, "PwdHackDeny")

s:tab("config1", translate("<font style='color:gray'>SSH拒绝登录日志</font>"))
conf = s:taboption("config1", Value, "editconf1", nil, translate("<font style='color:red'>同一IP仅显示最后一条记录,新的信息需要刷新页面才会有所显示。</font>"))
conf.template = "cbi/tvalue"
conf.rows = 25
conf.wrap = "off"
conf.readonly="readonly"
--conf:depends("enabled", 1)
function conf.cfgvalue()
	return fs.readfile("/tmp/badip.dropbear.log", value) or ""
end

s:tab("config2", translate("<font style='color:gray'>web拒绝登录日志</font>"))
conf = s:taboption("config2", Value, "editconf2", nil, translate("<font style='color:red'>同一IP仅显示最后一条记录,新的信息需要刷新页面才会有所显示。</font>"))
conf.template = "cbi/tvalue"
conf.rows = 25
conf.wrap = "off"
conf.readonly="readonly"
--conf:depends("enabled", 1)
function conf.cfgvalue()
	return fs.readfile("/tmp/badip.router.log", value) or ""
end

s:tab("config3", translate("<font style='color:black'>SSH禁止IP</font>"))
conf = s:taboption("config3", Value, "editconf3", nil, translate("如要去除，删除然后重启系统即可。"))
conf.template = "cbi/tvalue"
conf.rows = 25
conf.wrap = "off"
function conf.cfgvalue(self, section)
    return fs.readfile("/etc/badip.dropbear") or ""
end
function conf.write(self, section, value)
    if value then
        value = value:gsub("\r\n?", "\n")
        fs.writefile("/tmp/badip.dropbear", value)
        if (luci.sys.call("cmp -s /tmp/badip.dropbear /etc/badip.dropbear") == 1) then
            fs.writefile("/etc/badip.dropbear", value)
        end
        fs.remove("/tmp/badip.dropbear")
    end
end

s:tab("config4", translate("<font style='color:black'>web禁止IP</font>"))
conf = s:taboption("config4", Value, "editconf4", nil, translate("如要去除，删除然后重启系统即可。"))
conf.template = "cbi/tvalue"
conf.rows = 25
conf.wrap = "off"
function conf.cfgvalue(self, section)
    return fs.readfile("/etc/badip.router") or ""
end
function conf.write(self, section, value)
    if value then
        value = value:gsub("\r\n?", "\n")
        fs.writefile("/tmp/badip.router", value)
        if (luci.sys.call("cmp -s /tmp/badip.router /etc/badip.router") == 1) then
            fs.writefile("/etc/badip.router", value)
        end
        fs.remove("/tmp/badip.router")
    end
end

local e=luci.http.formvalue("cbi.apply")
if e then
  io.popen("/etc/init.d/PwdHackDeny start")
end

return m

