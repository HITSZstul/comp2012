module switch(
    input wire         rst_to_sw,    
    input wire         clk_to_sw,    
    input wire [31:0]  addr_to_sw,
    input wire [23:0]  sw,   
    output reg [31:0]  rdata_from_sw
    );
    always @(*) begin
        if(rst_to_sw) begin
            rdata_from_sw = 32'd0;
        end else begin
            rdata_from_sw = {8'd0, sw};
        end
    end
    
endmodule