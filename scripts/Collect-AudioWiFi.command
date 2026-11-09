#!/bin/bash
set -u
HERE="$(cd "$(dirname "$0")" && pwd)"
DEST="$HOME/Desktop/Tahoe-AudioWiFi-diagnostics-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$DEST" || exit 1
{
  date
  sw_vers
  uname -r
  /usr/sbin/sysctl kern.bootargs
  echo '--- Loaded extensions ---'
  /usr/bin/kmutil showloaded 2>&1 | /usr/bin/grep -Ei 'AppleALC|SimpleHDA|AppleHDA|NMXAudio|VoodooHDA|AirportItlwm|itlwm|Lilu|IO80211|IOSkywalk' || true
  echo '--- Hardware network ports ---'
  /usr/sbin/networksetup -listallhardwareports
  echo '--- Installed audio extensions (known paths only) ---'
  for KEXT in NMXAudio VoodooHDA AppleHDA AppleALC SimpleHDA IOAudioFamily; do
    PLIST="/Library/Extensions/$KEXT.kext/Contents/Info.plist"
    if [ -f "$PLIST" ]; then
      printf '\n%s\n' "$PLIST"
      /usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' "$PLIST"
      /usr/libexec/PlistBuddy -c 'Print :CFBundleVersion' "$PLIST"
    fi
  done
  echo '--- Optional AppleHDA HAL presence ---'
  /bin/ls -ld /Library/Audio/Plug-Ins/SimpleHDA/AppleHDAHALPlugIn.bundle 2>&1
} > "$DEST/summary.txt" 2>&1
/usr/sbin/system_profiler SPAudioDataType SPAirPortDataType -detailLevel mini > "$DEST/audio-wifi.txt" 2>&1
for NAME in HDEF HDAS; do
  /usr/sbin/ioreg -r -n "$NAME" -l -w0 > "$DEST/ioreg-$NAME.txt" 2>&1
done
for CLASS in AppleHDAController IOHDACodecDevice IOAudioEngine itlwm AirportItlwm; do
  /usr/sbin/ioreg -r -c "$CLASS" -l -w0 > "$DEST/ioreg-$CLASS.txt" 2>&1
done
/usr/bin/log show --last 10m --style compact --predicate 'process == "kernel" AND (eventMessage CONTAINS[c] "SimpleHDA" OR eventMessage CONTAINS[c] "AppleALC" OR eventMessage CONTAINS[c] "AppleHDA" OR eventMessage CONTAINS[c] "AirportItlwm" OR eventMessage CONTAINS[c] "itlwm")' > "$DEST/kernel-audio-wifi.txt" 2>&1
if /usr/bin/ditto -c -k --keepParent "$DEST" "$DEST.zip"; then
  printf '\n诊断完成，桌面文件：%s.zip\n' "$DEST"
  if /bin/cp "$DEST.zip" "$HERE/"; then
    printf 'U 盘副本：%s/%s.zip\n' "$HERE" "$(basename "$DEST")"
  fi
else
  printf '\n诊断文件夹：%s\n' "$DEST"
fi
printf '包含本机网络信息，仅保存在本机和 U 盘，没有上传。\n'
