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
    output wire         debug_wb_have_inst, // ???????????????????1?7?1?7?? (???????CPU????????1?7?1?7?????1)
    output wire [31:0]  debug_wb_pc,        // ????1?7?1?7???????PC (??wb_have_inst=0?????????????)
    output              debug_wb_ena,       // ????1?7?1?7??????????????1?7?1?7??? (??wb_have_inst=0?????????????)
    output wire [ 4:0]  debug_wb_reg,       // ????1?7?1?7??????1?7?1?7????????? (??wb_ena??wb_have_inst=0?????????????)
    output wire [31:0]  debug_wb_value      // ????1?7?1?7??????1?7?1?7????????? (??wb_ena??wb_have_inst=0?????????????)
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
    
    // Interface between CPU and Bridge
    wire [31:0] Bus_rdata;
    wire [31:0] Bus_addr;
    wire        Bus_we;
    wire [31:0] Bus_wdata;
    
    // Interface between bridge and DRAM
    // wire         rst_bridge2dram;
    wire         clk_bridge2dram;
    wire [31:0]  addr_bridge2dram;
    wire [31:0]  rdata_dram2bridge;
    wire         we_bridge2dram;
    wire [31:0]  wdata_bridge2dram;
    
    //to dig
    wire rst_to_dig;
    wire clk_to_dig;
    wire [31:0]  addr_to_dig;
    wire         we_to_dig;
    wire [31:0]  wdata_to_dig;
    
    //Interface to LEDs
    wire         rst_to_led;  
    wire         clk_to_led;  
    wire [31:0]  addr_to_led; 
    wire         we_to_led;   
    wire [31:0]  wdata_to_led; 
    
    // Interface to switches
    wire         rst_to_sw;    
    wire         clk_to_sw;    
    wire [31:0]  addr_to_sw;   
    wire [31:0]  rdata_from_sw;
    
    // Interface to buttons
    wire         rst_to_btn;   
    wire         clk_to_btn;   
    wire [31:0]  addr_to_btn;  
    wire [31:0]  rdata_from_btn;
    // Interface between bridge and peripherals
    // TODO: ??????????????????I/O?????1?7?1?7???????????
    //
    
`ifdef RUN_TRACE
    // Trace??????????????????????
    assign cpu_clk = fpga_clk;
`else
    // ??1?7?1?7???????PLL?????????
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

        // Interface to Bridge
        .Bus_addr           (Bus_addr),
        .Bus_rdata          (Bus_rdata),
        .Bus_we             (Bus_we),
        .Bus_wdata          (Bus_wdata),
        
        // Interface to IROM
        .inst_addr(inst_addr),
        .inst(inst)

`ifdef RUN_TRACE
        ,// Debug Interface
        .debug_wb_have_inst (debug_wb_have_inst),
        .debug_wb_pc        (debug_wb_pc),
        .debug_wb_ena       (debug_wb_ena),
        .debug_wb_reg       (debug_wb_reg),
        .debug_wb_value     (debug_wb_value)
`endif
    );
    Bridge Bridge (       
        // Interface to CPU
        .rst_from_cpu       (fpga_rst),
        .clk_from_cpu       (cpu_clk),
        .addr_from_cpu      (Bus_addr),
        .we_from_cpu        (Bus_we),
        .wdata_from_cpu     (Bus_wdata),
        .rdata_to_cpu       (Bus_rdata),
        
        // Interface to DRAM
        // .rst_to_dram    (rst_bridge2dram),
        .clk_to_dram        (clk_bridge2dram),
        .addr_to_dram       (addr_bridge2dram),
        .rdata_from_dram    (rdata_dram2bridge),
        .we_to_dram         (we_bridge2dram),
        .wdata_to_dram      (wdata_bridge2dram),
        
        // Interface to 7-seg digital LEDs
        .rst_to_dig         (rst_to_dig),
        .clk_to_dig         (clk_to_dig),
        .addr_to_dig        (addr_to_dig),
        .we_to_dig          (we_to_dig),
        .wdata_to_dig       (wdata_to_dig),

        // Interface to LEDs
        .rst_to_led         (rst_to_led),
        .clk_to_led         (clk_to_led),
        .addr_to_led        (addr_to_led),
        .we_to_led          (we_to_led),
        .wdata_to_led       (wdata_to_led),

        // Interface to switches
        .rst_to_sw          (rst_to_sw),
        .clk_to_sw          (clk_to_sw),
        .addr_to_sw         (addr_to_sw),
        .rdata_from_sw      (rdata_from_sw),

        // Interface to buttons
        .rst_to_btn         (rst_to_btn),
        .clk_to_btn         (clk_to_btn),
        .addr_to_btn        (addr_to_btn),
        .rdata_from_btn     (rdata_from_btn)
    );
    IROM Mem_IROM (
        .a          (inst_addr_pro[17:2]),
        .spo        (inst)
    );
    wire [31:0] addr_bridge2dram_temp = addr_bridge2dram - 32'h4000;
    DRAM Mem_DRAM (
        .clk        (clk_bridge2dram),
        .a          (addr_bridge2dram_temp[15:2]),
        .spo        (rdata_dram2bridge),
        .we         (we_bridge2dram),
        .d          (wdata_bridge2dram)
    );
//    button u_button(
//        .rst_to_btn         (rst_to_btn),   
//        .clk_to_btn         (clk_to_btn),   
//        .addr_to_btn        (addr_to_btn), 
//        .button             (button), 
//        
//        .rdata_from_btn     (rdata_from_btn)
//    );
    
    led u_led(
        .rst_to_led         (rst_to_led),  
        .clk_to_led         (clk_to_led),  
        .addr_to_led        (addr_to_led),
        .led                (led), 
        .we_to_led          (we_to_led),   
        .wdata_to_led       (wdata_to_led)
    );
    
    switch u_switch(
        .rst_to_sw          (rst_to_sw),    
        .clk_to_sw          (clk_to_sw),    
        .addr_to_sw         (addr_to_sw), 
        .sw                 (sw),  
        .rdata_from_sw      (rdata_from_sw)
    );
    dig_led u_dig_led(
        .rst_to_dig         (rst_to_dig),  
        .clk_to_dig         (clk_to_dig),  
        .addr_to_dig        (addr_to_dig), 
        .we_to_dig          (we_to_dig),   
        .wdata_to_dig       (wdata_to_dig),
        
        .button             (button),
        .dig_en             (dig_en),
        .DN_A               (DN_A),
        .DN_B               (DN_B),
        .DN_C               (DN_C),
        .DN_D               (DN_D),
        .DN_E               (DN_E),
        .DN_F               (DN_F),
        .DN_G               (DN_G),
        .DN_DP              (DN_DP)
    );
    // TODO: ???????????????I/O?????1?7?1?7???
    //


endmodule
