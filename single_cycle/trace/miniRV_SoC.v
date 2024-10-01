`timescale 1ns / 1ps
`include "defines.vh"

    module miniRV_SoC (
    input  wire         fpga_rst,   // High active
    input  wire         fpga_clk,

    input  wire [23:0]  sw,
    input  wire [ 4:0]  button,
    output wire [ 7:0]  dig_en,
    output wire         DN_A,
    output wire         DN_B,
    output wire         DN_C,
    output wire         DN_D,
    output wire         DN_E,
    output wire         DN_F,
    output wire         DN_G,
    output wire         DN_DP,
    output wire [23:0]  led

`ifdef RUN_TRACE
    ,// Debug Interface
    output wire         debug_wb_have_inst, // ??????????????????�1�7�1�7?? (???????CPU???????�1�7�1�7?????1)
    output wire [31:0]  debug_wb_pc,        // ???�1�7�1�7???????PC (??wb_have_inst=0?????????????)
    output              debug_wb_ena,       // ???�1�7�1�7?????????????�1�7�1�7??? (??wb_have_inst=0?????????????)
    output wire [ 4:0]  debug_wb_reg,       // ???�1�7�1�7?????�1�7�1�7????????? (??wb_ena??wb_have_inst=0?????????????)
    output wire [31:0]  debug_wb_value      // ???�1�7�1�7?????�1�7�1�7????????? (??wb_ena??wb_have_inst=0?????????????)
`endif
);
    wire        pll_lock;
    wire        pll_clk;
    wire        cpu_clk;

    // Interface between CPU and IROM
`ifdef RUN_TRACE
    wire [15:0] inst_addr;
`else
    wire [13:0] inst_addr;
`endif
    wire [31:0] inst;
    wire [31:0] inst_addr_pro={16'b0,inst_addr};

    
    // Interface between bridge and peripherals
    // TODO: ??????????????????I/O????�1�7�1�7???????????
    //
    
    
`ifdef RUN_TRACE
    // Trace??????????????????????
    assign cpu_clk = fpga_clk;
`else
    // ?�1�7�1�7???????PLL?????????
    assign cpu_clk = pll_clk & pll_lock;
    cpuclk Clkgen (
        // .resetn     (!fpga_rst),
        .clk_in1    (fpga_clk),
        .clk_out1   (pll_clk),
        .locked     (pll_lock)
    );
`endif
    wire [31:0] alu_c;
    wire [31:0] dram_rd;
    wire [31:0] rD2;
    wire dram_we;
    
    myCPU Core_cpu (
        .cpu_rst            (fpga_rst),
        .cpu_clk            (cpu_clk),

        // Interface to IROM
        .inst_addr(inst_addr),
        .inst(inst),

        .dram(dram_rd),
        .rD2(rD2),
        .alu_c(alu_c),
        .ram_we(dram_we),

`ifdef RUN_TRACE
        ,// Debug Interface
        .debug_wb_have_inst (debug_wb_have_inst),
        .debug_wb_pc        (debug_wb_pc),
        .debug_wb_ena       (debug_wb_ena),
        .debug_wb_reg       (debug_wb_reg),
        .debug_wb_value     (debug_wb_value)
`endif
    );
    IROM Mem_IROM (
        .a          (inst_addr_pro[17:2]),
        .spo        (inst)
    );
    DRAM Mem_DRAM (
        .clk        (cpu_clk),
        .a          (alu_c[15:2]),  //默认偏移4位
        .spo        (dram_rd),
        .we         (dram_we),
        .d          (rD2)
    );
    
    // TODO: ???????????????I/O????�1�7�1�7???
    //


endmodule
