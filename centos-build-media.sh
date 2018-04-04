#! /bin/bash
# centos-build-media
#
#  centos-build-media is a tool to create Centos installation media containing
#  a kickstart file for automated Centos installation.
#
#  centos-build-media creates an custom .iso by extracting
#  the contents of a stock Centos installation
#  .iso, performing modifications on the contents, and creating a new
#  .iso file from the modified contents.
#
#  A custom .iso may be created from either
# @Author Cameron Morris & Brandon Phillips

usage()
{
cat <<EOF

Usage:
	centos-build-media -i iso -k kickstart [ -t tar file ] [ -h ]

	-h	Show the help menu
	-i	The iso file to use
	-k 	The kickstart file to inject
	-t	The tar file to extract. Must NOT be compressed.
	-e	The root folder containing other dependant files to be embeded  
	
	Examples:

    # Create net media using the kickstart file "base.cfg"
	  $ centos-build-media -i mini.iso -k base.cfg


EOF
}

# Print help if -h or no args specified
[ "${1}" == "-h" ] && usage && exit 0
[ "$#" -eq 0 ] && usage && exit 0

# Make sure only root can execute this script.
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root." 1>&2
   exit 1
fi


### Input argument processing.

## Set default input arguments.
KICKSTART=""


## Parse input arguments from command line.
while [ "$1" != "" ]; do

    if [ "$1" == "-i" ]; then
	STOCK_ISO="${2}"; shift

    elif [ "$1" == "-k" ]; then
	KICKSTART="${2}"; shift

    elif [ "$1" == "-t" ]; then
	TAR_FILE="${2}"; shift

    elif [ "$1" == "-e" ]; then
    	EMBED_DIR="${2}"; shift

    fi

    shift

done


## Input argument post-processing.
# Get canonical file name (CFN) to input preseed file.
# The canonical file name is the full path to the file.
KICKSTART_CFN=$(readlink -f "$KICKSTART")


### Create directories for processing.

## Define directories.
BUILD_DIR='/tmp/lentos-inject-build'
STOCK_ISO_MOUNT_POINT='/tmp/lentos-inject-imp'


## Create directories.
rm -rf "$BUILD_DIR"                 # Remove files from previous builds.
mkdir -p "$BUILD_DIR"               # Build directory for new media.

mkdir -p "$STOCK_ISO_MOUNT_POINT"   # Directory to mount stock Centos ISO.
umount "$STOCK_ISO_MOUNT_POINT"     # Perform unmount in case stock ISO already mounted.

### Copy contents into media.

## Mount stock ISO and copy its contents into build directory.
mount -o loop "$STOCK_ISO" "$STOCK_ISO_MOUNT_POINT"
rsync -av "${STOCK_ISO_MOUNT_POINT}/" "$BUILD_DIR"

## Copy input kickstart into build directory.
KICKSTART_NAME='ks.cfg'
cp "$KICKSTART_CFN" "$BUILD_DIR/$KICKSTART_NAME"

sed -i 's/inst\.stage2=hd:LABEL=CentOS\\x207\\x20x86_64/inst\.stage2=hd:LABEL=Cent7 quiet ks=hd:LABEL=Cent7:\/ks.cfg/g' $BUILD_DIR/isolinux/isolinux.cfg

## If embed directory is specified, copy it into the build directory.
if [ -n "${EMBED_DIR}" ]; then
	cp -r "${EMBED_DIR}" "${BUILD_DIR}/"
fi	

## If TAR files are specified, copy them into build directory.
#if [ -n "$TAR_FILE" ]; then
#    mkdir "$BUILD_DIR/keys"
#    tar -xf "$TAR_FILE" -C "${BUILD_DIR}/keys"
#fi

# Create the ISO 

CWD=$(pwd)

# Change to build directory.
cd "$BUILD_DIR"

# Create custom net install media.

xorriso -as mkisofs -U -r -v -T -J -joliet-long -V "Cent7" -volset "Cent7" -A \
    "Cent7" -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot \
    -boot-load-size 4 -boot-info-table -eltorito-alt-boot \
    -e images/efiboot.img \
    -no-emul-boot -o "$CWD/lentos-inject.iso" -isohybrid-gpt-basdat \
    -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin \
    -no-emul-boot -eltorito-alt-boot .

cd $CWD

### Script complete.
echo "Finished creating media."
