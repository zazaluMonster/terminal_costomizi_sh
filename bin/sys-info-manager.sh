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
    -h
        查看帮助文档"
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
        *)           usage
                     ;;
    esac
else
    print_main
fi