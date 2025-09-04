`define BCLK_DIV	15	//2MHz, need larger than mininum data rate
`define LRCLK_DIV	625	//48kHz

module i2s(
    input clk,
    input rst,

    input phy_en,
    output reg busy,
   
    input phy_rd_valid,
    output reg phy_rd,
    input[16:0] phy_rd_data_chan0,
    input[16:0] phy_rd_data_chan1,

    output io_i2s_lrclk,
    output io_i2s_bclk,
    //tcyc > 390ns
    output reg io_i2s_data
);

reg[31:0] phy_result;

reg pclk;
reg phy_tx;
reg phy_chan;
reg[31:0] bclk_count;
reg[31:0] lrclk_count;

wire phy_bit;
assign phy_bit = bclk_count == `BCLK_DIV;
wire phy_word;
assign phy_word = lrclk_count == `LRCLK_DIV;

//integer fd_result;
//initial fd_result = $fopen("output_wave.bin", "wb");

always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        pclk <= 0;
        bclk_count <= 1;
        lrclk_count <= 1;
        busy <= 0;
        phy_tx <= 1;
        phy_rd <= 0;
        phy_chan <= 0;
        phy_result = 0;
    end else
    begin
        if(phy_en) busy <= 1;
        else busy <= phy_word ? 0 : busy;
        if(busy)
        begin
            pclk <= phy_word ? 0 : (phy_bit ? ~pclk : pclk);
            bclk_count <= phy_word || phy_bit ? 1 : bclk_count + 1; 
            lrclk_count <= phy_word ? 1 : lrclk_count + 1;
            phy_tx <= phy_word;
            phy_rd <= phy_rd_valid && phy_word && phy_chan;
            phy_chan <= phy_word ? ~phy_chan : phy_chan;
            if(phy_rd)
            begin
            	phy_result[31:16] = phy_rd_data_chan1;
            	phy_result[15:0] = phy_rd_data_chan0;
                //$fwrite(fd_result, "%u", phy_result);
            end
        end else
        begin
            pclk <= 0;
            bclk_count <= 1;
            lrclk_count <= 1;
            phy_tx <= 0;
            phy_rd <= 0;
            phy_chan <= 0;
        end
    end
end

reg cke;
reg[4:0] fsm;

assign io_i2s_bclk = cke ? pclk : 0;
assign io_i2s_lrclk = phy_chan;

always @(negedge pclk or posedge phy_tx)
begin
    if(phy_tx)
    begin
        cke <= 1;
        fsm <= 5'h0f;
        io_i2s_data <= 0;
    end else
    begin
        cke <= ~fsm[4];
        fsm <= fsm[4] ? fsm : fsm - 1;
        io_i2s_data <= fsm[4] ? 0 : phy_result[{phy_chan, fsm[3:0]}];
    end
end

endmodule
