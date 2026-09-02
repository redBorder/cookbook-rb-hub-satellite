Name: cookbook-rb-hub-satellite
Version: %{__version}
Release: %{__release}%{?dist}
BuildArch: noarch
Summary: redborder hub satellite cookbook to install and configure hub-satellite system on redborder environment.

License: AGPL 3.0
URL: https://github.com/redBorder/cookbook-rb-hub-satellite
Source0: %{name}-%{version}.tar.gz

%description
%{summary}

%prep
%setup -qn %{name}-%{version}

%build

%install
mkdir -p %{buildroot}/var/chef/cookbooks/rb-hub-satellite
cp -f -r  resources/* %{buildroot}/var/chef/cookbooks/rb-hub-satellite/
chmod -R 0755 %{buildroot}/var/chef/cookbooks/rb-hub-satellite
install -D -m 0644 README.md %{buildroot}/var/chef/cookbooks/rb-hub-satellite/README.md

%pre
if [ -d /var/chef/cookbooks/rb-hub-satellite ]; then
    rm -rf /var/chef/cookbooks/rb-hub-satellite
fi

%post
case "$1" in
  1)
    # This is an initial install.
    :
  ;;
  2)
    # This is an upgrade.
    su - -s /bin/bash -c 'source /etc/profile && rvm gemset use default && env knife cookbook upload rb-hub-satellite'
  ;;
esac

%postun
# Deletes directory when uninstall the package
if [ "$1" = 0 ] && [ -d /var/chef/cookbooks/rb-hub-satellite ]; then
  rm -rf /var/chef/cookbooks/rb-hub-satellite
fi

%files
%defattr(0644,root,root)
%attr(0755,root,root)
/var/chef/cookbooks/rb-hub-satellite
%defattr(0644,root,root)
/var/chef/cookbooks/rb-hub-satellite/README.md

%doc

%changelog
* Wed Jul 29 2026 Vicente Mesa <vimesa@redborder.com>
- first spec version
