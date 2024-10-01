`timescale 1ns / 1ps
`include "defines.vh"
module control#(
    parameter R =    7'b0110011,
    parameter I =    7'b0010011,
    parameter LW =   7'b0000011,
    parameter JALR = 7'b1100111,
    parameter SW =   7'b0100011,
    parameter B =    7'b1100011,
    parameter U =    7'b0110111,
    parameter J =    7'b1101111
    )(
    input wire [31:0] inst,
    input wire f,
    
    output reg [1:0] npc_op,
    output reg        rf_we,
    output reg [1 :0] rf_wsel,
    output reg [2 :0] sext_op,
    output reg [3 :0] alu_op,
    output reg   alu_opA_sel,
    output reg   alu_opB_sel,
    output reg        ram_we
    );
    

    wire [6:0]opcode = inst[6:0];
    wire [2:0]func3 = inst[14:12];
    wire [6:0]func7 = inst[31:25];
    
    //???npc?????npc_op
    always@(*)begin
        case(opcode)
            R: npc_op = `NPC_PC4;
            I: npc_op = `NPC_PC4;
            LW: npc_op = `NPC_PC4;
            JALR: npc_op = `NPC_ALU;
            SW: npc_op = `NPC_PC4;
            B: npc_op = f?`NPC_BEQ:`NPC_PC4;
            U: npc_op = `NPC_PC4;
            J: npc_op = `NPC_JMP;
            default: npc_op = `NPC_PC4;
        endcase    
    end
    
    
    //???alu?????
    always @(*) begin
        case(opcode)
            R:    
                case(func3)
                    3'b000:  alu_op = (func7==7'b00000000)? `ALU_ADD : `ALU_SUB;
                    3'b111:  alu_op = `ALU_AND;
                    3'b110:  alu_op = `ALU_OR; 
                    3'b100:  alu_op = `ALU_XOR;
                    3'b001:  alu_op = `ALU_SLL;
                    3'b101:  alu_op = (func7==7'b00000000)? `ALU_SRL : `ALU_SRA;
                    default: alu_op = `ALU_ADD;
                endcase
            I:  
                case(func3)
                    3'b000:  alu_op = `ALU_ADD;
                    3'b111:  alu_op = `ALU_AND;
                    3'b110:  alu_op = `ALU_OR; 
                    3'b100:  alu_op = `ALU_XOR;
                    3'b001:  alu_op = `ALU_SLL;
                    3'b101:  alu_op = (func7==7'b00000000)? `ALU_SRL : `ALU_SRA;
                    default: alu_op = `ALU_ADD;
                endcase  
            LW:   alu_op = `ALU_ADD;
            JALR: alu_op = `ALU_ADD;
            SW:   alu_op = `ALU_ADD;
            B:  begin
                case(func3)
                    3'b000:  alu_op = `ALU_BEQ;
                    3'b001:  alu_op = `ALU_BNE; 
                    3'b100:  alu_op = `ALU_BLT;
                    3'b101:  alu_op = `ALU_BGE;
                    default: alu_op = `ALU_ADD;
                endcase
            end
            default: alu_op = `ALU_ADD;
        endcase
    end
    //???sext?????
    always@(*)begin
        case(opcode)
            I: begin
                case(func3)
                    3'b000:  sext_op = `SEXT_I;
                    3'b111:  sext_op = `SEXT_I;
                    3'b110:  sext_op = `SEXT_I; 
                    3'b100:  sext_op = `SEXT_I;
                    3'b010:  sext_op = `SEXT_I;
                    3'b001:  sext_op = `SEXT_SHIFT;
                    3'b101:  sext_op = `SEXT_SHIFT;
                    default: sext_op = `SEXT_I;
                endcase
            end
            LW:   sext_op = `SEXT_I;
            JALR: sext_op = `SEXT_I; 
            SW:   sext_op = `SEXT_S;
            B:    sext_op = `SEXT_B;
            U:    sext_op = `SEXT_U;
            J:    sext_op = `SEXT_J;
            default: sext_op = `SEXT_I;
        endcase
    end
    
    //???alu????????
    always@(*)begin
        case(opcode)
            R:   begin alu_opA_sel = `ALU_A_rD1; alu_opB_sel = `ALU_B_rD2;end
            I:   begin alu_opA_sel = `ALU_A_rD1; alu_opB_sel = `ALU_B_EXT;end
            LW:  begin alu_opA_sel = `ALU_A_rD1; alu_opB_sel = `ALU_B_EXT;end 
            JALR:begin alu_opA_sel = `ALU_A_rD1; alu_opB_sel = `ALU_B_EXT;end
            SW:  begin alu_opA_sel = `ALU_A_rD1; alu_opB_sel = `ALU_B_EXT;end 
            B:   begin alu_opA_sel = `ALU_A_rD1; alu_opB_sel = `ALU_B_rD2;end 
            U:   begin alu_opA_sel = `ALU_A_rD1; alu_opB_sel = `ALU_B_rD2;end 
            J:   begin alu_opA_sel = `ALU_A_PC;  alu_opB_sel = `ALU_B_EXT;end
            default: begin alu_opA_sel = `ALU_A_rD1;alu_opB_sel = `ALU_B_rD2;end   
        endcase
    end
    
    //DRAM???§Õ????
    always@(*)begin
        if(opcode == SW) begin
            ram_we = `DRAM_WRITE;
        end else begin
            ram_we = `DRAM_READ;
        end
    end
    
    //RF???§Õ????
    always@(*)begin
        case(opcode)
            SW: rf_we = `RF_READ;
            B: rf_we = `RF_READ;
            default: rf_we = `RF_WRITE;
        endcase
    end
    
    //§Õ??Rf??????
    always@(*)begin
        case(opcode)
            R: rf_wsel = `WB_ALU;
            I: rf_wsel = `WB_ALU;
            SW: rf_wsel = `WB_EXT;
            JALR: rf_wsel = `WB_PC4;
            LW: rf_wsel = `WB_DAM;
            U: rf_wsel = `WB_EXT;
            J: rf_wsel = `WB_PC4;
            default: rf_wsel = `WB_ALU;
        endcase
    end
endmodule
