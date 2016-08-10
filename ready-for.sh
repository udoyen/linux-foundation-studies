#!/bin/bash
#
# Copyright (c) 2013 Chris Simmonds
#               2013-2016 Behan Webster
#               2014 Jan-Simon Möller
#
# Originally written by Chris Simmonds for LF315
# Version 1.0: 18th January 4653
# Massive updates (bordering on a rewrite) by Behan Webster
# Version 1.5: 11th December 2013
#     - Fixed support for Ubuntu-12.04 for LF315
# Version 1.6: 15th December 2013
#     - Parameterized code to make it easier to update
# Version 1.7: 16th December 2013
#     - Added support for other classes
# Version 2.0: 19th December 2013
#     - Added support for multiple distros
#     - Renumbered courses
# Version 2.1: 20th December 2013
#     - Bug fixes
#     - Adjust better defaults for courses
#     - make libGL.so link optional
#     - Add --simulate-failure option for debugging
# Version 2.2: 2nd January 2014
#     - Added JSON support
#     - Add better support for Arch
#     - Add better support for CentOS
#     - Add better support for Fedora
#     - Add better support for Gentoo
#     - Add better support for openSUSE
# Version 2.2: 9th January 2014
#     - Changed minimum openSUSE to 12.2
#     - Added PACKAGE macro support (e.g. @embedded, @kernel)
#     - Added package list to JSON output
#     - Added course requirements/packages list
# Version 2.3: 18th March 2014
#     - Fixed macros
#     - Add LFD312
# Version 2.4: 20th March 2014
#     - Add support for running extra code as a hook
# Version 2.5: 25th March 2014
#     - Add openSuSE support, tested on 13.1
#     - Add CPUFLAGS support
#     - Add CONFIGS support
# Version 2.6: 28th March 2014
#     - Fix Red Hat distro detection
# Version 2.7: 30th March 2014
#     - Rewrite Distro detection
# Version 2.8: 31th March 2014
#     - Add explicit Fedora support
#     - Add [key] support for Package list
#     - Add -pkgname support for Package list
# Version 3.0: 8th Apr 2014
#     - Add script update capability
# Version 3.1: 10th Apr 2014
#     - Restructure script for maintainability
# Version 3.2: 5th May 2014
#     - Fix recursive package macro expansion
#     - Catch recursive package list definitions
# Version 3.3: 21th May 2014
#     - Various updates for RHEL packaging list
# Version 3.4: 21th May 2014
#     - Various updates for RHEL packaging list
#     - Add --try-all-courses options
#     - Suppress PASSes if NO_PASS=1
#     - Soften overall failure message
# Version 3.5: 26th May 2014
#     - Better LinuxMint support
#     - Various fixes for Redhat
# Version 3.6: 3rd June 2014
#     - Better LinuxMint support (fixes)
# Version 3.7: 4th July 2014
#     - LFS416 Support
# Version 3.8: 29th Sep 2014
#     - Update LFD405 minimum requirements
#     - Package updates from Jerry
# Version 3.9: 23rd Oct 2014
#     - Update LFD405 Ubuntu 14.04 requirements
#     - Add LinuxMint 17
# Version 3.10: 23rd Oct 2014
#     - Fix update to only rerun command if $COURSE is set
# Version 4.0: 28rd Oct 2014
#     - Fix RHEL-7 dependency issues
# Version 4.1: 3rd Nov 2014
#     - Require glibc-static for RHEL/Centos/Fedora for LFD411
#     - Require lib-tools-generic for Ubunt-14.04+ for LFS426
# Version 4.2: 4th Nov 2014
#     - Fix bug in calculating $EFFECTIVE_DISTRIB_RELEASE
#     - Add missing @common to LFD320 and LFD331
#     - Rename $PACKAGES -> $PKGLIST for installing packages
# Version 4.3: 5th Nov 2014
#     - Add missing dependencies for LFD405
# Version 4.4: 13th Nov 2014
#     - Add a check_repos which will make sure distro repos are properly enabled
#     - Currently only Ubuntu universe and multivers sections are supported
#     - Add test for finding if a card reader is available
#     - Add test for finding if we are running in a VM or not
#     - Both of the above are accomplished by looking for PCI devices
#     - To do so we have to examine /sys directly since lspci isn't necessarily available
#     - Add overall WARN at the end (not just overall FAIL)
#     - Refactor system checks into functions
#     - Better Documentation
# Version 4.5: 17th Nov 2014
#     - Fix distro detection for CentOS-7
# Version 4.6: 18th Nov 2014
#     - Add LFS202, LFS220, LFS230, LFS430
#     - Add @build and @sysadm package lists
# Version 4.7: 13th Feb 2015
#     - Add LFS101, LFD205, LFD211, LFS422, LFS520
#     - Fix LFD426 package lists
#     - Add course number spell check LFD<->LFS
#     - Add @virt package lists
#     - Make partial failure (warn) of course check list more ominous
# Version 4.8: 20th Feb 2015
#     - Add LFS201 remove LFS202
#     - Update qemu devices for VM detection
#     - Fix typos
# Version 4.09: 12th Apr 2015
#     - Fix LFD411 dependencies
#     - Fix LFS426 dependencies
# Version 4.10: 28th Apr 2015
#     - Add --detect-vm
#     - Add Hyper-V detection
#     - Add network timeouts to get()
#     - Move hugepages package to Ubuntu from Debian for LFS426
#     - Add check_sudo to install/configure sudo if not available
#     - Fix bug in check_repos
#     - Add debian support to check_repos
# Version 4.11: 2nd May 2015
#     - Warn if running script as root
#     - add warn_wait() and bug()
#     - Add bug checking code
#     - Download latest course material "SOLUTIONS" tar file
#     - Check for Internet availability by seeing if the version check works (not ping)
#     - Add epel to Fedora/RHEL
#     - Ask before installing debian packages
# Version 4.12: 5th May 2015
#     - Add deb_check which makes dpkg is in a good state
# Version 4.13: 8th May 2015
#     - Remove stress from RHEL/CentOS/Fedora
# Version 4.14: 10th May 2015
#     - Support SOLUTIONS files with x.y.z versions
#     - Fix check_free_disk
# Version 4.15: 11th May 2015
#     - Make sure single digit versions for courses work for get_cm()
#     - Fix SOLUTIONS downloads to not always do a partial download
#     - Add support to download beta versions of script
#     - Verify script from update MD5 metadata
#     - Add ping fallback for internet check
#     - Add nfs server and dnsmasq to @embedded
# Version 4.16: 12th May 2015
#     - Add LFD461
#     - Add course webpages to web interface
# Version 4.17: 13th May 2015
#     - Add URL variables
#     - Fix linux-tools for Ubuntu-15.04
# Version 4.18: 19th May 2015
#     - Add --no-cache to wget to fix upgrades behind proxies
#     - Add proper support for Ubuntu-15.04
#     - Fix linux-tools for Ubuntu-15.04
#     - Remove kernel-debuginfo from LFD426
# Version 4.19: 5th June 2015
#     - Add squashfs-tools to LFD411
# Version 4.20: 10th June 2015
#     - Increase disk requirements for LFD320 and LFD331 to 15GiB
# Version 4.21: 14th June 2015
#     - Decrase disk requirements for LFD320 and LFD331 to 10GiB
# Version 4.22: 16th June 2015
#     - Add distro blacklist for Ubuntu-12.10 - Ubuntu-13.10
#     - Remove Java from LFD211 in RHEL
# Version 4.23: 19th June 2015
#     - Add RECOMMENDS support
#     - Don't run all the checks if --install
# Version 4.24: 25th June 2015
#     - Add --no-course-materials
#     - Fix package lists based on Jerry's input
#     - Make package install failures non-fatal
#     - Fix bug in distro fallback
#     - Add support for openSuse tumbleweed distro detection
# Version 4.25: 28th June 2015
#     - Add nautilus-open-terminal to RECOMMENDS
#     - move from iptraf to iptraf-ng
#     - Rebuild PACKAGES/RECOMMENDS package list lookup
#     - Add --no-install
#     - Add --override-distro
#     - Rewrite Distro fallback code
#     - Rewrite RUNCODE code
# Version 4.26: 29th June 2015
#     - Fixed distro detection issues with openSuse
# Version 4.27: 30th July 2015
#     - Added Linux detection (so its not run on OSX or Windows)
#     - Add support for LFS426 SOLUTIONS download
#     - Add perl-Time-HiRes (for Unixbench) to RHEL/Centos for LFS426 
#     - Various whitespace fixes
# Version 5.0: 31st July 2015
#     - Support checking multiple classes at a time for hybrid classes
#     - Remove Ubuntu-10.08 and Fedora-18 support
#     - Add Fedora-21 and Fedora-22 support
# Version 5.1: 31st July 2015
#     - Support custom courses with .ready-for.conf files in CM dirs
# Version 5.2: 6th Aug 2015
#     - Fix bug in md5sum
#     - Only download course materials once
# Version 5.3: 16th Aug 2015
#     - Add support for LFS550/551
#     - Fix LFS URLS
#     - Fix typos in LFS461
#     - Add support for installing build-dep for deb packages
# Version 5.4: 20th Sep 2015
#     - Added better package support for LFD262
#     - Add support for lscpu for VM detection
# Version 5.5: 1st Oct 2015
#     - Add subversion to LFD262
#     - fix df use for disk space calculation
# Version 5.6: 9th Dec 2015
#     - Remove nautilus-open-terminal from Ubuntu
#     - Add ssl-dev support for @kernel
#     - Add x11/qt support for Mint
#     - Add sparse for Fedora_@kernel
#     - Further hardening of the check_free_disk routine
# Version 5.7: 10th Dec 2015
#     - Add cryptsetup to LFS201 and LFS220
# Version 5.8: 22nd Feb 2016
#     - LFD262 => LFD305, LFS102 => LFS300, LFS220 => LFS301, LFS230 => LFS311
#     - Add Ubuntu-15.10
#     - fix broken lscpu problem
#     - Add python-pip and daemon to LFD405
# Version 5.9: 7th Mar 2016
#     - Updates to dependencies for LFD411 and LFD405
#     - Added more debugging statements
#     - Fixed up fallbacks for Debian/Ubuntu/LinuxMint
# Version 5.10: 29th Mar 2016
#     - Add --all-courses for testing
#     - Add arch detection to installing epel on RHEL
#     - Move packages which are in epel to RECOMMENDS
#     - Fix mispelling in RHEL detection
#     - Fix distro arch detection for s390x
#     - Fix cpu counting to be more robust
#     - Fix bogomips counting to be more robust
# Version 5.11: 30th Mar 2016
#     - Lots of course renaming
#     - LFD211/LFD262 => LFD301, LFD305 => LFD301, LFD312 => LFD401
#     - LFD320 => LFD420, LFD331 => LFD430, LFD410 => LFD450, LFD405 => LFD460
#     - LFS102 => LFS300, LFS520 => LFS452, LFS540 => LFS462, LFS550 => LFS465
# Version 5.12: 21st Apr 2016
#     - Add notice
#     - Add support for Ubuntu 16.04
#     - Refactor distro data naming and code flow
#===============================================================================
VERSION=5.12
#===============================================================================
#
# You can define requirements for a particular course by defining the following
# variables where LFXXXX is your course number:
#
#   DESCRIPTION[LFXXXX]=""      # Name of the course
#   WEBPAGE[LFXXXX]="http://..."# LF URL for course
#   ARCH[LFXXXX]=x86_64         # Required CPU arch (optional)
#   CPUFLAGS[LFXXXX]="vmx aes"  # Required CPU flags (optional)
#   CPUS[LFXXXX]=2              # How many CPUS/cores are required
#   PREFER_CPUS[LFXXXX]=4       # How many CPUS would be preferred
#   BOGOMIPS[LFXXXX]=4000       # How many cululative BogoMIPS you need
#   RAM[LFXXXX]=2               # How many GiB of RAM you need
#   DISK[LFXXXX]=30             # How many GiB of Disk you need free in $HOME
#   BOOT[LFXXXX]=30             # How many MiB of Disk you need free in /boot
#   CONFIGS[LFXXXX]="KSM"       # Which CONFIG_* kernel variables are required (optional)
#   DISTRO_ARCH[LFXXXX]=x86_64  # Required Linux distro arch (optional)
#   INTERNET[LFXXXX]=y          # Is internet access required? (optional)
#   CARDREADER[LFXXXX]=Required # Is a card reader or USB mass storage device required? (optional)
#   NATIVELINUX[LFXXXX]=Required# Is Native Liunux required for this course? (optional)
#   VMOKAY[LFXXXX]=Okay         # Can this course be done on a VM? (optional)
#   RUNCODE[LFXXXX]=lfXXX_func  # Run this bash function after install (optional)
#   DISTROS[LFXXXX]="Fedora-21+ CentOS-6+ Ubuntu-12.04+"
#                               # List of distros you can support.
#                               #   DistroName
#                               #   DistroName:arch
#                               #   DistroName-release
#                               #   DistroName-release+
#                               #   DistroName:arch-release
#                               #   DistroName:arch-release+
#
# Note: I know BogoMIPS aren't a great measure of CPU speed, but it's what we have
# easy access to.
#
# You can also specify required packages for your distro. All the appropriate
# package lists for the running machine will be checked. This allows you to
# keep package lists for particular distros, releases, arches and classes.
# For example:
#
#   PACKAGES[Ubuntu]="gcc less"
#   PACKAGES[Ubuntu_LFD320]="stress trace-cmd"
#   PACKAGES[Ubuntu-14.04]="git-core"
#   PACKAGES[Ubuntu-12.04]="git"
#   PACKAGES[Ubuntu-12.04_LFD450]="gparted u-boot-tools"
#   PACKAGES[Ubuntu-LFS550]="build-dep_wireshark"
#   PACKAGES[RHEL]="gcc less"
#   PACKAGES[RHEL-6]="git"
#   PACKAGES[RHEL-6_LF320]="trace-cmd"
#
# Missing packages are listed so the user can install them manually, or you can
# rerun this script with --install to do it automatically.
#
# Support for all distros is not yet finished, but I've templated in code where
# possible. If you can add code to support a distro, please send a patch!
#
# If you want to see extra debug output, set DEBUG=1
#
#    DEBUG=1 ./ready-for.sh LFD450
# or
#    ./ready-for.sh --debug LFD450
#

#===============================================================================
RED="\e[0;31m"
GREEN="\e[0;32m"
YELLOW="\e[0;33m"
CYAN="\e[0;36m"
BLUE="\e[0;34m"
BACK="\e[0m"
#-------------------------------------------------------------------------------
pass() {
    [[ -n $NO_PASS ]] || echo -e "${GREEN}PASS${BACK}: $*"
}
#-------------------------------------------------------------------------------
notice() {
    local OPT
    if [[ $1 == -* ]] ; then
        OPT=$1; shift
    fi
    if [[ -n $OPT || -z $NO_WARN ]] ; then
        echo $OPT -e "${CYAN}NOTE${BACK}: $*" >&2
    fi
}
warn() {
    local OPT
    if [[ $1 == -* ]] ; then
        OPT=$1; shift
    fi
    if [[ -n $OPT || -z $NO_WARN ]] ; then
        echo $OPT -e "${YELLOW}WARN${BACK}: $*" >&2
    fi
}
warn_wait() {
    warn -n "$*\n    Continue? [Yn] " >&2
    read ANS
    case $ANS in
        Y*|y*|1*) return 0 ;;
        *) [[ -z $ANS ]] || return 1 ;;
    esac
    return 0
}
ask() {
    echo -ne "${YELLOW}WARN${BACK}: $* " >&2
}
#-------------------------------------------------------------------------------
verbose() {
    [[ -z "$VERBOSE" ]] || echo -e "INFO: $*" >&2
}
#-------------------------------------------------------------------------------
progress() {
    [[ -z $PROGRESS ]] || echo -en $1 >&2
}
#-------------------------------------------------------------------------------
fail() {
    echo -e "${RED}FAIL${BACK}: $*" >&2
}
#-------------------------------------------------------------------------------
highlight() {
    echo -e "${YELLOW}$*${BACK}" >&2
}
#-------------------------------------------------------------------------------
dothis() {
    echo -e "${BLUE}$*${BACK}"
}
#-------------------------------------------------------------------------------
debug() {
    [[ -z "$DEBUG" ]] || echo D: $* >&2
}
#-------------------------------------------------------------------------------
bug() {
    local MSG=$1 CODE=$2
    warn "Hmm... That's not right...\n    $MSG\n    Probably a bug. Please send the output of the following to behanw@converseincode.com\n      $CODE"
}
#-------------------------------------------------------------------------------
export MYPID=$$
error() {
    echo E: $* >&2
    set -e
    kill -TERM $MYPID 2>/dev/null
}

#===============================================================================
# Check that we're running on Linux
if [[ $(uname -s) != Linux || -n "$SIMULATE_FAILURE" ]] ; then
    fail "You need to run this on Linux machine you intend to use for the class, not on $(uname -s)"
    exit 1
fi

#===============================================================================
# The minimum version of bash required to run this script is bash v4
if bash --version | egrep -q 'GNU bash, version [1-3]' ; then
    fail "This script requires at least version 4 of bash"
    fail "You are running: $(bash --version | head -1)"
    exit 1
