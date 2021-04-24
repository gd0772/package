#!/bin/bash
# https://github.com/Hyy2001X/AutoBuild-Actions
# AutoBuild Module by Hyy2001

rm -f /tmp/cloud_version
if [ ! -f /bin/AutoUpdate.sh ];then
	echo "未检测到 /bin/AutoUpdate.sh" > /tmp/cloud_version
	exit
fi
CURRENT_DEVICE="$(awk 'NR==3' /etc/openwrt_info)"
Firmware_COMP1="$(awk 'NR==5' /etc/openwrt_info)"
Firmware_COMP2="$(awk 'NR==6' /etc/openwrt_info)"
[[ -z "${CURRENT_DEVICE}" ]] && CURRENT_DEVICE="$(jsonfilter -e '@.model.id' < "/etc/board.json" | tr ',' '_')"
Github="$(awk 'NR==2' /etc/openwrt_info)"
[[ -z "${Github}" ]] && exit
Author="${Github##*com/}"
Github_Tags="https://api.github.com/repos/${Author}/releases/tags/update_Firmware"
wget -q ${Github_Tags} -O - > /tmp/Github_Tags
Firmware_Type="$(awk 'NR==4' /etc/openwrt_info)"
case ${CURRENT_DEVICE} in
x86-64)
	if [ -d /sys/firmware/efi ];then
		Firmware_SFX="-UEFI.${Firmware_Type}"
		BOOT_Type="-UEFI"
	else
		Firmware_SFX="-Legacy.${Firmware_Type}"
		BOOT_Type="-Legacy"
	fi
;;
*)
	Firmware_SFX=".${Firmware_Type}"
	BOOT_Type=""
;;
esac
Cloud_Ver="$(cat /tmp/Github_Tags | egrep -o "${Firmware_COMP1}-${Firmware_COMP2}-${CURRENT_DEVICE}-[0-9]+.*?[0-9]+${Firmware_SFX}" | awk 'END {print}' | egrep -o '[a-zA-Z0-9_-]+.*?[0-9]+')"
Cloud_Version="${Cloud_Ver#*${Firmware_COMP1}-}"
CURRENT_Version="$(awk 'NR==1' /etc/openwrt_info)"
if [[ ! -z "${Cloud_Version}" ]];then
	if [[ "${CURRENT_Version}" -eq "${Cloud_Version}" ]];then
		Checked_Type="已是最新"
		echo "${Cloud_Version}${BOOT_Type} [${Checked_Type}]" > /tmp/cloud_version
	elif [[ "${CURRENT_Version}" -gt "${Cloud_Version}" ]];then
		Checked_Type="发现更新"
		echo "${Cloud_Version}${BOOT_Type} [${Checked_Type}]" > /tmp/cloud_version
	elif [[ "${CURRENT_Version}" -lt "${Cloud_Version}" ]];then
		echo "您当前的版本高于云端现有版本" > /tmp/cloud_version		
	fi
else
	echo "当前网络不佳,请检查网络或者再次刷新网页  、或者云端固件已删除,请检查云端地址的固件是否已删除  、或者您使用的是私人仓库,云端地址不能访问,检测不到云端固件" > /tmp/cloud_version
fi
exit
