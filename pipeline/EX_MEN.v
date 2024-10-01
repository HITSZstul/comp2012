`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/23 10:51:06
// Design Name: 
// Module Name: EX_MEN
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module EX_MEN(
    input wire clk,
    input wire rst,

    input wire [1:0]    ex_rf_wsel       ,
    input wire          ex_rf_we         ,
    input wire          ex_ram_we        ,
    input wire [31:0]   ex_alu    ,  
    input wire [31:0]   ex_wd     ,  
    input wire [4:0]    ex_wR      , 
    input wire [31:0]   ex_rD2       ,  
                
    output reg [1:0]  men_rf_wsel                  ,
    output reg        men_rf_we                    ,
    output reg        men_ram_we                   ,
    output reg [31:0] men_alu                      ,
    output reg [31:0] men_wd                       ,
    output reg [4:0]  men_wR                       ,
    output reg [31:0] men_rD2                          
    );
    
    always@(posedge clk or posedge rst)begin
        if(rst)begin
            men_wR <= 4'd0;
        end
        else begin
            men_wR <= ex_wR;
        end
    end
    
    always@(posedge clk or posedge rst)begin
        if(rst)begin
            men_rD2 <= 32'd0;
        end
        else begin
            men_rD2 <= ex_rD2;
        end
    end
    
    always@(posedge clk or posedge rst)begin
        if(rst)begin
            men_wd <= 32'd0;
        end
        else begin
            men_wd <= ex_wd;
        end
    end
    
    always@(posedge clk or posedge rst)begin
        if(rst)begin
            men_alu <= 32'd0;
        end
        else begin
            men_alu <= ex_alu;
        end
    end
    
    always@(posedge clk or posedge rst)begin
        if(rst)begin
            men_ram_we <= 1'd0;
        end
        else begin
            men_ram_we <= ex_ram_we;
        end
    end
    
    always@(posedge clk or posedge rst)begin
        if(rst)begin
            men_rf_we <= 1'd0;
        end
        else begin
            men_rf_we <= ex_rf_we;
        end
    end
    
    always@(posedge clk or posedge rst)begin
        if(rst)begin
            men_rf_wsel <= 4'd0;
        end
        else begin
            men_rf_wsel <= ex_rf_wsel;
        end
    end
endmodule
