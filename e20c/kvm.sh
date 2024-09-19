#!/bin/bash

# 定义颜色输出函数
red() { echo -e "\033[31m\033[01m[WARNING] $1\033[0m"; }
green() { echo -e "\033[32m\033[01m[INFO] $1\033[0m"; }
greenline() { echo -e "\033[32m\033[01m $1\033[0m"; }
yellow() { echo -e "\033[33m\033[01m[NOTICE] $1\033[0m"; }
blue() { echo -e "\033[34m\033[01m[MESSAGE] $1\033[0m"; }
light_magenta() { echo -e "\033[95m\033[01m[NOTICE] $1\033[0m"; }
highlight() { echo -e "\033[32m\033[01m$1\033[0m"; }
cyan() { echo -e "\033[38;2;0;255;255m$1\033[0m"; }

# 检查是否以 root 用户身份运行
if [ "$(id -u)" -ne 0 ]; then
    green "注意！输入密码过程不显示*号属于正常现象"
    echo "此脚本需要以 root 用户权限运行，请输入当前用户的密码："
    # 使用 'sudo' 重新以 root 权限运行此脚本
    sudo -E "$0" "$@"
    exit $?
fi

declare -a menu_options
declare -A commands
menu_options=(
    "更新Linux系统软件包"
    "安装文件管理器FileBrowser"
    "安装QEMU/KVM虚拟机管理器"
    "安装Cockpit虚拟机Web管理工具"
    "允许虚拟机通过指定的桥接网卡收发数据"
    "安装docker"
    "安装1panel面板管理工具"
    "卸载1panel面板管理工具"
    "卸载QEMU/KVM虚拟机管理器"
    "卸载Cockpit虚拟机Web管理工具"
    "更新脚本"
)

commands=(
    ["更新Linux系统软件包"]="update_system_packages"
    ["安装文件管理器FileBrowser"]="install_filemanager"
    ["安装QEMU/KVM虚拟机管理器"]="install_virt_manager"
    ["安装Cockpit虚拟机Web管理工具"]="install_cockpit"
    ["允许虚拟机通过指定的桥接网卡收发数据"]="add_nft_rules_for_bridge"
    ["安装docker"]="install_docker"
    ["安装1panel面板管理工具"]="install_1panel_on_linux"
    ["卸载QEMU/KVM虚拟机管理器"]="uninstall_virt_manager"
    ["卸载Cockpit虚拟机Web管理工具"]="uninstall_cockpit"
    ["卸载1panel面板管理工具"]="uninstall_1panel"
    ["更新脚本"]="update_scripts"
)

# 更新系统软件包
update_system_packages() {
    green "Setting timezone Asia/Shanghai..."
    sudo timedatectl set-timezone Asia/Shanghai
    # 更新系统软件包
    green "Updating system packages..."
    sudo apt update
    sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
    if ! command -v curl &>/dev/null; then
        red "curl is not installed. Installing now..."
        sudo apt install -y curl
        if command -v curl &>/dev/null; then
            green "curl has been installed successfully."
        else
            echo "Failed to install curl. Please check for errors."
        fi
    else
        echo "curl is already installed."
    fi
}

