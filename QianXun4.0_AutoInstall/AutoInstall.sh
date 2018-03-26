#!/bin/bash
# Mr.Ray for ZYSW-6097 2017-08-17
# 

source ./Install.conf
baseDir=$PWD

#=======================================================
# 安装expect工具
function InstallExpect() {
	rpm -q expect
	
	if [ $? -ne 0 ]
	then
		if [ -f ./rpm/tcl-8.5.7-6.el6.x86_64.rpm -a -f ./rpm/expect-5.44.1.15-5.el6_4.x86_64.rpm ]; then
			rpm -ivh ./rpm/tcl-8.5.7-6.el6.x86_64.rpm ./rpm/expect-5.44.1.15-5.el6_4.x86_64.rpm
		else
			echo '    - expect 安装包不存在'
			exit 201
		fi
		if [ $? -ne 0 ]
		then
			echo -e "\033[31m   - 安装expect失败 \033[0m"
			exit 202
		fi
	else
	
		echo -e "\033[34m    - expect工具已经安装 \033[0m"
	fi
	
	sleep 2
}
#=======================================================
# 创建数据库
#
function CreateDatabase(){
	/etc/init.d/mysql status
	if [ $? -ne 0 ]; then
		echo -e "\033[31m   - MySQL未启动... \033[0m"
		exit 211
	fi
	
	# 判断数据库是否已经存在
	mysql -uroot -padmin -e "USE ${databaseName}"
	if [ $? -eq 0 ]; then
		# 判断库中是否有表
		temp=`mysql -uroot -padmin -e"USE ${databaseName}; SHOW TABLES;" | wc -l`
		if [ ${temp} -ne 0 ]; then
			echo -e "\033[31m    - database ${databaseName} 已经存在，请在脚本第25-27行手动修改数据库名 \033[0m"
			exit 222
		fi
	else
		# 创建数据库
		mysql -uroot -padmin -e "CREATE DATABASE ${databaseName} CHARACTER SET utf8mb4 COLLATE utf8mb4_bin; \
                                         GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'admin' WITH GRANT OPTION;"
	fi
}

#=======================================================
# 解压安装包
#
function UnzipPackage() {
	cd ${baseDir}/Packages
	echo -e "\033[32m    - 开始解压安装包${packageName}.tar.gz \033[0m"
	# 判断安装包是否已被解压
	if [ -d ${packageName} ]
	then
		echo -e "\033[34m    - 安装包已解压好 \033[0m"
	# 判断安装包是否存在
	elif [ -f ${packageName}.tar.gz ]
	then
		tar -xvf ${packageName}.tar.gz
		echo -e "\033[34m    - 安装包解压完成 \033[0m"
	else
		echo -e "\033[31m    - ${packageName}.tar.gz不存在\033[0m"
		exit 231
	fi
	sleep 2
}

#=======================================================
# 安装千寻
#
function InstallQianxun() {
	echo -e "\033[32m    - 开始安装千寻 \033[0m"
	cd ${baseDir}/Packages/${packageName}
	time /usr/bin/expect << EOF
	set time 120
	spawn ./install
		expect "请选择需要安装的组件";	sleep 1;	send "\r";
		expect "请输入安装目录";	sleep 1;	send "${InstallRoute}\r";
		
		expect "单点登陆系统外网地址"; 	sleep 1;	send "${psaeIP}\r";
		expect "单点登陆系统外网端口"; 	sleep 1;	send "\r";
		expect "单点登录系统内网地址"; 	sleep 1;	send "${psaeIP}\r";
		expect "单点登录系统内网端口"; 	sleep 1;	send "\r";
		
		expect "Optimus识别服务子网网卡IP"; 	sleep 1; 	send "${optimusIP}\r";
		expect "offsr-threads"; 		sleep 1; 	send "${psttThreads}\r";
		
		expect "PSAE服务外网访问地址"; 	sleep 1; 	send "${psaeIP}\r";
		expect "PSAE服务工作端口"; 	sleep 1; 	send "\r";
		expect "DC服务地址"; 		sleep 1; 	send "${psaeIP}\r";
		expect "DC服务端口"; 		sleep 1; 	send "\r";
		
		expect "服务器名"; 	sleep 1; 	send "${psaeIP}\r";
		expect "端口号"; 	sleep 1; 	send "\r";
		expect "数据库名"; 	sleep 1; 	send "${databaseName}\r";
		expect "用户名"; 	sleep 1; 	send "root\r";
		expect "密码"; 		sleep 1; 	send "admin\r";
		
		expect "Optimus资源管理服务子网网卡I"; 	sleep 1; 	send "${optimusIP}\r";
		
		expect "服务器名"; 	sleep 1; 	send "${psaeIP}\r";
		expect "端口号"; 	sleep 1; 	send "\r";
		expect "数据库名"; 	sleep 1; 	send "${databaseName}\r";
		expect "用户名"; 	sleep 1; 	send "root\r";
		expect "密码"; 		sleep 1; 	send "admin\r";
		
		expect "服务器名"; 	sleep 1; 	send "${psaeIP}\r";
		expect "端口号"; 	sleep 1; 	send "\r";
		expect "数据库名"; 	sleep 1; 	send "${databaseName}\r";
		expect "用户名"; 	sleep 1; 	send "root\r";
		expect "密码"; 		sleep 1; 	send "admin\r";
		
		expect "文本数据源探测目录";	sleep 1;	send "${datasourceRoute}/text\r";
		expect "语音数据源探测目录";	sleep 1;	send "${datasourceRoute}/speech\r"
		expect "请确认您的安装参数";	sleep 1;	send "Y\r";
		sleep 60
		expect eof
EOF

	if [ $? -ne 0 ]
	then
		echo -e "\033[31m   - 安装失败 \033[0m"
		exit 241
	else
		echo -e "\033[34m   - 千寻4.0安装成功 \033[0m"
	fi
	
	sleep 2
}

#=======================================================
# 配置语言模型
#
function ChangeModel() {
	echo -e "\033[32m   - 开始更换语言模型 \033[0m"
	cd ${baseDir}/Packages
	if [ -f ${modelName}.tar.gz ]
	then
		tar -zxvf ${modelName}.tar.gz
		mv -v model ${InstallRoute}/service/optimus-offsr/pstt/${modelName}
		cd ${InstallRoute}/service/optimus-offsr/pstt/
		mv resource resource_init
		ln -s ${modelName} resource
		return 0
	else
		echo "   - 语言模型包不存在"
	fi
}


#=======================================================
# main
#
InstallExpect
CreateDatabase
UnzipPackage
InstallQianxun
ChangeModel
