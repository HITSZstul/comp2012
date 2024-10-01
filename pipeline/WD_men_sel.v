`timescale 1ns / 1ps
module WD_men_sel(

        input wire [1:0] men_rf_wsel,
        input wire [31:0]dram_rd,
        input wire [31:0]ex_wd,  
       
        output reg [31:0]men_wd
    );
    
    always@(*)begin
        if(men_rf_wsel==`WB_DAM)
            men_wd = dram_rd;
        else
            men_wd = ex_wd;
    end
    
endmodule
