# 一键KVM虚拟机

### Armbian/Ubuntu/Debian/RaspberryPiOS等基于Debian的Linux

```bash
wget -qO kvm.sh https://cafe.cpolar.cn/wkdaily/e20c/raw/branch/master/e20c/kvm.sh && chmod +x kvm.sh && ./kvm.sh

```
### 配套图文📁 https://wkdaily.cpolar.cn/archives/e20chelper
### 相关视频📺️ https://www.bilibili.com/video/BV12msDegEFg
### 相关视频📺️ https://www.youtube.com/watch?v=YjMzyja9xWo

### 该项目兼容x86-64 和 arm64 双平台、推荐使用linux内核为5.x以上、推荐内存2G以上
### 推荐使用支持KVM虚拟化的cpu，因为如果不支持，就只能单靠QEMU模拟，性能会大打折扣。
- 瑞芯微系列✅
- 树莓派的博通系列✅
- 全志Allwinner ❌ 普遍不支持KVM
- 晶晨的盒子 这个存量太大 以实际测试为准
### 试问？arm机型debian系统下创建虚拟机有什么优势？
- 充分利用了硬件性能。 对于大内存且CPU支持KVM的机型，不浪费其硬件性能。这条路是漫长发展的，但未来趋势，势不可挡。毕竟都出现了32GB内存的RK3588
- 底层debian具备大量稳定网卡驱动的适配,哪怕是单网口arm开发板,只要具备usb，就能扩展网卡（桥接）给虚拟机使用。一定程度上减少了openwrt不识别网卡的问题。代表机型NEO3
- 底层debian系统增强了docker运行的稳定性。大量开源项目、脚本都是在debian中使用的。例如小雅alist等。
- 底层debian系统有极为丰富的软件生态。成熟项目、脚本均适配了该系统。
- 对于单网口但是带wifi网卡的机型，若不用虚拟机拨号，则可将wifi桥接（模拟）为有线网卡，这样可组成双网口虚拟机软路由。代表机型树莓派4b
- qemu虚拟机固件的统一性。若采用arm虚拟机，虚拟机的固件则相同。不用单独找对应型号的固件。比如你的R4S 跟 树莓派4b 可以共用同一个qemu固件。一定程度上玩出了x86的统一快感。


### 常见机型和系统推荐


| 型号 |推荐系统固件<br>和下载地址|内核版本|备注建议|
|-----|-----------|-----|-----|
| Radxa e20c<br>(RK3528A) | [armbian](https://drive.google.com/file/d/1_UFO9dzp3oDMfn2EQCWFGecKiFlY4w2e/view?usp=sharing) ✅ |5.10.x or 6.1|❤️测试通过且推荐。<br>e20c开发板建议2GB内存以上 建议刷armbian系统并升级内核到6.1|
| NanoPi R4S<br>(RK3399) | [armbian](https://dl.armbian.com/nanopi-r4s/Bookworm_current_server) ✅ |6.6|测试通过但不推荐。<br>R4S 只有1GB内存 截图仅供测试 不建议低内存跑虚拟机 建议内存2GB起步|
| NanoPi R4SE<br>(RK3399) | [armbian](https://drive.google.com/file/d/1Ip0pcMIKew3nvOpAbhvw294KxGKULGnd/view?usp=sharing) ✅ |6.1| 未测试,跟R4S同款CPU,内存也大,理论可行,待网友验证
|RaspberryPi-4B|[RaspberryPiOS](https://www.raspberrypi.com/software/) ✅ |6.1|❤️测试通过。推荐4GB内存的树莓派
|电犀牛R66S<br>(RK3568)|[armbian](https://github.com/ophub/amlogic-s9xxx-armbian/releases) ✅ |6.1|❤️测试通过且推荐。刚好过2GB内存准入门槛，且该机型配备了双2.5G网口
| OrangePiZero3<br>(全志H618) | [debian](https://drive.google.com/drive/folders/1915jA2FgjUIUrdcEe4I1wxqSZgyDLiBN?usp=sharing) ✅ |6.1|测试通过但不推荐。<br>全志H618不支持KVM虚拟化,只能依赖QEMU仿真。因此不推荐此机型部署,当然如果你只是玩玩测试是可以的|
| Nanopi-R2S<br>(RK3328) | [armbian](https://armbian.systemonachip.net/archive/nanopi-r2s/archive/Armbian_23.11.1_Nanopi-r2s_bookworm_current_6.1.63.img.xz) ✅ |6.1|测试通过但不推荐。<br>R2S 内存只有1GB、推荐2GB以上机型。
|Nanopi-Neo3<br>(RK3328)|[armbian](https://k-space.ee.armbian.com/archive/nanopineo3/archive/Armbian_23.11.1_Nanopineo3_bookworm_current_6.1.63.img.xz) ✅ |6.1～6.6|❤️测试通过。刚好过2GB内存准入门槛。但是单网口比较适合做旁路由
|Radxa-zero3E<br>(RK3566)|[armbian](https://www.armbian.com/radxa-zero-3/) ✅ |6.1|❤️测试通过。拥有4GB内存 但是单网口比较适合做旁路由

### 推荐内存是2G以上，不过1GB 也能跑通，如图：如果给虚拟机openwrt 3、400M内存
<img src="https://github.com/user-attachments/assets/32372c38-a147-4c24-aaf8-ae7537c1794e" alt="r4s" width="500">

![r4ss](https://github.com/user-attachments/assets/71582537-5914-4317-9e47-41292ecd95da)

![rrr](https://github.com/user-attachments/assets/176b64e2-c25d-49c5-b53a-adda63c2a535)
