#!/bin/bash

# v1.0
# 功能介绍
# 个人用的bash shell工具包，内含各种我平时常用的shell脚本
# If there is a coding problem, use "export $LANG=zh.CN-UTF-8"

#main function
print_main() {
    weclome

    monitor_disk

    quick_cd
    
    return;
}

#欢迎语，当前时间，当前linux发行版版本，当前linux内核版本，当前使用的是哪款shell程序
weclome(){
    local WELCOME="欢迎回来"
    local current_time=$(date)
    local current_hour=$(date +%H)
    # local current_distribution=$(tail -n 1 /etc/lsb-release | cut -d "=" -f 2)
    # local current_kernel=$(cut -d " " -f 3 /proc/version)
    # local current_shell=$(echo $SHELL | cut -d "/" -f 3)
    local current_REM=$(free -m | grep Mem | awk '{print $7}')

    #根据时间输出不同内容
    case $current_hour in
        [0-1]) echo "再不睡觉明早就会没精神了哦"
        ;;
        [2-6]) echo "今天又要熬夜了吗?记得泡杯枸杞哦"
        ;;
        [7-9]|10|1[4-7]|2[0-1])  echo "$WELCOME"  
        ;;
        1[1-3]) echo "中午好,吃饭了没"
        ;;
        1[8-9]) echo "晚上好，吃饭了没"
        ;;
        2[2-3]) echo "夜已深，注意休息"
    esac
    
    echo "剩余可用内存: $current_REM MB"
    echo $current_time
    # echo "当前linux发行版版本号: $current_distribution"
    # echo "当前linux内核版本: $current_kernel"
    # echo "当前使用的shell： $current_shell"
    # echo "$ZAZALU_PATH"
}

#常用目录引导
quick_cd() {
    #可选项
    echo "您想快速进入哪个目录呢?
    1.不做任何操作
    2.我的博客
    3.git相关
    4.我的学习文档
    5.本程序所在目录
    "
    # 从键盘获取一个数字
    read -p " -> " -n 1 var
    # 手动打印个换行
    echo -e "\n"
    # 逻辑判断
    if [[ $var == 2 ]] 
    then
        cd /home/zazalu/blog/zazaluMonster.github.io/
    elif [[ $var == 3 ]] 
    then
        cd /home/zazalu/Documents/gitRepos/
    elif [[ $var == 4 ]] 
    then
        cd /home/zazalu/Documents/MyTips/
    elif [[ $var == 5 ]] 
    then
        cd /home/zazalu/app/my-sys-info-manager/bin
    fi
}

#监控path_array包含目录的硬盘使用情况，超过80%使用率就发送提示信息和警报音
monitor_disk() {
    local path_array=("/" "/home" "/boot")
    local alarm_line=80

    for i in $path_array
    do
        local path=$i
        local path_regular=${i}'$'

        local disk_use=$(df -hl | grep -E  $path_regular | awk '{print $5}' | sed 's/\%//g')

        compare $disk_use $alarm_line $path 
    done
}

compare() {
    if ((  $1 > $2 ))
    then
        echo "$3 path need clean " $'\a'
    fi
}

# 列出输入路径占用最高的n个文件 $1为你需要查询的路径
file_disk_usage_use_root() {
    echo "$(sudo du -S $1 | sort -rn | head -n 5)"
}

# 打开我的百度云盘第三方工具-BND
open_bnd() {
    updatedb
    local path=$(locate baidudownload)
    $path
}

# 查看当前cpu占用前10的进程,为了保证排版清晰，我用下临时文件(懒得自己拼,借用管道和重定向把系统给我的数据，也就是已经排版好的数据存到临时文件)
cpu_top_ten() {
    touch temp.txt
    ps -auxc | head -1 > temp.txt
    ps -auxc | sort -k3nr | head -10 >> temp.txt
    cat temp.txt
    rm temp.txt

    #不需要排版就直接使用  ps -auxc | sort -k3nr | head -10
}

