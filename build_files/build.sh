#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
# dnf5 install -y tmux

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

#systemctl enable podman.socket

# Enable repos
sed -i 's@enabled=0@enabled=1@g' "/etc/yum.repos.d/terra.repo"

# install extra packages from fedora repos
dnf5 install -y \
    htop \
    screen

dnf5 -y copr enable ublue-os/packages
dnf5 -y install ublue-brew
dnf5 -y copr disable ublue-os/packages

# remove pre-installed packages
dnf5 remove -y \
    tailscale

# Disable repos
sed -i 's@enabled=1@enabled=0@g' "/etc/yum.repos.d/terra.repo"


systemctl enable brew-setup.service
systemctl enable brew-upgrade.timer
systemctl enable brew-update.timer