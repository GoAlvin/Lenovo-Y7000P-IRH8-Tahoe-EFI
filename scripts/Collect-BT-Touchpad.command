#!/bin/bash
set -u
HERE="$(cd "$(dirname "$0")" && pwd)"
DEST="$HOME/Desktop/Tahoe-BT-Touchpad-diagnostics-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$DEST" || exit 1
{
  date
  sw_vers
  uname -r
  /usr/sbin/sysctl kern.bootargs
  echo '--- Loaded extensions ---'
  /usr/bin/kmutil showloaded 2>&1 | /usr/bin/grep -Ei 'Bluetooth|IntelBT|BlueTool|Voodoo|USBToolBox|UTB|AirportItlwm|NMXAudio' || true
} > "$DEST/summary.txt" 2>&1
/usr/sbin/system_profiler SPBluetoothDataType SPUSBDataType -detailLevel mini > "$DEST/bluetooth-usb.txt" 2>&1
/usr/sbin/ioreg -p IOUSB -l -w0 > "$DEST/usb-registry.txt" 2>&1
/usr/bin/hidutil list > "$DEST/hid-devices.txt" 2>&1
for CLASS in IntelBluetoothFirmware IntelBTPatcher IOBluetoothHCIController IOBluetoothHostControllerUSBTransport VoodooI2CPCIController VoodooI2CDeviceNub VoodooI2CHIDDevice VoodooInput VoodooGPIO; do
  /usr/sbin/ioreg -r -c "$CLASS" -l -w0 > "$DEST/ioreg-$CLASS.txt" 2>&1
done
for NAME in TPAD I2C0 GPI0; do
  /usr/sbin/ioreg -p IOACPIPlane -r -n "$NAME" -l -w0 > "$DEST/acpi-$NAME.txt" 2>&1
done
/usr/bin/log show --last 15m --style compact --predicate '(process == "bluetoothd" OR process == "BlueTool") OR (process == "kernel" AND (eventMessage CONTAINS[c] "IntelFirmware" OR eventMessage CONTAINS[c] "IntelBluetooth" OR eventMessage CONTAINS[c] "IntelBTPatcher" OR eventMessage CONTAINS[c] "BlueTool" OR eventMessage CONTAINS[c] "VoodooI2C" OR eventMessage CONTAINS[c] "FOCA0001"))' > "$DEST/bluetooth-touchpad-log.txt" 2>&1
if /usr/bin/ditto -c -k --keepParent "$DEST" "$DEST.zip"; then
  printf '\n诊断完成，桌面文件：%s.zip\n' "$DEST"
  if /bin/cp "$DEST.zip" "$HERE/"; then
    printf 'U 盘副本：%s/%s.zip\n' "$HERE" "$(basename "$DEST")"
  fi
else
  printf '\n诊断文件夹：%s\n' "$DEST"
fi
printf '可能含蓝牙设备名、地址和 USB 序列号；仅保存在本机和 U 盘，没有上传。\n'
