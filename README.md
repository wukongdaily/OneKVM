# 一键KVM虚拟机
https://wkdaily.cpolar.cn/archives/e20c

### 该项目兼容x86-64 和 arm64 双平台、推荐使用linux内核为5.x以上、推荐内存2G以上

### Armbian/Ubuntu/Debian/RaspberryPiOS等基于Debian的Linux

```bash
wget -qO kvm.sh https://cafe.cpolar.cn/wkdaily/e20c/raw/branch/master/e20c/kvm.sh && chmod +x kvm.sh && ./kvm.sh

```
### 常见机型和系统推荐


| 型号 |推荐系统  |内核版本|
|-----|-----|-----|
| Radxa e20c | [armbian](https://drive.google.com/file/d/1_UFO9dzp3oDMfn2EQCWFGecKiFlY4w2e/view?usp=sharing) ✅ |5.10.x or 6.1|
| NanoPi R4S | [armbian](https://dl.armbian.com/nanopi-r4s/Bookworm_current_server) ✅ |6.6|
| NanoPi R4SE | [armbian](https://drive.google.com/file/d/1Ip0pcMIKew3nvOpAbhvw294KxGKULGnd/view?usp=sharing) ✅ |6.1|
|RaspberryPi-4B|[RaspberryPiOS](https://www.raspberrypi.com/software/) ✅ |6.1|
|电犀牛R66S|[armbian](https://github.com/ophub/amlogic-s9xxx-armbian/releases) ✅ |6.1|

### 推荐内存是2G以上，不过1GB 也能跑通，如图：如果给虚拟机openwrt 3、400M内存
<img src="https://github.com/user-attachments/assets/32372c38-a147-4c24-aaf8-ae7537c1794e" alt="r4s" width="500">

![r4ss](https://github.com/user-attachments/assets/71582537-5914-4317-9e47-41292ecd95da)

![rrr](https://github.com/user-attachments/assets/176b64e2-c25d-49c5-b53a-adda63c2a535)
