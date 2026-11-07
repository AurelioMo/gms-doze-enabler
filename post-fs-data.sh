#!/data/adb/magisk/busybox sh
GMS='com.google.android.gms'
patch_xml() {
  sed -i -E "/allow-in-power-save.*package=[\"']${GMS}[\"']/d; /package=[\"']${GMS}[\"'].*allow-in-power-save/d; /allow-in-data-usage-save.*package=[\"']${GMS}[\"']/d; /package=[\"']${GMS}[\"'].*allow-in-data-usage-save/d" "$1"
}
for file in $(find /data/adb/modules /data/adb/post-fs-data.d /data/adb/service.d -type f -iname '*.xml' 2>/dev/null); do
  if grep -qE "(allow-in-power-save|allow-in-data-usage-save).*package=[\"']${GMS}[\"']|package=[\"']${GMS}[\"'].*(allow-in-power-save|allow-in-data-usage-save)" "$file" 2>/dev/null; then
    patch_xml "$file"
  fi
done
exit 0
