# CUBE

If any questions, welcome for Issues & PRs   
如果有疑问，欢迎提交Issues或PR

**WARNING! This Project is not been fully productive tested, use at your own risk!**   
**警告！该项目未经充分的生产测试，使用需要你自己衡量**

### License

This project is licensed under the LGPL-2.1-or-later license. **DO NOT** download or clone this project until you have read and agree the LICENSE.  
该项目采用 `LGPL-2.1 以及之后版本` 授权。当你下载或克隆项目时，默认已经阅读并同意该协定。

### TODO

1. Enable MIPI CSI-2, compatible with RaspberryPi 15-pin
2. Enable 4-bit SDIO for microSD
3. Enable I2C Master Bus for HID and EEPROM
4. Support Camera(DVP) Compatible IO pinout

### Overview

Tiny Full-feature FPGA DevKit based on Sipeed Tang Primer 25k SoM, used to perform demonstrate and exploration of small digital logic.  
迷你全功能 FPGA 开发套件, 基于 Sipeed Tang Primer 25k SoM 核心板, 用于探索和展示小型数字逻辑模型。

### Feature

- microSD Storage
- EEPROM firmware
- 256Mbit(32MB) HYPERRAM DRAM
- 16 Programmable Voltage Level IO, support multiple stages(1.2V to 3.3V)
- USB 12Mbps Full Speed Device, which can emulate USB Audio Card, CDC Serial, Mass Storage...
- MIPI CSI-2 and DVP Camera
- Stereo High Definition Headphone Audio output(via [CUBE/hat](https://github.com/AnterCreeper/CUBE/tree/main/hat))
- USB & BLE HID to I2C HID, enabling support for Mouse and Keyboard(via [CUBE/hat](https://github.com/AnterCreeper/CUBE/tree/main/hat))
- Dual Gigabit Ethernet(via [nethat](https://github.com/AnterCreeper/nethat))
- 1080p 60fps Digital Video & Audio，via DisplayPort over Type-C, and support USB Host(via [pdaltmode](https://github.com/AnterCreeper/pdaltmode))

### Pinout
<!-- TODO: Pinout -->

### Appearance

![front](https://github.com/user-attachments/assets/abb218c1-7b0b-481c-92ce-c1d8ebb9a848)
![back](https://github.com/user-attachments/assets/daafba18-5fae-471a-bee7-6256036dffc9)
