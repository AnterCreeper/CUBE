//Copyright (C)2014-2025 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//Tool Version: V1.9.11.03 Education
//Part Number: GW5A-LV25MG121NC1/I0
//Device: GW5A-25
//Device Version: A
//Created Time: Thu Sep  4 13:50:54 2025

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

	fifo_top your_instance_name(
		.Data(Data), //input [31:0] Data
		.WrClk(WrClk), //input WrClk
		.RdClk(RdClk), //input RdClk
		.WrEn(WrEn), //input WrEn
		.RdEn(RdEn), //input RdEn
		.Q(Q), //output [31:0] Q
		.Empty(Empty), //output Empty
		.Full(Full) //output Full
	);

//--------Copy end-------------------
