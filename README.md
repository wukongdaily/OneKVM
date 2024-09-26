# 一键KVM虚拟机
### 配套图文📁 https://wkdaily.cpolar.cn/archives/e20chelper
### 相关视频📺️ https://www.bilibili.com/video/BV12msDegEFg
### 相关视频📺️ https://www.youtube.com/watch?v=YjMzyja9xWo

### 该项目兼容x86-64 和 arm64 双平台、推荐使用linux内核为5.x以上、推荐内存2G以上

### Armbian/Ubuntu/Debian/RaspberryPiOS等基于Debian的Linux

```bash
wget -qO kvm.sh https://cafe.cpolar.cn/wkdaily/e20c/raw/branch/master/e20c/kvm.sh && chmod +x kvm.sh && ./kvm.sh

```
### 常见机型和系统推荐


| 型号 |推荐系统  |内核版本|备注建议|
|-----|-----|-----|-----|
| Radxa e20c | [armbian](https://drive.google.com/file/d/1_UFO9dzp3oDMfn2EQCWFGecKiFlY4w2e/view?usp=sharing) ✅ |5.10.x or 6.1|e20c开发板建议2GB内存以上 建议刷armbian系统并升级内核到6.1|
| NanoPi R4S | [armbian](https://dl.armbian.com/nanopi-r4s/Bookworm_current_server) ✅ |6.6|R4S 只有1GB内存 截图仅供测试 不建议低内存跑虚拟机 建议内存2GB起步|
| NanoPi R4SE | [armbian](https://drive.google.com/file/d/1Ip0pcMIKew3nvOpAbhvw294KxGKULGnd/view?usp=sharing) ✅ |6.1|
|RaspberryPi-4B|[RaspberryPiOS](https://www.raspberrypi.com/software/) ✅ |6.1|
|电犀牛R66S|[armbian](https://github.com/ophub/amlogic-s9xxx-armbian/releases) ✅ |6.1|
| OrangePiZero3 | [debian](https://drive.google.com/drive/folders/1915jA2FgjUIUrdcEe4I1wxqSZgyDLiBN?usp=sharing) ✅ |6.1|全志H618不支持KVM虚拟化,只能依赖QEMU仿真。因此不推荐此机型部署,当然如果你只是玩玩测试是可以的|

### 推荐内存是2G以上，不过1GB 也能跑通，如图：如果给虚拟机openwrt 3、400M内存
<img src="https://github.com/user-attachments/assets/32372c38-a147-4c24-aaf8-ae7537c1794e" alt="r4s" width="500">

![r4ss](https://github.com/user-attachments/assets/71582537-5914-4317-9e47-41292ecd95da)

![rrr](https://github.com/user-attachments/assets/176b64e2-c25d-49c5-b53a-adda63c2a535)
