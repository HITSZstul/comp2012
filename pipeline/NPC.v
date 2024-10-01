
module NPC(
    //input wire [1:0] npc_op,
    input wire        flag,
    input wire [31:0] pc,
    input wire [31:0] npc_change,
    //input wire [31:0] alu_c,
    //input wire [31:0] offset,
    //input wire br,
    
    output wire [31:0]pc4,
    output wire [31:0]npc
    );
    assign pc4 = pc + 4;
    
    assign npc = flag ? npc_change : pc + 4;
//   always @(*)begin
//       case(npc_op)
//           `NPC_PC4: npc = pc + 32'd4;                //pc+4
//           `NPC_JMP: npc = alu_c;                     //jal  alu_c 换成pc+offest
//           `NPC_BEQ: npc = br ? (pc+offset) : (pc+4); //beq    pc + offset
//           `NPC_ALU: npc = alu_c;                     //jalr  这里需要用到r+offest
//           default: npc = pc + 4;
//       endcase
//   end
endmodule
