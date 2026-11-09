# Lenovo Y7000P IRH8 · macOS Tahoe EFI

联想拯救者 **Y7000P IRH8 / 82YA，i7-13700H + RTX 4060 Laptop** 的 OpenCore EFI 与适配记录。

**当前为实验性快照，存在重启后卡在启动画面的未解决问题。** 本机曾正常进入 macOS，用户确认声音及系统原生 Wi-Fi 已恢复；这不等于已完成长期稳定性验证。蓝牙、触控板、睡眠唤醒仍需继续排查。

公开版本已经移除真实序列号、MLB、UUID、ROM、原始诊断和机器绑定资料。**仓库只提供 `config.sample.plist`；使用前必须生成自己的 `config.plist`。**

## 硬件与版本

| 项目 | 本机记录 |
| --- | --- |
| 机型 | Lenovo Legion Y7000P IRH8 / 82YA |
| 主板 / BIOS | LNVNB161216 / M2CN39WW |
| CPU | Intel Core i7-13700H；采集时 HT 关闭，14 个逻辑处理器 |
| 独显 | NVIDIA GeForce RTX 4060 Laptop，`10DE:28E0`，8 GB |
| 显示路线 | 独显直连；内屏由 NVIDIA 驱动 |
| 内存 | 32 GB DDR5，采集时运行于 5200 MT/s |
| 无线 / 蓝牙 | Intel AX211，Wi-Fi `8086:51F1`，蓝牙 USB `8087:0033` |
| 音频 | Intel `8086:51CA` 控制器 + Realtek ALC257 |
| 触控板 | FocalTech `FOCA0001`，I2C HID |
| 硬盘 | UMIS 1 TB + Samsung PM981 2 TB；macOS 位于 PM981 的 APFS 分区 |
| OpenCore | 1.0.9 DEBUG，基础 EFI 来自 1401 Windows 2.8.1 |
| 系统实测记录 | macOS 26.7.2 / 25G332，Darwin 25.6.0，以本机诊断输出为准 |
| SMBIOS | `MacBookPro16,2`；身份字段未公开 |

## 当前功能状态

| 功能 | 状态与验证范围 |
| --- | --- |
| 进入桌面 | 曾成功；随后普通重启仍复现启动停滞，未解决 |
| 内置声音 | 用户报告恢复；日志已识别 Realtek ALC257 输出及输入；各接口未逐项验证 |
| 系统原生 Wi-Fi | 用户确认开关及联网恢复；使用 Tahoe AirportItlwm alpha 分支 |
| NVIDIA 显示 | 驱动 2.8.1 曾加载并进入桌面；重启稳定性仍在排查 |
| Metal、视频编解码、性能 | 未完成专项验证 |
| 蓝牙 | 固件与修补驱动已配置；目前缺少耳机/鼠标配对验证及完整控制器诊断 |
| 触控板 | 当前禁用 I2C 驱动；重新启用实验曾伴随启动停滞，未完成定位 |
| USB | 使用 USBToolBox + UTBDefault；不是完整的本机端口定制表 |
| PM981 | 配置 NVMeFix 及针对性电源属性；不能据此视为完全兼容或长期稳定 |
| 电池、亮度、休眠唤醒 | 有相关组件，但未完成逐项验证 |

## 主要适配

