#!/data/adb/magisk/busybox sh
ui_print "- GMS Doze Enabler 1.0.0"
if [ -n "${BOOTMODE:-}" ] && [ -n "${KSU:-}" ]; then
  ui_print "- Installing from KernelSU app"
elif [ -n "${BOOTMODE:-}" ] && [ -n "${MAGISK_VER_CODE:-}" ]; then
  ui_print "- Installing from Magisk app"
else
  abort "- Install this module from Magisk or KernelSU (recovery is not supported)"
fi

API="${API:-$(getprop ro.build.version.sdk 2>/dev/null)}"
case "$API" in ''|*[!0-9]*) abort "- Unable to determine Android API level";; esac
[ "$API" -ge 23 ] || abort "- Unsupported API version: $API"
GMS='com.google.android.gms'
ROOT_DIR="${ROOT:-/}"
[ "$ROOT_DIR" = / ] || ROOT_DIR="${ROOT_DIR%/}"

matches_gms_rule() {
  grep -qE "(allow-in-power-save|allow-in-data-usage-save).*package=[\"']${GMS}[\"']|package=[\"']${GMS}[\"'].*(allow-in-power-save|allow-in-data-usage-save)" "$1" 2>/dev/null
}
patch_xml() {
  sed -i -E \
    "/allow-in-power-save.*package=[\"']${GMS}[\"']/d; /package=[\"']${GMS}[\"'].*allow-in-power-save/d; /allow-in-data-usage-save.*package=[\"']${GMS}[\"']/d; /package=[\"']${GMS}[\"'].*allow-in-data-usage-save/d" "$1"
}

ui_print "- Searching system XML files"
for dir in system system_ext product vendor odm oem system_dlkm apex; do
  base="$ROOT_DIR/$dir"
  [ -d "$base" ] || continue
  find "$base" -type f -iname '*.xml' 2>/dev/null | while IFS= read -r file; do
    if matches_gms_rule "$file"; then
      rel="${file#$ROOT_DIR}"
      case "$rel" in
        /system/*) overlay="${rel#/system}" ;;
        *) overlay="$rel" ;;
      esac
      dst="$MODPATH/system$overlay"
      mkdir -p "$(dirname "$dst")"
      cp -af "$file" "$dst" || continue
      patch_xml "$dst"
      ui_print "  Patched: $rel"
    fi
  done
done

ui_print "- Removing conflicting module rules"
for file in $(find /data/adb/modules /data/adb/post-fs-data.d /data/adb/service.d -type f -iname '*.xml' 2>/dev/null); do
  matches_gms_rule "$file" && patch_xml "$file"
done

mkdir -p "$MODPATH/system/bin"
cp -af "$MODPATH/gmsdoze" "$MODPATH/system/bin/gmsdoze"
rm -f "$MODPATH/gmsdoze"
ui_print "- Clearing stale GMS cache files"
for gms_dir in /data/user/*/com.google.android.gms /data/user_de/*/com.google.android.gms /data/data/com.google.android.gms; do
  [ -d "$gms_dir" ] || continue
  find "$gms_dir" -type f -name '*gms*' -delete 2>/dev/null
done
find "$MODPATH" -mindepth 1 -maxdepth 1 ! -name module.prop ! -name post-fs-data.sh ! -name service.sh ! -name system -exec rm -rf {} +
set_perm_recursive "$MODPATH" 0 0 0755 0755
set_perm "$MODPATH/system/bin/gmsdoze" 0 2000 0755
