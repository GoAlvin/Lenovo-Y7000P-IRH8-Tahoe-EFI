#!/usr/bin/env python3
"""Create a private OpenCore config from the public template. No network calls."""
from pathlib import Path
import plistlib
import re
import uuid

ROOT = Path(__file__).resolve().parent.parent

def main():
    source = ROOT / 'EFI/OC/config.sample.plist'
    target = ROOT / 'EFI/OC/config.plist'
    if target.exists():
        raise SystemExit('config.plist already exists; preserve it before generating another identity.')
    config = plistlib.loads(source.read_bytes())
    print('Generate your own MacBookPro16,2 identity with GenSMBIOS/macserial first.')
    serial = input('SystemSerialNumber: ').strip().upper()
    mlb = input('MLB: ').strip().upper()
    system_uuid = input('SystemUUID (blank = generate UUID): ').strip() or str(uuid.uuid4())
    rom = input('ROM (your own stable MAC address, 12 hex digits): ').strip().replace(':', '').replace('-', '')
    if not re.fullmatch(r'[A-Z0-9]{11,12}', serial):
        raise SystemExit('Expected an 11- or 12-character serial.')
    if not re.fullmatch(r'[A-Z0-9]{17}', mlb):
        raise SystemExit('Expected a 17-character MLB.')
    try:
        system_uuid = str(uuid.UUID(system_uuid)).upper()
    except ValueError:
        raise SystemExit('Invalid UUID.')
    if int(uuid.UUID(system_uuid)) == 0 or not re.fullmatch(r'[0-9a-fA-F]{12}', rom) or int(rom, 16) == 0:
        raise SystemExit('UUID and ROM must be valid and nonzero.')
    generic = config['PlatformInfo']['Generic']
    generic.update(SystemSerialNumber=serial, MLB=mlb, SystemUUID=system_uuid, ROM=bytes.fromhex(rom))
    with target.open('xb') as handle:
        plistlib.dump(config, handle, sort_keys=False)
    print('Created EFI/OC/config.plist locally. It is excluded from Git; run check_efi.py --configured and ocvalidate 1.0.9.')

if __name__ == '__main__':
    main()
