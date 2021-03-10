module("luci.controller.autoupdate",package.seeall)

function index()
	entry({"admin","system","autoupdate"},cbi("autoupdate"),_("更新固件"),99)
end
