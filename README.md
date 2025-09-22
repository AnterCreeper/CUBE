# CUBE
FPGA Development Kit based on Tang Primer 25k Module

### Feature
1. 1080p 60fps Video + I2S Audio Output(combined with pdaltmode project)
2. Audio DAC HAT with PLL, reuse displayport i2s and use no extra pins.
3. 16x Programmable Voltage IO
4. SDCard in 1-bit SDIO/SPI mode
5. USB Device

### Issue
1. Video Output comsumed too much IOs, use RGB666 instead. The remained 6x 1.8V pins can be used by SDcard(CLK, D[3:0] and CMD), extend it to full 4-bit. Use one TXB0106 and adjustable LDO for programmable level shifting.
2. The 4x 3.3V pins from SDcard can be used as follows: one for SDCard Power Mux, one for MCU Interrupt to FPGA, one for I2C arbitering between MCU and FPGA, and one for UART Debug Tx(and also connected with LED).
3. The arbitering Line is pulled up, having one host(FPGA) and one device(MCU). MCU should controll the EN pin of I2C level shifter, and enable it after receiving ack of the request from the FPGA.
4. Add Power Mux TPS2121 for multiple Power Supplies(PoE, Batteries, etc..).

### 12+4 pin Programmable Voltage HAT
1. Gigabit Ethernet with RTL8211, 14pins(TXCLK,TX[3:0],RXCLK,RX[3:0],TX_CTL,RX_CTL,MDIO,MDC).
2. Camera Parallel, 12pins(D[7:0],PCLK,VSYNC,HREF/DE,PWON), could be Camera, HDMI to RGB, USB Camera to DVP or CSI-2 to RGB.
3. USB FT245 FIFO, 14pins(D[7:0],CLK60,PWREN,TXF,RXF,WR,RD).
