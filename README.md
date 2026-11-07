# GMS Doze Enabler

Restore Android's battery optimization controls for Google Play services on rooted devices.

GMS Doze Enabler removes Google Play services (`com.google.android.gms`) from static Doze and data-saver exemptions, removes its runtime `deviceidle` whitelist entry at boot, and handles the dynamic partition layout used by current Android releases and Samsung One UI. It is a systemless KernelSU, Magisk, and APatch module.

> **KernelSU requirement:** KernelSU users must install a separate system-mount metamodule, such as **Magic Mount-rs**, **meta-overlayfs**, or **Hybrid Mount**. Without one, KernelSU can show this module as installed while its `system/` overlay is not applied.

## Download

[Download GMS Doze Enabler 1.0.0 from Releases](https://github.com/AurelioMo/gms-doze-enabler/releases/latest). Download `gms-doze-enabler-v1.0.0.zip` from the release assets. The repository source archive is not the installable module.

Current version: **1.0.0**

## Compatibility

| Component | Requirement |
| --- | --- |
| Root framework | KernelSU, Magisk, or APatch |
| KernelSU mounting | An active metamodule such as Magic Mount-rs, meta-overlayfs, or Hybrid Mount |
| Android | 6.0 or newer (API 23+) |
| Tested device | Samsung Galaxy S23 (SM-S911B) |
| Vendor layouts | Samsung One UI and dynamic `system_ext`, `product`, `vendor`, `odm`, `oem`, `system_dlkm`, and `apex` paths |

The module is vendor-oriented rather than model-specific. It searches the mounted system layout for the XML rules instead of relying on one fixed Samsung path.

## Installation

1. If you previously used **Universal GMS Doze**, disable or uninstall that older module first.
2. KernelSU users: install and activate one external metamodule (**Magic Mount-rs**, **meta-overlayfs**, or **Hybrid Mount**) before installing GMS Doze Enabler. Only one metamodule should be active.
3. Install the ZIP from the root manager's module screen.
4. Reboot using the manager's supported reboot flow so the system overlay is mounted.
5. Verify the runtime state:

```sh
su
cmd deviceidle whitelist | grep com.google.android.gms
```

An empty result means Google Play services is no longer in the runtime Doze whitelist. The optional `gmsdoze` command prints the same state in a compact form.

## What it changes

- Removes GMS entries for `allow-in-power-save` and `allow-in-data-usage-save` from system XML configuration.
- Removes GMS from the runtime `deviceidle` whitelist during boot.
- Disables the Google device-administrator receivers used for managed-device behavior, per Android user.
- Patches conflicting XML rules from other installed modules.
- Cleans only stale files named `*gms*` inside GMS data directories during installation.

## Trade-offs and recovery

Doze can delay Google notifications, location sharing, Find My Device, account synchronization, Play Games, and other background work. Disable the module from the root manager to restore the previous behavior. The uninstaller re-enables the managed-device receivers and restores the runtime whitelist entry.

If `com.google.android.gms` is still present in the XML after installation, check that KernelSU has an active metamodule and that the module overlay is mounted. A module can appear as installed while its `system/` files remain unapplied when no mount provider is active.

## Validation

- Shell syntax checked for all installer, boot, uninstall, and helper scripts.
- Install ZIP checked for the required module metadata and installer files.
- Installed and verified on a Samsung Galaxy S23 (SM-S911B) with KernelSU and Magic Mount-rs.
- Confirmed that the mounted Samsung XML no longer contains the two Doze/data-saver rules for GMS.
- Confirmed that `dumpsys deviceidle whitelist` no longer lists `com.google.android.gms`.

These checks confirm the tested configuration; behavior can still vary with vendor firmware, root framework, and active metamodule.

## Source and release

The module is built from the files in this repository. The release ZIP contains the same scripts and metadata committed to `main`. Release notes are maintained in [changelog.md](changelog.md).

## Credits

Developed by [AurelioMo](https://github.com/AurelioMo). The module format follows the Magisk/KernelSU module conventions. GMS Doze Enabler is independent of Google, Samsung, Magisk, KernelSU, and APatch.

## License

See [LICENSE](LICENSE).
