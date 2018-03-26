#!/bin/bash
#
Flag=0

# 检查千寻安装包
FileNum=$(ls ./Packages | grep "^QianXun-4.0" | grep "tar.gz$" | wc -l)
if [ $FileNum -eq 0 ]; then
	echo "  - 千寻安装包不存在"
	Flag=91
elif [ $FileNum -gt 1 ]; then
	echo "  - 千寻安装包数量大于 1个，请清理无用安装包..."
	Flag=92
elif [ $FileNum -eq 1 ]; then
	echo "  - 检测到1个千寻安装包..."
	FileNum=0
fi

# 检查语言模型包
FileNum=$(ls ./Packages | grep "lstm" | wc -l)
if [ $FileNum -eq 0 ]; then
	echo "  - 语言模型包不存在"
elif [ $FileNum -gt 1 ]; then
	echo "  - 语言模型包数量大于 1个，请清理无用语言模型包..."
	Flag=94
elif [ $FileNum -eq 1 ]; then
	echo "  - 检测到1个语言模型包..."
	FileNum=0
fi

# 检查JAVA版本
source /etc/profile
echo ${JAVA_HOME} | grep '1\.7' > /dev/null
if [ $? -ne 0 ]; then
	echo '  - JAVA版本不是1.7，不适用千寻4.0运行'
	Flag=95
else
	echo '  - JAVA版本是1.7 ...'
fi

exit $Flag
