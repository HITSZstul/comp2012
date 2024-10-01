`timescale 1ns / 1ps
    //ID_EX 传递参数有op_A,op_B,rD2,
    //pc+4,imm,j_imm,rD1
    //alu_op,branch,menwirte,pc_sel,men_to_reg
module ID_EX(
    input wire clk,
    input wire rst,
    //数据信号
    //input wire [31:0]   id_inst,
    input wire [31:0]   id_op_A,
    input wire [31:0]   id_op_B,
    input wire [31:0]   id_rD2,
    input wire [31:0]   id_pc4,
    input wire [31:0]   id_imm,
    input wire [31:0]   id_pc_imm,
    input wire [4:0]    id_wR,
    //控制信号
    input wire [3:0]    id_alu_op,
    input wire          id_ram_we,
    input wire          id_npc_sel,
    input wire [1:0]    id_rf_wsel,
    input wire          id_rf_we,
    
    
    //output reg [31:0]    ex_inst,
    output reg [31:0]    ex_op_A,
    output reg [31:0]    ex_op_B,
    output reg [31:0]    ex_rD2,
    output reg [31:0]    ex_pc4,
    output reg [31:0]    ex_imm,
    output reg [31:0]    ex_pc_imm,
    output reg [4:0]     ex_wR,
    
    output reg [3:0]     ex_alu_op,
    output reg           ex_ram_we,       
    output reg [1:0]     ex_npc_sel,
    output reg           ex_rf_we,
    output reg [1:0]     ex_rf_wsel     
    
    );
    always@(posedge clk or posedge rst)begin
        if(rst)begin
            ex_rf_wsel <= 2'd0;
        end
        else begin
            ex_rf_wsel <= id_rf_wsel;
        end
    end
    
    always@(posedge clk or posedge rst)begin
        if(rst)begin
            ex_rf_we <= 1'd0;
        end
        else begin
            ex_rf_we <= id_rf_we;
        end
    end
    
    always@(posedge clk or posedge rst)begin
        if(rst)begin
            ex_npc_sel <= 2'd0;
        end
        else begin
            ex_npc_sel <= id_npc_sel;
        end
    end
    
    always@(posedge clk or posedge rst)begin
        if(rst)begin
            ex_ram_we <= 32'd0;
        end
        else begin
            ex_ram_we <= id_ram_we;
        end
    end
    
    always@(posedge clk or posedge rst)begin
        if(rst)begin
            ex_alu_op <= 4'd0;
        end
        else begin
            ex_alu_op <= id_alu_op;
        end
    end
    
    always@(posedge clk or posedge rst)begin
        if(rst)begin
            ex_wR <= 32'd0;
        end
        else begin
            ex_wR <= id_wR;
        end
    end
    always@(posedge clk or posedge rst)begin
        if(rst)begin
            ex_op_A <= 32'd0;
        end
        else begin
            ex_op_A <= id_op_A;
        end
    end
    
    always@(posedge clk or posedge rst)begin
        if(rst)begin
            ex_op_B <= 32'd0;
        end
        else begin
            ex_op_B <= id_op_B;
        end
    end
    
    always@(posedge clk or posedge rst)begin
        if(rst)begin
            ex_rD2 <= 32'd0;
        end
        else begin
            ex_rD2 <= id_rD2;
        end
    end
    
    always@(posedge clk or posedge rst)begin
        if(rst)begin
            ex_pc4 <= 32'd0;
        end
        else begin
            ex_pc4 <= id_pc4;
        end
    end
    
    always@(posedge clk or posedge rst)begin
        if(rst)begin
            ex_imm <= 32'd0;
        end
        else begin
            ex_imm <= id_imm;
        end
    end
    
    always@(posedge clk or posedge rst)begin
        if(rst)begin
            ex_pc_imm <= 32'd0;
        end
        else begin
            ex_pc_imm <= id_pc_imm;
        end
    end
endmodule
