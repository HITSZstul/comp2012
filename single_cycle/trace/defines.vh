// Annotate this macro before synthesis
`define RUN_TRACE

// TODO: �ڴ˴�������ĺ�
// 

// ����I/O�ӿڵ�·�Ķ˿ڵ�ַ
`define PERI_ADDR_DIG   32'hFFFF_F000
`define PERI_ADDR_LED   32'hFFFF_F060
`define PERI_ADDR_SW    32'hFFFF_F070
`define PERI_ADDR_BTN   32'hFFFF_F078

//npc�Ŀ����ź�
`define NPC_PC4 2'b00
`define NPC_JMP 2'b01
`define NPC_BEQ 2'b10
`define NPC_ALU 2'b11


//RFѡ���ź�
`define WB_ALU 2'b00
`define WB_EXT 2'b01
`define WB_PC4 2'b10
`define WB_DAM 2'b11

//sext�����ź�op
`define SEXT_I 3'b000    
`define SEXT_B 3'b001    
`define SEXT_S 3'b010    
`define SEXT_J 3'b011    
`define SEXT_U 3'b100    
`define SEXT_SHIFT 3'b101

//alu�������
`define ALU_ADD 4'b0000
`define ALU_SUB 4'b0001
`define ALU_SLL 4'b0010
`define ALU_SRL 4'b0011
`define ALU_SRA 4'b0100
`define ALU_OR  4'b0101
`define ALU_AND 4'b1011
`define ALU_XOR 4'b0110
`define ALU_BEQ 4'b0111
`define ALU_BLT 4'b1000
`define ALU_BNE 4'b1001
`define ALU_BGE 4'b1010

//aluѡ���ź�
`define ALU_A_rD1 1'b1
`define ALU_A_PC  1'b0
`define ALU_B_rD2 1'b1
`define ALU_B_EXT 1'b0

//DRAM�Ķ�д�����ź�
`define DRAM_WRITE 1'b1
`define DRAM_READ  1'b0

//RF�����ź�
`define RF_READ 1'b0
`define RF_WRITE 1'b1

