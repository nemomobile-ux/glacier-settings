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
Requires: kf5bluezqt-bluez4-declarative

BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  desktop-file-utils

%description
Settings application for nemo mobile

%package developermode
Summary: Developer mode plugin of glacier settings
Requires: %{name}

%description developermode
This plug-in represents access to the settings of developermode

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

desktop-file-install --delete-original       \
  --dir %{buildroot}%{_datadir}/applications             \
   %{buildroot}%{_datadir}/applications/*.desktop

%files
%defattr(-,root,root,-)
%{_bindir}/%{name}
%{_datadir}/%{name}
%exclude %{_datadir}/%{name}/qml/plugins/developermode
%exclude %{_datadir}/%{name}/qml/plugins/example
%exclude %{_datadir}/%{name}/plugins/developermode.json
%exclude %{_datadir}/%{name}/plugins/example.json
%{_datadir}/jolla-supported-languages
%{_datadir}/applications/%{name}.desktop
%{_datadir}/mapplauncherd/privileges.d/glacier-settings.privileges

%files developermode
%{_datadir}/%{name}/qml/plugins/developermode
%{_datadir}/%{name}/plugins/developermode.json

%files example
%{_datadir}/%{name}/qml/plugins/example
%{_datadir}/%{name}/plugins/example.json
