module sys(
    input           clk50,

    inout           mcu_i2c_sda,
    inout           mcu_i2c_scl,

    output	        vid_pclk,
    output [23:0]   vid_d,
    output          vid_de,
    output          vid_hs,
    output          vid_vs,

    output [3:0]    dbg
);

wire reset_n;
assign reset_n = 1'b1;

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
    .reset_n(reset_n),
    .vpg_de(vid_de),
    .vpg_hs(vid_hs),
    .vpg_vs(vid_vs),
    .vpg_pclk_out(vid_pclk),
    .vpg_r(vid_d[23:16]),
    .vpg_g(vid_d[15:8]),
    .vpg_b(vid_d[7:0])
);

endmodule

module pll (
    input clkin,
    input areset,
    output clkout
);

Gowin_PLL pll(
    .clkin(clkin),
    .clkout0(clkout),
    .mdclk(clkin)
);

endmodule
