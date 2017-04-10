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
%qmake5

make %{?_smp_mflags}

%install
rm -rf %{buildroot}
%qmake5_install

mkdir -p %{buildroot}%{_datadir}/mapplauncherd/privileges.d
install -m 644 -p privileges %{buildroot}%{_datadir}/mapplauncherd/privileges.d/glacier-settings

desktop-file-install --delete-original       \
  --dir %{buildroot}%{_datadir}/applications             \
   %{buildroot}%{_datadir}/applications/*.desktop

%files
%defattr(-,root,root,-)
%{_bindir}
%{_datadir}/%{name}
%{_datadir}/applications/%{name}.desktop
%dir %{_datadir}/mapplauncherd
%dir %{_datadir}/mapplauncherd/privileges.d
%{_datadir}/mapplauncherd/privileges.d/glacier-settings