fi

#===============================================================================
# Allow info to be gathered in order to fix distro detection problems
gather() {
    FILE=$(which $1 2>/dev/null || echo $1)
    if [[ -n "$FILE" ]] && [[ -e "$FILE" ]] ; then
        echo "--- $FILE -----------------------------------------------------------"
        [[ -x $FILE ]] && $FILE || cat $FILE
    fi
}
gather_info() {
    echo "----------------------------------------------------------------------"
    /bin/bash --version | head -1
    gather lsb_release
    gather /etc/lsb-release
    gather /etc/os-release
    gather /etc/debian_version
    gather /etc/redhat-release
    gather /etc/SuSE-release
    gather /etc/arch-release
    gather /etc/gentoo-release
    echo "----------------------------------------------------------------------"
    exit 0
}

#===============================================================================
usage() {
    echo "Usage: `basename $0` <course>"
    echo "       `basename $0` [options]"
    echo "    --distro               List current Linux distro"
    echo "    --install              Install missing packages for the course"
    echo "    --list                 List all supported courses"
    echo "    --no-course-materials  Don't install course materials"
    echo "    --no-install           Don't check installed packages"
    echo "    --no-recommends        Don't install recommended packages"
    echo "    --update               Update to latest version of this script"
    echo "    --verify               Verify script MD5sum"
    echo "    --version              List script version"
    echo "    --verbose              Turn on extra messages"
    echo
    echo "Example: `basename $0` --install LFD450"
    exit 0
}

#===============================================================================
# Command option parsing
OPTS="$*"
while [[ $# -gt 0 ]] ; do
    case "$1" in
        -A|--all|--all-courses) ALL_COURSES=y ;;
        --debug) DEBUG=y ;;
        --distro) LIST_DISTRO=y ;;
        --detect-vm) DETECT_VM=y ;;
        -i|--install) INSTALL=y ;;
        --force-update) FORCEUPDATE=y ;;
        --gather-info) gather_info ;;
        --json) JSON=y ;;
        -l|--list) LIST_COURSES=y; break ;;
        -L|--list-requirements) LIST_REQS=y ;;
        -C|--no-course-materials) NOCM=y ;;
        -I|--no-install) NOINSTALL=y ;;
        -R|--no-recommends) NORECOMMENDS=y ;;
        -D|--override-distro) DISTRO=$2; shift;;
        --progress) PROGRESS=y ;;
        --simulate-failure) SIMULATE_FAILURE=y ;;
        --try-all-courses) TRY_ALL_COURSES=y ;;
        --update-beta) UPDATE=beta; VERBOSE=y ;;
        --update) UPDATE=y; VERBOSE=y ;;
        --verify) VERIFY=y ;;
        -v|--verbose) VERBOSE=y ;;
        -V|--version) echo $VERSION; exit 0;;
        LFD*|LFS*) COURSE="$COURSE $1";;
        [0-9][0-9][0-9]) COURSE="$COURSE LFD$1";;
        -h*|--help*|*) usage ;;
    esac
    shift
done
CMD=$0

#===============================================================================
# URLS
LFURL="https://training.linuxfoundation.org"
LFCM="$LFURL/cm"
LFDTRAINING="$LFURL/linux-courses/development-training"
LFSTRAINING="$LFURL/linux-courses/system-administration-training"

EPELURL="http://download.fedoraproject.org/pub/epel"

#===============================================================================
# Just in case we're behind a proxy server (the system will add settings to /etc/environment)
[[ -f /etc/environment ]] && . /etc/environment
export all_proxy http_proxy https_proxy ftp_proxy

#===============================================================================
# Download file (try wget, then curl, then perl)
get() {
    local URL=$1 WGET_OPTS=$2 CURL_OPTS=$3
    if which wget >/dev/null ; then
        debug "wget $URL"
        wget --quiet --no-cache --timeout=8 $WGET_OPTS $URL -O- 2>/dev/null || return 1
    elif which curl >/dev/null ; then
        debug "curl $URL"
        curl --connect-timeout 8 $CURL_OPTS $URL 2>/dev/null || return 1
    elif which perl >/dev/null ; then
        debug "perl LWP::Simple $URL"
        perl -MLWP::Simple -e "getprint '$URL'" 2>/dev/null || return 1
    else
        warn "No download tool found." >&2
        return 1
    fi
    return 0
}

#===============================================================================
# See if version is less than the other
ltver() {
    IFS='.' read -r MAJ1 MIN1 <<< "$1"
    IFS='.' read -r MAJ2 MIN2 <<< "$2"

    debug "ltver <$MAJ1:$MIN1> <$MAJ2:$MIN2>"

    [[ $MAJ1 -lt $MAJ2 ]] || [[ $MIN1 -lt $MIN2 ]] || return 1
    return 0
}

#===============================================================================
# See if version is less than the other
md5cmp() {
    local FILE=$1 MD5=$2
    [[ $(md5sum $0 | awk '{print $1}') == $MD5 ]] || return 1
    return 0
}

#===============================================================================
# Check for updates
check_version() {
    local URL=$LFCM/prep/ready-for.sh
    local META=$LFCM/prep/ready-for.meta
    local NEW="${TMPDIR:-/tmp}/ready-for.$$"

    verbose "Checking version"
    [[ -z $DONTUPDATE ]] || return

    #---------------------------------------------------------------------------
    # Beta update
    if [[ $UPDATE == "beta" ]] ; then
        if get "$URL-beta" >$NEW ; then
            mv $NEW $0
            chmod 755 $0
            warn "Now running beta version of this script"
        else
            rm -f $NEW
            warn "No beta version of this script found"
        fi
        exit 0
    fi

    #---------------------------------------------------------------------------
    # Verify meta data
    read -r VER MD5 <<< $(get "$META")
    if [[ -n $VERIFY && -n $MD5 ]] ; then
        if md5cmp $0 $MD5 ; then
            pass "md5sum matches"
        else
            fail "md5sum failed (you might want to run a --force-update to re-download)"
        fi
        exit 0
    elif [[ -z $VER ]] ; then
        return
    fi

    #---------------------------------------------------------------------------
    # Get update for script
    INTERNET_AVAILABLE=y
    debug "My ver:$VERSION VER:$VER MD5:$MD5"
    [[ -n $FORCEUPDATE ]] && UPDATE=y
    if [[ -n $FORCEUPDATE ]] || ( ! md5cmp $0 $MD5 && ltver $VERSION $VER ) ; then
        if [[ -n $UPDATE ]] ; then
            get "$URL" >$NEW || (rm -f $NEW; return)
            notice "A new version of this script was found. Upgrading..."
            mv $NEW $0
            chmod 755 $0
            [[ -n $COURSE ]] && DONTUPDATE=1 eval bash $0 $OPTS
        else
            notice "A new version of this script was found. (use \"$0 --update\" to download)"
        fi
    else
        verbose "No update found"
    fi
    [[ -n $UPDATE && -z $COURSE ]] && exit 0
}
check_version

#===============================================================================
# Make associative arrays
declare -A ARCH BOGOMIPS BOOT CONFIGS CPUFLAGS CPUS COURSE_ALIASES DEBREL \
    DESCRIPTION WEBPAGE DISK DISTROS DISTS DISTRO_ARCH DISTRO_BL FALLBACK \
    INTERNET CARDREADER NATIVELINUX PACKAGES PREFER_CPUS RAM RECOMMENDS \
    RUNCODE VMOKAY

#===============================================================================
#=== Start of Course Definitions ===============================================
#===============================================================================

#===============================================================================
# If we can't find settings/packages for a distro fallback to the next one
FALLBACK=(
    [CentOS]="RHEL Fedora"
    [CentOS-6]="RHEL-6"
    [CentOS-7]="RHEL-7"
    [Debian]="Ubuntu"
    [Debian-7]="Ubuntu-12.04"
    [Debian-8]="Ubuntu-14.04 Debian-7"
    [Fedora]="RHEL CentOS"
    [Fedora-19]="Fedora"
    [Fedora-20]="Fedora Fedora-19"
    [Fedora-21]="Fedora Fedora-20"
    [Fedora-22]="Fedora Fedora-21"
    [LinuxMint]="Ubuntu"
    [LinuxMint-16]="Ubuntu-12.04"
    [LinuxMint-17]="Ubuntu-14.04 Debian-8"
    [Mint]="LinuxMint Ubuntu"
    [RHEL]="CentOS Fedora"
    [RHEL-6]="CentOS-6"
    [RHEL-7]="CentOS-7"
    [openSUSE-999]="openSuse-13.2"
    [SLES]="openSUSE"
    [SUSE]="openSUSE"
    [Suse]="openSUSE"
    [Ubuntu]="Debian"
    [Ubuntu-12.04]="Debian-7"
    [Ubuntu-14.04]="Debian-8"
    [Ubuntu-15.04]="Ubuntu-14.04 Debian-8"
    [Ubuntu-15.10]="Ubuntu-15.04 Debian-8"
    [Kubuntu]="Ubuntu"
    [XUbuntu]="Ubuntu"
)

#===============================================================================
# Distro release code names
DEBREL=(
    [hamm]=2
    [slink]=2.1
    [potato]=2.2
    [woody]=3
    [sarge]=3.1
    [etch]=4
    [lenny]=5
    [squeeze]=6
    [wheezy]=7
    [jessie]=8
    [stretch]=9
    [sid]=999
    [unstable]=999
)

#===============================================================================
# Some classes have the same requirements as other classes
COURSE_ALIASES=(
    [LFD211]=LFD301
    [LFD262]=LFD301
    [LFD305]=LFD301
    [LFD312]=LFD401
    [LFD320]=LFD420
    [LFD331]=LFD430
    [LFD404]=LFD460
    [LFD405]=LFD460
    [LFD410]=LFD450
    [LFD411]=LFD450
    [LFD414]=LFD415
    [LFS102]=LFS300
    [LFS220]=LFS301
    [LFS230]=LFS311
    [LFS520]=LFS452
    [LFS540]=LFS462
    [LFS541]=LFS462
    [LFS550]=LFS465
    [LFS551]=LFS465
)

#===============================================================================
# Default Requirements for all courses
#===============================================================================
#ARCH=x86_64
#CPUFLAGS=
CPUS=1
PREFER_CPUS=2
BOGOMIPS=2000
RAM=1
DISK=5
#BOOT=128
#CONFIGS=
#DISTRO_ARCH=x86_64
#INTERNET=y
#CARDREADER=y
#NATIVELINUX=y
VMOKAY=Acceptable
#DISTROS="Arch-2012+ Gentoo-2+"
DISTROS="CentOS-6+ Debian-7+ Fedora-19+ LinuxMint-16+ openSUSE-12.2+ RHEL-6+ Ubuntu-14.04+"
#DISTRO_BL="Ubuntu-12.10 Ubuntu-13.04 Ubuntu-13.10"
PACKAGES=
RECOMMENDS=
#===============================================================================
# Create empty Package lists for all distros above
#===============================================================================
PACKAGES[CentOS]=
PACKAGES[CentOS-6]=
PACKAGES[CentOS-7]=
#-------------------------------------------------------------------------------
PACKAGES[Debian]=
PACKAGES[Debian-7]=
PACKAGES[Debian-8]=
#-------------------------------------------------------------------------------
PACKAGES[Fedora]=
PACKAGES[Fedora-19]=
PACKAGES[Fedora-20]=
PACKAGES[Fedora-21]=
PACKAGES[Fedora-22]=
#-------------------------------------------------------------------------------
PACKAGES[LinuxMint]=
PACKAGES[LinuxMint-16]=
PACKAGES[LinuxMint-17]=
#-------------------------------------------------------------------------------
PACKAGES[openSUSE]=
PACKAGES[openSUSE-12.2]=
PACKAGES[openSUSE-13.2]=
#-------------------------------------------------------------------------------
PACKAGES[RHEL]=
PACKAGES[RHEL-6]=
PACKAGES[RHEL-7]=
#-------------------------------------------------------------------------------
PACKAGES[Ubuntu]=
PACKAGES[Ubuntu-12.04]=
PACKAGES[Ubuntu-14.04]=
PACKAGES[Ubuntu-15.04]=
PACKAGES[Ubuntu-15.10]=
PACKAGES[Ubuntu-16.04]=
#-------------------------------------------------------------------------------
# Add more default package lists here for other distros
#===============================================================================

#===============================================================================
# Build packages
#===============================================================================
PACKAGES[@build]="autoconf automake bison flex gdb make patch"
RECOMMENDS[@build]="ccache texinfo"
#-------------------------------------------------------------------------------
PACKAGES[Debian_@build]="build-essential libc6-dev libncurses5-dev libtool manpages"
#-------------------------------------------------------------------------------
PACKAGES[Ubuntu_@build]="[Debian_@build]"
PACKAGES[Ubuntu-12.04_@build]="g++-multilib"
#-------------------------------------------------------------------------------
PACKAGES[LinuxMint_@build]="[Ubuntu_@build]"
PACKAGES[LinuxMint-16_@build]="[Ubuntu-12.04_@build]"
#-------------------------------------------------------------------------------
PACKAGES[RHEL_@build]="gcc gcc-c++ glibc-devel"
#-------------------------------------------------------------------------------
PACKAGES[CentOS_@build]="[RHEL_@build]"
#-------------------------------------------------------------------------------
PACKAGES[Fedora_@build]="[RHEL_@build]"
#-------------------------------------------------------------------------------
PACKAGES[openSUSE_@build]="[RHEL_@build] -texinfo"

#===============================================================================
# Common packages used in various courses
#===============================================================================
PACKAGES[@common]="curl gawk git screen sudo tree unzip wget"
RECOMMENDS[@common]="diffuse emacs gparted mc zip"
#-------------------------------------------------------------------------------
PACKAGES[Debian_@common]="gnupg htop tofrodos unp vim"
#-------------------------------------------------------------------------------
PACKAGES[Ubuntu_@common]="[Debian_@common]"
#-------------------------------------------------------------------------------
PACKAGES[LinuxMint_@common]="[Debian_@common]"
#-------------------------------------------------------------------------------
PACKAGES[openSUSE_@common]="dos2unix gpg2 vim"
RECOMMENDS[openSUSE_@common]="-diffuse mlocate"
RECOMMENDS[openSUSE-999_@common]="net-tools-deprecated"
#-------------------------------------------------------------------------------
PACKAGES[RHEL_@common]="dos2unix gnupg2 vim-enhanced"
RECOMMENDS[RHEL-7_@common]="nautilus-open-terminal"
RECOMMENDS[CentOS_@common]="[RHEL_@common]"
RECOMMENDS[CentOS-7_@common]="[RHEL-7_@common]"
RECOMMENDS[Fedora_@common]="[RHEL_@common] nautilus-open-terminal"

#===============================================================================
# Embedded packages
#===============================================================================
PACKAGES[@embedded]="lzop screen"
RECOMMENDS[@embedded]="minicom"
#-------------------------------------------------------------------------------
PACKAGES[Ubuntu_@embedded]="dnsmasq-base dosfstools mtd-utils parted nfs-kernel-server"
RECOMMENDS[Ubuntu-12.04_@embedded]="u-boot-tools"
PACKAGES[Ubuntu-14.04_@embedded]="[Ubuntu-12.04_@embedded]"
PACKAGES[Ubuntu-15.04_@embedded]="[Ubuntu-12.04_@embedded]"
#-------------------------------------------------------------------------------
PACKAGES[LinuxMint-16_@embedded]="[Ubuntu-12.04_@embedded]"
PACKAGES[LinuxMint-17_@embedded]="[Ubuntu-14.04_@embedded]"
#-------------------------------------------------------------------------------
PACKAGES[Debian-7_@embedded]="[Ubuntu-12.04_@embedded]"
PACKAGES[Debian-8_@embedded]="[Ubuntu-14.04_@embedded]"
#-------------------------------------------------------------------------------
PACKAGES[openSUSE_@embedded]="nfs-kernel-server"
RECOMMENDS[openSUSE_@embedded]="u-boot-tools"
#-------------------------------------------------------------------------------
PACKAGES[RHEL_@embedded]="dnsmasq glibc-static nfs-utils"
RECOMMENDS[RHEL_@embedded]="uboot-tools"
#-------------------------------------------------------------------------------
PACKAGES[CentOS_@embedded]="[RHEL_@embedded]"
PACKAGES[Fedora_@embedded]="[RHEL_@embedded]"

#===============================================================================
# Kernel related packages
#===============================================================================
PACKAGES[@kernel]="crash cscope gitk kexec-tools sysfsutils indent"
#-------------------------------------------------------------------------------
PACKAGES[Debian_@kernel]="exuberant-ctags kdump-tools libfuse-dev libssl-dev
    manpages-dev nfs-common"
RECOMMENDS[Debian_@kernel]="libglade2-dev libgtk2.0-dev qt4-default sparse
    stress symlinks"
