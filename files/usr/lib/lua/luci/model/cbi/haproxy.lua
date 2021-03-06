--Alex<1886090@gmail.com>
local fs = require "nixio.fs"

function sync_value_to_file(value, file) --用来写入文件的函数，目前这种方式已经弃用
	value = value:gsub("\r\n?", "\n")
	local old_value = nixio.fs.readfile(file)
	if value ~= old_value then
		nixio.fs.writefile(file, value)
	end	
end
local state_msg = ""
local haproxy_on = (luci.sys.call("pidof haproxy > /dev/null") == 0)
local router_ip = luci.sys.exec("uci get network.lan.ipaddr")
if haproxy_on then	
	state_msg = "<b><font color=\"green\">" .. translate("Running") .. "</font></b>"
else
	state_msg = "<b><font color=\"red\">" .. translate("Not running") .. "</font></b>"
end
m=Map("haproxy",translate("HAProxy"),translate("HAProxy能够检测SS服务器的联通情况，从而实现负载均衡和高可用的功能，支持主备用服务器宕机自动切换，并且你可以设置多个主服务器用于分流，设置每个分流节点的流量比例等。前提条件是你的所有ss服务器的【加密方式】和【密码】必须一致。注意设置多个主服务器进行分流不会加快你的网页浏览速度，但是会提高下载速度和网络稳定性，妈妈再也不用担心单节点掉线了。使用方法：只要把下面配置文件的倒数几行改成你的服务器ip地址和端口，然后开启【Redsocks2】服务，选择Shadowsocks，将服务器地址填写为【127.0.0.1】，端口【2222】，其他参数和之前一样即可，你可以通过访问【路由器的IP:1111/haproxy】输入用户名admin，密码root来观察各节点健康状况，红色为宕机，绿色正常,使用说明请<a href='http://www.right.com.cn/forum/thread-198649-1-1.html'>点击这里</a>") .. "<br><br>后台监控页面：<a href='http://" .. router_ip .. ":1111/haproxy'>" .. router_ip .. ":1111/haproxy</a>  用户名admin，密码root" .. "<br><br>状态 - " .. state_msg)
s=m:section(TypedSection,"arguments","")
	s.addremove=false
	s.anonymous=true
	view_enable = s:option(Flag,"enabled",translate("Enable"))
	--通过读写配置文件控制HAProxy这种方式已经弃用
	--view_cfg = s:option(TextValue, "1", nil)
	--view_cfg.rmempty = false
	--view_cfg.rows = 43

	--function view_cfg.cfgvalue()
	--	return nixio.fs.readfile("/etc/haproxy.cfg") or ""
	--end
	--function view_cfg.write(self, section, value)
	--	sync_value_to_file(value, "/etc/haproxy.cfg")
	--end
s=m:section(TypedSection,"main_server",translate("<b>主服务器列表<b>"))
	s.anonymous=true
	s.addremove=true
	o=s:option(Value,"server_name",translate("显示名称(仅限英文字母)"))
	o.rmempty = false
	o=s:option(Value,"server_ip",translate("Proxy Server IP"))
	o.datatype="ip4addr"
	o=s:option(Value,"server_port",translate("Proxy Server Port"))
	o.datatype="uinteger"
	o=s:option(Value,"server_weight",translate("分流权重"))
	o.datatype="uinteger"

s=m:section(TypedSection,"backup_server",translate("<b>备用服务器列表<b>"))
	s.anonymous=true
	s.addremove=true
	o=s:option(Value,"server_name",translate("显示名称(仅限英文字母)"))
	o.rmempty = false
	o=s:option(Value,"server_ip",translate("Proxy Server IP"))
	o.datatype="ip4addr"
	o=s:option(Value,"server_port",translate("Proxy Server Port"))
	o.datatype="uinteger"
-- ---------------------------------------------------
local apply = luci.http.formvalue("cbi.apply")
if apply then
	os.execute("/etc/haproxy_init.sh >/dev/null 2>&1 &")
end
return m