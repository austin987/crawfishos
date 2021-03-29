#!/bin/bash

# This file is part of PrawnOS (https://www.prawnos.com)
# Copyright (c) 2020 Austin English <austinenglish@gmail.com>
# Copyright (c) 2020 Hal Emmerich <hal@halemmerich.com>

# PrawnOS is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2
# as published by the Free Software Foundation.

# PrawnOS is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with PrawnOS.  If not, see <https://www.gnu.org/licenses/>.

set -e
set -x

GITHUB_SHA="$1"
TEST_TARGET="$2"
BRANCH="$3"
BUILD_TYPE="$4"

# FIXME: how will this handle tags?
IMG="CrawfishOS-${TEST_TARGET}-git-${BRANCH}-${GITHUB_SHA}.img"

cd "$(dirname "$0")/.."

# Get dependencies:
apt-get update

# Currently, only kernel/blobby_kernel/image are supported. The prereqs may change if other targets are added:

# Required basic dependencies for build system:
apt install -y make git
make install_dependencies_yes TARGET=$TEST_TARGET

## Build stuff:
    case "$BUILD_TYPE" in
            ## Note: there's an error for /proc/modules, but at least building the kernel/image works fine:
            ## libkmod: ERROR ../libkmod/libkmod-module.c:1657 kmod_module_new_from_loaded: could not open /proc/modules: No such file or directory
        blobby_kernel)
             make blobby_kernel TARGET=$TEST_TARGET
             # FIXME: do we want to make it available via github actions?
             ;;
        image)
             make image TARGET=$TEST_TARGET

             # Compress, otherwise downloads take forever. Ideally we'd use zip here, but:
             # A) that would be an additional package to install,
             # B) github actions would then nest THAT zip inside a second zip, see https://github.com/actions/upload-artifact/issues/39
             # when ^ is fixed, revisit
             gzip -1 ${IMG}
             ;;
        kernel)
             make kernel TARGET=$TEST_TARGET
             # FIXME: do we want to make it available via github actions?
             ;;
        *)
             echo "ERROR: BUILD_TYPE must be specified: (blobby_kernel|image|kernel)"
             exit 1
             ;;
    esac
