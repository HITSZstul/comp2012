`timescale 1ns / 1ps
module RF(
    input wire clk,
    input wire rst,
    input wire [4:0] rR1,
    input wire [4:0] rR2,
    input wire [4:0] wR,
    input wire we,
    
    input wire [31:0] imm,
    input wire [31:0] pc4,
    input wire [31:0] alu_c,
    input wire [31:0] dram,
    
    input wire [1:0] rf_wsel,
    
    output reg [31:0] wD,
    output wire [31:0] rD2,
    output wire [31:0] rD1
    );

    reg [31:0] regfile[31:0];
    
    assign rD1 = regfile[rR1];
    assign rD2 = regfile[rR2];

    always@(*)begin
        case(rf_wsel)
            `WB_ALU: wD = alu_c;
            `WB_EXT: wD = imm  ;
            `WB_PC4: wD = pc4  ;
            `WB_DAM: wD = dram ;
            default: wD = 32'd0;
        endcase
     end
     
     always @(posedge clk or posedge rst)begin
        if(rst)begin
            regfile[0] <= 32'd0; 
            regfile[1] <= 32'd0; 
            regfile[2] <= 32'd0; 
            regfile[3] <= 32'd0; 
            regfile[4] <= 32'd0; 
            regfile[5] <= 32'd0; 
            regfile[6] <= 32'd0; 
            regfile[7] <= 32'd0; 
            regfile[8] <= 32'd0; 
            regfile[9] <= 32'd0; 
            regfile[10] <= 32'd0;
            regfile[11] <= 32'd0;
            regfile[12] <= 32'd0;
            regfile[13] <= 32'd0;
            regfile[14] <= 32'd0;
            regfile[15] <= 32'd0;
            regfile[16] <= 32'd0;
            regfile[17] <= 32'd0;
            regfile[18] <= 32'd0;
            regfile[19] <= 32'd0;
            regfile[20] <= 32'd0;
            regfile[21] <= 32'd0;
            regfile[22] <= 32'd0;
            regfile[23] <= 32'd0;
            regfile[24] <= 32'd0;
            regfile[25] <= 32'd0;
            regfile[26] <= 32'd0;
            regfile[27] <= 32'd0;
            regfile[28] <= 32'd0;
            regfile[29] <= 32'd0;
            regfile[30] <= 32'd0;
            regfile[31] <= 32'd0;
        end
        else if(we && (wR != 5'd0))begin
            regfile[wR] <= wD;
        end
        else begin
            regfile[0] <= 32'd0;
        end
     end
endmodule