# 安装docker
install_docker() {
    bash <(curl -sSL https://linuxmirrors.cn/docker.sh)
}
# 安装QEMU/KVM虚拟机管理器
install_virt_manager() {
    sudo apt-get install -y gconf2 qemu-system-arm qemu-utils qemu-efi ipxe-qemu libvirt-daemon-system libvirt-clients bridge-utils virtinst virt-manager seabios vgabios gir1.2-spiceclientgtk-3.0 xauth fonts-wqy-microhei
}
# 卸载QEMU/KVM虚拟机管理器
uninstall_virt_manager() {
    sudo apt-get purge -y gconf2 qemu-system-arm qemu-utils qemu-efi ipxe-qemu libvirt-daemon-system libvirt-clients bridge-utils virtinst virt-manager seabios vgabios gir1.2-spiceclientgtk-3.0 xauth fonts-wqy-microhei
    sudo apt-get autoremove -y
    sudo apt-get clean
}

# 安装Cockpit虚拟机Web管理工具
install_cockpit() {
    sudo apt install cockpit cockpit-machines cockpit-networkmanager -y
    sudo systemctl start cockpit
    sudo apt install nftables -y
    nft add table ip filter
    nft add chain ip filter FORWARD { type filter hook forward priority 0 \; }
    sudo apt install dnsmasq -y
    sudo apt install dmidecode -y
    green "http://<您的服务器IP>:9090"
}

# 卸载Cockpit虚拟机Web管理工具
uninstall_cockpit() {
    sudo systemctl stop cockpit
    sudo apt-get purge -y cockpit cockpit-machines cockpit-networkmanager nftables dnsmasq dmidecode
    sudo apt-get autoremove -y
    sudo apt-get clean
    sudo nft delete table ip filter
}


# 允许虚拟机通过指定的桥接网卡收发数据
add_nft_rules_for_bridge() {
    read -p "请输入桥接网卡名称: " bridge_name
    nft add rule ip filter FORWARD iifname "$bridge_name" accept
    nft add rule ip filter FORWARD oifname "$bridge_name" accept
    green "$bridge_name 防火墙规则已设置"
}
# 安装文件管理器
# 源自 https://filebrowser.org/installation
install_filemanager() {
    trap 'echo -e "Aborted, error $? in command: $BASH_COMMAND"; trap ERR; return 1' ERR
    filemanager_os="unsupported"
    filemanager_arch="unknown"
    install_path="/usr/local/bin"

    # Termux on Android has $PREFIX set which already ends with /usr
    if [[ -n "$ANDROID_ROOT" && -n "$PREFIX" ]]; then
        install_path="$PREFIX/bin"
    fi

    # Fall back to /usr/bin if necessary
    if [[ ! -d $install_path ]]; then
        install_path="/usr/bin"
    fi

    # Not every platform has or needs sudo (https://termux.com/linux.html)
    ((EUID)) && [[ -z "$ANDROID_ROOT" ]] && sudo_cmd="sudo"

    #########################
    # Which OS and version? #
    #########################

    filemanager_bin="filebrowser"
    filemanager_dl_ext=".tar.gz"

    # NOTE: `uname -m` is more accurate and universal than `arch`
    # See https://en.wikipedia.org/wiki/Uname
    unamem="$(uname -m)"
    case $unamem in
    *aarch64*)
        filemanager_arch="arm64"
        ;;
    *64*)
        filemanager_arch="amd64"
        ;;
    *86*)
        filemanager_arch="386"
        ;;
    *armv5*)
        filemanager_arch="armv5"
        ;;
    *armv6*)
        filemanager_arch="armv6"
        ;;
    *armv7*)
        filemanager_arch="armv7"
        ;;
    *)
        green "Aborted, unsupported or unknown architecture: $unamem"
        return 2
        ;;
    esac

    unameu="$(tr '[:lower:]' '[:upper:]' <<<$(uname))"
    if [[ $unameu == *DARWIN* ]]; then
        filemanager_os="darwin"
    elif [[ $unameu == *LINUX* ]]; then
        filemanager_os="linux"
    elif [[ $unameu == *FREEBSD* ]]; then
        filemanager_os="freebsd"
    elif [[ $unameu == *NETBSD* ]]; then
        filemanager_os="netbsd"
    elif [[ $unameu == *OPENBSD* ]]; then
        filemanager_os="openbsd"
    elif [[ $unameu == *WIN* || $unameu == MSYS* ]]; then
        # Should catch cygwin
        sudo_cmd=""
        filemanager_os="windows"
        filemanager_bin="filebrowser.exe"
        filemanager_dl_ext=".zip"
    else
        green "Aborted, unsupported or unknown OS: $uname"
        return 6
    fi
    green "Downloading File Browser for $filemanager_os/$filemanager_arch..."
    if type -p curl >/dev/null 2>&1; then
        net_getter="curl -fsSL"
    elif type -p wget >/dev/null 2>&1; then
        net_getter="wget -qO-"
    else
        green "Aborted, could not find curl or wget"
        return 7
    fi
    filemanager_file="${filemanager_os}-$filemanager_arch-filebrowser$filemanager_dl_ext"
    filemanager_url="https://cafe.cpolar.cn/wkdaily/filebrowser/raw/branch/main/$filemanager_file"
    echo "$filemanager_url"

    # Use $PREFIX for compatibility with Termux on Android
    rm -rf "$PREFIX/tmp/$filemanager_file"

    ${net_getter} "$filemanager_url" >"$PREFIX/tmp/$filemanager_file"

    green "Extracting..."
    case "$filemanager_file" in
    *.zip) unzip -o "$PREFIX/tmp/$filemanager_file" "$filemanager_bin" -d "$PREFIX/tmp/" ;;
    *.tar.gz) tar -xzf "$PREFIX/tmp/$filemanager_file" -C "$PREFIX/tmp/" "$filemanager_bin" ;;
    esac
    chmod +x "$PREFIX/tmp/$filemanager_bin"

    green "Putting filemanager in $install_path (may require password)"
    $sudo_cmd mv "$PREFIX/tmp/$filemanager_bin" "$install_path/$filemanager_bin"
    if setcap_cmd=$(PATH+=$PATH:/sbin type -p setcap); then
        $sudo_cmd $setcap_cmd cap_net_bind_service=+ep "$install_path/$filemanager_bin"
    fi
    $sudo_cmd rm -- "$PREFIX/tmp/$filemanager_file"

    if type -p $filemanager_bin >/dev/null 2>&1; then
        green "Successfully installed"
        green "安装成功,现在您可以执行第3项开启文件管理并设置自启动"
        trap ERR
        start_filemanager
        return 0
    else
        red "Something went wrong, File Browser is not in your path"
        trap ERR
        return 1
    fi
}

