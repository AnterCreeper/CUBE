module sys(
    input           clk50,

    inout           mcu_i2c_sda,
    inout           mcu_i2c_scl,

    output	        vid_pclk,
    output [23:0]   vid_d,
    output          vid_de,
    output          vid_hs,
    output          vid_vs,

    output wire     usb_dp_pull,  // connect to USB D+ by an 1.5k resistor
    inout           usb_dp,       // connect to USB D+
    inout           usb_dn,       // connect to USB D-

    output          spi_pwron,
    output          spi_cs,
    output          spi_clk,
    input           spi_miso,
    output          spi_mosi,
    
    output          i2s_lrclk,
    output          i2s_bclk,
    output          i2s_data,

    output [3:0]    dbg,
    output [1:0]    dbg2,
    output [3:0]    dbg3
);

assign mcu_i2c_sda = 1'bz;
assign mcu_i2c_scl = 1'bz;

reg[3:0] cnt;
always @(posedge vid_pclk)
begin
    cnt <= cnt + 1;
end

assign dbg = {cnt[3], vid_de, vid_hs, vid_vs};

vpg	u_vpg (
    .clk_50(clk50),
    .vpg_de(vid_de),
    .vpg_hs(vid_hs),
    .vpg_vs(vid_vs),
    .vpg_pclk_out(vid_pclk),
    .vpg_r(vid_d[23:16]),
    .vpg_g(vid_d[15:8]),
    .vpg_b(vid_d[7:0])
);

//-------------------------------------------------------------------------------------------------------------------------------------

wire       clk60;
wire       clk_locked;

Gowin_PLL2 pllusb(
    .clkin(clk50), //input  clkin
    .clkout0(clk60), //output  clkout0
    .lock(clk_locked), //output  lock
    .mdclk(clk50) //input  mdclk
);

wire       led;
wire       uart_tx;

assign dbg2 = {led, uart_tx};

// here we simply make a loopback connection for testing, but convert lowercase letters to uppercase.
// When using minicom/hyperterminal/serial-assistant to send data from the host to the device, the send data will be returned.
wire [ 7:0] recv_data;
wire        recv_valid;
wire [ 7:0] send_data = (recv_data >= 8'h61 && recv_data <= 8'h7A) ? (recv_data - 8'h20) : recv_data;   // lowercase -> uppercase

usb_serial_top #(
    .DEBUG           ( "FALSE"             )    // If you want to see the debug info of USB device core, set this parameter to "TRUE"
) u_usb_serial (
    .rstn            ( clk_locked          ),
    .clk             ( clk60               ),
    // USB signals
    .usb_dp_pull     ( usb_dp_pull         ),
    .usb_dp          ( usb_dp              ),
    .usb_dn          ( usb_dn              ),
    // USB reset output
    .usb_rstn        ( led                 ),   // 1: connected , 0: disconnected (when USB cable unplug, or when system reset (rstn=0))
    // CDC receive data (host-to-device)
    .recv_data       ( recv_data           ),   // received data byte
    .recv_valid      ( recv_valid          ),   // when recv_valid=1 pulses, a data byte is received on recv_data
    // CDC send data (device-to-host)
    .send_data       ( send_data           ),   // 
    .send_valid      ( recv_valid          ),   // loopback connect recv_valid to send_valid
    .send_ready      (                     ),   // ignore send_ready, ignore the situation that the send buffer is full (send_ready=0). So here it will lose data when you send a large amount of data
    // debug output info, only for USB developers, can be ignored for normally use
    .debug_en        (                     ),
    .debug_data      (                     ),
    .debug_uart_tx   ( uart_tx             )
);

aud_gen aud_test(
    .clk(clk60),
    .rst(1'b0),

    .spi_pwron(spi_pwron),
    .spi_cs(spi_cs),
    .spi_clk(spi_clk),
    .spi_miso(spi_miso),
    .spi_mosi(spi_mosi),
    
    .i2s_lrclk(i2s_lrclk),
    .i2s_bclk(i2s_bclk),
    .i2s_data(i2s_data),
    
    .dbg(dbg3)
);

endmodule
