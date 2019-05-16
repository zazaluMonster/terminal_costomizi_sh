# sys-info-manager
个人bashshell工具包，内含我自己常用程序
bash_scripting practice

## Catalog

函数名称 | Task | 
---------|----------|---------
 print_main | 主程序,默认执行
 weclome | 系统信息打印
 quick_cd | 常用目录引导
 monitor_disk | 常用目录硬盘容量监控
 file_disk_usage_use_root | 打印PATH下前5个空间占用最高的文件
 open_bnd | 快速打开BND
 cpu_top_ten | 打印cpu占用前10进程
 mem_top_ten | 打印内存占用前10进程
 usage | 参数输出有误的引导
 forhelp | 帮助文档

 ## How To Use

 1. open `~/.bashrc`
 2. input
 ```
alias mymaster='. ~/app/my-sys-info-manager/bin/sys-info-manager.sh'
mymaster
 ```
 3. reboot

 ## Examples

输入
 ```
 >mymaster -c
 ```
输出类似如下
 ```
 USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
zazalu   28628 19.5  1.7 6535040 277536 tty2   Sl+  14:59  47:03 netease-cloud-m
zazalu   11499  5.0  0.6 559296 107620 tty2    Sl+  09:39  28:17 chrome
zazalu   11081  4.5  1.7 4247764 283288 tty2   Sl+  09:38  25:27 gnome-shell
zazalu   12050  4.2  2.5 2024556 422728 tty2   Sl+  09:39  24:06 code
zazalu   10935  3.9  0.6 1707672 113516 tty2   Sl+  09:38  22:05 Xorg
zazalu   28674  2.5  2.3 2715072 384816 tty2   Sl+  14:59   6:14 netease-cloud-m
zazalu   11462  2.3  1.6 1059444 270416 tty2   SLl+ 09:38  13:10 chrome
zazalu   11980  1.7  1.0 1749420 169280 tty2   Sl+  09:39   9:38 code
zazalu   11105  1.5  0.0 2216872 13780 ?       S<l  09:38   8:43 pulseaudio
zazalu   27238  1.5  0.8 806892 141056 tty2    Sl+  18:49   0:10 chrome
 ```
    


 
