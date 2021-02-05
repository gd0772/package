module("luci.controller.koolproxy",package.seeall)
function index()
	if not nixio.fs.access("/etc/config/koolproxy")then
		return
	end
	entry({"admin","services","koolproxy"},cbi("koolproxy/global"),_("KPR去广告"),1).dependent=true
	entry({"admin","services","koolproxy","rss_rule"},cbi("koolproxy/rss_rule"), nil).leaf=true
end
