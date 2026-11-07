# GMS Doze Enabler

GMS Doze Enabler restores Android's battery optimization controls for Google Play services (`com.google.android.gms`) on rooted devices. It is designed for modern Android releases and vendor layouts, including Samsung One UI.

The module removes Google Play services from static Doze and data-saver exemptions, removes its runtime `deviceidle` whitelist entry at boot, and disables the two Google device-administrator receivers that can reassert management behavior. It handles multiple Android users and dynamic partitions such as `product`, `vendor`, `system_ext`, `odm`, `oem`, `system_dlkm`, and `apex`.

## Requirements

- Android 6.0 or newer (API 23+)
- Root through Magisk, KernelSU, or APatch
- KernelSU users need an active metamodule such as Magic Mount-rs, meta-overlayfs, or Hybrid Mount for `/system` overlays

## Installation

1. Install the ZIP from your root manager.
2. Reboot using the manager's supported reboot flow.
3. Check the result with:

```sh
su
cmd deviceidle whitelist | grep com.google.android.gms
```

An empty result means Google Play services is no longer in the runtime Doze whitelist. The `gmsdoze` command also reports its current state.

## Scope and trade-offs

This module targets battery optimization. Notifications, location sharing, Find My Device, device management, and other Google features may be delayed or behave differently when Android places Google Play services into Doze. Disable the module from the root manager to restore the original behavior.

## Compatibility notes

The installer uses the current `cmd deviceidle` interface and falls back to the legacy `dumpsys deviceidle` interface on older Android versions. XML overlays are copied below the module's `system/` tree so they work with Magisk and KernelSU metamodules.

## License

See [LICENSE](LICENSE).
