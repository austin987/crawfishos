<p align="center">
<img src="/filesystem/resources/logo/newPrawn_transparent_high_compression.png" alt="CrawfishOS" data-canonical-src="/resources/BuildResources/logo/newPrawn_transparent_high_compression.png" width="200" height="200" /></p>

<h1 align="center">
CrawfishOS
</h1>

### Forked from [PrawnoS](https://github.com/SolidHal/PrawnOS), which is a build system for making blobless Debian and mainline Linux kernel with support for libre ath9k wireless, dmcrypt/LUKS root partition encryption, and graphics acceleration using panfrost

CrawfishOS allows blobs (in particular, for onboard Broadcom wireless). Otherwise it aims to match upstream PrawnOS (aside from PRs pending upstream).

Current pending upstream work includes:
* https://github.com/SolidHal/PrawnOS/pull/267
* https://github.com/SolidHal/PrawnOS/pull/268
* https://github.com/SolidHal/PrawnOS/pull/269
* https://github.com/SolidHal/PrawnOS/pull/270
* https://github.com/SolidHal/PrawnOS/pull/271

Not PRed for misc reasons:
* keyboardhack: PrawnOS package overwrites another package's file. rm it first. Probably a bug, ignored for now.
* leave lilyterm alone for now: something later tries to pull it in, so if there's no internet connection, install fails. Need to find what's pulling it in.
* Revert "bump armhf to 5.10.1, upload package": 5.10.1 breaks booting on speedy/emmc for me. Need a dedicated issue (wanted to try newer kernel first, maybe).
* scripts/Shared/package_lists.sh: use xfce4-screensaver instead of xsecurelock on xfce: depends on other pending PRs
* scripts/InstallScripts/InstallPackages.sh: remove dead code: depends on other pending PRs

Supports the following Devices:
* armhf cpu:
    * Asus C201 (C201P) (C201PA) (veyron-speedy)
    * _UNTESTED_ Asus C100 (veyron-minnie) (untested)
    * _UNTESTED_ Asus Chromebit CS10 (veyron-mickey)
* arm64 cpu:
    * _UNTESTED_ Samsung Chromebook Plus V1 (XE513C24) (gru-kevin)
    * _UNTESTED_ Asus C101p (gru-bob)

Build Debian filesystem with:
* Currently CrawfishOS supports xfce and gnome as choices for desktop enviroment.
* full root filesystem encryption
* mesa with support for panfrost for graphics acceleration 
* functional sound, touchpad, keyboard mappings

Build a blobby mainline kernel with:
* Patches for reliable USB on veyron devices.
* Patches to support the custom GPT partition table required to boot on veyron devices.
* Support for onboard Broadcom (BCM4354) WiFi.
* Support for Atheros AR9271 and AR7010 WiFi dongles.
* Support for CSR8510 (and possibly other) bluetooth dongles.

## Image Download

If you don't want to or can't build the image, you can find downloads under <releases> https://github.com/austin987/CrawfishOS/releases

## Dependencies

Building CrawfishOS has been tested on Debian 10 Buster (in a VM).

NOTE: _stretch doesn't work as the version of gcc-arm-none-eabi is too old_!

NOTE: _buster requires backports to build packages because of https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=965109_

Debian Bullseye or Buster with the Buster Backports repo are the only build environments that are supported.
These packages are required:

<!-- Please keep the packages sorted (and in sync with ./tests/build-image.sh): -->
``` 
        apt install --no-install-recommends --no-install-suggests \
        bc binfmt-support bison build-essential bzip2 ca-certificates cgpt cmake cpio debhelper \
        debootstrap device-tree-compiler devscripts file flex g++ gawk gcc gcc-aarch64-linux-gnu \
        gcc-arm-none-eabi git gpg gpg-agent kmod libc-dev libncurses-dev libssl-dev make \
        parted patch pbuilder qemu-user-static quilt rsync sudo texinfo u-boot-tools udev \
        vboot-kernel-utils wget
        apt install -t buster-backports qemu-user-static
```

## Build
Clone this Git repo: `git clone --recurse-submodules https://github.com/austin987/crawfishos`

All make commands required a TARGET=$ARCH to specify either armhf or arm64. 
See the top of the README for if you don't know which your device is.
armhf and arm64 builds can live side by side in the same git checkout. 

Build the `PrawnOS-*-.img` by running `sudo make image TARGET=$ARCH`


## Write to a flash drive or SD card
Write the 2GB image to a flash drive. Make sure to replace $USB_DEVICE with the desired target flash drive or SD card device. If you're not familiar with dd, check out Debian's
 how to page https://www.debian.org/CD/faq/#write-usb
