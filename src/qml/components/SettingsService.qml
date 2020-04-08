import QtQuick 2.6
import Nemo.DBus 2.0

Item {
    id: rootObject

    signal openSettingsPage(string plugin,  string extended)

    DBusAdaptor {
        id: settingsAdaptor
        service: "org.nemomobile.qmlsettings"
        path: "/"
        iface: "org.nemomobile.qmlsettings"

        xml: '  <interface name="org.nemomobile.qmlsettings">\n' +
             '    <method name="openSettingsPage" />\n' +
             '        <arg name="plugin" type="s" direction="in"/>\n' +
             '        <arg name="extended" type="s" direction="in"/>\n' +
             '    </method>\n' +
             '  </interface>\n'

        function openSettingsPage(plugin, extended) {
            rootObject.openSettingsPage(plugin, extended)
        }
    }
}
