# 排障记录

## 2026-11-09 的验证过程

| 阶段 | 结果与限制 |
| --- | --- |
| 原始安装/启动 | 处理定向 ACPI 与 PM981 电源配置后进入后续启动阶段；PM981 长期稳定性未确认 |
| 临时清除显卡失败计数 | 用户确认曾恢复进入桌面；这项每次启动清计数的排错设置仍在基线中 |
| AppleALC + SimpleHDA | 新增后出现停滞，照片最后有 SimpleHDA 加载 IOAudioFamily 信息；已撤回，未证实唯一根因 |
| OpenCore 初始化画面停住 | 同一支 U 盘 FAT32 检查报告目录错误；关闭文件日志后曾恢复启动，因果关系仍需进一步验证 |
| HeliPort 路线 | itlwm + HeliPort 曾确认联网；不提供系统原生 Wi-Fi 开关 |
| 原生 Wi-Fi + 声卡类别兼容 | Tahoe AirportItlwm 与 Intel HDAS class-code 覆盖后，用户明确确认声音及原生 Wi-Fi 成功 |
| I2C 触控板实验 | 恢复五项 I2C 加载项并只启用一份 VoodooInput 后出现启动停滞；已恢复成功基线 |
| 后续重启 | 成功基线曾再次进入桌面，但普通重启仍复现卡住。故当前整体启动稳定性仍标记为未解决 |

## 已知容易混淆的情况

- `Watchdog status is 0` 是 OpenCore 状态输出，不等于 macOS 显卡 boot guard 已触发。
- OpenCore 早期输出与 macOS 内核日志属于不同阶段；最后一行不必然就是故障源。
- 最新照片有 NVRM 2.8.1 启动、`boot guard: start 1`、Realtek ALC257 输出/输入。需要继续查显示交接和重启状态。
- `Driver ... has crashed 0 time(s)` 写的是零次，照片后面也有部分 DriverKit 服务启动成功信息；不能据此认定系统驱动损坏。
- `revert_to_snapshot`、`IOVersatile` 和 DriverKit 缓存报错需要结合完整日志判断，不能只凭照片决定重装或删除快照。
- 恢复 EFI 文件不会同时恢复 U 盘文件系统、固件 NVRAM、APFS 系统驱动和内核集合。

## 建议的下一步验证

1. 记录冷启动与从 macOS 普通重启的差异，先保持已验证声音、原生 Wi-Fi 的配置。
2. 按 NullMoth 官方恢复说明，使用 `1401: Start once without NVIDIA driver` 做一次显卡隔离测试；单次测试失败不能单独证明系统损坏。
3. 能进桌面时，运行本仓库的 `scripts/Collect-Boot-Stall.command` 收集已加载驱动、显卡状态、boot guard、系统卷和近期日志。
4. 蓝牙以进入配对模式的耳机、鼠标或键盘测试。仅使用手机/平板配对不足以确认故障，详见 [Intel 蓝牙 FAQ](https://openintelwireless.github.io/IntelBluetoothFirmware/FAQ.html)。
5. 触控板应在启动问题明确后再单独实验，保留 USB 鼠标和本机私有 EFI 备份。

诊断脚本只收集信息并写入桌面 ZIP，不自动上传。原始输出可能包含机器名、序列号、设备地址，请先脱敏再作为公开 Issue 附件。

## 原始资料

- [NullMoth 2.8.1 排障文档](https://github.com/nullmoth/nvidia-macos-driver/blob/v2.8.1/docs/TROUBLESHOOTING.md)
- [NVRM boot guard 实现](https://github.com/nullmoth/nvidia-macos-driver/blob/v2.8.1/kexts/NVRM/nvrm_off.h)
- [Tahoe AirportItlwm 分支](https://github.com/laobamac/itlwm)
- [NVMeFix](https://github.com/acidanthera/NVMeFix)
