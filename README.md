# luci-app-haproxy-tcp

简介
---

本软件包为OpenWRT路由器Shadowsocks做负载均衡和高可用的HAPrxoy的 LuCI 控制界面,因为仅用于ss，所以限定为tcp模式

可以设置多个主服务器或多个备用服务器. 默认监听端口127.0.0.1:2222 后台监控页面端口0.0.0.0:1111,后台监控页面地址192.168.1.1:1111/haproxy

多主服务器时是将所有TCP流量分流，并可以设置每个服务器的分流比例，多备用服务器时是在检测到主服务器A宕机之后切换至备用服务器B，B宕机之后切换到服务器C...依次类推，可以防止因为单个服务器或者线路故障导致的断网问题。
使用效果和更多使用方法请参考http://www.right.com.cn/forum/thread-198649-1-1.html


依赖
---

显式依赖 `haproxy`, 安装完毕该luci包后会stop并disable当前op的haproxy，点击“保存&应用”后会修改HAProxy默认配置文件/etc/haproxy.cfg并自动重启，支持开机自启.  


配置
---

如果有需要，可以修改/etc/haproxy_init.sh ,不要直接修改/etc/haproxy.cfg，否则会被覆盖 

编译
---

从 OpenWrt 的 [SDK][openwrt-sdk] 编译  
```bash
# 解压下载好的 SDK
tar xjf OpenWrt-SDK-ar71xx-for-linux-x86_64-gcc-4.8-linaro_uClibc-0.9.33.2.tar.bz2
cd OpenWrt-SDK-ar71xx-*
# Clone 项目
git clone https://github.com/AlexZhuo/luci-app-haproxy-tcp package/luci-app-haproxy-tcp
# 选择要编译的包 LuCI -> 3. Applications
make menuconfig
# 开始编译
make package/luci-app-haproxy-tcp/compile V=99
```
![](http://chuantu.biz/t5/45/1483582973x1903953690.jpg)

