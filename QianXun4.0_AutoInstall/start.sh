#!/bin/bash
#
Flag=0
source ./Install.conf

if [ $USER != 'root' ];then
	echo ' - 请使用root用户执行本脚本......'
fi

bash CheckFile.sh
if [ $? -eq 0 ]; then 
	echo '- 安装前检测成功...'
	bash AutoInstall.sh
	if [ $? -eq 0 ]; then
		bash AutoConfig.sh
	else
		Flag=102
	fi
else
	echo '- 安装前检测失败，请根据提示信息处理...'
	Flag=101
fi

if [ -z "$modelName" ];then
	echo '- 语言模型未替换，需要手动替换语言模型......'
fi
exit $Flag
