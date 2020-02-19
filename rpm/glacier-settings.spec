%{!?qtc_qmake:%define qtc_qmake %qmake}
%{!?qtc_qmake5:%define qtc_qmake5 %qmake5}
%{!?qtc_make:%define qtc_make make}
%{?qtc_builddir:%define _builddir %qtc_builddir}

Name:       glacier-settings
Summary:    Glacier Settings
Version:    0.1
Release:    1
Group:      System/Settings
License:    LGPL
URL:        https://github.com/nemomobile-ux/glacier-settings
Source0:    %{name}-%{version}.tar.bz2

Requires: nemo-qml-plugin-systemsettings >= 0.2.30
Requires: libqofonoext-declarative
Requires: nemo-qml-plugin-settings
Requires: qt5-qtquickcontrols-nemo >= 5.2.0
Requires: connman-qt5-declarative
Requires: mapplauncherd-booster-nemomobile
Requires: libglacierapp

#for gps plugin
Requires: qt5-qtdeclarative-import-positioning
Requires: qt5-plugin-position-geoclue

BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  pkgconfig(Qt5Positioning)
BuildRequires:  desktop-file-utils
BuildRequires:  qt5-qttools-linguist
BuildRequires:  pkgconfig(glacierapp)

%description
Settings application for nemo mobile

%package developermode
Summary: Developer mode plugin of glacier settings
Requires: %{name}

%description developermode
This plug-in represents access to the settings of developermode

%package bluez
Summary: bluez plugin of glacier settings
Requires: %{name}
Requires: kf5bluezqt-declarative

%description bluez
This plug-in provide bluetooth configuration for bluez

%package keyboard
Summary: Keyboard plugin of glacier settings
Requires: %{name}
Requires: maliit-plugins
Requires: nemo-qml-plugin-configuration-qt5

%description keyboard
This plug-in provide configuration of keyboard

%package example
Summary: Example plugin of glacier settings
Requires: %{name}

%description example
This is just example plugin

%prep
%setup -q -n %{name}-%{version}

%build
%qtc_qmake5
%qtc_make %{?_smp_mflags}

%install
rm -rf %{buildroot}
%qmake5_install

lrelease %{buildroot}%{_datadir}/%{name}/translations/*.ts

desktop-file-install --delete-original       \
  --dir %{buildroot}%{_datadir}/applications             \
   %{buildroot}%{_datadir}/applications/*.desktop

%files
%defattr(-,root,root,-)
%{_bindir}/%{name}
%{_datadir}/%{name}
%{_datadir}/dbus-1/services/org.nemomobile.qmlsettings.service
%exclude %{_datadir}/%{name}/qml/plugins/developermode
%exclude %{_datadir}/%{name}/plugins/developermode.json
%exclude %{_datadir}/%{name}/plugins/example.json
%exclude %{_datadir}/%{name}/qml/plugins/example
%exclude %{_datadir}/%{name}/plugins/bluez.json
%exclude %{_datadir}/%{name}/qml/plugins/bluez
%exclude %{_datadir}/%{name}/plugins/keyboard.json
%exclude %{_datadir}/%{name}/qml/plugins/keyboard

%{_datadir}/jolla-supported-languages
%{_datadir}/applications/%{name}.desktop
%{_datadir}/mapplauncherd/privileges.d/glacier-settings.privileges

%files developermode
%{_datadir}/%{name}/qml/plugins/developermode
%{_datadir}/%{name}/plugins/developermode.json

%files example
%{_datadir}/%{name}/qml/plugins/example
%{_datadir}/%{name}/plugins/example.json

%files bluez
%{_datadir}/%{name}/plugins/bluez.json
%{_datadir}/%{name}/qml/plugins/bluez

%files keyboard
%{_datadir}/%{name}/plugins/keyboard.json
%{_datadir}/%{name}/qml/plugins/keyboard