```
sudo dd if=PrawnOS-*.img of=/dev/$USB_DEVICE bs=50M status=progress; sync
```

## Enable Developer Mode

Enabling developer mode is required to install PrawnOS. Note that enabling developer mode WILL ERASE ALL LOCALLY STORED DATA.

### Shut down
First, shutdown and power off the chromebook. Once powered off, hold the 'ESCAPE' and 'REFRESH' (F3) buttons, and while continuing to hold those two buttons, press and release the 'POWER' button.

### First screen
The chromebook should power on and show a white screen, with a message saying:
"Chrome OS is missing or damaged. Please insert a recovery USB stick or SD card."
<p align="center">
<img src="/resources/DocumentationResources/DeveloperModeResources/devmode1.png" alt="screen1" data-canonical-src="/resources/DocumentationResources/DeveloperModeResources/devmode1.png" /></p>

Press 'CTRL' + 'D' to continue.

### Second screen
A second screen will appear, saying:
"To turn OS verification OFF, press ENTER. Your system will reboot and local data will be cleared. To go back, press ESC."
<p align="center">
<img src="/resources/DocumentationResources/DeveloperModeResources/devmode2.png" alt="screen2" data-canonical-src="/resources/DocumentationResources/DeveloperModeResources/devmode2.png" /></p>

As it says, press 'ENTER'.

### Third screen
The third screen will inform you that OS verification is disabled:
<p align="center">
<img src="/resources/DocumentationResources/DeveloperModeResources/devmode3.png" alt="screen3" data-canonical-src="/resources/DocumentationResources/DeveloperModeResources/devmode3.png" /></p>

Press 'CTRL' + 'D' to continue.

### Fourth screen
Your system is now transitioning to developer mode. You have 30 seconds to cancel this by powering off your chromebook:
<p align="center">
<img src="/resources/DocumentationResources/DeveloperModeResources/devmode4.png" alt="screen4" data-canonical-src="/resources/DocumentationResources/DeveloperModeResources/devmode4.png" /></p>

Otherwise, sit back and wait.

### Fifth screen
Your chromebook is now erasing local data and preparing developer mode:
<p align="center">
<img src="/resources/DocumentationResources/DeveloperModeResources/devmode5.png" alt="screen5" data-canonical-src="/resources/DocumentationResources/DeveloperModeResources/devmode5.png" /></p>
This takes approximately 10 minutes. The system will reboot on its own.

### Sixth screen
Your system will again show the 'OS verification is off' screen:
<p align="center">
<img src="/resources/DocumentationResources/DeveloperModeResources/devmode3.png" alt="screen3" data-canonical-src="/resources/DocumentationResources/DeveloperModeResources/devmode3.png" /></p>

Press 'CTRL' + 'D' to continue.

### Seventh screen
Your chromebook should now show the welcome screen. You'll notice that 'debugging features' are now possible:
<p align="center">
<img src="/resources/DocumentationResources/DeveloperModeResources/devmode7.png" alt="screen7" data-canonical-src="/resources/DocumentationResources/DeveloperModeResources/devmode7.png" /></p>

Clicking 'Enable debugging features' doesn't actually work here, so don't try. Instead, press 'CTRL' + 'ALT' + 'REFRESH' (F3) to open a vtty.

### Eighth screen
<p align="center">
<img src="/resources/DocumentationResources/DeveloperModeResources/devmode8.png" alt="screen8" data-canonical-src="/resources/DocumentationResources/DeveloperModeResources/devmode8.png" /></p>

Log in as 'root', there is no password. Finally, enable booting PrawnOS from USB/SD:

To enable booting unsigned media:

`# crosssystem dev_boot_signed_only=0`

To enable USB booting:

`# crosssystem dev_boot_usb=1`

Finally, reboot or shutdown the system:

`# reboot`

On each subsequent boot, you'll see the 'OS verification is off' screen.

## Booting/Installing PrawnOS

If you haven't enabled developer mode, see [Enable Developer Mode](#enable-developer-mode)

After rebooting/powering on, at the 'OS verification is off' screen, press 'CTRL' + 'U' to boot from USB/SD. Or 'CTRL' + 'D' to boot from the internal emmc.

## Installing

There are two ways to use PrawnOS. 

