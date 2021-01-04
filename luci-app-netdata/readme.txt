luci-app-netdata for OpenWRT/Lede(ÖÐÎÄ)


Install to OpenWRT/LEDE

git clone https://github.com/gd0772/gd772-package/tree/main/luci-app-netdata
cp -r luci-app-netdata LEDE_DIR/package/luci-app-netdata

cd LEDE_DIR
./scripts/feeds update -a
./scripts/feeds install -a

make menuconfig
LuCI  --->
	1. Collections  --->
		<*> luci
	3. Applications  --->
		<*> luci-app-netdata.........................LuCI support for Netdata


make package/luci-app-netdata/compile V=s
