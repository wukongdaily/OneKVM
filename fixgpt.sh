#!/bin/bash
set -e  

sudo apt update -y
sudo apt install -y gdisk
sudo apt install -y expect

DISK="/dev/sda"

expect <<EOF
spawn sudo gdisk "$DISK"
expect "Command (? for help):" { send "w\r" }
expect "correct this problem? (Y/N):" { send "Y\r" }
expect "Do you want to proceed? (Y/N):" { send "Y\r" }
expect eof
EOF

echo "GPT分区表已成功修复 您可以使用U盘/硬盘剩余空间啦 $DISK"
