`timescale 1ns / 1ps

`include "defines.vh"

module myCPU (
    input  wire         cpu_rst,
    input  wire         cpu_clk,

    // Interface to IROM
`ifdef RUN_TRACE
    output wire [15:0]  inst_addr,
`else
    output wire [13:0]  inst_addr,
`endif

    input  wire [31:0]  inst,
    
    input  wire [31:0]  dram,
    output wire [31:0]  alu_c,
    output wire [31:0]  rD2,
    output wire         ram_we,
    
    // Interface to Bridge
    output wire [31:0]  Bus_addr,
    input  wire [31:0]  Bus_rdata,
    output wire         Bus_we,
    output wire [31:0]  Bus_wdata

`ifdef RUN_TRACE
    ,// Debug Interface
    output wire         debug_wb_have_inst,
    output wire [31:0]  debug_wb_pc,
    output              debug_wb_ena,
    output wire [ 4:0]  debug_wb_reg,
    output wire [31:0]  debug_wb_value
`endif
);

    // TODO: 完成你自己的单周期CPU设计
    //
    wire [1:0]  npc_op;
    wire        rf_we;
    wire [1 :0] rf_wsel;
    wire [2 :0] sext_op;
    wire [3 :0] alu_op;
    wire   alu_opA_sel;
    wire   alu_opB_sel;
    
    wire [31:0] wD;
    wire [31:0] rD1;

    wire [31:0] imm;
    wire [31:0] pc;
    wire [31:0] npc;
    wire [31:0] pc4;
    wire f;
    
    assign inst_addr = pc[15:0];

    control u_control(
        .inst(inst),
        .f(f),
        
        .npc_op(npc_op),
        .rf_we(rf_we),
        .rf_wsel(rf_wsel),
        .sext_op(sext_op),
        .alu_op(alu_op),
        .alu_opA_sel(alu_opA_sel),
        .alu_opB_sel(alu_opB_sel),
        .ram_we(ram_we)
    );
    
    ALU u_ALU(
       .rD1(rD1), 
       .rD2(rD2), 

       .ext(imm), 
       .pc(pc),  
       
       .alu_op(alu_op),   
       .op_A_sel(alu_opA_sel),   
       .op_B_sel(alu_opB_sel),   
                       
       .f(f),          
       .alu_c(alu_c)
    );
    
    NPC u_NPC(
        .npc_op(npc_op),

        .pc(pc),
        .alu_c(alu_c),

        .offset(imm),
        .br(f),

        .pc4(pc4),
        .npc(npc)
    );
    
    PC u_PC(
        .rst(cpu_rst),
        .din(npc),
        .clk(cpu_clk),
        .pc(pc)
    );
    
    RF u_RF(
        .clk(cpu_clk),
        .rst(cpu_rst),

        .rR1(inst[19:15]),
        .rR2(inst[24:20]),
        .wR(inst[11:7]),

        .imm(imm),
        .pc4(pc4),
        .alu_c(alu_c),
        .dram(dram),
       
        .we(rf_we),
        .rf_wsel(rf_wsel),

        .wD(wD),
        .rD1(rD1),
        .rD2(rD2)
    );
    
    SEXT u_SEXT(
        .sext_op(sext_op),
        .din(inst[31:7]),
        
        .ext(imm)
    );

`ifdef RUN_TRACE
    // Debug Interface
    assign debug_wb_have_inst = 1'b1 /* TODO */; 
    assign debug_wb_pc        = pc   /* TODO */;
    assign debug_wb_ena       = rf_we /* TODO */;
    assign debug_wb_reg       = inst[11:7] /* TODO */;
    assign debug_wb_value     = wD /* TODO */;
`endif

endmodule
