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
Requires: qt5-qtquickcontrols-nemo >= 5.2.0


BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  desktop-file-utils
BuildRequires:  qt5-qttools-linguist

%description
Settings application for nemo mobile

%package developermode
Summary: Developer mode plugin of glacier settings
Requires: %{name}

%description developermode
This plug-in represents access to the settings of developermode

%package bluez4
Summary: bluez4 plugin of glacier settings
Requires: %{name}
Requires: kf5bluezqt-bluez4-declarative

%description bluez4
This plug-in provide bluetooth configuration for bluez4 based devices

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
%exclude %{_datadir}/%{name}/qml/plugins/developermode
%exclude %{_datadir}/%{name}/plugins/developermode.json
%exclude %{_datadir}/%{name}/plugins/example.json
%exclude %{_datadir}/%{name}/qml/plugins/example
%exclude %{_datadir}/%{name}/plugins/bluez4.json
%exclude %{_datadir}/%{name}/qml/plugins/bluez4

%{_datadir}/jolla-supported-languages
%{_datadir}/applications/%{name}.desktop
%{_datadir}/mapplauncherd/privileges.d/glacier-settings.privileges

%files developermode
%{_datadir}/%{name}/qml/plugins/developermode
%{_datadir}/%{name}/plugins/developermode.json

%files example
%{_datadir}/%{name}/qml/plugins/example
%{_datadir}/%{name}/plugins/example.json

%files bluez4
%{_datadir}/%{name}/plugins/bluez4.json
%{_datadir}/%{name}/qml/plugins/bluez4
