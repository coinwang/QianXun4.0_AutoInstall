#!/bin/bash
#

source ./Install.conf

#============================================================================
# 配置psae组件
function Config_PSAE() {
	echo '---------------------------------'
	echo -e "\033[32m -开始配置PSAE组件 \033[0m"
	sed -i "/^\ \ recieveAddr/ c \ \ recieveAddr:\ ${optimusIP}" ${InstallRoute}/etc/psae/dc-mapping.yml
	sed -i "/^\ \ browserAddr/ c \ \ browserAddr:\ ${optimusIP}" ${InstallRoute}/etc/psae/dc-mapping.yml
	sed -i "/^\ \ psaeAddr/ c \ \ psaeAddr:\ ${optimusIP}" ${InstallRoute}/etc/psae/dc-mapping.yml
	echo -e "\033[34m -PSAE组件配置完成 \033[0m\n"
	sleep 2
}


#============================================================================
# 配置psso组件
function Config_PSSO() {
	echo '---------------------------------'
	echo -e "\033[32m -开始配置PSSO组件 \033[0m"
	sed -i "/^PSSO\.Cas\.Server\.url/ c PSSO\.Cas\.Server\.url\=http\:\/\/${psaeIP}\:8184" ${InstallRoute}/etc/psso/psso.cfg
	sed -i "/^PSSO\.Server\.Name/ c PSSO\.Server\.Name\=http\:\/\/${psaeIP}\:8184\/admin" ${InstallRoute}/etc/psso/psso.cfg
	echo -e "\033[34m -PSSO组件配置完成 \033[0m\n"
	sleep 2
}


#============================================================================
# 配置dc组件
function Config_DC() {
	echo '---------------------------------'
	echo -e "\033[32m -开始配置DC组件 \033[0m"
	sed -i "/^DataCenter\.Recognizer\.Threads/ c DataCenter\.Recognizer\.Threads\ \=\ ${psttThreads}" ${InstallRoute}/etc/dc/dc-static.cfg
	sed -i '/^DataCenter\.Recognizer\.Name/ s/FileMatched/Optimus/g' ${InstallRoute}/etc/dc/dc-static.cfg
	# 更换optimus绑定网卡
	sed -i "/^DataCenter\.Optimus\.BindNetwork/ c DataCenter\.Optimus\.BindNetwork\ \=\ ${optimusIP}" ${InstallRoute}/etc/dc/dc-static.cfg
	sed -i "/#DataCenter\.Optimus\.ResourcePrime\.Address/ c DataCenter\.Optimus\.ResourcePrime\.Address = ${optimusIP}:5656" ${InstallRoute}/etc/dc/dc-static.cfg
	echo -e "\033[34m -DC组件配置完成 \033[0m\n"
	sleep 2
}


#============================================================================
# 配置Offsr组件
function Config_Offsr() {
	echo '---------------------------------'
	echo -e "\033[32m -开始配置Offsr组件 \033[0m"
	sed -i "/^\#ResourcePrime\.Address/ c ResourcePrime\.Address\ \=\ ${optimusIP}:5656" ${InstallRoute}/etc/optimus/offsr-prime.cfg
	sed -i "/^Unicast\.IP/ c Unicast\.IP\ \=\ ${optimusIP}" ${InstallRoute}/etc/optimus/offsr-prime.cfg
	sed -i "/^Service\.MaxConcurrent/ s/MPC/${psttThreads}/g" ${InstallRoute}/etc/optimus/offsr-prime.cfg
	echo -e "\033[34m -Offsr组件配置完成 \033[0m\n"
	sleep 2
}


#============================================================================
# 配置Res
function Config_Res() {
	echo '---------------------------------'
	echo -e "\033[32m -开始配置Res组件 \033[0m"
	sed -i "/^Resource\.GuardMode/ s/multicast/unicast/g" ${InstallRoute}/etc/optimus/res-prime.cfg
	sed -i "/^Unicast\.IP/ c Unicast\.IP\ \=\ ${optimusIP}" ${InstallRoute}/etc/optimus/res-prime.cfg
	sed -i "/^License\.Service\.Address/ s/127\.0\.0\.1/${psaeIP}/g" ${InstallRoute}/etc/optimus/res-prime.cfg
	echo -e "\033[34m -Res组件配置完成 \033[0m\n"
	sleep 2
}


#============================================================================
# 配置Monitor
# 分布式时需要启用，修改Monitor的端口
#
function Config_Monitor() {
	echo '---------------------------------'
	echo -e "\033[32m -开始配置Monitor组件 \033[0m"
	sed -i "/^Monitor\.Server\.Port/ s/9191/9192/g" ${optimusInstallRoute}/etc/monitor/monitor.cfg
	echo -e "\033[34m -Monitor组件配置完成 \033[0m\n"
	sleep 2
}

#============================================================================
# 配置PSTT
#
function Config_PSTT() {
	echo '---------------------------------'
	echo -e "\033[32m -开始配置PSTT组件 \033[0m"
	sed -i "/^TOKEN_NUM/ c TOKEN_NUM\ \=\ ${psttThreads}" ${InstallRoute}/service/optimus-offsr/pstt/conf/config.cfg.example
	echo -e "\033[34m -PSTT组件配置完成 \033[0m\n"
	sleep 2
}



#============================================================================
# Main
#
Config_PSAE
Config_PSSO
Config_DC
Config_Offsr
Config_Res
# Config_Monitor
Config_PSTT
