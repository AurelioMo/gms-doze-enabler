# Contributing

Bug reports and pull requests are welcome.

When reporting a compatibility issue, include:

- Device model and Android/One UI version
- Root framework and version
- Active KernelSU metamodule, if applicable
- Output of `cmd deviceidle whitelist`
- The affected XML path, without private data

Keep changes compatible with Android `/system/bin/sh` and avoid hardcoded device-specific paths. Run `sh -n` against every changed shell script before submitting a pull request.
