`timescale 1ns / 1ps
`include "defines.vh"
module ALU(
    input wire [31:0] rD1,
    input wire [31:0] rD2,
    input wire [31:0] ext,

    input wire [31:0] pc,

    input wire [3:0] alu_op,
    input wire op_A_sel,
    input wire op_B_sel,
    
    output reg f,
    output reg [31:0] alu_c
    );
    
    wire [31:0] op_A = op_A_sel?rD1:pc;
    wire [31:0] op_B = op_B_sel?rD2:ext;
    wire [4:0] shamt = op_B[4:0];
    
    always @(*)begin
        case(alu_op)
            `ALU_ADD: begin 
                alu_c = op_A + op_B;
             end
            `ALU_SUB: begin 
                alu_c = op_A +(~op_B) + 1;
            end
            `ALU_SLL: begin 
                alu_c = op_A << shamt;
            end
            `ALU_SRL: begin 
                alu_c = op_A >> shamt;
            end
            `ALU_SRA: begin 
                alu_c = $signed(op_A) >>> shamt;
            end
            `ALU_OR : begin 
                alu_c = op_A | op_B;
            end
            `ALU_XOR: begin 
                alu_c = op_A ^ op_B;
            end
            `ALU_AND: begin
                alu_c = op_A & op_B;
            end
            `ALU_BEQ: begin 
                f = (op_A == op_B)? 1: 0;
            end
            `ALU_BLT: begin 
                alu_c = op_A + (~op_B) + 1;
                f = alu_c[31] ? 1:0;
            end
            `ALU_BNE: begin 
                f = (op_A == op_B) ? 1'b0:1'b1;
            end
            `ALU_BGE: begin 
                alu_c = op_A + (~op_B) + 1;
                f = alu_c[31] ? 1'b0: 1'b1;
            end
            default:alu_c = 32'd0;
        endcase
    end
endmodule
