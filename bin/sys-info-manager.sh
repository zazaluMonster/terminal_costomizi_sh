#! /bin/bash
# 查阅当前系统的各项参数的shell脚本

# v1.0 完成对以下变量的输出，并展现为一个html报告
# 欢迎语，当前时间，当前linux发行版版本，当前linux内核版本，当前使用的是哪款shell程序，当前系统各个自定义目录说明(常用目录列举)
# 当前内存使用量，当前硬盘容量(过于复杂暂不实现)


#属性定义
WELCOME="欢迎回来"
# ZAZALU_PATH="~/blog，博客目录;~/app，存放第三方应用;~/Documents/MyTips，个人笔记库;~/Documents/gitRepos，git库"
current_time=$(date)
# current_distribution=$(tail -n 1 /etc/lsb-release | cut -d "=" -f 2)
# current_kernel=$(cut -d " " -f 3 /proc/version)
# current_shell=$(echo $SHELL | cut -d "/" -f 3)
current_REM=$(free -m | grep Mem | awk '{print $7}')

#函数定义
print_main() {
    echo "$WELCOME" 
    echo "剩余可用内存: $current_REM MB"
    echo $current_time
    # echo "当前linux发行版版本号: $current_distribution"
    # echo "当前linux内核版本: $current_kernel"
    # echo "当前使用的shell： $current_shell"
    # echo "$ZAZALU_PATH"
    return;
}

#脚本运行内容
print_main
