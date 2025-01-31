# Rockchip RK3566 quad core 1GB/2GB RAM eMMC 2x GbE USB3
BOARD_NAME="NanoPi R3S"
BOARDFAMILY="rockchip64"
BOARD_MAINTAINER=""
BOOTCONFIG="nanopi-r3s-rk3566_defconfig"
KERNEL_TARGET="current,edge"
KERNEL_TEST_TARGET="current"
DEFAULT_CONSOLE="serial"
HAS_VIDEO_OUTPUT="no"
BOOT_FDT_FILE="rockchip/rk3566-nanopi-r3s.dtb"
IMAGE_PARTITION_TABLE="gpt"


# Mainline U-Boot
function post_family_config__nanopi-r3s_use_mainline_uboot() {
	display_alert "$BOARD" "Using mainline U-Boot for $BOARD / $BRANCH" "info"

	declare -g BOOTSOURCE="https://github.com/u-boot/u-boot.git" # We ❤️ Mainline U-Boot
	declare -g BOOTBRANCH="tag:v2024.10"
	declare -g BOOTPATCHDIR="v2024.10/board_${BOARD}"
	# Don't set BOOTDIR, allow shared U-Boot source directory for disk space efficiency

	declare -g UBOOT_TARGET_MAP="BL31=${RKBIN_DIR}/${BL31_BLOB} ROCKCHIP_TPL=${RKBIN_DIR}/${DDR_BLOB};;u-boot-rockchip.bin"

	# Disable stuff from rockchip64_common; we're using binman here which does all the work already
	unset uboot_custom_postprocess write_uboot_platform write_uboot_platform_mtd

	# Just use the binman-provided u-boot-rockchip.bin, which is ready-to-go
	function write_uboot_platform() {
		dd "if=$1/u-boot-rockchip.bin" "of=$2" bs=32k seek=1 conv=notrunc status=none
	}
}
