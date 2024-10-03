# 一键KVM虚拟机

### Armbian/Ubuntu/Debian/RaspberryPiOS/飞牛fnOS 等基于Debian的Linux

```bash
wget -qO kvm.sh https://cafe.cpolar.cn/wkdaily/e20c/raw/branch/master/e20c/kvm.sh && chmod +x kvm.sh && ./kvm.sh

```
### 配套图文📁 https://wkdaily.cpolar.cn/archives/e20chelper
### ARM平台相关视频📺️ https://www.bilibili.com/video/BV12msDegEFg
### ARM平台相关视频📺️ https://www.youtube.com/watch?v=YjMzyja9xWo
### fnOS相关视频📺️ https://www.bilibili.com/video/BV1Zu4VetEXL
### fnOS相关视频📺️ https://www.youtube.com/watch?v=yGomQB4mFXk

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
### 试问？x86-64机型debian系统下创建kvm虚拟机有什么用？
- 可以弥补飞牛fnOS暂时没有虚拟机的问题
- debian在很古老的设备都能运行。但别的系统不一定。例如j1800的有些工控机的网卡，新iStoreOS就卡住启动不了。如果用KVM虚拟机运行iStoreOS，就没问题了。因为网卡是虚拟的，模拟了统一的硬件标准。再也不用担心升级后启动卡住。
- 轻量化是debian的极大优点，它的内存占用很低。剩余内存可直接用于虚拟机。
- debian系统一般都能识别wifi网卡，但市面上的成熟NAS反而缺乏wifi网卡驱动，单网口的电脑，若具备wifi，则可将wifi桥接（模拟）为有线网卡，这样可组成双网口虚拟机软路由。（不可用于拨号，因为无线不能拨号）
- 进退自如，如果你想升级到高级的虚拟机，可直接在debian系统下安装PVE，完成华丽的蜕变。（前提必须是debian原生系统哈，其他衍生版需要修改软件源比较麻烦。）
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
|Dell Wyse3030<br>(x86-64 赛扬N2807)|[armbian](https://www.armbian.com/uefi-x86/) ✅ |6.6|❤️测试通过。4GB内存 但是单网口比较适合做旁路由

### 推荐内存是2G以上，不过1GB 也能跑通，如图：如果给虚拟机openwrt 3、400M内存
<img src="https://github.com/user-attachments/assets/32372c38-a147-4c24-aaf8-ae7537c1794e" alt="r4s" width="500">

![r4ss](https://github.com/user-attachments/assets/71582537-5914-4317-9e47-41292ecd95da)

![rrr](https://github.com/user-attachments/assets/176b64e2-c25d-49c5-b53a-adda63c2a535)
### x86-64 机型举例 比如dell wyse3030
![x86](https://github.com/user-attachments/assets/6af68be5-7b9a-4eb8-8e73-26aad9b1c393)

![iStoreOS on QEMU:KVM 2024-09-28 21-51-42](https://github.com/user-attachments/assets/281b3d77-fea7-47c9-8e00-9b6a4e33a435)
### x86-64 机型 系统是基与debian12的飞牛fnOS v0.8.20 CPU:Intel 赛扬N4100 4*2.5G网口
<img src="https://github.com/user-attachments/assets/e2899894-04f3-4bfd-9bb0-344fbc8765f9" alt="r4s" width="500">

## 注意事项
#### 对于非管理的网口，如果你为了虚拟机设置了网桥，那么你最好将其手动设置ip，这ip随便啥都行，主要目的是为了，让它一直处于激活状态。
![网络 - wukong@j1800 2024-10-03 15-37-33](https://github.com/user-attachments/assets/aeb53107-63fa-482c-a07a-49678a27f11b)

![网络 - wukong@j1800 2024-10-03 15-42-56](https://github.com/user-attachments/assets/c22babcc-96a8-4f6a-b7e3-d41f629151f4)

#### 如果不是nas系统，而是debian系统，这时可能不分管理口，每个网口都一样。此时应该也将“wan” 这个网桥设置一个同网段的静态ip。这样做也是为了让这个网桥处于激活状态。防止虚拟软路由wan口无法联网。
