`timescale 1ns / 1ps

module num_to_led(
    input wire [3:0] data,
    output reg [8:0] led
    );
    
    always@(*)begin
        case(data)
            4'd0:   led <= 8'b0000_0011;
            4'd1:   led <= 8'b1001_1111;
            4'd2:   led <= 8'b0010_0101;
            4'd3:   led <= 8'b0000_1101;
            4'd4:   led <= 8'b1001_1001;
            4'd5:   led <= 8'b0100_1001;
            4'd6:   led <= 8'b0100_0001;
            4'd7:   led <= 8'b0001_1111;
            4'd8:   led <= 8'b0000_0001;
            4'd9:   led <= 8'b0001_1001;
            4'd10:  led <= 8'b0001_1001;
            4'd11:  led <= 8'b1100_0001;
            4'd12:  led <= 8'b1110_0101;
            4'd13:  led <= 8'b1000_0101;
            4'd14:  led <= 8'b0110_0001;
            4'd15:  led <= 8'b0111_0001;
            default: led <= 8'b1111_1111;
        endcase
    end
endmodule




















