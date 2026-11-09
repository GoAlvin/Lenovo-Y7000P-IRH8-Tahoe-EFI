#!/usr/bin/env python3
"""Check files, identity isolation, ACPI checksums and injected-kext dependency order."""
from pathlib import Path
import argparse
import hashlib
import json
import plistlib
import struct
import uuid

ROOT = Path(__file__).resolve().parent.parent

def check(configured=False):
    oc = ROOT / 'EFI/OC'
    config = plistlib.loads((oc / ('config.plist' if configured else 'config.sample.plist')).read_bytes())
    generic = config['PlatformInfo']['Generic']
    assert generic['SystemProductName'] == 'MacBookPro16,2'
    if configured:
        assert generic['SystemSerialNumber'] and generic['MLB']
        assert uuid.UUID(generic['SystemUUID']).int != 0
        assert isinstance(generic['ROM'], bytes) and len(generic['ROM']) == 6 and any(generic['ROM'])
    else:
        assert all(generic[k] == '' for k in ('SystemSerialNumber', 'MLB', 'SystemUUID'))
        assert generic['ROM'] == bytes(6)
    assert (ROOT / 'EFI/BOOT/BOOTx64.efi').is_file()
    positions = {}
    infos = []
    for index, entry in enumerate(config['Kernel']['Add']):
        if not entry['Enabled']:
            continue
        bundle = oc / 'Kexts' / entry['BundlePath']
        info = plistlib.loads((bundle / entry['PlistPath']).read_bytes())
        if entry['ExecutablePath']:
            assert (bundle / entry['ExecutablePath']).is_file(), entry['BundlePath']
        assert info['CFBundleIdentifier'] not in positions
        positions[info['CFBundleIdentifier']] = index
        infos.append((index, info))
    for index, info in infos:
        for dependency in info.get('OSBundleLibraries', {}):
            if dependency in positions:
                assert positions[dependency] < index, (info['CFBundleIdentifier'], dependency)
    for entry in config['ACPI']['Add']:
        if entry['Enabled']:
            data = (oc / 'ACPI' / entry['Path']).read_bytes()
            assert len(data) == struct.unpack_from('<I', data, 4)[0]
            assert sum(data) % 256 == 0, entry['Path']
    for entry in config['UEFI']['Drivers']:
        if entry['Enabled']:
            assert (oc / 'Drivers' / entry['Path']).is_file(), entry['Path']
    for entry in config['Misc']['Tools']:
        if entry['Enabled']:
            assert (oc / 'Tools' / entry['Path']).is_file(), entry['Path']
    active = {e['BundlePath'] for e in config['Kernel']['Add'] if e['Enabled']}
    assert 'AirportItlwm.kext' in active and 'itlwm.kext' not in active
    assert not any(n.startswith(('VoodooI2C', 'SimpleHDA', 'AppleALC')) for n in active)
    assert config['DeviceProperties']['Add']['PciRoot(0x0)/Pci(0x1f,0x3)']['class-code'] == bytes.fromhex('00030400')
    assert config['Misc']['Debug']['Target'] == 3
    manifest = json.loads((ROOT / 'manifest/EFI-SHA256.json').read_text())
    for name, expected in manifest.items():
        actual = hashlib.sha256((ROOT / name).read_bytes()).hexdigest()
        assert actual == expected, name
    print(f'PASS: {len(active)} enabled entries; ACPI, files, dependency order and {len(manifest)} public file hashes verified.')
    print('Static checks do not establish boot, restart, graphics or peripheral stability.')

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--configured', action='store_true')
    check(parser.parse_args().configured)
