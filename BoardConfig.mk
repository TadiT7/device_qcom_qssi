# config.mk
#
# Product-specific compile-time definitions.
#
BUILD_BROKEN_ANDROIDMK_EXPORTS=true
BUILD_BROKEN_DUP_COPY_HEADERS=true
BUILD_BROKEN_PHONY_TARGETS=true
# TODO(b/124534788): Temporarily allow eng and debug LOCAL_MODULE_TAGS
BUILD_BROKEN_ENG_DEBUG_TAGS := true

TARGET_BOARD_PLATFORM := msmnile
TARGET_BOOTLOADER_BOARD_NAME := msmnile

TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv7-a-neon
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a9

TARGET_HW_DISK_ENCRYPTION := true
TARGET_HW_DISK_ENCRYPTION_PERF := true

BOARD_SECCOMP_POLICY := device/qcom/$(TARGET_BOARD_PLATFORM)/seccomp

TARGET_NO_BOOTLOADER := true
TARGET_USES_UEFI := true
TARGET_NO_KERNEL := false

# Disable DLKMs compilation for lunch qssi builds.
TARGET_KERNEL_DLKM_DISABLE := true

-include $(QCPATH)/common/msmnile/BoardConfigVendor.mk

# Some framework code requires this to enable BT
BOARD_HAVE_BLUETOOTH := true
BOARD_USES_WIPOWER := true
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/qcom/common

USE_OPENGL_RENDERER := true
BOARD_USE_LEGACY_UI := true

ifeq ($(ENABLE_AB), true)
# Defines for enabling A/B builds
AB_OTA_UPDATER := true
# Full A/B partition update set
# AB_OTA_PARTITIONS := xbl rpm tz hyp pmic modem abl boot keymaster cmnlib cmnlib64 system bluetooth

# Minimum partition set for automation to test recovery generation code
# Packages generated by using just the below flag cannot be used for updating a device. You must pass
# in the full set mentioned above as part of your make commandline
TARGET_NO_RECOVERY := true
else
TARGET_NO_RECOVERY := true
# Enable System As Root even for non-A/B
# Add the below cache settings for /cache mountpoint, although we don't need the resultant cache image
# from within Qssi.
BOARD_CACHEIMAGE_PARTITION_SIZE := 268435456
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
endif

# Define BOARD_USES_METADATA_PARTITION to create metadata mount point in system image
BOARD_USES_METADATA_PARTITION := true

#Enable split vendor image
ENABLE_VENDOR_IMAGE := true
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_VENDOR := vendor
BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED := true

TARGET_USERIMAGES_USE_EXT4 := true
BOARD_BOOTIMAGE_PARTITION_SIZE := 0x06000000
BOARD_FLASH_BLOCK_SIZE := 131072 # (BOARD_KERNEL_PAGESIZE * 64)

#----------------------------------------------------------------------
# Compile Linux Kernel
#----------------------------------------------------------------------
KERN_CONF_PATH := kernel/msm-$(TARGET_KERNEL_VERSION)/arch/arm64/configs
KERNEL_DEFCONFIG := sdm845_defconfig
ifeq ($(wildcard $(KERN_CONF_PATH)/$(KERNEL_DEFCONFIG)),)
KERNEL_DEFCONFIG := $(shell ls $(KERN_CONF_PATH)/vendor | grep sm8..._defconfig)
ifeq ($(KERNEL_DEFCONFIG),)
KERNEL_DEFCONFIG := kona_defconfig
endif
KERNEL_DEFCONFIG := vendor/$(KERNEL_DEFCONFIG)
endif

TARGET_USES_ION := true
TARGET_USES_NEW_ION_API :=true
TARGET_USES_QCOM_BSP := false
BOARD_KERNEL_CMDLINE := console=ttyMSM0,115200n8 earlycon=msm_geni_serial,0xa90000 androidboot.hardware=qcom androidboot.console=ttyMSM0 androidboot.memcg=1 lpm_levels.sleep_disabled=1 video=vfb:640x400,bpp=32,memsize=3072000 msm_rtb.filter=0x237 service_locator.enable=1 swiotlb=2048 loop.max_part=7 androidboot.usbcontroller=a600000.dwc3

