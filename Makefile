RAM=8192
DISK=iot.qcow2
DISK_SIZE=25G
FEDORA_ISO=Fedora-Workstation-Live-44-1.7.x86_64.iso

all:
	qemu-system-x86_64 \
		-enable-kvm \
		-m $(RAM) \
		-cpu host \
		-nic user,model=virtio \
		-drive file=$(DISK),media=disk,if=virtio
.PHONY: all

install:
	qemu-system-x86_64 \
	-enable-kvm \
	-m $(RAM) \
	-cpu host \
	-nic user,model=virtio \
	-drive file=$(DISK),media=disk,if=virtio \
	-cdrom $(FEDORA_ISO)
.PHONY: install

disk:
	qemu-img create -f qcow2 $(DISK) $(DISK_SIZE)
.PHONY: dist