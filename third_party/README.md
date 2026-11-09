# 第三方来源与许可

根目录 MIT 仅覆盖本项目原创说明和辅助脚本。下列组件、固件表及资源保留原作者的版权和许可；许可证以对应版本源码及组件自身文件为准。

## 内核扩展

| 组件 | 版本 | 来源 / 对应源码 |
| --- | --- | --- |
| AMFIPass.kext | 1.4.1 | [dortania/OpenCore-Legacy-Patcher](https://github.com/dortania/OpenCore-Legacy-Patcher/blob/main/payloads/Kexts/Acidanthera/AMFIPass-v1.4.1-RELEASE.zip) |
| AirportItlwm.kext | 2.4.0 | [laobamac/itlwm](https://github.com/laobamac/itlwm/tree/7204c69) |
| BlueToolFixup.kext | 2.7.3 | [acidanthera/BrcmPatchRAM](https://github.com/acidanthera/BrcmPatchRAM/tree/6538902) |
| BrightnessKeys.kext | 1.0.4 | [acidanthera/BrightnessKeys](https://github.com/acidanthera/BrightnessKeys/tree/37bdf47) |
| CpuTopologyRebuild.kext | 2.0.2 | [b00t0x/CpuTopologyRebuild](https://github.com/b00t0x/CpuTopologyRebuild/tree/2.0.2) |
| IntelBTPatcher.kext | 2.5.0 | [OpenIntelWireless/IntelBluetoothFirmware](https://github.com/OpenIntelWireless/IntelBluetoothFirmware/tree/a414375) |
| IntelBluetoothFirmware.kext | 2.5.0 | [OpenIntelWireless/IntelBluetoothFirmware](https://github.com/OpenIntelWireless/IntelBluetoothFirmware/tree/a414375) |
| Lilu.kext | 1.7.3 | [acidanthera/Lilu](https://github.com/acidanthera/Lilu/tree/0249c3a) |
| NVMeFix.kext | 1.1.4 | [acidanthera/NVMeFix](https://github.com/acidanthera/NVMeFix/tree/4862220) |
| RealtekRTL8111.kext | 2.4.2 | [Mieze/RTL8111_driver_for_OS_X](https://github.com/Mieze/RTL8111_driver_for_OS_X/tree/2.4.2) |
| RestrictEvents.kext | 1.1.7 | [acidanthera/RestrictEvents](https://github.com/acidanthera/RestrictEvents/tree/9265e78) |
| SMCBatteryManager.kext | 1.3.9 | [acidanthera/VirtualSMC](https://github.com/acidanthera/VirtualSMC/tree/b5c62c2) |
| SMCLightSensor.kext | 1.3.9 | [acidanthera/VirtualSMC](https://github.com/acidanthera/VirtualSMC/tree/b5c62c2) |
| SMCProcessor.kext | 1.3.9 | [acidanthera/VirtualSMC](https://github.com/acidanthera/VirtualSMC/tree/b5c62c2) |
| SMCSuperIO.kext | 1.3.9 | [acidanthera/VirtualSMC](https://github.com/acidanthera/VirtualSMC/tree/b5c62c2) |
| USBToolBox.kext | 1.2.0 | [USBToolBox/kext](https://github.com/USBToolBox/kext/tree/1.2.0) |
| UTBDefault.kext | 1.0 | [USBToolBox/kext](https://github.com/USBToolBox/kext/tree/1.2.0) |
| VirtualSMC.kext | 1.3.9 | [acidanthera/VirtualSMC](https://github.com/acidanthera/VirtualSMC/tree/b5c62c2) |
| VoodooPS2Controller.kext | 2.3.8 | [acidanthera/VoodooPS2](https://github.com/acidanthera/VoodooPS2/tree/7eab4a3) |
| WhateverGreen.kext | 1.7.2 | [acidanthera/WhateverGreen](https://github.com/acidanthera/WhateverGreen/tree/093e76f) |
| XHCI-unsupported.kext | 0.9.2 | [daliansky/OS-X-USB-Inject-All](https://github.com/daliansky/OS-X-USB-Inject-All/tree/v0.8.0) |
| YogaSMC.kext | 1.5.3 | [zhen-zen/YogaSMC](https://github.com/zhen-zen/YogaSMC/tree/1.5.3) |

VoodooPS2 的 VoodooInput 插件还引用 [acidanthera/VoodooInput](https://github.com/acidanthera/VoodooInput)。

## 引导、资源与固件表

- OpenCore 1.0.9 DEBUG、OpenRuntime、OpenCanopy、ResetNvramEntry：来源于 [OpenCorePkg](https://github.com/acidanthera/OpenCorePkg)，构建发布入口记录在下面的下载清单。
- HfsPlus、apfs_aligned 及界面资源：来源于 EFI 构建过程使用的 [OcBinaryData](https://github.com/acidanthera/OcBinaryData)；Background 图像来自 [OpCore Simplify](https://github.com/lzhoang2801/OpCore-Simplify)。未为这些资源额外声明本项目许可证。
- NullMothSafe.efi：来自 [1401 / NullMoth](https://github.com/nullmoth/1401) 安装流程，附 PolyForm Noncommercial 1.0.0 文本。
- DSDT：本机 Lenovo 固件表的针对性适配，OEM 权利保留；辅助表基于 1401/OpCore Simplify 的生成结果。
- AMFIPass：来源于 OpenCore Legacy Patcher 的官方 payload；项目级许可证不意味着对 payload 中所有第三方内容重新授权。

## 许可证文本索引

- Mieze/RTL8111_driver_for_OS_X: 未在上游常见根目录路径取得独立许可证文本；请核对[原项目](https://github.com/Mieze/RTL8111_driver_for_OS_X)及对应源码文件头，不为其额外授予 MIT 权利。
- OpenIntelWireless/IntelBluetoothFirmware: [随附文本](../third_party/licenses/OpenIntelWireless--IntelBluetoothFirmware--LICENSE)；[原始位置](https://raw.githubusercontent.com/OpenIntelWireless/IntelBluetoothFirmware/master/LICENSE)。
- USBToolBox/kext: 未在上游常见根目录路径取得独立许可证文本；请核对[原项目](https://github.com/USBToolBox/kext)及对应源码文件头，不为其额外授予 MIT 权利。
- acidanthera/BrcmPatchRAM: [随附文本](../third_party/licenses/acidanthera--BrcmPatchRAM--LICENSE)；[原始位置](https://raw.githubusercontent.com/acidanthera/BrcmPatchRAM/master/LICENSE)。
- acidanthera/BrightnessKeys: [随附文本](../third_party/licenses/acidanthera--BrightnessKeys--LICENSE)；[原始位置](https://raw.githubusercontent.com/acidanthera/BrightnessKeys/master/LICENSE)。
- acidanthera/Lilu: [随附文本](../third_party/licenses/acidanthera--Lilu--LICENSE.txt)；[原始位置](https://raw.githubusercontent.com/acidanthera/Lilu/master/LICENSE.txt)。
- acidanthera/NVMeFix: [随附文本](../third_party/licenses/acidanthera--NVMeFix--LICENSE.txt)；[原始位置](https://raw.githubusercontent.com/acidanthera/NVMeFix/master/LICENSE.txt)。
- acidanthera/OcBinaryData: 未在上游常见根目录路径取得独立许可证文本；请核对[原项目](https://github.com/acidanthera/OcBinaryData)及对应源码文件头，不为其额外授予 MIT 权利。
- acidanthera/OpenCorePkg: [随附文本](../third_party/licenses/acidanthera--OpenCorePkg--LICENSE.txt)；[原始位置](https://raw.githubusercontent.com/acidanthera/OpenCorePkg/master/LICENSE.txt)。
- acidanthera/RestrictEvents: [随附文本](../third_party/licenses/acidanthera--RestrictEvents--LICENSE.txt)；[原始位置](https://raw.githubusercontent.com/acidanthera/RestrictEvents/master/LICENSE.txt)。
- acidanthera/VirtualSMC: [随附文本](../third_party/licenses/acidanthera--VirtualSMC--LICENSE.txt)；[原始位置](https://raw.githubusercontent.com/acidanthera/VirtualSMC/master/LICENSE.txt)。
- acidanthera/VoodooInput: [随附文本](../third_party/licenses/acidanthera--VoodooInput--LICENSE.txt)；[原始位置](https://raw.githubusercontent.com/acidanthera/VoodooInput/master/LICENSE.txt)。
- acidanthera/VoodooPS2: 未在上游常见根目录路径取得独立许可证文本；请核对[原项目](https://github.com/acidanthera/VoodooPS2)及对应源码文件头，不为其额外授予 MIT 权利。
- acidanthera/WhateverGreen: [随附文本](../third_party/licenses/acidanthera--WhateverGreen--LICENSE.txt)；[原始位置](https://raw.githubusercontent.com/acidanthera/WhateverGreen/master/LICENSE.txt)。
- b00t0x/CpuTopologyRebuild: [随附文本](../third_party/licenses/b00t0x--CpuTopologyRebuild--LICENSE)；[原始位置](https://raw.githubusercontent.com/b00t0x/CpuTopologyRebuild/master/LICENSE)。
- daliansky/OS-X-USB-Inject-All: 未在上游常见根目录路径取得独立许可证文本；请核对[原项目](https://github.com/daliansky/OS-X-USB-Inject-All)及对应源码文件头，不为其额外授予 MIT 权利。
- dortania/OpenCore-Legacy-Patcher: [随附文本](../third_party/licenses/dortania--OpenCore-Legacy-Patcher--LICENSE.txt)；[原始位置](https://raw.githubusercontent.com/dortania/OpenCore-Legacy-Patcher/master/LICENSE.txt)。
- laobamac/itlwm: [随附文本](../third_party/licenses/laobamac--itlwm--LICENSE)；[原始位置](https://raw.githubusercontent.com/laobamac/itlwm/master/LICENSE)。
- lzhoang2801/OpCore-Simplify: [随附文本](../third_party/licenses/lzhoang2801--OpCore-Simplify--LICENSE)；[原始位置](https://raw.githubusercontent.com/lzhoang2801/OpCore-Simplify/master/LICENSE)。
- nullmoth/1401: [随附文本](../third_party/licenses/nullmoth--1401--LICENSE)；[原始位置](https://raw.githubusercontent.com/nullmoth/1401/master/LICENSE)。
- nullmoth/nvidia-macos-driver: [随附文本](../third_party/licenses/nullmoth--nvidia-macos-driver--LICENSE)；[原始位置](https://raw.githubusercontent.com/nullmoth/nvidia-macos-driver/master/LICENSE)。
- zhen-zen/YogaSMC: [随附文本](../third_party/licenses/zhen-zen--YogaSMC--LICENSE)；[原始位置](https://raw.githubusercontent.com/zhen-zen/YogaSMC/master/LICENSE)。

下载来源和版本用于追溯；不会把未经确认的组件称为本项目原创实现。

## 原始下载记录

见 [manifest/upstream-downloads.json](../manifest/upstream-downloads.json)。原始构建记录未提供包级哈希的条目标记为 `null`；本仓库另提供实际公开文件的 SHA-256，不能将本地文件哈希冒充上游发布签名。
