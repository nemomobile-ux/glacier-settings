Name:       glacier-settings
Summary:    Glacier Settings
Version:    0.1
Release:    1
Group:      Qt/Qt
License:    LICENSE
URL:        http://example.org/
Source0:    %{name}-%{version}.tar.bz2
Source100:  glacier-settings.yaml

Requires: nemo-qml-plugin-systemsettings
Requires: qt5-qtquickcontrols-nemo >= 5.2.0
Requires: kf5bluezqt-bluez4-declarative

BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  desktop-file-utils

%description
Settings application for nemo mobile

%prep
%setup -q -n %{name}-%{version}

%build
%qtc_qmake5

make %{?_smp_mflags}

%install
rm -rf %{buildroot}
%qmake5_install

desktop-file-install --delete-original       \
  --dir %{buildroot}%{_datadir}/applications             \
   %{buildroot}%{_datadir}/applications/*.desktop

%files
%defattr(-,root,root,-)
%{_bindir}
%{_datadir}/%{name}
%{_datadir}/applications/%{name}.desktop
%{_datadir}/mapplauncherd/privileges.d/glacier-settings.privileges
