// convert 100MHz clock signal on Basys 3 board to 1Hz signal 
// to blink an arbitrary LED once a second.

`timescale 1ns/1ps

module blink (
    input i_clk_100MHz,
    output reg o_clk_1Hz
);
    // (100MHz * 50% duty cycle)-1, counter 0 to 49,999,999
    parameter COUNT_TO = ((100_000_000 / 2) - 1);

    reg [31:0] counter = 0;

    always @(posedge i_clk_100MHz) begin
        if (counter == COUNT_TO) begin
            counter <= 0;
            o_clk_1Hz <= ~o_clk_1Hz;
        end
        else begin
            counter <= counter + 1;
        end
    end

endmodule