- **声音**：本机 Intel 声卡报告 `class-code=040100`，当时 NMXAudio 只接管 NVIDIA HDMI。对 `PciRoot(0x0)/Pci(0x1f,0x3)` 注入 `class-code`，Data 为 `00030400`；随后用户确认声音恢复。本方案使用系统中已安装的 NMXAudio，EFI 不额外启用 AppleALC、SimpleHDA 或 VoodooHDA。
- **Wi-Fi**：启用 laobamac 的 `AirportItlwm` Tahoe `v2.4.0-alpha-7204c69`，限制 Darwin `25.0.0–25.99.99`；旧 itlwm 不加载。该分支暂不支持 WPA3-only、强制 PMF、AWDL/AirDrop、MLO，HE 保持默认关闭。见[上游说明](https://github.com/laobamac/itlwm)。
- **ACPI**：保留当前 BIOS 对应的替换 DSDT、定向 GPIO/XOSI 修正和辅助 SSDT，详见 [ACPI 记录](docs/ACPI.md)。更换 BIOS 后需要重新核对。
- **PM981**：仅对 `PciRoot(0x0)/Pci(0x6,0x2)/Pci(0x0,0x0)` 设置 `ps-max-latency-us` 为 8 字节零值，防止 NVMeFix 为它配置 APST。这不能消除所有 PM981 兼容性问题，见 [NVMeFix 上游说明](https://github.com/acidanthera/NVMeFix)。
- **日志**：`Misc → Debug → Target=3`，保留屏幕输出，关闭向 U 盘写日志。此前这支 U 盘的只读磁盘检查曾报告 FAT32 目录错误；文件系统修复并不包含在 EFI 备份中。

## 使用

1. 先保存自己的原始 EFI、SMBIOS 身份和磁盘数据。这个公开仓库不包含 macOS 安装镜像、已安装的 NVIDIA/NMXAudio 系统驱动或私有 1401 machine profile。
2. 对照上面的硬件、BIOS 和显示连接方式。尤其不要把这份替换 DSDT 当作其他 BIOS 或其他机型的通用补丁。
3. 按 [GenSMBIOS](https://github.com/corpnewt/GenSMBIOS) / OpenCore 的方式为 `MacBookPro16,2` 生成自己的身份，然后运行：

   ```bash
   python scripts/make_config.py
   ```

   脚本交互填写身份，并把 `EFI/OC/config.sample.plist` 生成到被 Git 忽略的 `EFI/OC/config.plist`。不会生成或提交真实身份到仓库。

4. 运行本项目检查及与版本匹配的 OpenCore `ocvalidate`：

   ```bash
   python scripts/check_efi.py --configured
   /path/to/OpenCore-1.0.9/Utilities/ocvalidate/ocvalidate EFI/OC/config.plist
   ```

5. 将完整 `EFI` 目录复制到自己的启动盘，保留可启动的恢复方案。NVIDIA 系统驱动需要按 [NullMoth 官方项目](https://github.com/nullmoth/nvidia-macos-driver)单独安装和验证。

公开配置在身份填好前不可直接用于启动。首次复制此项目也不会自动修复安装在 APFS 卷内的驱动、系统缓存、固件变量或文件系统。

## Boot guard 与重启问题

当前基线仍有**临时排错设置**：`NVRAM → Delete` 包含 `nullmoth-nv-starts`，每次启动清除 NVIDIA 失败计数。这会干预上游的连续失败保护，不能当作最终长期配置。稳定性问题解决后应恢复官方保护，见[上游实现](https://github.com/nullmoth/nvidia-macos-driver/blob/v2.8.1/kexts/NVRM/nvrm_off.h)。

最新启动照片中 NVRM 显示 `start 1` 并开始加载，ALC257 也已识别；因此这次并没有显示显卡因“两次失败”保护而被停用。照片同时有 IOVersatile、DriverKit 和 APFS 快照日志，但单凭最后一行不能确认根因。具体过程见 [排障记录](docs/TROUBLESHOOTING.md)。

## 文件组织

```text
EFI/                         OpenCore、当前启用组件、ACPI 与脱敏配置模板
docs/                        状态、ACPI 和排障说明
scripts/                     本地生成配置、静态检查、macOS 只读诊断
third_party/                 组件来源、对应源码与收集到的许可证
manifest/                    文件 SHA-256、组件版本和检查记录
```

公开版清理了历史 `config.plist.before-*` 和未使用的 AppleALC、SimpleHDA、itlwm、VoodooI2C 等驱动文件及禁用加载项；当前已启用的运行参数保持基线一致。私有完整备份留在本地，不在 Git 历史中。

## 来源与许可

感谢 [OpenCore/Acidanthera](https://github.com/acidanthera)、[1401](https://github.com/nullmoth/1401)、[OpCore Simplify](https://github.com/lzhoang2801/OpCore-Simplify)、[NullMoth](https://github.com/nullmoth/nvidia-macos-driver)、[OpenIntelWireless](https://github.com/OpenIntelWireless)、[laobamac](https://github.com/laobamac)、[VoodooI2C](https://github.com/VoodooI2C) 及各驱动作者。

本项目原创说明和辅助脚本采用 MIT；第三方二进制、资源及固件表保留各自权利，不因本仓库的 MIT 文件而更换许可证。组件、版本、源码入口和许可证见 [third_party/README.md](third_party/README.md)。

记录日期：2026-11-09。欢迎提供同机型、同 BIOS 的复现信息；公开提交前请先移除日志里的序列号、MAC 地址及账号信息。
