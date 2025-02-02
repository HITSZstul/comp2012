`timescale 1ns / 1ps
module PC(
    input wire rst,
    input wire [31:0] din,
    input wire clk,
    output reg [31:0] pc
    );
    reg flag;
always @(posedge clk or posedge rst)begin
    if(rst)begin
        pc <= 32'b0;
        flag <= 1'b0;
    end
    else begin
        if(flag)begin
            pc <= din;
        end
        else begin
            flag <= 1'b1;
        end
    end
end

endmodule
