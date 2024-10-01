`timescale 1ns / 1ps
module IF_ID(
    input wire clk,
    input wire rst,
    
    input wire [31:0] if_pc,
    input wire [31:0] if_inst,
    input wire [31:0] if_pc4,
    
    output reg [31:0] id_pc,
    output reg [31:0] id_inst,
    output reg [31:0] id_pc4
    );
    
    always@(posedge clk or posedge rst)begin
        if(rst)begin
            id_pc <= 32'd0;
        end
        else begin
            id_pc <= if_pc;
        end
    end
    
    always@(posedge clk or posedge rst)begin
        if(rst)begin
            id_pc4 <= 32'd0;
        end
        else begin
            id_pc4 <= if_pc4;
        end
    end
    
    always@(posedge clk or posedge rst)begin
        if(rst)begin
            id_inst <= 32'd0;
        end
        else begin
            id_inst <= if_inst;
        end
    end
endmodule
