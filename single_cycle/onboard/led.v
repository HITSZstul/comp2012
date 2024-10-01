module led(
    input wire         rst_to_led,  
    input wire         clk_to_led,  
    input wire [31:0]  addr_to_led,
    output reg [23:0]  led, 
    input wire         we_to_led,   
    input wire [31:0]  wdata_to_led
    );
    
    always@(posedge rst_to_led or posedge clk_to_led)begin
        if(rst_to_led)begin
            led = 32'hffff;
        end
        else if(we_to_led && addr_to_led == `PERI_ADDR_LED)begin
            led = wdata_to_led[23:0];
        end
        else begin
            led = led;
        end
    end
endmodule

