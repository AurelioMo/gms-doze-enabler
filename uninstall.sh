#!/system/bin/sh
GMS='com.google.android.gms'
NULL=/dev/null
for user_dir in /data/user/*; do
  [ -d "$user_dir" ] || continue
  user=${user_dir##*/}
  for component in auth.managed.admin.DeviceAdminReceiver mdm.receivers.MdmDeviceAdminReceiver; do
    pm enable --user "$user" "$GMS/$GMS.$component" 2>"$NULL"
  done
done
cmd deviceidle whitelist +"$GMS" 2>"$NULL" || dumpsys deviceidle whitelist +"$GMS" 2>"$NULL"
rm -rf /data/adb/modules/gms-doze-enabler /data/adb/gms-doze-enabler
exit 0
