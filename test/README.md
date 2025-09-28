# Test

VMs for testing the NixOS configs.

## Prerequisites

Ensure your system supports running virtual workloads:

* Ensure KVM kernel module is loaded:

```console
lsmod | grep kvm
# Should return:
kvm_intel             245760  0
kvm                   655360  1 kvm_intel
```

* Load modules:

```console
sudo modprobe kvm
sudo modprobe kvm_intel   # for Intel CPUs
sudo modprobe kvm_amd     # for AMD CPUs
```

* Check if /dev/kvm exists. If it does not, KVM device is not available:

```console
ls -l /dev/kvm
```

* Check CPU virtualization support (output 0 means it is not supported or enabled in BIOS):

```console
egrep -c '(vmx|svm)' /proc/cpuinfo
```

## Usage

Run VM:

```shell
./run-vm.sh (debian|debiancloud|nixos)
```

This will launch the VM with a VNC connection available at `:5901`. Access it using e.g.:

```shell
nix-shell -p vnctiger
vncviewer localhost:5901
```

If this is the first time running the script, it is recommended to make a snapshot of the image that you
can roll back to, if necessary. Either run e.g. `./run-vm.sh -s nixos -k` to make a backup snapshot of
the selected system, or manually run:

```console
qemu-img create -f qcow2 -b drives/nixos.qcow2 -F qcow2 snapshots/nixos.qcow2
```

## Building

### Option 1: Conventional image

We can build a bootable image by providing a regular ISO that creates a virtual drive file:

```shell
qemu-img create -f qcow2 debian_drive.qcow2 20G
qemu-system-x86_64 \
  -cdrom debian.iso \
  -drive file=debian_drive.qcow2,format=qcow2 \
  -boot c \
  -m 4G \
  -enable-kvm \
  -cpu host \
  -smp 4 \
  -device virtio-net-pci,netdev=net0 \
  -netdev user,id=net0,hostfwd=tcp::2222-:22 \
  -vga virtio \
  -display none \
  -vnc :1
```

Then access the VM over VNC and follow the install steps. Once installed, remove the `-cdrom` argument and set `-boot d`.

### Option 2: Cloud image

Cloud images rely on a seed image to do system initialization. These are in turn relying on certain user input,
such as `user-data` and `meta-data`:

```shell
genisoimage -output seed.iso -volid cidata -joliet -rock cloud-init/user-data cloud-init/meta-data
```

With the generated image, run the VM with VNC:

```shell
qemu-system-x86_64 \
  -drive file=debian_nocloud.qcow2,format=qcow2 \
  -drive file=seed.iso,format=raw \
  -boot d \
  -m 4G \
  -enable-kvm \
  -cpu host \
  -smp 4 \
  -device virtio-net-pci,netdev=net0 \
  -netdev user,id=net0,hostfwd=tcp::2222-:22 \
  -vga virtio \
  -display none \
  -vnc :1
```
