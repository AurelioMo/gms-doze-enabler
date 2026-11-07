# Changelog

## GMS Doze Enabler 1.0.0

### First independent release

GMS Doze Enabler is released as a new project focused on keeping Google Play services eligible for Android Doze across current vendor layouts.

> **KernelSU users:** an external system-mount metamodule (Magic Mount-rs, meta-overlayfs, or Hybrid Mount) is required. The module cannot mount its `system/` overlay by itself.

### Changes

- Renamed and reorganized as an independent project.
- Added support for Samsung and dynamic `system_ext`, `product`, `vendor`, `odm`, `oem`, `system_dlkm`, and `apex` paths.
- Added current `cmd deviceidle` handling with a legacy fallback.
- Added multi-user boot handling.
- Added KernelSU, Magisk, and APatch detection.
- Added GMS-only stale-cache cleanup.
- Added a `gmsdoze` status command.

### Validation

Validated on a Samsung Galaxy S23 (SM-S911B) using KernelSU with Magic Mount-rs. The release ZIP was installed from the KernelSU Manager and the mounted Samsung XML and runtime `deviceidle` whitelist were checked after reboot.
