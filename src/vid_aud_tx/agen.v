module fifo(
    input clk,
    input rst,

    input fifo_in_wr,
    output reg fifo_in_fin,
    input[31:0] fifo_in_dat,

    input fifo_out_rd,
    output fifo_out_vld,
    output[31:0] fifo_out_dat
);

wire fifo_full, fifo_empty;
reg fifo_int_wr;
reg[31:0] fifo_int_dat;

always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
    	fifo_in_fin <= 0;
    end else
    begin
    	if(fifo_in_wr && !fifo_full && !fifo_in_fin)
    	begin
    	    fifo_in_fin <= 1;
    	    fifo_int_wr <= 1;
    	    fifo_int_dat <= fifo_in_dat;
    	end else
    	begin
    	    fifo_in_fin <= 0;
    	    fifo_int_wr <= 0;
    	end
    end
end

assign fifo_out_vld = ~fifo_empty;

fifo_top gowin_fifo(
    .WrClk(clk), //input WrClk
    .WrEn(fifo_int_wr), //input WrEn
    .Data(fifo_int_dat), //input [31:0] Data
    
    .RdClk(clk), //input RdClk
    .RdEn(fifo_out_rd), //input RdEn
    .Q(fifo_out_dat), //output [31:0] Q
    
    .Empty(fifo_empty), //output Empty
    .Full(fifo_full) //output Full
);

endmodule

module aud_gen(
    input clk,
    input rst,
    
    output reg spi_pwron,
    output spi_cs,
    output spi_clk,
    input spi_miso,
    output spi_mosi,
    
    output i2s_lrclk,
    output i2s_bclk,
    output i2s_data,
    
    output[3:0] dbg
);

wire fifo_in_wr;
wire[31:0] fifo_in_dat;
wire fifo_in_fin;
wire fifo_out_vld;
wire fifo_out_rd;
wire[31:0] fifo_out_dat;

fifo a_fifo(
    .clk(clk),
    .rst(rst),
    
    .fifo_in_fin(fifo_in_fin),
    .fifo_in_wr(fifo_in_wr),
    .fifo_in_dat(fifo_in_dat),
    
    .fifo_out_vld(fifo_out_vld),
    .fifo_out_rd(fifo_out_rd),
    .fifo_out_dat(fifo_out_dat)
);

reg spi_en;
wire spi_busy;
wire spi_run;
reg spi_issue;
reg[31:0] spi_issue_addr;

sdhci storage(
    .clk(clk),
    .rst(rst),

    .fifo_write_request(fifo_in_wr),
    .fifo_write_data(fifo_in_dat),
    .fifo_request_finish(fifo_in_fin),
    
    .en(spi_en),
    .busy(spi_busy),
    .issue(spi_issue),
    .rd_blk_addr(spi_issue_addr),

    .run(spi_run),

    .spi_cs(spi_cs),
    .spi_clk(spi_clk),
    .spi_mosi(spi_mosi),
    .spi_miso(spi_miso)
);

reg phy_en;
wire i2s_busy;

i2s audio(
    .clk(clk),
    .rst(rst),

    .phy_en(phy_en),
    .busy(i2s_busy),

    .phy_rd_valid(fifo_out_vld),
    .phy_rd(fifo_out_rd),
    .phy_rd_data_chan0(fifo_out_dat[15:0]),
    .phy_rd_data_chan1(fifo_out_dat[31:16]),

    .io_i2s_lrclk(i2s_lrclk),
    .io_i2s_bclk(i2s_bclk),
    .io_i2s_data(i2s_data)
);

assign dbg = {spi_run, spi_cs, spi_clk, spi_mosi};

//control logic
always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
    	phy_en = 0;
    	spi_en = 0;
    	spi_pwron = 0;
    	spi_issue = 0;
    	spi_issue_addr = 0;
    end else
    begin
    	phy_en <= 1;
    	spi_en <= 1;
    	spi_pwron <= 1;
    	if(spi_busy)
    	begin
    	    spi_issue <= 0;
    	    spi_issue_addr <= spi_issue_addr;
    	end else
    	begin
    	    spi_issue <= 1;
    	    spi_issue_addr <= spi_issue_addr + 1;
    	end
    end
end

endmodule




