
module NPC(
    input wire [1:0] npc_op,
    input wire [31:0] pc,
    input wire [31:0] alu_c,
    input wire [31:0] offset,
    input wire br,
    
    output reg [31:0]pc4,
    output reg [31:0]npc
    );
    always @(*)begin
        pc4 = pc + 4;  
    end
    
    always @(*)begin
        case(npc_op)
            `NPC_PC4: npc = pc + 32'd4;                //pc+4
            `NPC_JMP: npc = alu_c;                     //jal  alu_c
            `NPC_BEQ: npc = br ? (pc+offset) : (pc+4); //beq    pc + offset
            `NPC_ALU: npc = alu_c;                     //jalr 
            default: npc = pc + 4;
        endcase
    end
endmodule
