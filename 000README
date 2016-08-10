********************************************************************
Copyright Linux Foundation 2015
********************************************************************

Please read this file before emailing us with questions.

In particular pay attention to information about accounts
and passwords as we have received many unnecessary queries
about such.  Please direct any questions to whoever directed
you to these resources or to training@linuxfoundation.org.

********************************************************************

0) Virtual machines contained:

The primary virtual machines here given are all 64-bit and are:

    CentOS 7
    Ubuntu LTS (14.04)
    Ubuntu LTS (15.04)
    openSUSE (13.2)

We also provide 64-bit VM's for the latest releases of:

    CentOS 6
    Debian 8
    Mint 17
    Fedora 22

New VM's are generally uploaded with upstream Linux kernel
release, i.e., with version 3.10, 3.18, 4.1 etc.  We also
have a subdirectory containing VM's for a number of previous
kernel versions.

As of the time of uploading these images were fully updated
using their appropriate packaging systems (yum, zypper,
apt-get etc.), and barring accidental omissions, contained
the required software for Linux Foundation Courses.

********************************************************************

1) Extraction:

The contained virtual machine images are given in tar.gz
format; we could have used better compression but wanted to
keep decompression as general as possible and easy to do on
dumb operating systems.

Extraction from the command line is done as in:

    tar zxvf A_VIRT_MACHINE.tar.gz

If you use the embedded unzip program in Windows it may fail
as it is brain dead and uses ancient formats.  The file is
_not_ corrupted.  Use a newer archive program such as 7zip
or infozip which can be freely downloaded.

The file MD5SUMS contains checksums. You can check the
integrity of your downloaded file by doing:

md5sum A_VIRT_MACHINE.tar.gz

and comparing values.

********************************************************************

2) Hypervisors:

The contained virtual machine images were created using
VMWARE and have been tested with VMware Player (freely
available at vmware.com) and VMware Workstation. (For the
MacOS you have to get VMWare Fusion at low cost, there is no
free version.)  

They have also been tested on Oracle Virtual Box.  However,
for CentOS7 there are two VMS, one for VMWare and 
one for Virtual Box for technical reasons.

The VM's have been confirmed to work on Linux, Windows and
MacOS host machines.

They can also be converted to be used on KVM, the native
Linux hypervisor, with conversion to qcow2 format such as
in:

qemu-img convert A_VIRT_MACHINE.vmdk -O qcow2 A_VIRT_MACHINE.qemu

Alternatively, KVM may run VMDK images as long as the right
XML file is provided. See the vmware2libvirt utility (part
of virt-goodies) to convert VMWare control files to XML.

********************************************************************

3) Importing the images to the hypervisor

The tar balls include large vmdk format files which are a
virtual machine disk image.

On VMWARE import the appliance with the supplied vmx file.
(You can import by selecting selecting "Open a Virtual
Machine" and then navigating to the directory where you
untarred the virtual machine and selecting the .vmx file.)
Select "was copied" when prompted when first opening.

On VirtualBox create a new appliance and select the vmdk
file as a pre-existing disk.

For KVM follow the conversion procedure described above.

********************************************************************

4) Accounts:

The virtual machines have two pre-created accounts:

student (passwd=student)
root (passwd=LFtrain)

Note: Ubuntu machines do not have a real root account and
only use sudo to elevate privilege.  Other distributors,
such as Mint, may do the same.

********************************************************************

5) sudo

sudo is enabled without password required.  This is rotten
for security purposes but convenient for classes with
disposable machines. Note you can keep a root shell alive
indefinitely with "sudo su".

********************************************************************

6) /home/student/LFT directory

Each virtual machine contains a /home/student/LFT directory
with SOLUTION files, kernel configuration files, and some
other useful things.  These are packaged in at time of VM
creation and sometimes updated Solutions can be found on our
website.

********************************************************************

7) Linux Kernel Git Repository

These virtual machines may contain under /usr/src/linux-stable, a
"shallow clone" of the Linux kernel source repository, and
it should have checked out the current version at time of
preparation.

However, note a shallow clone has its limitations.  It can
not be used to "push" changes upstream, and it will fail
when trying to do a "bisection" as it does not contain the
complete history.  The reason a shallow clone was used was
to save space -- about 1 GB compressed -- and works well in
class where we do not do these operations.  Beware that if
you update these repos with "git pull" they will get much
larger in size and still not be complete, so we do not
recommend that in class.

NOTE: instead of having a git clone, you may just have a
directory, such as /usr/src/linux-4.1, containing the kernel
source, depending on details of when the virtual machine was
created.

Most classes (particularly Enterprise LFS classes) do not
need the kernel source repository, but we prefer to use only
one image for all classes.  It does no harm to have it,
except wasting space.

********************************************************************

8) Kernel Versions

Each machine contains at least two kernels that can be booted from:

1) the latest stock kernel for the distributor. 
2) the latest upstream version from kernel.org -- 3.17.0 for example

All machines have been set up to boot from the stock kernel
by default.  Except for the CentOS6 machine, they have been
configured so that IF YOU SELECT A KERNEL a boot through the
grub menu, THAT CHOICE WILL PERSIST FOR THE NEXT BOOT.

Enterprise course students (LFS classes) will likely want to choose
the stock version at boot. 

Developer course students (LFD) class will likely opt for the
kernel.org choice at boot.

********************************************************************

