# ACPI 适配记录

适配对象为 Lenovo Y7000P IRH8、BIOS M2CN39WW。本目录说明的是当前文件的来源和已做修改，不表示所有 ACPI 运行时问题均已解决。

## 替换 DSDT

`EFI/OC/ACPI/DSDT.aml` 来自本机固件表并经过定向修正：

1. 保留之前为前向引用 Scope 所作的延后处理。
2. 将仅属于 GPI0 的 `_STA → XSTA` 重命名直接写入替换 DSDT，避免全局字节补丁命中其他 SSDT 的同名方法。
3. 将 31 处 `_OSI → XOSI` 调用重命名写入替换 DSDT。
4. 重新计算 ACPI 表校验和。

对应的两条全局 OpenCore Patch 在配置中保留为禁用，避免重复修改。辅助 `SSDT-GPI0` 和 `SSDT-XOSI` 保留。

其他辅助表包括 SBUS、EC、MCHC、PLUG-ALT、RTCAWAC、USB-Reset、USBX。

本机 ACPI 路径：

| 设备 | 路径 |
| --- | --- |
| Intel 音频 | `_SB.PC00.HDAS`，PCI `0:31:3` |
| I2C 触控板 | `_SB.PC00.I2C0.TPAD`，硬件 ID `FOCA0001`、兼容 ID `PNP0C50` |
| Intel 蓝牙 USB | Windows 枚举为 `_SB.PC00.XHCI.RHUB.HS10` |

## 尚未解决

早期启动照片曾有 OEM SSDT `CB-01` 的 `_UPC` 重复定义及一张表加载失败记录。该问题尚未完成独立修复，不应仅按 OEM Table ID 删除所有同名表。

触控板重新启用实验没有得到稳定启动结果。当前公开基线不加载 VoodooI2C/VoodooI2CHID。`-vi2c-force-polling` 参数仍保留，但驱动禁用时不会让触控板工作。

更换 BIOS 后，请重新提取和核对 ACPI；此仓库的完整 DSDT 不作为跨机器通用模板。