BOARD_EGL_CFG := device/qcom/$(TARGET_BOARD_PLATFORM)/egl.cfg

BOARD_KERNEL_BASE        := 0x00000000
BOARD_KERNEL_PAGESIZE    := 4096
BOARD_KERNEL_TAGS_OFFSET := 0x01E00000
BOARD_RAMDISK_OFFSET     := 0x02000000

TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_HEADER_ARCH := arm64
TARGET_KERNEL_CROSS_COMPILE_PREFIX := $(shell pwd)/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-androidkernel-

KERNEL_UNCOMPRESSED_DEFCONFIG := $(shell grep "CONFIG_BUILD_ARM64_UNCOMPRESSED_KERNEL=y" $(KERN_CONF_PATH)/$(KERNEL_DEFCONFIG))
ifeq ($(KERNEL_UNCOMPRESSED_DEFCONFIG),)
	TARGET_USES_UNCOMPRESSED_KERNEL := false
else
	TARGET_USES_UNCOMPRESSED_KERNEL := true
endif

MAX_EGL_CACHE_KEY_SIZE := 12*1024
MAX_EGL_CACHE_SIZE := 2048*1024

BOARD_USES_GENERIC_AUDIO := true
BOARD_QTI_CAMERA_32BIT_ONLY := true
TARGET_NO_RPC := true

TARGET_PLATFORM_DEVICE_BASE := /devices/soc.0/
TARGET_INIT_VENDOR_LIB := libinit_msm

TARGET_KERNEL_APPEND_DTB := true
TARGET_COMPILE_WITH_MSM_KERNEL := true

#Enable PD locater/notifier
TARGET_PD_SERVICE_ENABLED := true

#Enable peripheral manager
TARGET_PER_MGR_ENABLED := true

# Enable dex pre-opt to speed up initial boot
ifeq ($(HOST_OS),linux)
    ifeq ($(WITH_DEXPREOPT),)
      WITH_DEXPREOPT := true
      WITH_DEXPREOPT_PIC := true
      ifneq ($(TARGET_BUILD_VARIANT),user)
        # Retain classes.dex in APK's for non-user builds
        DEX_PREOPT_DEFAULT := nostripping
      endif
    endif
endif

TARGET_USES_GRALLOC1 := true

# Enable sensor multi HAL
USE_SENSOR_MULTI_HAL := true

#Enable INTERACTION_BOOST
TARGET_USES_INTERACTION_BOOST := true

#Enable DRM plugins 64 bit compilation
TARGET_ENABLE_MEDIADRM_64 := true

ifeq ($(ENABLE_VENDOR_IMAGE), false)
	$(error "Vendor Image is mandatory !!")
endif

#Flag to enable System SDK Requirements.
#All vendor APK will be compiled against system_current API set.
BOARD_SYSTEMSDK_VERSIONS:=28

BUILD_BROKEN_DUP_RULES := true

#Enable VNDK Compliance
BOARD_VNDK_VERSION:=current
Q_BU_DISABLE_MODULE := true

###### Dynamic Partition Handling ####
ifneq ($(strip $(BOARD_DYNAMIC_PARTITION_ENABLE)),true)
BOARD_BUILD_SYSTEM_ROOT_IMAGE := true
BOARD_VENDORIMAGE_PARTITION_SIZE := 1073741824
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 3221225472
BOARD_PRODUCTIMAGE_PARTITION_SIZE := 838860800
ifeq ($(ENABLE_AB), true)
AB_OTA_PARTITIONS ?= system
endif
else
TARGET_COPY_OUT_PRODUCT := product
BOARD_USES_PRODUCTIMAGE := true
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_BUILD_SYSTEM_ROOT_IMAGE := false
BOARD_SUPER_PARTITION_GROUPS := qti_dynamic_partitions
BOARD_QTI_DYNAMIC_PARTITIONS_PARTITION_LIST := system product
ifeq ($(ENABLE_AB), true)
AB_OTA_PARTITIONS ?= system product
endif
endif
###### Dynamic Partition Handling ####

#################################################################################
# This is the End of BoardConfig.mk file.
# Now, Pickup other split Board.mk files:
#################################################################################
-include vendor/qcom/defs/board-defs/system/*.mk
#################################################################################
