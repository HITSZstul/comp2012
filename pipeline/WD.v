`timescale 1ns / 1ps
module WD(
        input wire [1:0] wd_sel  ,
        input wire [31:0] alu_c   ,
        input wire [31:0] pc4     ,
        input wire [31:0] imm     ,
      
        output reg [31:0] wd    
    );
    
    always@(*)begin
        case(wd_sel)
            `WB_ALU: wd = alu_c;
            `WB_PC4: wd = pc4;
            `WB_EXT: wd = imm;
            default: wd = alu_c;
        endcase
    end
endmodule