PACKAGES[Ubuntu_@kernel]="[Debian_@kernel] hugepages libhugetlbfs-dev linux-crashdump"
PACKAGES[Ubuntu-12.04_@kernel]="libncurses5-dev"
PACKAGES[Ubuntu-14.04_@kernel]="liblzo2-dev"
PACKAGES[Ubuntu-15.04_@kernel]="[Ubuntu-14.04_@kernel]"
RECOMMENDS[Ubuntu-15.04_@kernel]="qt4-dev-tools"
#-------------------------------------------------------------------------------
PACKAGES[LinuxMint_@kernel]="[Ubuntu_@kernel]"
PACKAGES[LinuxMint-16_@kernel]="[Ubuntu-12.04_@kernel]"
PACKAGES[LinuxMint-17_@kernel]="[Ubuntu-14.04_@kernel]"
RECOMMENDS[LinuxMint-17_@kernel]="qt4-default libglade2-dev"
#-------------------------------------------------------------------------------
PACKAGES[Debian-7_@kernel]="[Ubuntu-12.04_@kernel]"
PACKAGES[Debian-8_@kernel]="[Ubuntu-14.04_@kernel]"
#-------------------------------------------------------------------------------
PACKAGES[Fedora_@kernel]="ctags fuse-devel kernel-devel libhugetlbfs libhugetlbfs-devel
    ncurses-devel nfs-utils"
RECOMMENDS[Fedora_@kernel]="gtk2-devel libglade2-devel qt-devel slang-devel
    sparse stress"
#-------------------------------------------------------------------------------
PACKAGES[RHEL_@kernel]="[Fedora_@kernel]"
PACKAGES[CentOS_@kernel]="[Fedora_@kernel] -stress"
#-------------------------------------------------------------------------------
PACKAGES[openSUSE_@kernel]="ctags fuse-devel kdump kernel-devel libhugetlbfs
    libhugetlbfs-libhugetlb-devel lzo-devel ncurses-devel nfs-kernel-server
    yast2-kdump"
RECOMMENDS[openSUSE_@kernel]="gtk2-devel libglade2-devel slang-devel sparse"

#===============================================================================
# Trace related packages
#===============================================================================
PACKAGES[@trace]="iotop strace"
PACKAGES[Ubuntu_@trace]="kernelshark ltrace linux-tools trace-cmd"
PACKAGES[Ubuntu-14.04_@trace]="-linux-tools linux-tools-generic"
PACKAGES[Ubuntu-15.04_@trace]="[Ubuntu-14.04_@trace]"
PACKAGES[Debian-8_@trace]="[Ubuntu_@trace]"
PACKAGES[LinuxMint-17]="[Ubuntu_@trace] -linux-tools"
PACKAGES[Fedora_@trace]="trace-cmd"
PACKAGES[RHEL_@trace]="[Fedora_@trace]"
PACKAGES[CentOS_@trace]="[Fedora_@trace]"
PACKAGES[openSUSE_@trace]="trace-cmd kernelshark"

#===============================================================================
# LFS related packages
#===============================================================================
PACKAGES[@sysadm]="collectl libtool mdadm m4 memtest86+ sysstat"
PACKAGES[Debian_@sysadm]="bonnie++ dstat gnuplot iftop"
PACKAGES[Ubuntu_@sysadm]="[Debian_@sysadm]"
PACKAGES[LinuxMint_@sysadm]="[Ubuntu_@sysadm]"
PACKAGES[RHEL_@sysadm]="bonnie++"
PACKAGES[CentOS_@sysadm]="[RHEL_@sysadm]"
PACKAGES[Fedora_@sysadm]="[RHEL_@sysadm]"
PACKAGES[openSUSE_@sysadm]="[RHEL_@sysadm] bonnie termcap"

#===============================================================================
# Virt related packages
#===============================================================================
PACKAGES[@virt]="qemu-kvm virt-manager"
PACKAGES[Debian_@virt]="libvirt-bin"
PACKAGES[Ubuntu_@virt]="[Debian_@virt]"
PACKAGES[LinuxMint_@virt]="[Debian_@virt]"
PACKAGES[RHEL_@virt]="libvirt"
PACKAGES[CentOS_@virt]="[RHEL_@virt]"
PACKAGES[Fedora_@virt]="[RHEL_@virt]"
PACKAGES[openSUSE_@virt]="[RHEL_@virt] libvirt-client libvirt-daemon"

#===============================================================================
# Extra requirements for LFD301
#===============================================================================
DESCRIPTION[LFD301]="Introduction to Linux for Developers and GIT"
WEBPAGE[LFD301]="$LFDTRAINING/introduction-to-linux-for-developers"
INTERNET[LFD301]=y
#-------------------------------------------------------------------------------
PACKAGES[LFD301]="@build @common @trace cvs gparted subversion sysstat tcpdump wireshark"
RECOMMENDS[LFD301]="iptraf-ng gnome-system-monitor ksysguard yelp"
PACKAGES[Debian_LFD301]="git git-cvs git-daemon-sysvinit git-gui git-svn gitk gitweb
	libcurl4-openssl-dev libexpat1-dev libssl-dev"
RECOMMENDS[Debian_LFD301]="default-jdk stress"
PACKAGES[Ubuntu_LFD301]="[Debian_LFD301]"
RECOMMENDS[Ubuntu_LFD301]="[Debian_LFD301]"
PACKAGES[LinuxMint_LFD301]="[Debian_LFD301]"
RECOMMENDS[LinuxMint_LFD301]="[Debian_LFD301]"
PACKAGES[RHEL_LFD301]="git-all curl-devel expat-devel openssl-devel"
RECOMMENDS[RHEL_LFD301]="kdebase"
RECOMMENDS[RHEL-6_LFD301]="-iptraf-ng iptraf"
PACKAGES[CentOS_LFD301]="[RHEL_LFD301]"
RECOMMENDS[CentOS-6_LFD301]="[RHEL-6_LFD301] -ksysguard ksysguardd"
PACKAGES[Fedora_LFD301]="[RHEL_LFD301]"
RECOMMENDS[Fedora_LFD301]="[RHEL_LFD301] stress"
PACKAGES[openSUSE_LFD301]="git git-core"
RECOMMENDS[openSUSE_LFD301]="kdebase4-workspace -ksysguard"

#===============================================================================
# Extra requirements for LFD401
#===============================================================================
DESCRIPTION[LFD401]="Developing Applications for Linux"
WEBPAGE[LFD401]="$LFDTRAINING/developing-applications-for-linux"
#-------------------------------------------------------------------------------
PACKAGES[LFD401]="@build @common valgrind kcachegrind ddd sysstat"
PACKAGES[Ubuntu_LFD401]="electric-fence"
PACKAGES[Debian_LFD401]="[Ubuntu_LFD401]"
PACKAGES[LinuxMint_LFD401]="[Ubuntu_LFD401]"
PACKAGES[RHEL_LFD401]="ElectricFence"
PACKAGES[CentOS_LFD401]="[RHEL_LFD401]"
PACKAGES[Fedora_LFD401]="[RHEL_LFD401]"
PACKAGES[openSUSE_LFD401]="[RHEL_LFD401] kcachegrind"

#===============================================================================
# Extra requirements for LFD415
#===============================================================================
DESCRIPTION[LFD415]="Inside Android: An Intro to Android Internals"
WEBPAGE[LFD415]="$LFDTRAINING/inside-android-an-intro-to-android-internals"
ARCH[LFD415]=x86_64
CPUS[LFD415]=2
PREFER_CPUS[LFD415]=4
BOGOMIPS[LFD415]=4000
RAM[LFD415]=4
DISK[LFD415]=80
DISTRO_ARCH[LFD415]=x86_64
INTERNET[LFD415]=Required
CARDREADER[LFD415]=Required
NATIVELINUX[LFD415]="highly recommended"
VMOKAY[LFD415]="highly discouraged"
DISTROS[LFD415]="Ubuntu:amd64-12.04 Ubuntu:amd64-14.04+"
RUNCODE[LFD415-12.04]=lfd415_extra
#===============================================================================
PACKAGES[LFD415]="@build @common @embedded vinagre"
#-------------------------------------------------------------------------------
PACKAGES[Ubuntu_LFD415]="libgl1-mesa-dev libxml2-utils mingw32
    python-markdown x11proto-core-dev xsltproc"
PACKAGES[Debian-7_LFD415]="ant libreadline6 libsdl-image1.2 libx11-dev zlib1g-dev"
PACKAGES[Ubuntu-12.04_LFD415]="[Debian-7_LFD415] libreadline6-dev:i386
    libsdl-image1.2:i386 libx11-dev:i386 zlib1g-dev:i386"
PACKAGES[Ubuntu-14.04_LFD415]="[Ubuntu-12.04_LFD415]"
PACKAGES[Ubuntu-15.04_LFD415]="[Ubuntu-14.04_LFD415] -mingw32"
#-------------------------------------------------------------------------------
PACKAGES[LinuxMint_LFD415]="[Ubuntu_LFD415]"
PACKAGES[LinuxMint-16_LFD415]="[Ubuntu-12.04_LFD415]"
PACKAGES[LinuxMint-17_LFD415]="[Ubuntu-14.04_LFD415]"
#-------------------------------------------------------------------------------
PACKAGES[Debian_LFD415]="[Ubuntu_LFD415]"
#-------------------------------------------------------------------------------
PACKAGES[openSUSE_LFD415]="Mesa-devel libxml2-devel libxml2-tools
    python-Markdown xorg-x11-proto-devel ant glibc-32bit readline-devel"
#-------------------------------------------------------------------------------
PACKAGES[RHEL_LFD415]="[openSUSE_LFD415]"
#-------------------------------------------------------------------------------
PACKAGES[Fedora_LFD415]="[RHEL_LFD415]"
#===============================================================================
lfd415_extra() {
    local CLASS=$1

    debug "Running ldf415_extra for $CLASS"
    GLSO=/usr/lib/i386-linux-gnu/libGL.so
    GLSOVER=/usr/lib/i386-linux-gnu/mesa/libGL.so.1
    if [[ -e $GLSOVER && ! -e $GLSO || -n "$SIMULATE_FAILURE" ]] ; then
        if [[ -z "$INSTALL" ]] ; then
            warn "Need to add missing symlink for libGL.so"
            highlight "You can do so by running '$0 --install $CLASS' or by:"
            dothis "  sudo ln -s $GLSOVER $GLSO"
        else
            notice "Adding missing symlink for libGL.so"
            sudo ln -s $GLSOVER $GLSO
        fi
    fi
}

#===============================================================================
# Extra requirements for LFD420
#===============================================================================
DESCRIPTION[LFD420]="Linux Kernel Internals and Debugging"
WEBPAGE[LFD420]="$LFDTRAINING/linux-kernel-internals-and-debugging"
BOOT[LFD420]=128	# Room for 2 more kernels
#-------------------------------------------------------------------------------
PACKAGES[LFD420]="@build @common @kernel @trace"
DISK[LFD420]=10

#===============================================================================
# Extra requirements for LFD430
#===============================================================================
DESCRIPTION[LFD430]="Developing Linux Device Drivers"
WEBPAGE[LFD430]="$LFDTRAINING/developing-linux-device-drivers"
BOOT[LFD430]=128	# Room for 2 more kernels
DISK[LFD430]=10
#-------------------------------------------------------------------------------
PACKAGES[LFD430]="@build @common @kernel @trace"

#===============================================================================
# Extra requirements for LFD432
#===============================================================================
DESCRIPTION[LFD432]="Optimizing Device Drivers for Power Efficiency"
WEBPAGE[LFD432]="$LFDTRAINING/optimizing-linux-device-drivers-for-power-efficiency"
#-------------------------------------------------------------------------------
PACKAGES[LFD432]="@build @common @kernel @trace gkrellm"
PACKAGES[Ubuntu_LFD432]="lm-sensors xsensors"
PACKAGES[Debian_LFD432]="[Ubuntu_LFD432]"
PACKAGES[LinuxMint_LFD432]="[Ubuntu_LFD432]"
PACKAGES[openSUSE_LFD432]="sensors"
PACKAGES[RHEL_LFD432]="xsensors"
PACKAGES[Fedora_LFD432]="[RHEL_LFD432]"

#===============================================================================
# Extra requirements for LFD435
#===============================================================================
DESCRIPTION[LFD435]="Embedded Linux Device Drivers"
WEBPAGE[LFD435]="$LFDTRAINING/developing-linux-device-drivers"
BOOT[LFD435]=128	# Room for 2 more kernels
DISK[LFD435]=40
#-------------------------------------------------------------------------------
PACKAGES[LFD435]="@build @common @kernel @trace"

#===============================================================================
# Extra requirements for LFD440
#===============================================================================
DESCRIPTION[LFD440]="Linux Kernel Debugging and Security"
#WEBPAGE[LFD440]="$LFDTRAINING/developing-linux-device-drivers"
BOOT[LFD440]=128	# Room for 2 more kernels
DISK[LFD440]=10
#-------------------------------------------------------------------------------
PACKAGES[LFD440]="@build @common @kernel @trace"

#===============================================================================
# Extra requirements for LFD450
#===============================================================================
DESCRIPTION[LFD450]="Embedded Linux Development"
WEBPAGE[LFD450]="$LFDTRAINING/embedded-linux-development"
CPUS[LFD450]=2
PREFER_CPUS[LFD450]=4
BOGOMIPS[LFD450]=3000
RAM[LFD450]=2
DISK[LFD450]=30
INTERNET[LFD450]=Required
CARDREADER[LFD450]=Required
NATIVELINUX[LFD450]="highly recommended"
VMOKAY[LFD450]="highly discouraged"
#-------------------------------------------------------------------------------
PACKAGES[LFD450]="@build @common @embedded @kernel @trace gperf help2man"
PACKAGES[Debian_LFD450]="libtool-bin squashfs-tools"
RECOMMENDS[Debian_LFD450]="libpython-dev"
PACKAGES[Ubuntu_LFD450]="[Debian_LFD450]"
RECOMMANDS[RHEL_LFD450]="libpython-devel"
RECOMMANDS[CentOS_LFD450]="[RHEL_LFD450]"
RECOMMANDS[Fedora_LFD450]="[RHEL_LFD450]"

#===============================================================================
# Extra requirements for LFD455
#===============================================================================
DESCRIPTION[LFD455]="Advanced Embedded Linux Development"
#WEBPAGE[LFD455]="$LFDTRAINING/embedded-linux-development"
CPUS[LFD455]=2
PREFER_CPUS[LFD455]=4
BOGOMIPS[LFD455]=3000
RAM[LFD455]=2
DISK[LFD455]=30
INTERNET[LFD455]=Required
CARDREADER[LFD455]=Required
NATIVELINUX[LFD455]="highly recommended"
VMOKAY[LFD455]="highly discouraged"
#-------------------------------------------------------------------------------
PACKAGES[LFD455]="@build @common @embedded @kernel @trace gperf help2man"
PACKAGES[Debian_LFD455]="libtool-bin squashfs-tools"
RECOMMENDS[Debian_LFD455]="libpython-dev"
PACKAGES[Ubuntu_LFD455]="[Debian_LFD455]"
RECOMMANDS[RHEL_LFD455]="libpython-devel"
RECOMMANDS[CentOS_LFD455]="[RHEL_LFD455]"
RECOMMANDS[Fedora_LFD455]="[RHEL_LFD455]"

#===============================================================================
# Extra requirements for LFD460
#===============================================================================
DESCRIPTION[LFD460]="Building Embedded Linux with the Yocto Project"
WEBPAGE[LFD460]="$LFDTRAINING/embedded-linux-development-with-yocto-project"
CPUS[LFD460]=4
PREFER_CPUS[LFD460]=8
BOGOMIPS[LFD460]=20000
RAM[LFD460]=4
DISK[LFD460]=100
INTERNET[LFD460]=Required
CARDREADER[LFD460]="highly recommended"
NATIVELINUX[LFD460]="highly recommended"
VMOKAY[LFD460]="highly discouraged"
#-------------------------------------------------------------------------------
PACKAGES[LFD460]="@build @common @embedded chrpath daemon diffstat python-pip
        python-ply python-progressbar socat xterm"
#-------------------------------------------------------------------------------
PACKAGES[Ubuntu_LFD460]="libarchive-dev libglib2.0-dev libsdl1.2-dev libxml2-utils texinfo xsltproc"
RECOMMENDS[Ubuntu_LFD460]="default-jre"
PACKAGES[Ubuntu-14.04_LFD460]="libnfs1"
PACKAGES[Ubuntu-15.04_LFD460]="libnfs8"
PACKAGES[Debian_LFD460]="[Ubuntu_LFD460]"
PACKAGES[Debian-7_LFD460]="[Ubuntu-14.04_LFD460]"
PACKAGES[Debian-8_LFD460]="[Ubuntu-15.04_LFD460]"
PACKAGES[LinuxMint_LFD460]="[Ubuntu_LFD460]"
PACKAGES[Fedora_LFD460]="cpp diffutils perl perl-Data-Dumper
	perl-Text-ParseWords perl-Thread-Queue python SDL-devel"
PACKAGES[CentOS_LFD460]="bzip2 cpp diffutils gzip python perl tar SDL-devel"
PACKAGES[RHEL_LFD460]="[CentOS_LFD460]"
PACKAGES[openSUSE_LFD460]="libSDL-devel python python-curses python-xml"