# 查看当前内存占用前10的进程
mem_top_ten() {
    touch temp.txt
    ps -auxc | head -1 > temp.txt
    ps -auxc | sort -k4nr | head -10 >> temp.txt
    cat temp.txt
    rm temp.txt
}

# usage
usage () {
    local PROGNAME=$(basename $0)
    echo "$PROGNAME: usage: $PROGNAME [OPTION]"
    echo "example: mymaster -h"
    return
}

# open_files 打开当前目录的文件管理器
open_files() {
    nautilus .
}

# 检查shadowsock是否已启动
checkShadowsocks(){
    #返回Address already in use表示已经启动
    ps -aux | grep shadowsocks	
}

# 打开shadowsocks开机启动配置文件（请只修改节点为目的调用此方法）
changeShadowsocksConfig(){
    # 如果发现路径不对，尝试locate shadowsocks.json
    vim /etc/shadowsocks.json
}

# 重启shadowsocks
restartShadowsocks(){
    echo "if you take a error like (Permission denied: '/var/run/shadowsocks.pid') use (sudo chmod 777 yourfilename)"
    sudo /usr/local/bin/sslocal -c /etc/shadowsocks.json -d stop
    sudo /usr/local/bin/sslocal -c /etc/shadowsocks.json -d start
}

# 打开JVM监控工具visualVM
openVisualVM(){
    # 使用参数指定下使用的jdk版本 不然无法运行visualVM
    /home/zazalu/app/visualvm_143/bin/visualvm --jdkhome "/home/zazalu/jdk/jdk1.8.0_211"
}


# help
forhelp() {
    echo "HELP:
    -f PATH 
        查询PATH下空间占用最大的5个文件
    -o 
        打开百度第三方下载器bnd
    -c
        查看当前cpu占用前10个进程
    -m
        查看当前内存占用前10个进程
    -g
        打开当前目录的GUI
    -ssl
        查看shadowsock启动状态
    -ssc
        修改shadowsock启动配置文件
    -ssr
        重启shadowsock后台服务
    -jvm
        启动JVM监控工具
    -git
        显示我自己总结的git帮助文档
    -h
        查看帮助文档"
}

# git help
myGitHelp(){
    echo "GIT COMMAND:
    git add . 
        添加改动过的文件到add区（Index区）
    git commit -m \"\"
        提交add区文件到commit区（HEAD区）
    git push origin branch-name
        推送commit区内容到远程分支
    git init
        在当前目录构建git库(生成.git)
    git clone url
        克隆一个库
    git remote add origin url
        连接一个远程git库
    git checkout -b branch-name
        创建一个新分支
    git checkout branch-name
        切换到某个分支
    git push -d origin branch-name
        删除远程库分支
    git status
        查看git状态，查看当前在哪个分支，查看当前修改未提交的文件等等
    git log 
        查看所有commit历史，每个commit记录都有一个commit-id
    git reset
        回退最近一次的[git add .]操作(专业术语：回退index区到就进一次修改之前)
    git reset file-name
        指定一个文件回退
    git reset --soft <commit-id>
        回退commit区（HEAD区），回退到<commit-id>对应的版本状态
    git reset --mixed <commit-id>
        不仅回退commit区，add区也会回退
    git reset --hard <commit-id>
        不仅回退commit和add，会把你的工作区(也就是本地文件内容！)，也回退，使用这个命令千万注意提前备份"
}

#run main
if [[ -n $1 ]]; then
    case $1 in
        -f)          file_disk_usage_use_root $2
                     ;;
        -o)          open_bnd
                     ;;
        -c)          cpu_top_ten
                     ;;
        -m)          mem_top_ten
                     ;;
        -h)          forhelp
                     ;;
        -g)          open_files
                     ;;
        -ssl)        checkShadowsocks
                     ;;
        -ssc)        changeShadowsocksConfig
                     ;;
        -ssr)        restartShadowsocks
                     ;;
        -jvm)        openVisualVM
                     ;;
        -git)        myGitHelp
                     ;;
        *)           usage
                     ;;
    esac
else
    print_main
fi
