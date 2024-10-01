`timescale 1ns / 1ps
module SEXT(
    input wire [2:0] sext_op,
    input wire [24:0] din,
    input wire [31:0] pc,
    
    output reg [31:0] ext,
    output wire [31:0] pc_imm
    );
    
    always @(*)begin
        case(sext_op)
            `SEXT_I: ext = din[24]? {20'hFFFFF,din[24:13]} : {20'h00000,din[24:13]};
            `SEXT_B: ext = din[24]?{20'hFFFFF, din[24],din[0],din[23:18],din[4:1],1'b0}:{20'h00000, din[24],din[0],din[23:18],din[4:1],1'b0};   
            `SEXT_S: ext = din[24]? {20'hFFFFF,din[24:18],din[4:0]} : {20'h00000,din[24:18],din[4:0]};    
            `SEXT_J: ext = din[24]? {12'hFFF,din[12:5],din[13],din[23:14],1'b0} : {12'h000,din[12:5],din[13],din[23:14],1'b0};     
            `SEXT_U: ext = {din[24:5],12'h000};    
            `SEXT_SHIFT: ext = {27'd0,din[17:13]};
            default: ext = 32'd0;
        endcase
    end
    
    assign pc_imm = ext + pc;//jal  jalr
    
endmodule
