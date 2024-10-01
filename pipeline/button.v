`timescale 1ns / 1ps

module button(
    input wire         rst_to_btn,   
    input wire         clk_to_btn,   
    input wire [31:0]  addr_to_btn,  
    input wire [4:0]   button,
    
    output reg [31:0]  rdata_from_btn
    );
    
    always@(*)begin
        if(rst_to_btn)rdata_from_btn = 32'b0;
        else rdata_from_btn = {27'b0,button};
    end
endmodule