#===============================================================================
# Extra requirements for LFD461
#===============================================================================
DESCRIPTION[LFD461]="KVM for Developers"
WEBPAGE[LFD461]="$LFDTRAINING/kvm-for-developers"
#-------------------------------------------------------------------------------
PACKAGES[LFD461]="@build @common @trace @virt"
#-------------------------------------------------------------------------------
PACKAGES[Ubuntu_LFD461]="g++"
PACKAGES[Debian_LFD461]="[Ubuntu_LFD461]"
PACKAGES[LinuxMint_LFD461]="[Ubuntu_LFD461]"
PACKAGES[RHEL_LFD461]="kernel-devel"
PACKAGES[CentOS_LFD461]="[RHEL_LFD461]"
PACKAGES[Fedora_LFD461]="[RHEL_LFD461]"
PACKAGES[openSUSE_LFD461]="[RHEL_LFD461]"

#===============================================================================
# Extra requirements for LFS101
#===============================================================================
DESCRIPTION[LFS101]="Introduction to Linux"
WEBPAGE[LFS101]="$LFSTRAINING/introduction-to-linux"
#-------------------------------------------------------------------------------
PACKAGES[LFS101]="@common"

#===============================================================================
# Extra requirements for LFS201
#===============================================================================
DESCRIPTION[LFS201]="Essentials of System Administration"
WEBPAGE[LFS201]="$LFSTRAINING/essentials-of-system-administration"
#-------------------------------------------------------------------------------
PACKAGES[LFS201]="@build @common @sysadm @trace cryptsetup"

#===============================================================================
# Extra requirements for LFS300
#===============================================================================
DESCRIPTION[LFS300]="Fundamentals of Linux"
WEBPAGE[LFS300]="$LFSTRAINING/fundamentals-of-linux"
#-------------------------------------------------------------------------------
PACKAGES[LFS300]="@common"

#===============================================================================
# Extra requirements for LFS301
#===============================================================================
DESCRIPTION[LFS301]="Linux System Administration"
WEBPAGE[LFS301]="$LFSTRAINING/linux-system-administration"
#-------------------------------------------------------------------------------
PACKAGES[LFS301]="@build @common @sysadm @trace cryptsetup"

#===============================================================================
# Extra requirements for LFS311
#===============================================================================
DESCRIPTION[LFS311]="Linux Network Management"
WEBPAGE[LFS311]="$LFSTRAINING/linux-network-management"
#-------------------------------------------------------------------------------
PACKAGES[LFS311]="@build @common @sysadm @trace"

#===============================================================================
# Extra requirements for LFS416
#===============================================================================
DESCRIPTION[LFS416]="Linux Security"
WEBPAGE[LFS416]="$LFSTRAINING/linux-security"
ARCH[LFS416]=x86_64
CPUS[LFS416]=4
BOGOMIPS[LFS416]=20000
RAM[LFS416]=8
DISK[LFS416]=20
INTERNET[LFS416]=y
CPUFLAGS[LFS416]=vmx
CONFIGS[LFS416]="HAVE_KVM KSM"
#-------------------------------------------------------------------------------
PACKAGES[LFS416]="@build @common @virt"
#-------------------------------------------------------------------------------
PACKAGES[Debian_LFS416]="apache2-utils"
PACKAGES[Ubuntu_LFS416]="-" # Forcing empty list so it doesn't fallback to Debian
PACKAGES[LinuxMint_LFS416]="-"
PACKAGES[RHEL_LFS416]="kernel-devel"
PACKAGES[CentOS_LFS416]="[RHEL_LFS416]"
PACKAGES[Fedora_LFS416]="[RHEL_LFS416]"
PACKAGES[openSUSE_LFS416]="[RHEL_LFS416]"

#===============================================================================
# Extra requirements for LFS422
#===============================================================================
DESCRIPTION[LFS422]="High Availability Linux Architecture"
WEBPAGE[LFS422]="$LFSTRAINING/high-availability-linux-architecture"
ARCH[LFS422]=x86_64
CPUS[LFS422]=2
RAM[LFS422]=4
DISK[LFS422]=40
DISTRO_ARCH[LFS422]=x86_64
INTERNET[LFS422]=y
CPUFLAGS[LFS422]=vmx
DISTROS[LFS422]="Ubuntu:amd64-12.04 Ubuntu:amd64-14.04+"
#-------------------------------------------------------------------------------
PACKAGES[LFS422]="@common @sysadm @trace @virt"

#===============================================================================
# Extra requirements for LFS426
#===============================================================================
DESCRIPTION[LFS426]="Linux Performance Tuning"
WEBPAGE[LFS426]="$LFSTRAINING/linux-performance-tuning"
ARCH[LFS426]=x86_64
CPUS[LFS426]=2
PREFER_CPUS[LFS426]=4
BOGOMIPS[LFS426]=20000
RAM[LFS426]=2
DISK[LFS426]=5
DISTRO_ARCH[LFS426]=x86_64
INTERNET[LFS426]=y
#-------------------------------------------------------------------------------
PACKAGES[LFS426]="@build @common @sysadm @trace @virt blktrace blktrace crash
	cpufrequtils fio hdparm lmbench lynx mdadm oprofile sysstat
	systemtap valgrind"
PACKAGES[Debian_LFS426]="hugepages iozone3 libaio-dev libblas-dev
	libncurses5-dev nfs-kernel-server zlib1g-dev"
RECOMMENDS[Debian_LFS426]="stress"
PACKAGES[Debian-8_LFS426]="[Debian_LFS426] -hugepages -lmbench -oprofile"
PACKAGES[Ubuntu_LFS426]="[Debian_LFS426]"
PACKAGES[RHEL_LFS426]="blas-devel iozone
	kernel-devel libaio-devel libhugetlbfs-utils ncurses-devel perl-Time-HiRes
        zlib-devel zlib-devel-static"
PACKAGES[CentOS_LFS426]="[RHEL_LFS426] -iozone -lmbench -zlib-devel-static"
PACKAGES[CentOS-7_LFS426]="-cpufrequtils"
PACKAGES[Fedora_LFS426]="[RHEL_LFS426] -iozone iozone3"
RECOMMENDS[Fedora_LFS426]="[RHEL_LFS426] stress"
PACKAGES[openSUSE_LFS426]="[RHEL_LFS426] -iozone -libhugetlbfs-utils -lmbench nfs-kernel-server"

#===============================================================================
# Extra requirements for LFS430
#===============================================================================
DESCRIPTION[LFS430]="Linux Enterprise Automation"
WEBPAGE[LFS430]="$LFSTRAINING/linux-enterprise-automation"
#-------------------------------------------------------------------------------
PACKAGES[LFS430]="@build @common @sysadm @trace"

#===============================================================================
# Extra requirements for LFS452
#===============================================================================
DESCRIPTION[LFS452]="Essentials of OpenStack Administration"
WEBPAGE[LFS452]="$LFSTRAINING/essentials-of-openstack-administration"
#-------------------------------------------------------------------------------
PACKAGES[LFS452]="@common @sysadm"

#===============================================================================
# Extra requirements for LFS462
#===============================================================================
DESCRIPTION[LFS462]="Introduction to Linux KVM Virtualization"
WEBPAGE[LFS462]="$LFSTRAINING/linux-kvm-virtualization"
CPUS[LFS462]=2
PREFER_CPUS[LFS462]=4
BOGOMIPS[LFS462]=10000
RAM[LFS462]=3
CPUFLAGS[LFS462]=vmx
CONFIGS[LFS462]="HAVE_KVM KSM"
NATIVELINUX[LFS462]="Required"
VMOKAY[LFS462]="This course can't be run on a VM"
#-------------------------------------------------------------------------------
PACKAGES[LFS462]="@build @common @virt"
#-------------------------------------------------------------------------------
PACKAGES[Ubuntu_LFS462]="g++"
PACKAGES[Debian_LFS462]="[Ubuntu_LFS462]"
PACKAGES[LinuxMint_LFS462]="[Ubuntu_LFS462]"
PACKAGES[RHEL_LFS462]="kernel-devel"
PACKAGES[CentOS_LFS462]="[RHEL_LFS462]"
PACKAGES[Fedora_LFS462]="[RHEL_LFS462]"
PACKAGES[openSUSE_LFS462]="[RHEL_LFS462]"

#===============================================================================
# Extra requirements for LFS465
#===============================================================================
DESCRIPTION[LFS465]="Software Defined Networking with OpenDaylight"
WEBPAGE[LFS465]="$LFSTRAINING/software-defined-networking-with-opendaylight"
CPUS[LFS465]=2
PREFER_CPUS[LFS465]=4
BOGOMIPS[LFS465]=10000
RAM[LFS465]=4
DISK[LFS465]=20
CONFIGS[LFS465]=OPENVSWITCH
DISTROS[LFS465]=Ubuntu:amd64-14.10+
#-------------------------------------------------------------------------------
PACKAGES[LFS465]="@build @common"
#-------------------------------------------------------------------------------
PACKAGES[Ubuntu_LFS465]="default-jre libxml2-dev libxslt-dev maven mininet
	openvswitch-switch openvswitch-test openvswitch-testcontroller
	python-openvswitch tshark wireshark wireshark-doc"
RECOMMENDS[Ubuntu_LFS465]="build-dep_wireshark"

#===============================================================================
#=== End of Course Definitions =================================================
#===============================================================================

#===============================================================================
check_root() {
    if [[ $USER == root ]] ; then
        warn "This script is intended to be run as a regular user (not as root)"
        exit 1
    fi
}

#===============================================================================
# List available courses
list_courses() {
    echo "Available courses:"
    for D in ${!DESCRIPTION[*]}; do
        echo "  $D - ${DESCRIPTION[$D]}"
    done | sort
    exit 0
}

#===============================================================================
for_each_course() {
    local CODE=$1; shift
    local CLASS
    debug for_each_course loop over: $*
    for CLASS in $(list_sort $*) ; do
        debug for_each_course eval "$CODE $CLASS"
        eval "$CODE $CLASS"
    done
}

#===============================================================================
supported_course() {
    local CLASS=$1
    [[ -n ${DESCRIPTION[$CLASS]} ]] || warn "Unsupported course: $CLASS"
}

#===============================================================================
check_course() {
    local CLASS=$1
    if [[ -n ${DESCRIPTION[$CLASS]} ]] ; then
        echo "Checking that this computer is suitable for $CLASS: ${DESCRIPTION[$CLASS]}"
    else
        warn "Unknown course \"$CLASS\", checking defaults requirements instead"
    fi
}

#===============================================================================
try_course() {
    local CLASS=$1 NEWCLASS=$2
    [[ -n ${DESCRIPTION[$NEWCLASS]} ]] || return 1
    if warn_wait "I think you meant $NEWCLASS (not $CLASS)" ; then
        echo $NEWCLASS
    else
        echo $CLASS
    fi
}

#===============================================================================
spellcheck_course() {
    local CLASS=$1
    local COURSES
    [[ -n $CLASS ]] || return 0
    if [[ -n ${DESCRIPTION[$CLASS]} ]] ; then
        echo $CLASS
    elif COURSES=$(get_cm_var $CLASS COURSES) && [[ -n $COURSES ]] ; then
        echo $COURSES
    else
        try_course $CLASS ${CLASS/LFD/LFS} || try_course $CLASS ${CLASS/LFS/LFD} || echo $CLASS
    fi
}

#===============================================================================
# Determine Course
find_course() {
    local COURSE=$1

    if [[ -n $COURSE && -n ${COURSE_ALIASES[$COURSE]} ]] ; then
        notice "$COURSE is an alias for ${COURSE_ALIASES[$COURSE]}"
        COURSE=${COURSE_ALIASES[$COURSE]}
    fi
    spellcheck_course $COURSE
}

#===============================================================================
# Try package list for all courses
try_all_courses() {
    for D in $(list_sort ${!DESCRIPTION[*]}); do
        echo "==============================================================================="
        NO_PASS=1 $CMD \
		${NOCM:+--no-course-materials} \
		${NOINSTALL:+--no-install} \
		${NORECOMMENDS:+--no-recommends} \
		$D
    done
    exit 0
}

