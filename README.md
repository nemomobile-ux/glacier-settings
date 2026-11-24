# Glacier Settings

Glacier Settings is the settings application for [Nemo Mobile](https://nemomobile.net/) and the Glacier UX. It provides a QML-based interface for configuring system and device settings through a modular plugin system.

## Features

Settings are organized into plugins, including:

- **About** — device and software information
- **Bluetooth** — Bluetooth adapter and device management
- **Certificates** — system and user certificate viewing
- **Date and time** — date, time, and time zone configuration
- **Device lock** — security and lock settings
- **Display** — brightness, orientation, theme, and scaling
- **Ethernet** — wired network configuration
- **Keypad** — hardware keypad backlight settings
- **Language** — interface language selection
- **Location** — GPS and location services
- **Mobile** — mobile network and SIM settings
- **NFC** — NFC configuration
- **Power save** — battery and power-saving settings
- **Sounds** — ringtones and volume levels
- **Storage** — device storage information
- **USB** — USB mode selection
- **VPN** — VPN configuration and OpenVPN import
- **Wi-Fi** — wireless network management

## Dependencies

Build-time dependencies include:

- CMake >= 3.10
- Qt 6 (Gui, Qml, Quick, Positioning, LinguistTools, DBus)
- KF6 BluezQt
- `systemsettings-qt6`
- `glacierapp6` / `glacierapp`
- `timed-qt6`
- `connman-qt6`
- `nemo-qml-plugin-devicelock`

Runtime dependencies depend on the enabled plugins and target distribution.

## Build

```bash
mkdir build
cd build
cmake .. \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=/usr
cmake --build .
```

To install:

```bash
sudo cmake --install .
```

To install the example plugin, configure with:

```bash
cmake .. -DBUILD_EXAMPLES=ON
```

## Translations

Translation sources are Qt Linguist `.ts` files:

- Main application: `translations/`
- Plugins: `src/plugins/*/translations/`

To refresh translation files after source changes, use `lupdate` (Qt 6):

```bash
/usr/lib/qt6/bin/lupdate src/main.cpp src/lib src/qml -ts translations/*.ts

for d in src/plugins/*/translations; do
  plugin_dir=$(dirname "$d")
  /usr/lib/qt6/bin/lupdate "$plugin_dir" -ts "$d"/*.ts
done
```

Compiled `.qm` files are generated during build via `qt6_add_translation`.

## License

LGPL. See `rpm/glacier-settings.spec` for packaging metadata.
