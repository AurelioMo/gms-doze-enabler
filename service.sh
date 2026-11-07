#!/data/adb/magisk/busybox sh
GMS='com.google.android.gms'
NULL=/dev/null
tries=0
while [ "$(getprop sys.boot_completed 2>"$NULL")" != 1 ] && [ "$tries" -lt 120 ]; do
  sleep 2
  tries=$((tries + 1))
done
for user_dir in /data/user/*; do
  [ -d "$user_dir" ] || continue
  user=${user_dir##*/}
  for component in auth.managed.admin.DeviceAdminReceiver mdm.receivers.MdmDeviceAdminReceiver; do
    pm disable-user --user "$user" "$GMS/$GMS.$component" 2>"$NULL" || pm disable --user "$user" "$GMS/$GMS.$component" 2>"$NULL"
  done
done
cmd deviceidle whitelist -"$GMS" 2>"$NULL" || dumpsys deviceidle whitelist -"$GMS" 2>"$NULL"
exit 0
