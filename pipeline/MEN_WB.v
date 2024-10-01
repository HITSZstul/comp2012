`timescale 1ns / 1ps
module MEN_WB(
        input wire clk       ,
        input wire rst       ,
                             
        input wire [31:0] men_wD    ,
        input wire [4:0]  men_wR    ,
        input wire        men_rf_we ,
                             
        output reg [31:0] wb_wD     ,
        output reg [4:0]  wb_wR     ,
        output reg        wb_rf_we  
    );
    
    always@(posedge clk or posedge rst)begin
        if(rst)begin
            wb_rf_we <= 1'd0;
        end
        else begin
            wb_rf_we <= men_rf_we;
        end
    end
    
    always@(posedge clk or posedge rst)begin
        if(rst)begin
            wb_wD <= 32'd0;
        end
        else begin
            wb_wD <= men_wD;
        end
    end
    
    always@(posedge clk or posedge rst)begin
        if(rst)begin
            wb_wR <= 5'd0;
        end
        else begin
            wb_wR <= men_wR;
        end
    end
endmodule
