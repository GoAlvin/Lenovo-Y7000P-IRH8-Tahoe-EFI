#!/bin/bash
set -u
HERE="$(cd "$(dirname "$0")" && pwd)"
DEST="$HOME/Desktop/Tahoe-Boot-diagnostics-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$DEST" || exit 1
{
  date
  sw_vers
  uname -r
  uptime
  /usr/sbin/sysctl kern.bootargs kern.boottime
  echo '--- Loaded graphics and audio extensions ---'
  /usr/bin/kmutil showloaded 2>&1 | /usr/bin/grep -Ei 'nullmoth|NVAccel|NVRM|Lilu|AMFI|WhateverGreen|IOGraphics|IONDRV|Voodoo|AirportItlwm' || true
  echo '--- Read-only GPU status queries ---'
  for KEY in debug.nvrmfb_guard_cleared debug.nvrmfb_state debug.nvrmfb_status debug.nvrmfb_heads debug.nvaccel_heads_published debug.nvaccelfb debug.nvaccel_iop_ok debug.nvaccel_vm_refused; do
    /usr/sbin/sysctl "$KEY" 2>&1
  done
  echo '--- Boot guard variables (read only) ---'
  for KEY in nullmoth-nv-starts nullmoth-nv-ok nullmoth-remove nullmoth-audio-attaching nullmoth-audio-state; do
    /usr/sbin/nvram "7C436110-AB2A-4BBB-A880-FE41995C9F82:$KEY" 2>&1
  done
} > "$DEST/summary.txt" 2>&1
{
  echo '--- Installed versions and executable hashes ---'
  for KEXT in NVRM NVRMFB NVAccel NVRMAGDC NMXAudio; do
    BASE="/Library/Extensions/$KEXT.kext/Contents"
    if [ -f "$BASE/Info.plist" ]; then
      echo "$BASE"
      /usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' "$BASE/Info.plist"
      /usr/libexec/PlistBuddy -c 'Print :CFBundleVersion' "$BASE/Info.plist"
      EXE="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleExecutable' "$BASE/Info.plist" 2>/dev/null)"
      /usr/bin/shasum -a 256 "$BASE/MacOS/$EXE"
    fi
  done
  echo '--- Installer boot-guard and fallback logs ---'
  for LOG in /Library/NullMoth/bootguard.log /Library/NullMoth/lastgood.log /Library/NullMoth/driver-version /Library/NullMoth/driver-restored; do
    if [ -f "$LOG" ]; then echo "$LOG"; /usr/bin/tail -n 100 "$LOG"; fi
  done
} > "$DEST/nullmoth-installation.txt" 2>&1
{
  /sbin/mount
  /usr/sbin/diskutil info /
  /usr/sbin/diskutil apfs listSnapshots /
  echo '--- DriverKit files (presence only) ---'
  /bin/ls -ld /System/Library/DriverExtensions/AppleUserHIDDrivers.dext /System/DriverKit/System/Library/dyld /System/Cryptexes/OS/System/DriverKit/System/Library/dyld
  echo '--- IOVersatile property-list validity and dependencies ---'
  PLIST=/System/Library/Extensions/IOVersatile.kext/Contents/Info.plist
  if [ -f "$PLIST" ]; then
    /usr/bin/plutil -lint "$PLIST"
    /usr/libexec/PlistBuddy -c 'Print :OSBundleLibraries' "$PLIST"
  fi
} > "$DEST/system-volume.txt" 2>&1
/usr/sbin/system_profiler SPDisplaysDataType SPAudioDataType -detailLevel mini > "$DEST/display-audio.txt" 2>&1
for CLASS in NVRM NVRMFB NVAccel IOFramebuffer IODisplayConnect; do
  /usr/sbin/ioreg -r -c "$CLASS" -l -w0 > "$DEST/ioreg-$CLASS.txt" 2>&1
done
/usr/bin/log show --last 1h --style compact --predicate '(process == "WindowServer") OR (process == "kernel" AND (eventMessage CONTAINS[c] "NVRM" OR eventMessage CONTAINS[c] "NVAccel" OR eventMessage CONTAINS[c] "NullMoth" OR eventMessage CONTAINS[c] "IOVersatile" OR eventMessage CONTAINS[c] "AppleUserHIDDrivers" OR eventMessage CONTAINS[c] "shared_region"))' 2>&1 | /usr/bin/tail -n 20000 > "$DEST/boot-display-log.txt"
if /usr/bin/ditto -c -k --keepParent "$DEST" "$DEST.zip"; then
  printf '\n诊断 ZIP：%s.zip\n' "$DEST"
  case "$HERE" in /Volumes/*) /bin/cp "$DEST.zip" "$HERE/" ;; esac
else
  printf '\n诊断文件夹：%s\n' "$DEST"
fi
printf '只读取系统状态，不修改驱动、快照、NVRAM 或磁盘；日志仅保存到本机及脚本所在 U 盘，没有上传。\n'
