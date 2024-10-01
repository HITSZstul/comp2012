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
    
    // Interface to Bridge
    output wire [31:0]  Dram_addr,
    input  wire [31:0]  Dram_rdata,
    
    output wire         Dram_we,
    output wire [31:0]  Dram_wdata

`ifdef RUN_TRACE
    ,// Debug Interface
    output wire         debug_wb_have_inst,
    output wire [31:0]  debug_wb_pc,
    output               debug_wb_ena,
    output wire [ 4:0]  debug_wb_reg,
    output wire [31:0]  debug_wb_value
`endif
);

    // TODO: 完成你自己的单周期CPU设计
    //
    wire [1:0]  npc_op;
    wire        rf_we;
    wire        ram_we;
    wire [1 :0] rf_wsel;
    wire [2 :0] sext_op;
    wire [3 :0] alu_op;
    //wire   alu_opA_sel;
    wire   alu_opB_sel;
    
    wire [31:0] wD;
    wire [31:0] rD1;
    wire [31:0] rD2;
    wire [31:0] alu_c;
    
    wire [31:0] imm;
    wire [31:0] pc;
    wire [31:0] npc;
    wire [31:0] pc4;
    wire f;
    
    assign inst_addr = pc[15:0];
    
    wire [31:0] if_pc;
    wire [31:0] if_pc4;
    //wire [31:0] if_inst;
    
    wire [31:0] id_pc;
    wire [31:0] id_pc4;
    wire [31:0] id_inst;
    
    PC u_PC(
        .rst(cpu_rst),
        .din(npc),
        .clk(cpu_clk),
        .pc(if_pc)
    );
    
    NPC u_NPC(
        .flag   (npc_op),
        .npc_change(npc_change),//ex阶段赋值
        .pc (if_pc),
        //.alu_c(alu_c),

        //.offset(imm),
        //.br(f),

        .pc4(if_pc4),
        .npc(npc)
    );
    
    IF_ID u_IF_ID(
        .clk(cpu_clk),
        .rst(cpu_rst),
        
        .if_pc(if_pc),
        .if_inst(inst),
        .if_pc4(if_pc4),
        
        .id_pc(id_pc),
        .id_pc4(id_pc4),
        .id_inst(id_inst)
    );
    //在if阶段获得pc和pc4，暂时不考虑跳转和分支
    //修改npc的获得JMP的方法，在npc内部执行PC+offest的运算，在if阶段获得j指令的npc
    
    //ID_EX 传递参数有op_A,op_B,rD2,
    //pc+4,imm,j_imm,rD1
    //alu_op,branch,menwirte,pc_sel,men_to_reg
    
    //id阶段
    
    //控制信号
    wire [31:0] id_pc_imm;//J型指令跳转计算结果，jal or jalr
    wire [3:0]  id_alu_op;
    wire        alu_opB_sel;
    wire        id_ram_we;
    wire        id_rf_we;
    wire [1:0]  id_rf_wsel;
    
    //数据信号
    wire [4:0]  id_wR;
    //wire        id_we;
    wire [31:0] id_imm;
    wire [31:0] id_op_A;
    wire [31:0] id_op_B;
    wire [31:0] id_rD2;
    wire [1:0]  id_npc_sel;
    
    
     //控制信号
    
    wire [31:0] ex_pc_imm;//J型指令跳转计算结果，jal or jalr
    wire [3:0]  ex_alu_op;
    wire        ex_ram_we;
    wire        ex_rf_we;
    wire [1:0]  ex_rf_wsel;
    
    //数据信号
    wire [31:0] ex_pc4;
    wire [4:0]  ex_wR;
    //wire        ex_we;
    wire [31:0] ex_imm;
    wire [31:0] ex_op_A;
    wire [31:0] ex_op_B;
    wire [31:0] ex_rD2;
    wire [1:0]  ex_npc_sel;
    
    control u_control(
        .inst       (id_inst),
        //.f(f),
        
        .npc_sel    (id_npc_sel),
        //.npc_op     (npc_op),
        .rf_we      (id_rf_we),
        .rf_wsel    (id_rf_wsel),//写入寄存器
        .sext_op    (sext_op),
        .alu_op     (alu_op),
        //.alu_opA_sel(alu_opA_sel),
        .alu_opB_sel(alu_opB_sel),
        .ram_we     (id_ram_we)
    );
    
    SEXT u_SEXT(
        .pc         (id_pc),
        .sext_op    (sext_op),
        .din        (id_inst[31:7]),
        
        .ext        (id_imm),
        .pc_imm     (id_pc_imm)
    );
    
    wire [31:0] wb_wD;
    wire [4:0]  wb_wR;
    wire        wb_rf_we;
    RF u_RF(
        .clk        (cpu_clk),
        .rst        (cpu_rst),
        
        .rR1        (id_inst[19:15]),
        .rR2        (id_inst[24:20]),
        .wR         (wb_wR),    //WB
        .op_B_sel   (alu_opB_sel),
        //***************************
        .imm        (id_imm),
        //**************************    WB
        //.pc4        (pc4),
        //.alu_c      (alu_c),
        //.dram       (Bus_rdata),在后续选择写入
       
        .we         (wb_rf_we),//WB

        .wD         (wb_wD),    //WB
        .rD1        (id_rD1),
        .rD2        (id_rD2),
        .op_A       (id_op_A),
        .op_B       (id_op_B)
    );
    
    assign id_wR = id_inst[11:7];
    
    ID_EX u_ID_EX(
         .clk          (cpu_clk),
         .rst          (cpu_rst),
    
         //.id_inst      (id_inst    )  ,
         .id_op_A      (id_op_A    )  ,
         .id_op_B      (id_op_B    )  ,
         .id_rD2       (id_rD2  )  ,
         .id_pc4       (id_pc4     )  ,
         .id_imm       (id_imm     )  ,
         .id_pc_imm    (id_pc_imm  )  ,
         .id_wR        (id_wR)        ,

         .id_alu_op    (id_alu_op  )  ,
         .id_ram_we    (id_ram_we   )  ,
         .id_npc_sel   (id_npc_sel  )  ,
         .id_rf_wsel   (id_rf_wsel )  ,
         .id_rf_we     (id_rf_we),

         //. ex_inst     ( ex_inst   )  ,
         . ex_op_A     ( ex_op_A   )  ,
         . ex_op_B     ( ex_op_B   )  ,
         . ex_rD2      ( ex_rD2 )  ,
         . ex_pc4      ( ex_pc4    )  ,
         . ex_imm      ( ex_imm    )  ,
         . ex_pc_imm   ( ex_pc_imm )  ,
         . ex_wR       ( ex_wR     )  ,
         . ex_rf_we    ( ex_rf_we),
         
         . ex_alu_op   ( ex_alu_op )  ,
         . ex_ram_we   ( ex_ram_we  )  ,
         . ex_npc_sel  ( ex_npc_sel )  ,
         . ex_rf_wsel  ( ex_rf_wsel )  
    );
    
    
    //data
    wire [31:0] ex_alu_c;
    wire        ex_f;
    
    ALU u_ALU(
       .op_A(ex_op_A), 
       .op_B(ex_op_B), 
       
       .alu_op(ex_alu_op),      
                       
       .f(ex_f),          
       .alu_c(alu_c)
    );
    
    NPC_control u_NPC_control(
        .npc_sel        (ex_npc_sel),
        .f              (ex_f),
        .alu            (ex_alu),
        .pc_imm         (ex_pc_imm),
        
        .flag           (npc_op),
        .npc_change     (npc_change)
    );
    wire [31:0] ex_wd;
    wire [31:0] men_wd_temp;
    wire [1:0]  men_rf_wsel;
    wire        men_rf_we;
    wire        men_ram_we;
    wire [31:0] men_alu;
    wire [31:0] men_wd;
    wire [4:0]  men_wR;
    wire [31:0] men_rD2;
    
    WD u_WD(
        .wd_sel         (ex_rf_wsel),
        .alu_c          (ex_alu),
        .pc4            (ex_pc4),
        .imm            (ex_imm),
        
        .wd             (ex_wd)
    );
    
    EX_MEN u_EX_MEN(
        .clk            (cpu_clk),
        .rst            (cpu_rst),
    
        .ex_rf_wsel     (ex_rf_wsel),
        .ex_rf_we       (ex_rf_we),
        .ex_ram_we      (ex_ram_we),
        .ex_alu         (ex_alu),
        .ex_wd          (ex_wd),
        .ex_wR          (ex_wR),
        .ex_rD2            (ex_rD2),
        
        .men_rf_wsel     (men_rf_wsel),
        .men_rf_we       (men_rf_we),
        .men_ram_we      (men_ram_we),
        .men_alu         (men_alu),
        .men_wd          (men_wd_temp),
        .men_wR          (men_wR),
        .men_rD2             (men_rD2)
    );
    
    WD_men_sel u_WD_men_sel(
        .men_rf_wsel(men_rf_wsel),
        .dram_rd    (Dram_rdata),
        .ex_wd      (men_wd_temp),
        
        .men_wd     (men_wd)
    );
    
    
    
    MEN_WB u_MEN_WB(
        .clk         (cpu_clk),
        .rst         (cpu_rst),
        
        .men_wD     (men_wd),
        .men_wR     (men_wR),
        .men_rf_we  (men_rf_we),
        
        .wb_wD      (wb_wD),
        .wb_wR      (wb_wR),
        .wb_rf_we   (wb_rf_we)
    );
    
`ifdef RUN_TRACE
    // Debug Interface
    assign debug_wb_have_inst = 1'b1 /* TODO */; 
    assign debug_wb_pc        = pc   /* TODO */;
    assign debug_wb_ena       = rf_we /* TODO */;
    assign debug_wb_reg       = inst[11:7] /* TODO */;
    assign debug_wb_value     = wD /* TODO */;
`endif

    assign Dram_addr = men_alu;
    assign Dram_wdata = men_rD2;
    assign Dram_we = men_ram_we;

endmodule