#===============================================================================
version_greater_equal () {
    local IFS=.
    local VER1=($1) VER2=($2)
    local i LEN=$( (( ${#VER1[*]} > ${#VER2[*]} )) && echo ${#VER1[*]} || echo ${#VER2[*]})
    for ((i=0; i<$LEN; i++)) ; do
        (( 10#${VER1[i]:-0} > 10#${VER2[i]:-0} )) && return 0
        (( 10#${VER1[i]:-0} < 10#${VER2[i]:-0} )) && return 1
    done
    return 0
}

#===============================================================================
distrib_list() {
    local RETURN=$1
    local L=$(for D in ${!PACKAGES[*]}; do echo $D; done | sed -e 's/_.*$//' | grep -- - | sort -u)
    eval $RETURN="'$L'"
}

#===============================================================================
distrib_ver() {
    local DID=$1 DREL=$2
    debug "Distribution: $DID $DREL"
    local AVAIL_INDEXES=$(for D in ${!PACKAGES[*]}; do echo $D; done | grep $DID | sort -ru)
    debug "Available package indexes for $DID: $AVAIL_INDEXES"
    local AVAIL_RELS=$(for R in $AVAIL_INDEXES; do R=${R#*-}; echo ${R%_*}; done | grep -v ^$DID | sort -ru)
    debug "Available distro releases for $DID: $AVAIL_RELS"
    local DVER=1
    for R in $AVAIL_RELS ; do
        if version_greater_equal $DREL $R ; then
            DVER=$R
            break
        fi
    done
    debug "We're going to use $DID-$DVER"
    echo $DVER
}

#===============================================================================
# Do a lookup in DB of KEY
lookup() {
    local DB=$1
    local KEY=$2
    [[ -n $KEY ]] || return
    local DATA=$(eval "echo \${$DB[$KEY]}")
    if [[ -n $DATA ]] ; then
        debug " - lookup $DB[$KEY] -> $DATA"
        echo $DATA
        return 0
    fi
    return 1
}

#===============================================================================
# Do a lookup in DB for DIST[-RELEASE] and if unfound consult FALLBACK distros
lookup_fallback() {
    local DB=$1
    local NAME=$2
    local DIST=$3
    local RELEASE=$4
    #debug "fallback DB=$DB NAME=$NAME DIST=$DIST RELEASE=$RELEASE"
    DIST+=${RELEASE:+-$RELEASE}
    local KEY
    for KEY in $DIST ${FALLBACK[${DIST:-no_distro}]} ; do
        KEY+=${NAME:+_$NAME}
	debug " - lookup_fallback $DB $KEY"
        lookup $DB $KEY && return
    done
}

#===============================================================================
# Do a lookup in DB for NAME, DIST_NAME, DIST-RELEASE_NAME
get_db() {
    local DB=$1
    local NAME=$2
    local DIST=$3
    local RELEASE=$4

    debug "get_db $DB NAME=$NAME DIST=$DIST RELEASE=$RELEASE"
    debug "- get_db lookup $DB '$NAME'"
    lookup $DB $NAME
    debug "- get_db lookup_fallback $DB $NAME $DIST"
    lookup_fallback $DB "$NAME" "$DIST" ""
    debug "- get_db lookup_fallback $DB $NAME $DIST $RELEASE"
    lookup_fallback $DB "$NAME" "$DIST" "$RELEASE"
}

#===============================================================================
# Recursively expand macros in package list
pkg_list_expand() {
    local DB=$1; shift
    local DID=$1; shift
    local DREL=$1; shift
    local KEY
    debug "expand $DB $DID-$DREL: $*"
    for KEY in $* ; do
        case $KEY in
            @*) local PKGS=$(get_db $DB $KEY $DID $DREL)
                pkg_list_expand $DB $DID $DREL $PKGS ;;
            [*) local PKGS=$(eval "echo \${$DB$KEY}") #]
                debug "lookup macro $DB$KEY -> $PKGS"
                [[ $KEY != $PKGS ]] || error "Recursive package list: $KEY"
                pkg_list_expand $DB $DID $DREL $PKGS ;;
            *) echo $KEY ;;
        esac
    done
}

#===============================================================================
# Handle removing packages from the list: foo -foo
pkg_list_contract() {
    local PKGS=$(list_sort $*)
    debug "pkg_list_contract (before): $PKGS"
    for PKG in $PKGS; do
        [[ $PKG == -* ]] && PKGS=$(for P in $PKGS; do echo $P; done | egrep -v "^-?${PKG/-/}$")
    done
    debug "pkg_list_contract (after): $PKGS"
    list_sort $PKGS
}

#===============================================================================
# Check package list for obvious problems
pkg_list_check() {
    for PKG in ${!PACKAGES[@]} ${!RECOMMENDS[@]}; do
        case "$PKG" in
            @*|*_@*) >/dev/null;;
            *@*) fail "'$PKG' is likely invalid. I think you meant '${PKG/@/_@}'";;
            *) >/dev/null;;
        esac
    done
}

#===============================================================================
# Build package list
# TODO: Needs to be tested more with other distros
package_list() {
    local DID=$1
    local DREL=$2
    local CLASS=$3

    pkg_list_check

    local DVER=$(distrib_ver $DID $DREL)

    #---------------------------------------------------------------------------
    local PLIST=$(get_db PACKAGES "" $DID $DVER; get_db PACKAGES $CLASS $DID $DVER)
    debug "Package list for PLIST=$PLIST"
    local LIST=$(pkg_list_expand PACKAGES $DID $DVER $PLIST)
    debug "PACKAGES LIST=$LIST"

    if [[ -z $NORECOMMENDS ]] ; then
        local RLIST=$(get_db RECOMMENDS "" $DID $DVER; get_db RECOMMENDS $CLASS $DID $DVER)
        LIST+=" $(pkg_list_expand RECOMMENDS $DID $DVER $PLIST $RLIST)"
        debug "PACKAGES+RECOMMENDS LIST=$LIST"
    fi

    LIST=$(pkg_list_contract $LIST)
    debug "Final package $DID-${DVER}_$CLASS: $LIST"
    echo $LIST
}

#===============================================================================
# List information
list_entry() {
    local NAME=$1; shift
    [[ -z "$*" ]] || echo "    $NAME: $*"
}
list_array() {
    local NAME=$1; shift
    local WS=$1; shift
    local LIST=$*
    [[ -z "$LIST" ]] || echo "    $WS$NAME: $LIST"
}
list_sort() {
    sed 's/ /\n/g' <<< $* | sort -u
}
#-------------------------------------------------------------------------------
list_requirements() {
    local COURSE=$1
    local DISTS
    [[ -n $COURSE ]] && supported_course $COURSE
    [[ -n $COURSE ]] && COURSES=$COURSE || COURSES=$(list_sort ${!DESCRIPTION[*]})
    echo 'Courses:'
    for D in $COURSES; do
        echo "  $D:"
        list_entry DESCRIPTION ${DESCRIPTION[$D]}
        list_entry WEBPAGE ${WEBPAGE[$D]}
        list_entry ARCH ${ARCH[$D]:-$ARCH}
        list_entry CPUFLAGS ${CPUFLAGS[$D]:-$CPUFLAGS}
        list_entry CPUS ${CPUS[$D]:-$CPUS}
        list_entry PREFER_CPUS ${PREFER_CPUS[$D]:-$PREFER_CPUS}
        list_entry BOGOMIPS ${BOGOMIPS[$D]:-$BOGOMIPS}
        list_entry RAM ${RAM[$D]:-$RAM}
        list_entry DISK ${DISK[$D]:-$DISK}
        list_entry BOOT ${BOOT[$D]:-$BOOT}
        list_entry CONFIGS ${CONFIGS[$D]:-$CONFIGS}
        list_entry DISTRO_ARCH ${DISTRO_ARCH[$D]:-$DISTRO_ARCH}
        list_entry INTERNET ${INTERNET[$D]:-$INTERNET}
        list_entry CARDREADER ${CARDREADER[$D]:-$CARDREADER}
        list_entry NATIVELINUX ${NATIVELINUX[$D]:-$NATIVELINUX}
        list_entry VMOKAY ${VMOKAY[$D]:-$VMOKAY}
        list_array DISTROS "" ${DISTROS[$D]:-$DISTROS}
        list_array DISTRO_BL "" ${DISTRO_BL[$D]:-$DISTRO_BL}
        [[ -z $DIST_LIST ]] && distrib_list DISTS || DISTS=$DIST_LIST
        debug "DISTS=$DISTS"
        if [[ -n "$DISTS" ]] ; then
            echo '    PACKAGES:'
            for DIST in $DISTS; do
                local P=$(package_list ${DIST/-/ } $D)
                debug $P
                list_array $DIST "  " $P
            done
        fi
    done
}

#===============================================================================
parse_distro() {
    local DIST DARCH DVER GT
    IFS='-' read -r DIST GT <<< "$1"
    DVER=${GT%+}
    GT=${GT/$DVER/}
    IFS=':' read -r DIST DARCH <<< "$DIST"
    debug "parse_distro: $DIST,$DARCH,$DVER,$GT"
    echo $DIST,$DARCH,$DVER,$GT
}

#===============================================================================
# Is distro-B in filter-A?
cmp_dists() {
    local A=$1 B=$2
    debug cmp_dists $A $B

    [[ $A == $B || $A+ == $B || $A == $B+ ]] && return 0

    local AD AA AV AG
    local BD BA BV BG
    IFS=',' read -r AD AA AV AG <<< $(parse_distro $A)
    IFS=',' read -r BD BA BV BG <<< $(parse_distro $B)

    if [[ $AD == $BD ]] ; then
        [[ -n $AA || -n $BA ]] && [[ $AV == $BV ]] && return 0
        [[ $AV == $BV ]] && return 0
        [[ -n $AG ]] && ! ltver $AV $BV || return 0
    fi
    return 1
}

#===============================================================================
filter_dists() {
    local FILTER=$1; shift;
    local DISTS=$*
    local F D

    debug "filter_dists <$FILTER> <$DISTS>"

    if [[ -z $FILTER ]] ; then 
        echo $DISTS
        return 0
    fi

    for D in $DISTS; do
        for F in $FILTER; do
            if cmp_dists $F $D ; then
                debug "filter_dists $D is in $F"
                echo $D
            fi
        done
    done
}

#===============================================================================
# JSON support
json_entry() {
    local NAME=$1; shift
    progress '.'
    [[ -z "$*" ]] || echo "      \"$NAME\": \"$*\","
}
json_array() {
    local NAME=$1; shift
    local WS=$1; shift
    local LIST=$*
    progress '+'
    [[ -z "$LIST" ]] || echo "      $WS\"$NAME\": [\"${LIST// /\", \"}\"],"
}
#-------------------------------------------------------------------------------
list_json() {
    distrib_list DISTS
    ( cat <<END
{
  "whatisthis": "Description of Linux Foundation course requirements",
  "form": {
    "description": "Course Description",
    "arch": "Required CPU Architecture",
    "cpuflags": "Required CPU features",
    "cpus": "Required Number of CPU cores",
    "prefer_cpus": "Preferred Number of CPU cores",
    "bogomips": "Minimum CPU Performance (bogomips)",
    "ram": "Minimum Amount of RAM (GiB)",
    "disk": "Free Disk Space in \$HOME (GiB)",
    "boot": "Free Disk Space in /boot (MiB)",
    "configs": "Kernel Configuration Options",
    "distro_arch": "Distro Architecture",
    "internet": "Is Internet Required?",
    "card_reader": "Is the use of a Card Reader Required?",
    "native_linux": "Native Linux",
    "vm_okay": "Virtual Machine",
    "distros": "Supported Linux Distros",
    "distro_bl": "Unsupported Linux Distros",
    "packages": "Package List"
  },
  "distros": [
$(for DIST in $DISTS ; do echo '    "'$DIST'+",'; done | sort)
  ],
  "distro_fallback": {
$(for FB in ${!FALLBACK[*]} ; do echo '    "'$FB'": "'${FALLBACK[$FB]}'",'; done | sort)
  },
  "courses": {
END
    local D
    for D in $(list_sort ${!DESCRIPTION[*]}); do
        progress "$D: "
        echo "    \"$D\": {"
        json_entry description ${DESCRIPTION[$D]}
        json_entry url ${WEBPAGE[$D]}
        json_entry arch ${ARCH[$D]:-$ARCH}
        json_entry cpuflags ${CPUFLAGS[$D]:-$CPUFLAGS}
        json_entry cpus ${CPUS[$D]:-$CPUS}
        json_entry prefer_cpus ${PREFER_CPUS[$D]:-$PREFER_CPUS}
        json_entry bogomips ${BOGOMIPS[$D]:-$BOGOMIPS}
        json_entry ram ${RAM[$D]:-$RAM}
        json_entry disk ${DISK[$D]:-$DISK}
        json_entry boot ${BOOT[$D]:-$BOOT}
        json_entry configs ${CONFIGS[$D]:-$CONFIGS}
        json_entry distro_arch ${DISTRO_ARCH[$D]:-$DISTRO_ARCH}
        json_entry internet ${INTERNET[$D]:-$INTERNET}
        json_entry card_reader ${CARDREADER[$D]:-$CARDREADER}
        json_entry native_linux ${NATIVELINUX[$D]:-$NATIVELINUX}
        json_entry vm_okay ${VMOKAY[$D]:-$VMOKAY}
        json_array distros "" ${DISTROS[$D]:-$DISTROS}
        [[ ${DISTRO_BL[$D]} != delete ]] && json_array distro_bl "" ${DISTRO_BL[$D]:-$DISTRO_BL}
        local DLIST=$(filter_dists "${DISTROS[$D]}" $DISTS)
        if [[ -n "$DLIST" ]] ; then
            echo '      "packages": {'
            for DIST in $(sed 's/:[a-zA-Z0-9]*-/-/g; s/\+//g' <<< $DLIST); do
                local P=$(package_list ${DIST/-/ } $D)
                json_array $DIST "  " $P
            done
            echo '      },'
        fi
        echo '    },'
        progress "\n"
    done
    echo '  }'
    echo '}') | perl -e '$/=undef; $_=<>; s/,(\s+[}\]])/$1/gs; print;'
    # Minification
    #| sed ':a;N;$!ba; s/\n//g; s/   *//g; s/\([:,]\) \([\[{"]\)/\1\2/g'
    exit 0
}

#===============================================================================
# Determine Distro and release
guess_distro() {
    local DISTRO=$1
    local DISTRIB_SOURCE DISTRIB_ID DISTRIB_RELEASE DISTRIB_CODENAME DISTRIB_DESCRIPTION DISTRIB_ARCH
    #-------------------------------------------------------------------------------
    if [[ -f /etc/lsb-release ]] ; then
        DISTRIB_SOURCE+="/etc/lsb-release"
        . /etc/lsb-release
    fi
    #-------------------------------------------------------------------------------
    if [[ -z "$DISTRIB_ID" ]] ; then
        if [[ -f /usr/bin/lsb_release ]] ; then
            DISTRIB_SOURCE+=" lsb_release"
            DISTRIB_ID=$(lsb_release -is)
            DISTRIB_RELEASE=$(lsb_release -rs)
            DISTRIB_CODENAME=$(lsb_release -cs)
            DISTRIB_DESCRIPTION=$(lsb_release -ds)
        fi
    fi
    #-------------------------------------------------------------------------------
    if [[ -f /etc/os-release ]] ; then
        DISTRIB_SOURCE+=" /etc/os-release"
        . /etc/os-release
        DISTRIB_ID=${DISTRIB_ID:-${ID^}}
        DISTRIB_RELEASE=${DISTRIB_RELEASE:-$VERSION_ID}
        DISTRIB_DESCRIPTION=${DISTRIB_DESCRIPTION:-$PRETTY_NAME}
    fi
    #-------------------------------------------------------------------------------
    if [[ -f /etc/debian_version ]] ; then
        DISTRIB_SOURCE+=" /etc/debian_version"
        DISTRIB_ID=${DISTRIB_ID:-Debian}
        [[ -n $DISTRIB_CODENAME ]] || DISTRIB_CODENAME=$(sed 's|^.*/||' /etc/debian_version)
        [[ -n $DISTRIB_RELEASE ]] || DISTRIB_RELEASE=${DEBREL[$DISTRIB_CODENAME]:-$DISTRIB_CODENAME}
    #-------------------------------------------------------------------------------
    elif [[ -f /etc/SuSE-release ]] ; then
        DISTRIB_SOURCE+=" /etc/SuSE-release"
        [[ -n $DISTRIB_ID ]] || DISTRIB_ID=$(awk 'NR==1 {print $1}' /etc/SuSE-release)
        [[ -n $DISTRIB_RELEASE ]] || DISTRIB_RELEASE=$(awk '/^VERSION/ {print $3}' /etc/SuSE-release)
        [[ -n $DISTRIB_CODENAME ]] || DISTRIB_CODENAME=$(awk '/^CODENAME/ {print $3}' /etc/SuSE-release)
    #-------------------------------------------------------------------------------
    elif [[ -f /etc/redhat-release ]] ; then
        DISTRIB_SOURCE+=" /etc/redhat-release"
        if egrep -q "^Red Hat Enterprise Linux" /etc/redhat-release ; then
            [[ -n $DISTRIB_RELEASE ]] || DISTRIB_RELEASE=$(awk '{print $7}' /etc/redhat-release)
        elif egrep -q "^CentOS|Fedora" /etc/redhat-release ; then
            DISTRIB_ID=$(awk '{print $1}' /etc/redhat-release)
            [[ -n $DISTRIB_RELEASE ]] || DISTRIB_RELEASE=$(awk '{print $3}' /etc/redhat-release)
        fi
        DISTRIB_ID=${DISTRIB_ID:-RHEL}
        [[ -n $DISTRIB_CODENAME ]] || DISTRIB_CODENAME=$(sed 's/^.*(//; s/).*$//;' /etc/redhat-release)
    #-------------------------------------------------------------------------------
    elif [[ -e /etc/arch-release ]] ; then
        DISTRIB_SOURCE+=" /etc/arch-release"
        DISTRIB_ID=${DISTRIB_ID:-Arch}
        # Arch Linux doesn't have a "release"...
        # So instead we'll look at the modification date of pacman
        [[ -n $DISTRIB_RELEASE ]] || DISTRIB_RELEASE=$(ls -l --time-style=+%Y.%m /bin/pacman | cut -d' ' -f6)
    #-------------------------------------------------------------------------------
    elif [[ -e /etc/gentoo-release ]] ; then
        DISTRIB_SOURCE+=" /etc/gentoo-release"
        DISTRIB_ID=${DISTRIB_ID:-Gentoo}
        [[ -n $DISTRIB_RELEASE ]] || DISTRIB_RELEASE=$(cut -d' ' -f5 /etc/gentoo-release)
    fi
    #-------------------------------------------------------------------------------
    if [[ -n $DISTRO ]] ; then
        debug "Overriding distro: $DISTRO"
        DISTRIB_SOURCE+=" override"
        DISTRIB_ID=${DISTRO%%-*}
        DISTRIB_RELEASE=${DISTRO##*-}
        DISTRIB_CODENAME=Override
        DISTRIB_DESCRIPTION="$DISTRO (Override)"
    fi
    #-------------------------------------------------------------------------------
    shopt -s nocasematch
    if [[ $DISTRIB_ID =~ 'Debian' ]] ; then
        DISTRIB_RELEASE=${DEBREL[$DISTRIB_RELEASE]:-$DISTRIB_RELEASE}
    elif [[ $DISTRIB_ID =~ 'SUSE' ]] ; then
        DISTRIB_ID=$(echo $DISTRIB_DESCRIPTION | sed 's/"//g; s/ .*//')
        #[[ "$DISTRIB_RELEASE" -lt 20000000 ]] || DISTRIB_RELEASE=999
        version_greater_equal 20000000 "$DISTRIB_RELEASE" || DISTRIB_RELEASE=999
    elif [[ $DISTRIB_ID == Centos ]] ; then
        DISTRIB_ID=CentOS
    elif [[ $DISTRIB_ID == RedHat* || $DISTRIB_ID == Rhel ]] ; then
        DISTRIB_ID=RHEL
    fi
    shopt -u nocasematch
    #-------------------------------------------------------------------------------
    DISTRIB_ID=${DISTRIB_ID:-Unknown}
    DISTRIB_RELEASE=${DISTRIB_RELEASE:-0}
    #DISTRIB_CODENAME=${DISTRIB_CODENAME:-Unknown}
    [[ -n "$DISTRIB_DESCRIPTION" ]] || DISTRIB_DESCRIPTION="$DISTRIB_ID $DISTRIB_RELEASE"

    #===============================================================================
    # Determine Distro arch
    local DARCH
    if [[ -e /usr/bin/dpkg && $DISTRIB_ID =~ Debian|Kubuntu|LinuxMint|Mint|Ubuntu|Xubuntu ]] ; then
        DARCH=$(dpkg --print-architecture)
    elif [[ -e /bin/rpm || -e /usr/bin/rpm ]] && [[ $DISTRIB_ID =~ CentOS|Fedora|Rhel|RHEL|openSUSE|Suse|SUSE ]] ; then
        DARCH=$(rpm --eval %_arch)
    elif [[ -e /usr/bin/file ]] ; then
        DARCH=$(/usr/bin/file /usr/bin/file | cut -d, -f2)
        DARCH=${DARCH## }
        DARCH=${DARCH/-64/_64}
    else
        DARCH=Unknown
    fi
    # Because Debian and derivatives use amd64 instead of x86_64...
    if [[ "$DARCH" == "amd64" ]] ; then
        DISTRIB_ARCH=x86_64
    else
        DISTRIB_ARCH=$(sed -re 's/IBM //' <<<$DARCH)
    fi

    #===============================================================================
    debug DISTRIB_SOURCE=$DISTRIB_SOURCE
    debug DISTRIB_ID=$DISTRIB_ID
    debug DISTRIB_RELEASE=$DISTRIB_RELEASE
    debug DISTRIB_CODENAME=$DISTRIB_CODENAME
    debug DISTRIB_DESCRIPTION=$DISTRIB_DESCRIPTION
    debug DISTRIB_ARCH=$DISTRIB_ARCH
    debug DARCH=$DARCH
    echo $DISTRIB_ID,$DISTRIB_RELEASE,$DISTRIB_CODENAME,$DISTRIB_DESCRIPTION,$DISTRIB_ARCH,$DARCH
}

#===============================================================================
list_distro() {
    local ID=$1 ARCH=$2 RELEASE=$3 CODENAME=$4
    echo "Linux Distro: $ID${ARCH:+:$ARCH}-$RELEASE ${CODENAME:+($CODENAME)}"
    exit 0
}

#===============================================================================
setup_meta() {
    local CLASS=$1
    debug COURSE=$CLASS

    local ATTR
    local ATTRS="ATTR in ARCH CPUFLAGS CPUS PREFER_CPUS RAM DISK BOOT CONFIGS \
            INTERNET CARDREADER NATIVELINUX VMOKAY DISTROS DISTRO_BL DISTRO_ARCH"

    for ATTR in $ATTRS ; do
        eval "case \$$ATTR in
            [0-9]*) [[ \${$ATTR[$CLASS]} -gt \$$ATTR ]] && $ATTR=\"\${$ATTR[$CLASS]}\" ;;
            [a-zA-Z]*) [[ \${$ATTR[$CLASS]} > \$$ATTR ]] && $ATTR=\"\${$ATTR[$CLASS]}\" ;;
            *) $ATTR=\"\${$ATTR[$CLASS]}\" ;;
        esac
        debug $ATTR=\$$ATTR"
    done
}

#===============================================================================
# See whether sudo is available
check_sudo() {
    local DID=$1 DREL=$2
    if ! sudo -V >/dev/null 2>&1 ; then
        [[ $USER == root ]] || warn "sudo isn't installed, so you will have to run these commands as root instead"
        # Provide sudo wrapper for try_packages
        sudo() {
             if [[ $USER == root ]] ; then
                 $*
             else
                 highlight "Please enter root password to run the following as root"
                 highlight $* >&2
                 su -c "$*" root
             fi
        }
        INSTALL=y NO_CHECK=y NO_PASS=y NO_WARN=y try_packages $DID $DREL COURSE sudo
        unset sudo
        if [[ -f /etc/sudoers ]] ; then
            # Add $USER to sudoers
            highlight "Please enter root password to add yourself to sudoers"
            su -c "sed -ie 's/^root\(.*ALL$\)/root\1\n$USER\1/' /etc/sudoers" root
        fi
        highlight "From now on you will be asked for your user password"
    fi
}

#===============================================================================
check_repos() {
    local ID=$1 RELEASE=$2 CODENAME=$3 ARCH=$4
    debug "check_repos $ID-$RELEASE ($CODENAME) $ARCH"
    verbose "Checking installed repos"

    #-------------------------------------------------------------------------------
    if [[ $ID == Debian ]] ; then
        debug "Check repos for Debian"
        local CHANGES REPOS="contrib non-free"
        local LISTFILE=/etc/apt/sources.list.d/debian.list
        for SECTION in $REPOS ; do
            grep "deb .*debian.* main" /etc/apt/sources.list $([[ -f $LISTFILE ]] && echo $LISTFILE) \
                    | grep -v '#' | grep -v $SECTION | sed -e 's/main.*/'$SECTION'/' \
                    | while read LINE ; do
                [[ -n $LINE ]] || continue
                debug "Is '$LINE' enabled?"
                [[ -f $LISTFILE ]] || sudo touch $LISTFILE
                if ! grep -q "$LINE" $LISTFILE ; then
                    echo "$LINE" | sudo tee -a $LISTFILE
                    verbose "Adding '$LINE' to $LISTFILE"
                    CHANGES=y
                fi
            done
        done
        if [[ -n "$CHANGES" ]] ; then
            notice "Enabling $REPOS in sources.list... updating"
            sudo apt-get -qq update
        fi

    #-------------------------------------------------------------------------------
    elif [[ $ID =~ CentOS|RHEL ]] ; then
        debug "Check repos for CentOS|RHEL"
        if rpm -q epel-release >/dev/null ; then
            verbose "epel is already installed"
        else
            case "$RELEASE" in
                6*) [[ $ARCH != i386 && $ARCH != x86_64 ]] \
			|| EPEL="$EPELURL/6/i386/epel-release-6-8.noarch.rpm" ;;
                7*) [[ $ARCH != x86_64 ]] \
			|| EPEL="$EPELURL/7/x86_64/e/epel-release-7-5.noarch.rpm" ;;
            esac
            if [[ -n $EPEL ]] ; then
                notice "Installing epel in ${ID}..."
                sudo rpm -Uvh $EPEL
            fi
        fi

    #-------------------------------------------------------------------------------
    elif [[ $ID == Ubuntu ]] ; then
        debug "Check repos for Ubuntu"
        local CHANGES REPOS="universe multiverse"
        for SECTION in $REPOS ; do
            local DEB URL DIST SECTIONS
            while read DEB URL DIST SECTIONS ; do
                [[ $URL =~ http && $DIST =~ $CODENAME && $SECTIONS =~ main ]] || continue
                [[ $URL =~ archive.canonical.com || $URL =~ extras.ubuntu.com ]] && continue
                debug "$DISTRO: is $SECTION enabled for $URL $DIST $SECTIONS"
                if ! egrep -q "^$DEB $URL $DIST .*$SECTION" /etc/apt/sources.list ; then
                    verbose "Running: sudo add-apt-repository '$DEB $URL $DIST $SECTION'"
                    sudo add-apt-repository "$DEB $URL $DIST $SECTION"
                    CHANGES=y
                fi
            done </etc/apt/sources.list
        done
        if [[ -n "$CHANGES" ]] ; then
            notice "Enabling $REPOS in sources.list... updating"
            sudo apt-get -qq update
        fi
    fi
}

#===============================================================================
deb_check() {
    verbose "Check dpkg is in a good state"
    while [[ $((dpkg -C 2>/dev/null || sudo dpkg -C) | wc -l) -gt 0 ]] ; do
        local PKG FILE
        if sudo dpkg -C | grep -q "missing the md5sums" ; then
            for PKG in $(sudo dpkg -C | awk '/^ / {print $1}') ; do
                [[ ! -f /var/lib/dpkg/info/${PKG}.md5sums ]] || continue
                if warn_wait "The md5sums for $PKG need updating. Can I fix it?" ; then
                    for FILE in $(sudo dpkg -L $PKG | grep -v "^/etc" | sort) ; do
                        [[ -f $FILE && ! -L $FILE ]] && md5sum $FILE
                    done | sed 's|/||' | sudo tee /var/lib/dpkg/info/${PKG}.md5sums >/dev/null
                fi
            done
            verbose "Updated all missing MD5SUM files"
        else
            if warn_wait "dpkg reports some issues with the package system. I can't continue without these being fixed.\n    Is it okay if I try a \"dpkg --configure -a\"?" ; then
                sudo dpkg --configure -a
                verbose "Attempted to configure all unconfigured packages"
            fi
        fi
    done
}

#===============================================================================
BUILDDEPSTR=build-dep_
no_build_dep() {
    sed 's/ /\n/g' <<< $* | grep -v $BUILDDEPSTR
}

#===============================================================================
only_build_dep() {
    sed 's/ /\n/g' <<< $* | grep $BUILDDEPSTR | sed "s/$BUILDDEPSTR//g"
}

#===============================================================================
# Install packages with apt-get
debinstall() {
    local PKGLIST=$(no_build_dep $*)
    local BDLIST=$(only_build_dep $*)
    [[ -z "$PKGLIST" && -z "$BDLIST" ]] && return
    debug "debinstall $*"

    deb_check

    local APTGET="apt-get --no-install-recommends"
    # Check for packages which can't be found
    if [[ -n "$PKGLIST" ]] ; then
        local ERRPKG=$($APTGET --dry-run install $PKGLIST 2>&1 \
            | awk '/^E: Unable/ {print $6}; /^E: Package/ {print $3}' | grep -v -- '-f' | sed -e "s/'//g")
        if [[ -n "$ERRPKG" ]] ; then
            warn "Can't find package(s) in index: $ERRPKG"
            echo "Looks like you may need to run 'sudo apt-get update' and try this again"
            MISSING_PACKAGES=y
            return
        fi
    fi

    # Find new packages which need installing
    local NEWPKG=$(list_sort $(
        [[ -z "$PKGLIST" ]] || $APTGET --dry-run install $PKGLIST | awk '/^Inst / {print $2}';
        [[ -z "$BDLIST" ]] || $APTGET --dry-run build-dep $BDLIST | awk '/^Inst / {print $2}'))
    [[ -n "$SIMULATE_FAILURE" ]] && NEWPKG=$PKGLIST
    if [[ -z "$NEWPKG" ]] ; then
        pass "All required packages are already installed"
    else
        warn "Missing packages:" $NEWPKG
        if [[ -z "$INSTALL" ]] ; then
            highlight "You can install missing packages by running '$0 --install $COURSE' or by:"
            dothis "  sudo $APTGET install" $NEWPKG
            MISSING_PACKAGES=y
        else
            ask "About to install:" $NEWPKG "\nIs that okay? [y/N]"
            read CONFIRM
            case $CONFIRM in
            y*|Y*|1) sudo $APTGET install $NEWPKG
                if [[ -z $NO_CHECK ]] ; then
                    FAILPKG=$(sudo $APTGET --dry-run install $PKGLIST | awk '/^Conf / {print $2}')
                    if [[ -n "$FAILPKG" ]] ; then
                        warn "Some packages didn't install: $FAILPKG"
                        WARNINGS=y
                    else
                        pass "All required packages are now installed"
                    fi
                fi ;;
            esac
        fi
    fi
}

#===============================================================================
# Install packages with yum or zypper
rpminstall() {
    local TOOL=$1; shift
    local PKGLIST=$*
    [[ -z "$PKGLIST" ]] && return
    debug "rpminstall TOOL=$TOOL $PKGLIST"

    local NEWPKG=$(list_sort $(rpm -q $PKGLIST | awk '/is not installed$/ {print $2}'))
    [[ -n "$SIMULATE_FAILURE" ]] && NEWPKG=$PKGLIST
    if [[ -z "$NEWPKG" ]] ; then
        pass "All required packages are already installed"
    else
        notice "Need to install:" $NEWPKG
        if [[ -z "$INSTALL" ]] ; then
            highlight "You can install missing packages by running '$0 --install $COURSE' or by:"
            dothis "  sudo $TOOL install" $NEWPKG
            MISSING_PACKAGES=y
        else
            sudo $TOOL install $NEWPKG
            if [[ -z $NO_CHECK ]] ; then
                FAILPKG=$(rpm -q $PKGLIST | awk '/is not installed$/ {print $2}')
                if [[ -n "$FAILPKG" ]] ; then
                    warn "Some packages didn't install: $FAILPKG"
                    WARNINGS=y
                else
                    pass "All required packages are now installed"
                fi
            fi
        fi
    fi
}

#===============================================================================
# Run extra code based on distro, release, and course
run_extra_code() {
    local DID=$1 DREL=$2 COURSE=$3
    local CODE
    for KEY in $DID-${DREL}_$COURSE ${DID}_$COURSE $COURSE $DID-$DREL $DID ; do
        CODE=${RUNCODE[${KEY:-no_code_key}]}
        if [[ -n $CODE ]] ; then
            debug "run exra setup code for $KEY -> eval $CODE"
            eval "$CODE $COURSE"
            return 0
        fi
    done
}

#===============================================================================
# TEST: Are the correct packages installed?
try_packages() {
    local ID=$1; shift
    local RELEASE=$1; shift
    local COURSE=$1; shift
    local PKGLIST=$(list_sort $*)
    debug "try_packages: ID=$ID PKGLIST=$PKGLIST"

    #-------------------------------------------------------------------------------
    if [[ $ID =~ Debian|Kubuntu|LinuxMint|Mint|Ubuntu|Xubuntu ]] ; then
        debinstall $PKGLIST
        for_each_course "run_extra_code $ID $RELEASE" $COURSE

    #-------------------------------------------------------------------------------
    elif [[ $ID =~ CentOS|Fedora|RHEL ]] ; then
        PKGMGR=yum
        [[ -e /bin/dnf || -e /usr/bin/dnf ]] && PKGMGR=dnf
        rpminstall $PKGMGR $PKGLIST
        for_each_course "run_extra_code $ID $RELEASE" $COURSE

    #-------------------------------------------------------------------------------
    elif [[ $ID =~ openSUSE|Suse|SUSE ]] ; then
        rpminstall zypper $PKGLIST
        for_each_course "run_extra_code $ID $RELEASE" $COURSE

    #-------------------------------------------------------------------------------
    elif [[ $ID == "Arch" ]]  ; then
    # TODO: Add support for pacman here to provide similar functionality as apt-get code above
        warn "Currently there is no package support for Arch Linux"
        for_each_course "run_extra_code $ID $RELEASE" $COURSE

    #-------------------------------------------------------------------------------
    elif [[ $ID == "Gentoo" ]]  ; then
    # TODO: Add support for emerge here to provide similar functionality as apt-get code above
        warn "Currently there is no package support for Gentoo"
        for_each_course "run_extra_code $ID $RELEASE" $COURSE
    fi
}

#===============================================================================
# TEST: Right cpu architecture?
check_cpu() {
    local ARCH=$1
    if [[ -n "$ARCH" ]] ; then
        verbose "check_cpu: ARCH=$ARCH"
        local CPU_ARCH=$(uname -m)
        if [[ -n "$ARCH" && $CPU_ARCH != "$ARCH" || -n "$SIMULATE_FAILURE" ]] ; then
            fail "CPU architecture is $CPU_ARCH (Must be $ARCH)"
            FAILED=y
        else
            pass "CPU architecture is $CPU_ARCH"
        fi
    fi
}

#===============================================================================
# TEST: Right cpu flags?
check_cpu_flags() {
    local CPUFLAGS=$1 LOCAL NOTFOUND
    if [[ -n "$CPUFLAGS" ]] ; then
        verbose "check_cpu_flags: CPUFLAGS=$CPUFLAGS"
        for FLAG in $CPUFLAGS ; do
            grep -qc " $FLAG " /proc/cpuinfo || NOTFOUND+=" $FLAG"
        done
        if [[ -n "$NOTFOUND" ]] ; then
            fail "CPU doesn't have the following capabilities:$NOTFOUND"
            FAILED=y
        else
            pass "CPU has all needed capabilities: $CPUFLAGS"
        fi
    fi
}

#===============================================================================
get_number_of_cpus() {
    local NUM_CPU=$(lscpu | awk '/^CPU\(s\):/ {print $2}')
    [[ -n $NUM_CPU ]] || NUM_CPU=$(grep -c ^processor /proc/cpuinfo)
    echo ${NUM_CPU:-0}
}

#===============================================================================
# TEST: Enough CPUS?
check_number_of_cpus() {
    local CPUS=$1
    verbose "check_number_of_cpus: CPUS=$CPUS"
    local NUM_CPU=$(get_number_of_cpus)
    if [[ -z $NUM_CPU || $NUM_CPU == 0 ]] ; then
        bug "I didn't find the number of cpus you have" "lscpu | awk '/^CPU\\(s\\):/ {print \$2}'"
    elif [[ $NUM_CPU -lt $CPUS || -n "$SIMULATE_FAILURE" ]] ; then
        fail "Single core CPU: not powerful enough (require at least $CPUS, though $PREFER_CPUS is preferred)"
        FAILED=y
        NOTENOUGH=y
    elif [[ $NUM_CPU -lt $PREFER_CPUS ]] ; then
        pass "$NUM_CPU core CPU (good enough but $PREFER_CPUS is preferred)"
    else
        pass "$NUM_CPU core CPU"
    fi
}

#===============================================================================
get_bogomips() {
	local NUM_CPU=$(get_number_of_cpus)
        local BMIPS=$(lscpu | awk '/^BogoMIPS:/ {print $2}' | sed -re 's/\.[0-9]{2}$//')
        [[ -n $BMIPS ]] || BMIPS=$(awk '/^bogomips/ {mips+=$3} END {print int(mips + 0.5)}' /proc/cpuinfo)
	echo $(( ${NUM_CPU:-0} * ${BMIPS:-0} ))
}

#===============================================================================
# TEST: Enough BogoMIPS?
check_bogomips() {
    local BOGOMIPS=$1
    if [[ -n "$BOGOMIPS" ]] ; then
        verbose "check_bogomips: BOGOMIPS=$BOGOMIPS"
	local BMIPS=$(get_bogomips)
	[[ -z $BMIPS ]]
        if [[ -z $BMIPS || $BMIPS == 0 ]] ; then
            bug "I didn't find the number of BogoMIPS your CPU(s) have" \
                "awk '/^bogomips/ {mips+=\$3} END {print int(mips + 0.5)}' /proc/cpuinfo"
        elif [[ $BMIPS -lt $BOGOMIPS || -n "$SIMULATE_FAILURE" ]] ; then
            fail "Your CPU isn't powerful enough (must be at least $BOGOMIPS BogoMIPS cumulatively)"
            FAILED=y
        else
            if [[ -n "$NOTENOUGH" ]] ; then
                notice "Despite not having enough CPUs, you may still have enough speed (currently at $BMIPS BogoMIPS)"
            else
                pass "Your CPU appears powerful enough (currently at $BMIPS BogoMIPS cumulatively)"
            fi
        fi
    fi
}

#===============================================================================
# TEST: Enough RAM?
check_ram() {
    local RAM=$1
    verbose "check_ram: RAM=$RAM"
    local RAM_GBYTES=$(awk '/^MemTotal/ {print int($2/1024/1024+0.7)}' /proc/meminfo)
    if [[ -z $RAM_GBYTES ]] ; then
        bug "I didn't how much free RAM you have" \
            "awk '/^MemTotal/ {print int(\$2/1024/1024+0.7)}' /proc/meminfo"
    elif [[ $RAM_GBYTES -lt $RAM || -n "$SIMULATE_FAILURE" ]] ; then
        fail "Only $RAM_GBYTES GiB RAM (require at least $RAM GiB)"
        FAILED=y
    else
        pass "$RAM_GBYTES GiB RAM"
    fi
}

#===============================================================================
# df wrapper
get_df() {
    local DIR=$1
    local UNIT=$2
    [[ -n $DIR ]] || return

    local KBYTES=$(df -k $DIR | awk '{if (NR == 2) print int($4)}')
    case $UNIT in
        MiB) echo $(( ($KBYTES + 512) / 1024 ));;
        GiB) echo $(( ($KBYTES + 512*1024) / 1024 / 1024));;
    esac
}

#===============================================================================
# find space on another attached drive
find_alternate_disk() {
    local MINSIZE=$1
    local UNIT=$2
    local STRING=$3
    local NOTFOUND=1
    local LINE FS TOTAL USED AVAIL USE MP 
    debug "Looking for disk bigger than $MINSIZE $UNIT"

    df | awk '{if (NR > 1) print}' \
    | while read -r FS TOTAL USED AVAIL USE MP; do
        debug "Check $MP $AVAIL"
        [[ -n $MP ]] || continue
        AVAIL=$(get_df "$MP" $UNIT)
        if [[ $AVAIL -ge $MINSIZE ]] ; then
           echo "$STRING$MP has $AVAIL $UNIT free"
           NOTFOUND=0
        fi
    done
    return $NOTFOUND
}

#===============================================================================
# TEST: Enough free disk space in $BUILDHOME? (defaults to $HOME)
check_free_disk() {
    local DISK=$1 BUILDHOME=${2:-$HOME}
    [[ -n $BUILDHOME ]] || BUILDHOME=$(getent passwd "$USER" | cut -d: -f6)
    [[ -n $BUILDHOME ]] || return
    verbose "check_free_disk: DISK=$DISK BUILDHOME=$BUILDHOME"
    local DISK_GBYTES=$(get_df "$BUILDHOME" GiB)
    if [[ -z $DISK_GBYTES ]] ; then
        bug "I didn't find how much disk space is free in $BUILDHOME" \
            "df --output=avail $BUILDHOME | awk '{if (NR == 2) print int(($4+524288)/1048576)}'"
    elif [[ ${DISK_GBYTES:=1} -lt $DISK || -n "$SIMULATE_FAILURE" ]] ; then
        local ALT=$(find_alternate_disk $DISK GiB "BUILDHOME=")
        if [[ -n $ALT ]] ; then
            warn "$BUILDHOME only has $DISK_GBYTES GiB free (need at least $DISK GiB)"
            pass "However, $ALT"
        else
            fail "only $DISK_GBYTES GiB free in $BUILDHOME (need at least $DISK GiB) Set BUILDHOME=/path/to/disk to override \$HOME"
            FAILED=y
        fi
    else
        pass "$DISK_GBYTES GiB free disk space in $HOME"
    fi
}

#===============================================================================
# TEST: Enough free disk space in /boot?
check_free_boot_disk() {
    local BOOT=$1 BOOTDIR=${2:-/boot}
    [[ -n $BOOTDIR ]] || continue
    verbose "check_free_boot_disk: BOOT=$BOOT BOOTDIR=$BOOTDIR"
    local BOOT_MBYTES=$(get_df "$BOOTDIR" MiB)
    if [[ -z $BOOT_MBYTES ]] ; then
        bug "I didn't find how much disk space is free in $BOOTDIR" \
            "awk '/^MemTotal/ {print int(\$2/1024/1024+0.7)}' /proc/meminfo"
    elif [[ ${BOOT_MBYTES:=1} -le $BOOT || -n "$SIMULATE_FAILURE" ]] ; then
        fail "only $BOOT_MBYTES MiB free in /boot (need at least $BOOT MiB)"
        FAILED=y
    else
        pass "$BOOT_MBYTES MiB free disk space in /boot"
    fi
}

#===============================================================================
# TEST: Right Linux distribution architecture?
check_distro_arch() {
    local ARCH=$1 DISTRO_ARCH=$2
    if [[ -n "$DISTRO_ARCH" ]] ; then
        verbose "check_distro_arch: DISTRO_ARCH=$DISTRO_ARCH ARCH=$ARCH"
        if [[ -z $ARCH || -z $DISTRO_ARCH ]] ; then
            bug "Wasn't able to determine Linux distribution architecture" \
                "$0 --gather-info"
        elif [[ "$ARCH" != "$DISTRO_ARCH" || -n "$SIMULATE_FAILURE" ]] ; then
            fail "The distribution architecture must be $DISTRO_ARCH"
            FAILED=y
        else
            pass "Linux distribution architecture is $DISTRO_ARCH"
        fi
    fi
}

#===============================================================================
# Look for the current distro in a list of distros
found_distro() {
    local ID=$1 DARCH=$2 RELEASE=$3 DISTROS=$4
    local DISTRO
    verbose "found_distro: ID=$ID DARCH=$DARCH RELEASE=$RELEASE DISTROS=$DISTROS"

    for DISTRO in $DISTROS ; do
        [[ $DISTRO = *+ ]] && G=y && DISTRO=${DISTRO%\+} || unset G
        [[ $DISTRO = *-* ]] && R=${DISTRO#*-} && DISTRO=${DISTRO%-*} || R='*'
        [[ $DISTRO = *:* ]] && A=${DISTRO#*:} && DISTRO=${DISTRO%:*} || A='*'
        debug "Are we running DISTRO=$DISTRO ARCH=$A REL=$R or-newer=$G"
        [[ -n "$G" && "$R" != "*" ]] && version_greater_equal $RELEASE $R && R='*'
        if [[ $ID = $DISTRO && $DARCH = $A && $RELEASE = $R ]] ; then
            debug "Yes. We are running DISTRO=$DISTRO ARCH=$A REL=$R or-newer=$G"
            return 0
        fi
        debug "No we aren't..."
    done
    return 1
}

#===============================================================================
# TEST: Blacklisted Linux distribution?
check_distro_bl() {
    local ID=$1 DARCH=$2 RELEASE=$3 CODENAME=$4 DISTRO_BL=$5
    verbose "check_distros_bl: ID=$ID DARCH=$DARCH RELEASE=$RELEASE DISTRO_BL=$DISTRO_BL"
    if [[ -n "$SIMULATE_FAILURE" ]] ; then
        DISTRO_BL=$ID-$RELEASE
    fi
    if [[ -z $ID || -z $DARCH ]] ; then
        bug "Wasn't able to determine Linux distribution" \
            "$0 --gather-info"
    elif [[ -n "$DISTRO_BL" ]] ; then
        if found_distro $ID $DARCH $RELEASE "$DISTRO_BL" ; then
            fail "This Linux distribution can't be used for this course: $ID:$DARCH-$RELEASE ${CODENAME:+($CODENAME)}"
            FAILED=y
            [[ -n "$SIMULATE_FAILURE" ]] || exit 1
        fi
    fi
}

#===============================================================================
# TEST: Right Linux distribution?
check_distro() {
    local ID=$1 DARCH=$2 RELEASE=$3 CODENAME=$4 DESCRIPTION=$5 DISTROS=$6
    verbose "check_distros: ID=$ID DARCH=$DARCH RELEASE=$RELEASE DISTROS=$DISTROS"
    if [[ -n "$SIMULATE_FAILURE" ]] ; then
        DISTROS=NotThisDistro-0
    fi
    if [[ -z "$DISTROS" ]] ; then
        notice "No required Linux distribution (Currently running $DESCRIPTION)"
    elif [[ -z $ID || -z $DARCH ]] ; then
        bug "Wasn't able to determine Linux distribution" \
            "$0 --gather-info"
    else
        if found_distro $ID $DARCH $RELEASE "$DISTROS" ; then
            pass "Linux distribution is $ID:$DARCH-$RELEASE ${CODENAME:+($CODENAME)}"
        else
            fail "The distribution must be: $DISTROS"
            FAILED=y
        fi
    fi
}

#===============================================================================
# TEST: Is the kernel configured properly?
check_kernel_config() {
    local CONFIGS=$1
    if [[ -n "$CONFIGS" ]] ; then
        verbose "check_kernel_config: CONFIGS=$CONFIGS"
        local MISSINGCONFIG
        local KERNELCONFIG=${KERNELCONFIG:-/boot/config-$(uname -r)}
        if [[ ! -f $KERNELCONFIG ]] ; then
            warn "Wasn't able to find kernel config. You can specify it by settting KERNELCONFIG=<filename>"
            return 1
        fi
        for CONFIG in $CONFIGS ; do
            grep -qc CONFIG_$CONFIG $KERNELCONFIG || MISSINGCONFIG+=" $CONFIG"
        done
        if [[ -z "$MISSINGCONFIG" ]] ; then
            pass "The Current kernel is properly configured: $CONFIGS"
        else
            fail "Current kernel is missing these options:$MISSINGCONFIG"
            FAILED=y
        fi
    fi
}

#===============================================================================
# TEST: Is there Internet?
check_internet() {
    local INTERNET=$1
    local AVAILABLE=$2
    local INTERNET=$1 PING_HOST=${2:-8.8.8.8}

    if [[ -n "$INTERNET" ]] ; then
        verbose "check_internet: INTERNET=$INTERNET AVAILABLE=${AVAILABLE:-n}"
        if [[ -n $AVAILABLE ]] ; then
            pass "Internet is available (which is required for this course)"
        elif ping -q -c 1 $PING_HOST >/dev/null 2>&1 && [[ -z "$SIMULATE_FAILURE" ]] ; then
            verbose "check_internet with ping PING_HOST=$PING_HOST"
            pass "Internet is available (which is required for this course)"
        else
            fail "Internet doesn't appear to be available"
            FAILED=y
        fi
    else
        verbose "Not requiring Internet availability"
    fi
}

#===============================================================================
# We need this because lspci may not be installed
find_devices() {
    local DATA=$1
    local RETURN=$2
    [[ -n "$DATA" ]] || return 1
    local DEV
    for DEV in /sys/bus/pci/devices/*; do
        local PCIID="`cat $DEV/vendor` `cat $DEV/device`"
        debug find_devices $DEV $PCIID
        if grep -q "$PCIID" <<<"$DATA" ; then
            local RET=`grep "$PCIID" <<<"$DATA" | cut -d' ' -f4-`
            eval $RETURN="'$RET'"
            return 0
        fi
    done
    return 1
}

#===============================================================================
# Info about PCI devices for finding SD/MMC reader
# Generated by perl script on machine which has /usr/share/misc/pci.ids
# pcigrep 'MMC|MS-?PRO|SD|xD' '3PCIO|9060SD|ASDE|Broadcast|CXD|DASD|DeckLink|ESD|HSD|Frame|G200|ISDN|Kona|Magic|MSDDC|MVC101|Napatech|PSDMS|PXD1000|Quadro|SDC|SDF|SDK|SDM|SDR|SDRAM|SDS|SDT|SSD|TXD|Video|VisionSD|Xena'
SDDEV="
0x1022 0x7806 # Advanced Micro Devices, Inc. [AMD] - FCH SD Flash Controller
0x1022 0x7813 # Advanced Micro Devices, Inc. [AMD] - FCH SD Flash Controller
0x1022 0x7906 # Advanced Micro Devices, Inc. [AMD] - FCH SD Flash Controller
0x104c 0x803b # Texas Instruments - 5-in-1 Multimedia Card Reader (SD/MMC/MS/MS PRO/xD)
0x104c 0x803c # Texas Instruments - PCIxx12 SDA Standard Compliant SD Host Controller
0x104c 0xac4b # Texas Instruments - PCI7610 SD/MMC controller
0x104c 0xac8f # Texas Instruments - PCI7420/7620 SD/MS-Pro Controller
0x10b9 0x5473 # ULi Electronics Inc. - M5473 SD-MMC Controller
0x1106 0x95d0 # VIA Technologies, Inc. - SDIO Host Controller
0x1179 0x0803 # Toshiba America Info Systems - TC6371AF SD Host Controller
0x1179 0x0805 # Toshiba America Info Systems - SD TypA Controller
0x1180 0x0575 # Ricoh Co Ltd - R5C575 SD Bus Host Adapter
0x1180 0x0576 # Ricoh Co Ltd - R5C576 SD Bus Host Adapter
0x1180 0x0822 # Ricoh Co Ltd - R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter
0x1180 0x0841 # Ricoh Co Ltd - R5C841 CardBus/SD/SDIO/MMC/MS/MSPro/xD/IEEE1394
0x1180 0x0843 # Ricoh Co Ltd - R5C843 MMC Host Controller
0x1180 0x0852 # Ricoh Co Ltd - xD-Picture Card Controller
0x1180 0xe822 # Ricoh Co Ltd - MMC/SD Host Controller
0x1180 0xe823 # Ricoh Co Ltd - PCIe SDXC/MMC Host Controller
0x1180 0xe852 # Ricoh Co Ltd - PCIe xD-Picture Card Controller
0x1217 0x7120 # O2 Micro, Inc. - Integrated MMC/SD Controller
0x1217 0x7130 # O2 Micro, Inc. - Integrated MS/xD Controller
0x1217 0x8120 # O2 Micro, Inc. - Integrated MMC/SD Controller
0x1217 0x8130 # O2 Micro, Inc. - Integrated MS/MSPRO/xD Controller
0x1217 0x8320 # O2 Micro, Inc. - OZ600 MMC/SD Controller
0x1217 0x8321 # O2 Micro, Inc. - Integrated MMC/SD controller
0x1217 0x8330 # O2 Micro, Inc. - OZ600 MS/xD Controller
0x1217 0x8520 # O2 Micro, Inc. - SD/MMC Card Reader Controller
0x14e4 0x16bc # Broadcom Corporation - BCM57765/57785 SDXC/MMC Card Reader
0x14e4 0x16bf # Broadcom Corporation - BCM57765/57785 xD-Picture Card Reader
0x1524 0x0551 # ENE Technology Inc - SD/MMC Card Reader Controller
0x1524 0x0750 # ENE Technology Inc - ENE PCI SmartMedia / xD Card Reader Controller
0x1524 0x0751 # ENE Technology Inc - ENE PCI Secure Digital / MMC Card Reader Controller
0x1679 0x3000 # Tokyo Electron Device Ltd. - SD Standard host controller [Ellen]
0x197b 0x2381 # JMicron Technology Corp. - Standard SD Host Controller
0x197b 0x2382 # JMicron Technology Corp. - SD/MMC Host Controller
0x197b 0x2384 # JMicron Technology Corp. - xD Host Controller
0x197b 0x2386 # JMicron Technology Corp. - Standard SD Host Controller
0x197b 0x2387 # JMicron Technology Corp. - SD/MMC Host Controller
0x197b 0x2389 # JMicron Technology Corp. - xD Host Controller
0x197b 0x2391 # JMicron Technology Corp. - Standard SD Host Controller
0x197b 0x2392 # JMicron Technology Corp. - SD/MMC Host Controller
0x197b 0x2394 # JMicron Technology Corp. - xD Host Controller
0x8086 0x0807 # Intel Corporation - Moorestown SD Host Ctrl 0
0x8086 0x0808 # Intel Corporation - Moorestown SD Host Ctrl 1
0x8086 0x0f14 # Intel Corporation - ValleyView SDIO Controller
0x8086 0x0f15 # Intel Corporation - ValleyView SDIO Controller
0x8086 0x0f16 # Intel Corporation - ValleyView SDIO Controller
0x8086 0x0f17 # Intel Corporation - ValleyView SDIO Controller
0x8086 0x811c # Intel Corporation - System Controller Hub (SCH Poulsbo) SDIO Controller #1
0x8086 0x811d # Intel Corporation - System Controller Hub (SCH Poulsbo) SDIO Controller #2
0x8086 0x811e # Intel Corporation - System Controller Hub (SCH Poulsbo) SDIO Controller #3
0x8086 0x8809 # Intel Corporation - Platform Controller Hub EG20T SDIO Controller #1
0x8086 0x880a # Intel Corporation - Platform Controller Hub EG20T SDIO Controller #2
0x8086 0x9c35 # Intel Corporation - Lynx Point-LP SDIO Controller
"

#===============================================================================
# TEST: Is there a card reader?
check_cardreader() {
    local CARDREADER=$1
    if [[ -n "$CARDREADER" ]] ; then
        verbose "check_cardreader: CARDREADER=$CARDREADER"
        local DEV CRFOUND
        for DEV in `cd /dev; echo mmcblk? sd?`; do
            [ -e "/dev/$DEV" ] || continue
            local META='ID_DRIVE_MEDIA_FLASH_SD=1|ID_USB_DRIVER=usb-storage|ID_VENDOR=Generic'
            if udevadm info --query=all --name $DEV | egrep -q $META ; then
                pass "Card Reader was found: /dev/$DEV"
                CRFOUND=1
            elif find_devices "$SDDEV" CRFOUND; then
                pass "Built-in Card Reader was found: $CRFOUND"
            fi
        done
        if [[ -z "$CRFOUND" ]] ; then
            warn "Card Reader wasn't found, and you require one for this course (Maybe it isn't plugged in?)"
            WARNINGS=y
        fi
    fi
}

#===============================================================================
# Info about PCI devices for determining if we are running in a VM
# Generated by perl script on machine which has /usr/share/misc/pci.ids
# ./pcigrep | grep -i Microsoft
# Detect Hyper-V (Azure and other MS hypervisors)
HYPERV="
0x1414 0x0001 # Microsoft Corporation - MN-120 (ADMtek Centaur-C based)
0x1414 0x0002 # Microsoft Corporation - MN-130 (ADMtek Centaur-P based)
0x1414 0x5353 # Microsoft Corporation - Hyper-V virtual VGA
0x1414 0x5801 # Microsoft Corporation - XMA Decoder (Xenon)
0x1414 0x5802 # Microsoft Corporation - SATA Controller - CdRom (Xenon)
0x1414 0x5803 # Microsoft Corporation - SATA Controller - Disk (Xenon)
0x1414 0x5804 # Microsoft Corporation - OHCI Controller 0 (Xenon)
0x1414 0x5805 # Microsoft Corporation - EHCI Controller 0 (Xenon)
0x1414 0x5806 # Microsoft Corporation - OHCI Controller 1 (Xenon)
0x1414 0x5807 # Microsoft Corporation - EHCI Controller 1 (Xenon)
0x1414 0x580a # Microsoft Corporation - Fast Ethernet Adapter (Xenon)
0x1414 0x580b # Microsoft Corporation - Secure Flash Controller (Xenon)
0x1414 0x580d # Microsoft Corporation - System Management Controller (Xenon)
0x1414 0x5811 # Microsoft Corporation - Xenos GPU (Xenon)
"
# ./pcigrep Virtio
KVM="
0x1af4 0x1000 # Red Hat, Inc - Virtio network device
0x1af4 0x1001 # Red Hat, Inc - Virtio block device
0x1af4 0x1002 # Red Hat, Inc - Virtio memory balloon
0x1af4 0x1003 # Red Hat, Inc - Virtio console
0x1af4 0x1004 # Red Hat, Inc - Virtio SCSI
0x1af4 0x1005 # Red Hat, Inc - Virtio RNG
0x1af4 0x1009 # Red Hat, Inc - Virtio filesystem
0x1af4 0x1110 # Red Hat, Inc - Virtio Inter-VM shared memory
"
# ./pcigrep QEMU
QEMU="
0x1013 0x1100 # Cirrus Logic - QEMU Virtual Machine
0x1022 0x1100 # Advanced Micro Devices, Inc. [AMD] - QEMU Virtual Machine
0x1033 0x1100 # NEC Corporation - QEMU Virtual Machine
0x106b 0x1100 # Apple Inc. - QEMU Virtual Machine
0x10ec 0x1100 # Realtek Semiconductor Co., Ltd. - QEMU Virtual Machine
0x10ec 0x1100 # Realtek Semiconductor Co., Ltd. - QEMU Virtual Machine
0x1106 0x1100 # VIA Technologies, Inc. - QEMU Virtual Machine
0x1af4 0x1100 # Red Hat, Inc - QEMU Virtual Machine
0x1b36 0x0001 # Red Hat, Inc. - QEMU PCI-PCI bridge
0x1b36 0x0002 # Red Hat, Inc. - QEMU PCI 16550A Adapter
0x1b36 0x1100 # Red Hat, Inc. - QEMU Virtual Machine
0x1b36 0x0003 # Red Hat, Inc. - QEMU PCI Dual-port 16550A Adapter
0x1b36 0x1100 # Red Hat, Inc. - QEMU Virtual Machine
0x1b36 0x0004 # Red Hat, Inc. - QEMU PCI Quad-port 16550A Adapter
0x1b36 0x1100 # Red Hat, Inc. - QEMU Virtual Machine
0x1b36 0x0005 # Red Hat, Inc. - QEMU PCI Test Device
0x1b36 0x1100 # Red Hat, Inc. - QEMU Virtual Machine
0x1b36 0x1100 # Red Hat, Inc. - QEMU Virtual Machine
0x8086 0x1100 # Intel Corporation - QEMU Virtual Machine
0x8086 0x1100 # Intel Corporation - QEMU Virtual Machine
0x8086 0x1100 # Intel Corporation - QEMU Virtual Machine
0x8086 0x1100 # Intel Corporation - Qemu virtual machine
0x8086 0x1100 # Intel Corporation - QEMU Virtual Machine
0x8086 0x1100 # Intel Corporation - QEMU Virtual Machine
0x8086 0x1100 # Intel Corporation - QEMU Virtual Machine
0x8086 0x1100 # Intel Corporation - QEMU Virtual Machine
0x8086 0x1100 # Intel Corporation - QEMU Virtual Machine
0x8086 0x1100 # Intel Corporation - QEMU Virtual Machine
0x8086 0x1100 # Intel Corporation - QEMU Virtual Machine
0x8086 0x1100 # Intel Corporation - QEMU Virtual Machine
0x8086 0x1100 # Intel Corporation - QEMU Virtual Machine
0x8086 0x1100 # Intel Corporation - QEMU Virtual Machine
0x8086 0x1100 # Intel Corporation - QEMU Virtual Machine
0x8086 0x1100 # Intel Corporation - QEMU Virtual Machine
0x8086 0x1100 # Intel Corporation - QEMU Virtual Machine
0x8086 0x1100 # Intel Corporation - QEMU Virtual Machine
0x8086 0x1100 # Intel Corporation - QEMU Virtual Machine
0x8086 0x1100 # Intel Corporation - QEMU Virtual Machine
0x8086 0x1100 # Intel Corporation - QEMU Virtual Machine
0x8086 0x1100 # Intel Corporation - QEMU Virtual Machine
0x8086 0x5845 # Intel Corporation - QEMU NVM Express Controller
0x8086 0x1100 # Intel Corporation - QEMU Virtual Machine
0x8086 0x1100 # Intel Corporation - Qemu virtual machine
0x8086 0x1100 # Intel Corporation - Qemu virtual machine
0x8086 0x1100 # Intel Corporation - QEMU Virtual Machine
0x8086 0x1100 # Intel Corporation - QEMU Virtual Machine
0x8086 0x1100 # Intel Corporation - Qemu virtual machine
"
# ./pcigrep | grep Parallels
PARALLELS="
0x1ab8 0x4000 # Parallels, Inc. - Virtual Machine Communication Interface
0x1ab8 0x4005 # Parallels, Inc. - Accelerated Virtual Video Adapter
0x1ab8 0x4006 # Parallels, Inc. - Memory Ballooning Controller
"
# ./pcigrep VirtualBox
VBOX="
0x80ee 0xbeef # InnoTek Systemberatung GmbH - VirtualBox Graphics Adapter
0x80ee 0xcafe # InnoTek Systemberatung GmbH - VirtualBox Guest Service
"
# ./pcigrep | grep -i VMware
VMWARE="
0x15ad 0x0405 # VMware - SVGA II Adapter
0x15ad 0x0710 # VMware - SVGA Adapter
0x15ad 0x0720 # VMware - VMXNET Ethernet Controller
0x15ad 0x0740 # VMware - Virtual Machine Communication Interface
0x15ad 0x0770 # VMware - USB2 EHCI Controller
0x15ad 0x0774 # VMware - USB1.1 UHCI Controller
0x15ad 0x0778 # VMware - USB3 xHCI Controller
0x15ad 0x0790 # VMware - PCI bridge
0x15ad 0x07a0 # VMware - PCI Express Root Port
0x15ad 0x07b0 # VMware - VMXNET3 Ethernet Controller
0x15ad 0x07c0 # VMware - PVSCSI SCSI Controller
0x15ad 0x07e0 # VMware - SATA AHCI controller
0x15ad 0x0801 # VMware - Virtual Machine Interface
0x15ad 0x0800 # VMware - Hypervisor ROM Interface
0x15ad 0x1977 # VMware - HD Audio Controller
0xfffe 0x0710 # VMWare Inc (temporary ID) - Virtual SVGA
"
# ./pcigrep | grep -i XenSource
XEN="
0x5853 0x0001 # XenSource, Inc. - Xen Platform Device
0x5853 0xc110 # XenSource, Inc. - Virtualized HID
0x5853 0xc147 # XenSource, Inc. - Virtualized Graphics Device
0xfffd 0x0101 # XenSource, Inc. - PCI Event Channel Controller
"

#===============================================================================
# TEST: Is this a VM?
check_for_vm() {
    local NATIVELINUX=$1 VMOKAY=$2
    verbose "check_for_vm: NATIVELINUX=$NATIVELINUX VMOKAY=$VMOKAY"
    shopt -s nocasematch
    if [[ -n "$NATIVELINUX" || $VMOKAY == n || $VMOKAY =~ 'discouraged' ]] ; then
        local ACTION INVM VMREASON
        if [[ $VMOKAY =~ 'discouraged' ]] ; then
            ACTION=warn
            VMREASON="which is $VMOKAY for this course"
        else
            ACTION=fail
            VMREASON="which is not possible for this course"
        fi
        local HV=$(lscpu | grep "^Hypervisor vendor:" | sed 's/^.*: *//')
        if [[ -n $HV ]] ; then
            $ACTION "You're using a virtual machine ($HV) $VMREASON"
        elif find_devices "$HYPERV" INVM ; then
            $ACTION "You're in Hyper-V (or Azure) $VMREASON (Found: $INVM)"
        elif find_devices "$KVM" INVM ; then
            $ACTION "You're in KVM $VMREASON (Found: $INVM)"
        elif find_devices "$QEMU" INVM ; then
            $ACTION "You're in QEMU $VMREASON (Found: $INVM)"
        elif find_devices "$PARALLELS" INVM ; then
            $ACTION "You're in Parallels $VMREASON (Found: $INVM)"
        elif find_devices "$VBOX" INVM ; then
            $ACTION "You're in VirtualBox $VMREASON (Found: $INVM)"
        elif find_devices "$VMWARE" INVM ; then
            $ACTION "You're in VMWare $VMREASON (Found: $INVM)"
        elif find_devices "$XEN" INVM ; then
            $ACTION "You're in Xen $VMREASON (Found: $INVM)"
        fi
        if [[ -n "$INVM" ]] ; then
            [[ $ACTION == warn ]] && WARNINGS=y || FAILED=y
        else
            if [[ $NATIVELINUX =~ 'recommended' || $NATIVELINUX =~ 'Required' ]] ; then
                NLREASON=" which is $NATIVELINUX for this course"
            fi
            pass "You are running Linux natively$NLREASON"
        fi
    fi
}

#===============================================================================
get_cm_var(){
    local CLASS=$1
    local KEY=$2
    get_cm_file $CLASS/.ready-for.conf | awk -F= '/'$KEY'=/ {print $2}' | sed -e 's/^"\(.*\)"$/\1/'
}

#===============================================================================
# Get File from course material site
get_cm_file() {
    local CLASS=$1
    local FILE=$2
    local CMDIR=$3
    debug get_cm_file CLASS=$CLASS FILE=$FILE CMDIR=$CMDIR

    local URL=$LFCM/$CLASS${FILE:+/$FILE}
    local USERNAME=LFtraining PASSWORD=Penguin2014

    local OLDDIR=$PWD; cd $CMDIR
    if which wget >/dev/null ; then
        debug "wget $URL"
        local OPTS="--quiet -O -"
        [[ -z $FILE ]] || OPTS="--continue --progress=bar"
        wget $OPTS --user=$USERNAME --password=$PASSWORD --timeout=10 $URL
    elif which curl >/dev/null ; then
        debug "curl $URL"
        local OPTS="-s"
        [[ -z $FILE ]] || OPTS="-# -O"
        [[ -f $FILE ]] && tar tf $FILE >/dev/null 2>&1 || rm -f $FILE
        [[ -f $FILE ]] || curl --user $USERNAME:$PASSWORD --connect-timeout 10 $URL $OPTS
    else
        warn "No download tool found." >&2
        return 1
    fi
    cd $OLDDIR
    return 0
}

#===============================================================================
# Get Course Materials
get_course_materials() {
    local COURSE=$1
    local TODIR=${CMDIR:-$HOME/LFT}

    verbose "Get course materials for $COURSE"

    # Find newest SOLUTIONS file
    local FILE=$(get_cm_file $COURSE \
        | awk -F\" '/SOLUTIONS/ {print $8}' \
        | sed -Ee 's/^(.*V)([0-9.]+)(_.*)$/\2.0.0 \1\2\3/' \
        | sort -t. -n -k1,1 -k2,2 -k3,3 \
        | awk 'END {print $2}')
    if [[ -z $FILE ]] ; then
        FILE=$(get_cm_file $COURSE \
        | awk -F\" '/SOLUTIONS/ {print $8}' \
        | sort | tail -1)
    fi
    debug "Course Materials: $FILE"

    [[ -n $FILE ]] || return 0
    verbose "Course Materials: $FILE"
    [[ -d $TODIR ]] || mkdir -p $TODIR
    if [[ -f $TODIR/$FILE ]] ; then
        if ! tar tf $TODIR/$FILE >/dev/null 2>&1 ; then
            warn_wait "Partial download of $TODIR/$FILE found. Continue?" || return
        else
            highlight "$FILE can be found in $TODIR"
            return 0
        fi
    else
        warn_wait "Download course material? ($FILE)" || return
    fi
    highlight "Downloading $FILE to $TODIR"
    get_cm_file $COURSE $FILE $TODIR
}

#===============================================================================
#===============================================================================
if [[ -n $DETECT_VM ]] ; then
    check_for_vm 0 1
    exit 0
fi

#===============================================================================
[[ -n $ALL_COURSES ]] && COURSE=$(echo $(list_sort ${!DESCRIPTION[*]}))
[[ -n $JSON ]] && list_json
[[ -n $LIST_COURSES ]] && list_courses
[[ -n $TRY_ALL_COURSES ]] && try_all_courses

#===============================================================================
ORIG_COURSE=$COURSE
COURSE=$(for_each_course find_course $COURSE)
debug COURSE=$COURSE
if [[ -n $LIST_REQS ]] ; then
    for_each_course list_requirements $COURSE
    exit 0
fi

#===============================================================================
#guess_distro $DISTRO
IFS=',' read -r ID RELEASE CODENAME DESCRIPTION ARCH DARCH <<< $(guess_distro $DISTRO)
[[ -n $LIST_DISTRO ]] && list_distro "$ID" "$ARCH" "$RELEASE" "$CODENAME"
check_root

#===============================================================================
[[ -n $COURSE ]] || usage
debug "CLASSES: $COURSE"
for_each_course setup_meta $COURSE
for_each_course check_course $COURSE

#===============================================================================
# Check all the things
if [[ -z "$INSTALL" ]] ; then
    check_cpu $ARCH
    check_cpu_flags $CPUFLAGS
    check_number_of_cpus $CPUS
    check_bogomips $BOGOMIPS
    check_ram $RAM
    check_free_disk $DISK $BUILDHOME
    check_free_boot_disk $BOOT $BOOTDIR
    check_distro_arch $ARCH $DISTRO_ARCH
    check_distro_bl $ID $DARCH $RELEASE $CODENAME "$DISTRO_BL"
    check_distro $ID $DARCH $RELEASE $CODENAME "$DESCRIPTION" "$DISTROS"
    check_kernel_config "$CONFIGS"
    check_internet "$INTERNET" $INTERNET_AVAILABLE $PING_HOST
    check_cardreader "$CARDREADER"
    check_for_vm "$NATIVELINUX" "$VMOKAY"
fi

#===============================================================================
# Check package list
if [[ -n $INSTALL || -z $NOINSTALL ]] ; then
    check_sudo $ID $RELEASE
    check_repos "$ID" "$RELEASE" "$CODENAME" "$ARCH"
    PKGLIST=$(for_each_course "package_list $ID $RELEASE" $COURSE)
    try_packages "$ID" "$RELEASE" "$COURSE" $PKGLIST
else
    notice "Not checking whether the appropriate packages are being installed"
fi

#===============================================================================
# Overall PASS/FAIL
echo
if [[ -n "$FAILED" ]] ; then
    warn "You will likely have troubles using this computer with this course. Ask your instructor."
elif [[ -n "$WARNINGS" ]] ; then
    warn "You may have troubles using this computer for this course unless you can fix the above warnings."
    warn "Ask your instructor."
elif [[ -n "$MISSING_PACKAGES" ]] ; then
    warn "You have some missing packages. This is probably not a big deal."
    warn "Ask your instructor about this on the day of the course."
else
    pass "You are ready for the course! W00t!"
fi

#===============================================================================
if [[ -z "$INSTALL" && -z "$NOCM" ]] ; then
    echo
    for_each_course get_course_materials $ORIG_COURSE $COURSE
fi

exit 0
