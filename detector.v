`define numRows 10
`define numColumn 10

module object_detector(
    input             i_clk,
    input             i_reset,
    input             i_mode,
    input             i_img_mem_wr,
    input       [7:0] i_img_data,
    output  reg [7:0] o_img_data,
    output  reg       o_img_data_valid,
    output            o_done_training
    );
    
    reg [`numRows*`numColumn-1:0] pixel_in_image_valid;
    wire [`numRows*`numColumn-1:0] pixel_out_image_valid;
    wire [`numRows*`numColumn-1:0] done_training;
    wire [7:0] cell_image[`numRows*`numColumn-1:0];
    reg [7:0] currWrCell;
    reg [7:0] currRdCell;
    reg [7:0] inputData;
    
    assign o_done_training = &done_training;
    
    always @(posedge i_clk)
    begin
        if(o_done_training)
        begin
            o_img_data_valid <= i_img_mem_wr;
        end
    end
    
    
    always @(posedge i_clk)
    begin
        if(i_reset)
    	begin
    	    currWrCell <= 0;
    	end
    	else
    	begin
    	    pixel_in_image_valid <= 'd0;
    	    pixel_in_image_valid[currWrCell] <= i_img_mem_wr;
    		inputData <= i_img_data;
    		if(i_img_mem_wr)
    		begin
    		    if(currWrCell == `numRows*`numColumn-1)
    			    currWrCell  <=  0;
    			else
    		        currWrCell   <=   currWrCell+1'b1;
    		end
    	end
    end
    
    always @(posedge i_clk)
    begin
        if(i_reset)
    	begin
    	    currRdCell <= 0;
			o_img_data <= cell_image[0];
    	end
    	else
    	begin
    	    if(o_img_data_valid)
            begin
    		    o_img_data <= cell_image[currRdCell];
    			if(currRdCell == `numRows*`numColumn-1)
    			    currRdCell  <=  0;
    			else
    		        currRdCell   <=   currRdCell+1'b1;
    		end
    	end
    end
    
    genvar i;
    generate
        for(i=0;i<`numRows*`numColumn;i=i+1)
    	begin:genloop
    	    memCell mC(
                .i_clk(i_clk),
                .i_reset(i_reset),
                .i_mode(i_mode),
                .i_img_mem_wr(pixel_in_image_valid[i]),
                .i_img_data(inputData),
                .o_img_data(cell_image[i]),
                .o_img_data_valid(pixel_out_image_valid[i]),
                .o_done_training(done_training[i])
        );
    	end
    endgenerate

endmodule