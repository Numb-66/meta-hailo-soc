# Wasno main board V1R1 (MACHINE `hailo15-wasno-v1r1`)

Board: PRJ-H15 schematic v1r1 (2026-08-21), Hailo-15H, **1 GB LPDDR4X** (one Winbond W66DP2RQQAHJ, 8Gb x32).
The V1R0 board keeps building as `MACHINE=hailo15-sbc-rev3`; do not mix the two
images, the U-Boot DTB carries the DDR configuration and V1R0 (LPDDR4) will not
boot with the V1R1 DTB or vice versa.

## Build

```
kas build kas/hailo15-wasno-v1r1.yml          # core-image-minimal (dev)
kas build kas/hailo15-wasno-v1r1-core.yml     # core-image-hailo
```

Artifacts are the usual set under `build/tmp/deploy/images/hailo15-wasno-v1r1/`
(`u-boot-tfa.itb`, `u-boot.dtb.signed`, `u-boot-spl.bin`, `fitImage`, `hailo15_scu_*.bin`,
`core-image-*-hailo15-wasno-v1r1.wic`, swupdate `.swu`).

## What the machine changes (vs `hailo15-sbc-rev3`)

| Area | File | V1R1 setting |
|---|---|---|
| Machine | `meta-hailo-bsp/conf/machine/hailo15-wasno-v1r1.conf` | `UBOOT_MACHINE = hailo15_wasno_v1r1_defconfig` |
| Kernel cfg | `recipes-kernel/linux/linux-yocto-hailo.bb` | `cma-non-reusable.cfg` like rev3 |
| U-Boot DTB | `hailo-u-boot: arch/arm/dts/hailo15-wasno-v1r1.dts` | W66DP2RQQAHJ 1GB LP4X regconfig, auto-detect off, shutdown GPIO 24 |
| Kernel DTB | `linux-yocto-hailo: arch/arm64/boot/dts/hailo/hailo15-wasno-v1r1.dts` | see below |

### DDR (the reason V1R1 needs its own U-Boot DTB)

The SCU-FW reads the DDR controller/PHY configuration from the U-Boot DTB node
`hailo_boot_info/ddr_config`. The DTB includes a base register set plus one
`ddr_patches/<name>` node per supported DRAM part, and `assembled_dram_pn` selects
the patch. U-Boot's `dram_init()` derives the RAM size from `CS_VAL_UPPER_0`
(ctrl register 274) of the applied config and passes it to Linux.

V1R1 populates one **Winbond W66DP2RQQAHJ** (8Gb LPDDR4X, 256M x32, 1 rank = **1 GB**).
Hailo release 1.9.1 has no config for it, so
`hailo15_ddr_W66DP2RQQAHJ_regconfig_1GB_LP4X{,_patch}.dtsi` were backported verbatim from
hailo-u-boot 1.12.0 (only the 1.12.0-only `reg_config_version` property dropped) and added
to `hailo15_ddr_patch_include.dtsi`. Other 1.9.1 options, for reference:
`hailo15_ddr_MT53E512M32D1-046_regconfig_2GB_lpddr4x.dtsi` (Micron 2 GB LP4X, SBC rev3-1) and
`hailo15_ddr_H9HCNNNBKUMLXR_NEE_regconfig_2GB.dtsi` (SK hynix 2 GB LP4X).

`dram_auto_detect_en` must stay `0` on this board. It only matches the Hailo SBC DRAM
list; with the SBC image the V1R1 board stops at
`[CFG] Running DRAM auto-detect` / `[CFG] no matching ddr config was found`.

### 1 GB memory layout (kernel DTB)

The Hailo base dtsi assumes 2 GB (sdio0 bounce pool at 0xC8000000, default CMA at
0xCC000000, DMA window at 0xC0000000). The V1R1 kernel DTB follows the Hailo 1.12.0
`hailo15l-sbc-1gb.dts` reference:

| Region | Address | Size |
|---|---|---|
| kernel Image / DTB | 0x80C00000 / 0x80800000 | fitImage defaults |
| sdio0 restricted DMA pool | 0x84000000 | 64 MiB |
| hailo_media_buf CMA | 0x88000000 | 384 MiB |
| default Linux CMA | 0xA0000000 | 256 MiB |
| main-bus dma-ranges | + bus 0x50000000 -> phys 0x80000000 (256 MiB) | second HW window |
| gp_vdma | disabled | as on the 1.12.0 1 GB board |

1.12.0 shares one 640 MiB pool between the media library and the default CMA with
`linux,cma-soft-link`; the 1.9.1 cma_heap has no such property, so the pools are split
384/256 MiB. Resize both together if the media pipeline needs a different balance.

### Kernel DTB highlights

* GPIO line names follow the V1R1 schematic (`gpioinfo` shows ALM_IN1/ALM_IN2/IR_IN/
  EXT_RSTn/FOCUS_PI/ZOOM_PI/RGB_*/flashing/...).
* No gpio-hog: the SBC `DSI_INTR` hog on GPIO29 would hold the V1R1 `flashing` line low.
* PWM: channels 3/4/5 = GPIO3 DC_IRIS_PWM, GPIO4 wLED_PWM, GPIO5 irLED_PWM
  (`pwm1_grp` + `pwm2_grp`). In sysfs `pwmchip0/pwm0..2` map to channels 3,4,5.
  GPIO2 (channel 2) is unconnected on V1R1.
* microSD: NVT4857UKAZ translator with SEL tied low, so the card runs at 3.3 V,
  SD High Speed (50 MHz) and polling card-detect (`broken-cd`). Card detect is wired to
  GPIO15; switch to `cd-gpios = <&gpio0 15 ...>` once the polarity is measured.
* I2C1: only the PCF8563 RTC. I2C3: ES8388 codec (GPIO6/7). I2C2 (GPIO22/23 to the sensor
  FPC) is muxed but `disabled`; set `status = "okay"` when the sensor board has an I2C2 device.
* USB: USB2-only, no over-current pin (masked in xhci-hub.c), VBUS sense hardwired.
* Ethernet RMII, eMMC HS200 with the retry/fallback driver, ES8388 pace values: unchanged from V1R0.

### Alarm input polarity (application level)

* ALM_IN1 (GPIO16): direct input with 1 K pull-up -> external contact closed reads 0.
* ALM_IN2 (GPIO17): MMBT3904 inverter -> external contact closed reads 1.

## First boot on a new V1R1 board (blank NOR)

Boot strap SW1 to UART mode, run the Hailo UART recovery flow with the V1R1 artifacts
(`hailo15_scu_bl.bin`, `scu_bl_cfg_a.bin`, `hailo15_scu_fw.bin`, `u-boot-spl.bin`,
`u-boot-initial-env`, `u-boot.dtb.signed`, `customer_certificate.bin`, `u-boot-tfa.itb`),
then SW1 back to flash mode. UART1 at 115200 should show SCU-BL, SCU-FW and then
U-Boot; a stop after `Running DRAM auto-detect` means the SBC DTB was flashed instead
of the V1R1 one.
