`timescale 1ns / 1ps
module NPC_control(
    input wire[1:0] npc_sel,
    input wire      f,
    input wire[31:0]alu,
    input wire[31:0] pc_imm,
    
    output reg      flag,
    output reg[31:0]npc_change
    );
    
    always @(*)begin
        case(npc_sel)                                        
            `NPC_JMP: begin npc_change = pc_imm;             flag = 1;end
            `NPC_ALU: begin npc_change = {alu[31:1], 1'b0};  flag = 1;end // jalr: rd1 + imm
            `NPC_BEQ: begin npc_change = pc_imm;             flag = f ? 1'b1 : 1'b0;end
            default: flag = 1'b0;
        endcase
    end
endmodule
