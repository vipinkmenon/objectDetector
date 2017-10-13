module memCell(
input             i_clk,
input             i_reset,
input             i_mode,
input             i_img_mem_wr,
input       [7:0] i_img_data,
output  reg [7:0] o_img_data,
output  reg     o_img_data_valid,
output  reg     o_done_training
);


reg [7:0] trainImg;

always @(posedge i_clk)
begin
    if(i_mode == 1'b0 && i_img_mem_wr)
	    trainImg <= i_img_data;
end

always @(posedge i_clk)
begin
    if(i_reset)
	    o_done_training  <=  1'b0;
	else if(i_mode == 1'b0 && i_img_mem_wr)
        o_done_training <=  1'b1;
end

always @(posedge i_clk)
begin
    o_img_data <= i_img_data^trainImg;
end

always @(posedge i_clk)
begin
    if(i_mode == 2'b1 && i_img_mem_wr)
	    o_img_data_valid    <=    1'b1;
	else
	    o_img_data_valid    <=    1'b0;
end

endmodule