# 启动文件管理器
start_filemanager() {
    # 检查是否已经安装 filebrowser
    if ! command -v filebrowser &>/dev/null; then
        red "Error: filebrowser 未安装，请先安装 filebrowser"
        return 1
    fi

    # 启动 filebrowser 文件管理器
    echo "启动 filebrowser 文件管理器..."

    # 使用 nohup 和输出重定向，记录启动日志到 filebrowser.log 文件中
    nohup sudo filebrowser -r / --address 0.0.0.0 --port 8080 >filebrowser.log 2>&1 &

    # 检查 filebrowser 是否成功启动
    if [ $? -ne 0 ]; then
        red "Error: 启动 filebrowser 文件管理器失败"
        return 1
    fi
    local host_ip
    host_ip=$(hostname -I | awk '{print $1}')
    green "filebrowser 文件管理器已启动，可以通过 http://${host_ip}:8080 访问"
    green "登录用户名：admin"
    green "默认密码：admin（请尽快修改密码）"
    sudo wget -O /etc/systemd/system/filebrowser.service "https://cafe.cpolar.cn/wkdaily/zero3/raw/branch/main/filebrowser.service"
    sudo chmod +x /etc/systemd/system/filebrowser.service
    sudo systemctl daemon-reload              # 重新加载systemd配置
    sudo systemctl start filebrowser.service  # 启动服务
    sudo systemctl enable filebrowser.service # 设置开机启动
    yellow "已设置文件管理器开机自启动,下次开机可直接访问文件管理器"
}

# 安装1panel面板
install_1panel_on_linux() {
    curl -sSL https://resource.fit2cloud.com/1panel/package/quick_start.sh -o quick_start.sh && sudo bash quick_start.sh
    intro="https://1panel.cn/docs/installation/cli/"
    if command -v 1pctl &>/dev/null; then
        echo '{
  "registry-mirrors": [
    "https://docker.1panel.live"
  ]
}' | sudo tee /etc/docker/daemon.json >/dev/null
        sudo /etc/init.d/docker restart
        green "如何卸载1panel 请参考：$intro"
    else
        red "未安装1panel"
    fi

}

# 卸载1panel
uninstall_1panel() {
    sudo 1pctl uninstall
}

# 更新自己
update_scripts() {
    wget -O kvm.sh https://cafe.cpolar.cn/wkdaily/e20c/raw/branch/main/e20c/e20c/kvm.sh && chmod +x kvm.sh
    echo "脚本已更新并保存在当前目录 kvm.sh,现在将执行新脚本。"
    ./kvm.sh
    exit 0
}


show_menu() {
    clear
    greenline "————————————————————————————————————————————————————"
    echo '
    ***********  DIY docker轻服务器  ***************
    环境: (Ubuntu/Debian/Armbian etc)
    '
    echo -e "    https://github.com/wukongdaily/e20c/"
    greenline "————————————————————————————————————————————————————"
    echo "请选择操作："

    # 特殊处理的项数组
    special_items=("安装docker" "安装1panel面板管理工具" "安装小雅tvbox" "安装特斯拉伴侣TeslaMate")
    for i in "${!menu_options[@]}"; do
        if [[ " ${special_items[*]} " =~ " ${menu_options[i]} " ]]; then
            # 如果当前项在特殊处理项数组中，使用特殊颜色
            cyan "$((i + 1)). ${menu_options[i]}"
        else
            # 否则，使用普通格式
            echo "$((i + 1)). ${menu_options[i]}"
        fi
    done
}

handle_choice() {
    local choice=$1
    # 检查输入是否为空
    if [[ -z $choice ]]; then
        echo -e "${RED}输入不能为空，请重新选择。${NC}"
        return
    fi

    # 检查输入是否为数字
    if ! [[ $choice =~ ^[0-9]+$ ]]; then
        echo -e "${RED}请输入有效数字!${NC}"
        return
    fi

    # 检查数字是否在有效范围内
    if [[ $choice -lt 1 ]] || [[ $choice -gt ${#menu_options[@]} ]]; then
        echo -e "${RED}选项超出范围!${NC}"
        echo -e "${YELLOW}请输入 1 到 ${#menu_options[@]} 之间的数字。${NC}"
        return
    fi

    # 执行命令
    if [ -z "${commands[${menu_options[$choice - 1]}]}" ]; then
        echo -e "${RED}无效选项，请重新选择。${NC}"
        return
    fi

    "${commands[${menu_options[$choice - 1]}]}"
}

while true; do
    show_menu
    read -p "请输入选项的序号(输入q退出): " choice
    if [[ $choice == 'q' ]]; then
        break
    fi
    handle_choice $choice
    echo "按任意键继续..."
    read -n 1 # 等待用户按键
done
