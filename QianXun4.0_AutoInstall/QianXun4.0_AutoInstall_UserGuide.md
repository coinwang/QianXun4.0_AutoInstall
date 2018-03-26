## 1. 脚本结构
```
[root@localhost QianXun4.0单机版自动部署脚本]# ls -l
总用量 36
-rw-r--r-- 1 root root 4161 1月  29 18:19 AutoConfig.sh
-rw-r--r-- 1 root root 5079 1月  29 18:19 AutoInstall.sh
-rw-r--r-- 1 root root  966 1月  29 18:19 CheckFile.sh
-rw-r--r-- 1 root root  868 1月  29 18:19 Install.conf
drwxr-xr-x 2 root root 4096 1月  29 18:19 Packages
drwxr-xr-x 2 root root 4096 1月  29 18:19 rpm
-rwxr-xr-x 1 root root  483 1月  29 18:19 start.sh
```
- rpm 目录：自动化部署需要使用的expect工具包的保存目录
- Packages 目录：千寻4.0安装包、语言模型包的保存目录
- Install.conf 文件：安装配置文件，包括IP，安装路径配置
- CheckFile.sh 脚本：安装前环境检查脚本，包括
- AutoInstall.sh 脚本：安装expect工具，创建数据库，安装千寻4.0，替换语言模型
- start.sh 脚本：启动安装脚本

## 2. 使用注意事项
- 该脚本只适合千寻4.0的单机部署
- 确保安装环境是JDK1.7.0环境以及CentOS6.*
- 请确保**硬盘剩余空间大于2GB**
- 请确保Packages目录下只有一个千寻安装包和一个语言模型包
- 请使用root用户执行安装
- 如果系统没有一个很大的/mydata目录，请手动指定安装路径和数据源路径

## 3. 使用方法

第一步：将千寻4.0的安装包和语言模型包放入Packages目录下<br>
第二步：修改Install.conf文件，通常只需要修改psaeIP和optimusIP即可<br>
第三步：执行start.sh脚本<br>