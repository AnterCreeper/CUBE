//Copyright (C)2014-2025 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//Tool Version: V1.9.11.03 Education 
//Created Time: 2025-09-05 19:10:27
create_clock -name clk -period 20 -waveform {0 10} [get_ports {clk50}]
create_clock -name pclk -period 6.734 -waveform {0 3.367} [get_nets {vid_pclk}]
create_clock -name uclk -period 16.667 -waveform {0 8.334} [get_nets {clk60}]
set_output_delay -clock pclk 10 [get_ports {vid_pclk vid_d[23] vid_d[22] vid_d[21] vid_d[20] vid_d[19] vid_d[18] vid_d[17] vid_d[16] vid_d[15] vid_d[14] vid_d[13] vid_d[12] vid_d[11] vid_d[10] vid_d[9] vid_d[8] vid_d[7] vid_d[6] vid_d[5] vid_d[4] vid_d[3] vid_d[2] vid_d[1] vid_d[0] vid_de vid_hs vid_vs}]
set_output_delay -clock uclk 10 [get_ports {usb_dp usb_dn}]