The first and recommended option is to install it on a device other than the one you wrote the PrawnOS image to.
[click here](#install-to-internal-drive-emmc-or-to-sd-card-or-usb-drive)
* This lets you install PrawnOS to the internal emmc, an SD card or a USB device
* This allows you to setup root encryption
* Installing to an external device allows you to try PrawnOS without removing Chrome OS or whatever Linux you are running on your internal storage (emmc), but USB drives especially are a much slower experience as the c201 only has USB 2.0.
* The internal emmc is much faster than a usb device or sd card for both reads and writes, data from some tests is available in #133
* If you want to boot from external media, I would suggest using an SD card. 

The second option is to boot from the external USB or SD device you wrote the image to, and expand the image to take up the entire device.
[click here](#expand-prawnos)
* Expanding the PrawnOS image allows you to boot PrawnOS from the same USB or SD device that you wrote the image to
* Expansion does _NOT_ support root encryption. For root encryption the filesystem must be written after the encrypted root is created.

### Install to internal drive (emmc) or to SD card or USB drive
Now on the C201, insert the drive you wrote the PrawnOS image to. Press `control+u` at boot to boot from the external drive. 

If you are running stock coreboot and haven't flashed Libreboot, you will first have to enable developer mode and enable USB / external device booting:

At the prompt, login as root. The password is blank. 

Now insert the other USB device or SD card you would like to install PrawnOS on. If you want to boot from the internal emmc, you have nothing to insert!
Note: If you are installing to an external device, the filesystem portion may take a loooong time (20 minutes). This is because we are reading from one external device (the boot device) and writing to another external device. This more than saturates the USB and/or SD bus.

WARNING! THIS WILL ERASE YOUR INTERNAL EMMC STORAGE (your Chrome OS install or other Linux install and all of the associated user data) OR WHATEVER EXTERNAL DEVICE YOU CHOOSE AS YOUR INSTALL TARGET. Make sure to back up any data you would like to keep before running this.  

Run:
```
InstallPrawnOS
```
Choose `Install` and follow the prompts. This will ask what device you want to install to and setup root encryption with a custom initramfs and dmcrypt/LUKS if you want.
If you are curious how the initramfs, and root partition encryption work on PrawnOS check out the Initramfs and Encryption section in [DOCUMENTATION.md](DOCUMENTATION.md)
If you run in to any problems please open an issue. 
_If you install to the internal emmc this will show a bunch of scary red warnings that are a result of the emmc (internal storage) having a few unwritable (bad) blocks at the beginning of the device and the kernel message level being set low for debugging. They don't effect anything long-term. All C201s have these bad blocks at the beginning of the emmc_

After the partitioning and the filesystem copy is complete, it will prompt you to install either the xfce4 or the lxqt desktop environment, sound, trackpad, and Xorg configurations
It will also prompt you to make a new user that automatically gets sudo privileges.

After reboot, remove the external media you had booted from originally. If you installed to the internal emmc press `control+d`, if you installed to an external device press `control+u`

If you press nothing, it will boot to the internal storage by default.

Congratulations! Your computer is now a Prawn! https://sprorgnsm.bandcamp.com/track/the-prawn-song

### Expand PrawnOS
Now on the C201, insert the drive you wrote the PrawnOS image to. Press `control+u` at boot to boot from the external drive. 

If you are running stock coreboot and haven't flashed Libreboot, you will first have to enable developer mode and enable USB / external device booting. A quick search should get you some good guides, but if you're having issues feel free to open an issue here on github. 

At the prompt, login as root. The password is blank.
Run:
```
InstallPrawnOS
```
Choose `Expand` at the prompt

If you run in to any problems please open an issue. 

Now you can choose to install the packages, which are either the xfce4 or the lxqt desktop enviroment, sound, trackpad, and Xorg configurations.
It will also prompt you to make a new user that automatically gets sudo privileges.

If you choose in install the packages, when installation is complete it will reboot.
Press `control+u` at boot once again, and you'll get to a login screen. 

Congratulations! Your computer is now a Prawn! https://sprorgnsm.bandcamp.com/track/the-prawn-song

#### If you simply want a basic Linux environment with no desktop environment or window manager:
Say no at the prompt to install packages and a desktop environment.
Congratulations: you are done! Welcome to PrawnOS. You should probably change the root password and make a user, but I'm not your boss or anything so I'll leave that to you. 

#### Connecting to WiFi in a basic environment
If have a basic environment without xfce or lxqt you can connect to WiFi using `nmtui` and it's menus to connect; or issue the following nmcli commands:
```
nmcli device wifi list
nmcli device wifi connect "Network_name" password "network_password"
```
When that finishes, you should have access to the internet. 

## Upgrading PrawnOS

The components of PrawnOS are now packaged, making upgrades much easier. You have two options:

### build the packages yourself
- filesystem packages are located under `filesystem/packages`
all can be built by calling `make filesystem_packages_clean && make filesystem_packages`
or they can be built individually by going to the specific package and running `make clean && make`

once the `.deb` is built, move it to your PrawnOS device and run `sudo apt install ./<package-name>.deb`

- kernel packages are located under `kernel/packages`
the kernel image package can be built by running `make` in the `prawnos-linux-image-armhf` directory
once the `.deb` is built, move it to your PrawnOS device and run `sudo apt install ./<package-name>.deb`

### use the PrawnOS APT repo to update the PrawnOS packages automatically

`sudo apt upgrade` 

## Upgrade PrawnOS kernel using specific vmlinux.kpart

The kernel flashing script can be found at `/etc/prawnos/kernel/FlashKernelPartition.sh`
Easily flash a specific kernel by running it like this:
```
/etc/prawnos/kernel/FlashKernelPartition.sh vmlinux.kpart
```

## Documentation

Some useful things can be found in `DOCUMENTATION.md` including making the coreboot screen less annoying and less beepy


### Make options, developer tools
(All of these should be run as root or with sudo to avoid issues) 
The makefile automates many processes that make debugging the kernel or the filesystem easier. 
To begin with:

`make kernel_config` cross compiles `make menuconfig` Cross compiling is required for any of the Linux kernel make options that edit the kernel config, as the Linux kernel build system makes assumptions that change depending on what platform it is targeting. 

`make kernel` builds just the kernel

`make filesystem` builds the -BASE filesystem image with no kernel

`make initramfs` builds the PrawnOS-initramfs.cpio.gz, which can be found in /build

`make image` builds the initramfs image, builds the kernel, builds the filesystem if a -BASE image doesn't exist, and combines the two into a new PrawnOS.img using kernel_install

`make kernel_install` Installs a newly built kernel into a previously built PrawnOS.img-BASE.

`make write_image PDEV=/dev/sdX` Does everything `make image` does but then also checks `/dev/sdX` is available and writes the image to it using a sane blocksize and runs sync


You can use the environment variable `PRAWNOS_SUITE` to use a Debian suite other than `Bullseye`.  For example, to use Debian sid, you can build with `sudo PRAWNOS_SUITE=sid make image`

You can use the environment variable `PRAWNOS_DEBOOTSTRAP_MIRROR` to use a non-default Debian mirror with debootstrap.  For example, to use [Debian's Tor onion service mirror](https://onion.debian.org/) with debootstrap, you can build with `sudo PRAWNOS_DEBOOTSTRAP_MIRROR=http://vwakviie2ienjx6t.onion/debian make image`.


### Crossystem / mosys

crossystem is installed from the debian repos and mosys (a dependency of crossystem, and all around useful tool) is built and installed as part of the PrawnOS filesystem build.

### Warning: running these commands can leave you in a state where you cannot boot.
Specifically, enabling `dev_boot_signed_only` will prevent PrawnOS from booting, as no key is stored in the bootloader for the PrawnOS Linux kernel
Its also a bad idea to disable `dev_boot_usb` unless you are positive you will always be able to boot to the internal emmc.
Unless you are running libreboot, the only way to recover if you get in one of these states is to reinstall chromeos using recovery media 

#### Example crossystem  and mosys commands, most require root privileges

Kernels signature verification:

`sudo crossystem dev_boot_signed_only=1` enable
`sudo crossystem dev_boot_signed_only=0` disable

External media boot:

`sudo crossystem dev_boot_usb=1` enable
`sudo crossystem dev_boot_usb=0` disable

Legacy payload boot:

`sudo crossystem dev_boot_legacy=1` enable 
`sudo crossystem dev_boot_legacy=0` disable

Default boot medium:
`sudo crossystem dev_default_boot=disk` internal storage
`sudo crossystem dev_default_boot=usb` external media
`sudo crossystem dev_default_boot=legacy` legacy payload

Dump system state:
`sudo crossystem`

View mosys command tree:
`sudo mosys -t`

On older PrawnOS releases or other distributions, you can run the `buildCrossystem.sh` script located in `scripts/InstallScripts/` to build and install `mosys` and install `crossystem`
```
sudo /InstallScripts/buildCrossystem.sh
```

## Troubleshooting

The pulse audio mixer will only run if you are logged in as a non-root account. This is an issue (feature?) of pulse audio

## Discussion, Support, and IRC
IRC - You can find PrawnOS on the #prawnos channel on freenode

## Credits and Legal Information

Thanks to SolidHal for [PrawnoS](https://github.com/SolidHal/PrawnOS), on which CrawfishOS is based.

Thanks to Maccraft123 for [ShrimpOS](https://github.com/Maccraft123/ShrimpOS)/showing how to get proprietary wifi working.
