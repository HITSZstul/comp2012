`timescale 1ns / 1ps
module dig_led(
    output reg DN_A, 
    output reg DN_B, 
    output reg DN_C, 
    output reg DN_D, 
    output reg DN_E, 
    output reg DN_F, 
    output reg DN_G, 
    output reg DN_DP,
    output reg [7:0]dig_en,
    
    input wire [3:0] button,
    input wire rst_to_dig,          
    input wire clk_to_dig,          
    input wire [31:0]  addr_to_dig, 
    input wire         we_to_dig,   
    input wire [31:0]  wdata_to_dig
    );
    
    wire [63:0] each_dig;
    reg [31:0] data;
    
    always@(posedge clk_to_dig or posedge rst_to_dig)begin
        if(rst_to_dig)begin
            data = 32'd0;
        end
        else if(button[0])
            data = 32'h1234_5678;
        else if(button[1])
            data = 32'h8123_4567;
        else if(button[2])
            data = 32'h7812_3456;
        else if(button[3])
            data = 32'h6781_2345;
        else if(we_to_dig && addr_to_dig == `PERI_ADDR_DIG)begin
            data = wdata_to_dig;
        end
        else
            data = data;
    end
    
    wire [31:0] data_wire = data;
    num_to_led u_num_to_led_0(.data(data_wire[3:0]),.led(each_dig[63:56]));
    num_to_led u_num_to_led_1(.data(data_wire[7:4]),.led(each_dig[55:48]));
    num_to_led u_num_to_led_2(.data(data_wire[11:8]),.led(each_dig[47:40]));
    num_to_led u_num_to_led_3(.data(data_wire[15:12]),.led(each_dig[39:32]));
    num_to_led u_num_to_led_4(.data(data_wire[19:16]),.led(each_dig[31:24]));
    num_to_led u_num_to_led_5(.data(data_wire[23:20]),.led(each_dig[23:16]));
    num_to_led u_num_to_led_6(.data(data_wire[27:24]),.led(each_dig[15:8]));
    num_to_led u_num_to_led_7(.data(data_wire[31:28]),.led(each_dig[7:0]));
    
    always@(*)begin
        case(dig_en)
            8'b1111_1110:{DN_A,DN_B,DN_C,DN_D,DN_E,DN_F,DN_G,DN_DP}=each_dig[63:56];
            8'b1111_1101:{DN_A,DN_B,DN_C,DN_D,DN_E,DN_F,DN_G,DN_DP}=each_dig[55:48];
            8'b1111_1011:{DN_A,DN_B,DN_C,DN_D,DN_E,DN_F,DN_G,DN_DP}=each_dig[47:40];
            8'b1111_0111:{DN_A,DN_B,DN_C,DN_D,DN_E,DN_F,DN_G,DN_DP}=each_dig[39:32];
            8'b1110_1111:{DN_A,DN_B,DN_C,DN_D,DN_E,DN_F,DN_G,DN_DP}=each_dig[31:24];
            8'b1101_1111:{DN_A,DN_B,DN_C,DN_D,DN_E,DN_F,DN_G,DN_DP}=each_dig[23:16];
            8'b1011_1111:{DN_A,DN_B,DN_C,DN_D,DN_E,DN_F,DN_G,DN_DP}=each_dig[15:8];
            8'b0111_1111:{DN_A,DN_B,DN_C,DN_D,DN_E,DN_F,DN_G,DN_DP}=each_dig[7:0];
            default:{DN_A,DN_B,DN_C,DN_D,DN_E,DN_F,DN_G,DN_DP}=8'b1111_1111;
        endcase
    end
    
    reg flag;
    wire flag_end;
    reg [24:0]count;
    always @(posedge clk_to_dig or posedge rst_to_dig) begin      
        if(rst_to_dig)              flag <= 1'b0;
        else                        flag <= 1'b1;
    end

    assign flag_end = flag & (count==25'd29999);
    
    always @(posedge clk_to_dig or posedge rst_to_dig) begin      
        if(rst_to_dig)     count <= 25'd0;
        else if(flag_end)   count <= 25'd0;
        else if(flag)     count <= count + 25'd1;
        else   count <= count;
    end

    always @(posedge clk_to_dig or posedge rst_to_dig) begin      //Ë¢ÐÂÆµÂÊÉèÖÃ2ms
        if(rst_to_dig)   dig_en <= 8'b1111_1110;
        else if(flag_end)    dig_en <= {dig_en[6:0],dig_en[7]};  
        else    dig_en <= dig_en;
    end
endmodule
