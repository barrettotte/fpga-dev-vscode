// convert 100MHz clock signal on Basys 3 board to 1Hz signal 
// to blink an arbitrary LED once a second.

`timescale 1ns/1ps

module blink (
    input i_clk_100MHz,
    input i_clr,
    output reg o_clk_1Hz
);
    // (100MHz * 50% duty cycle)-1, counter 0 to 49,999,999
    parameter COUNT_TO = ((100_000_000 / 2) - 1);

    reg [31:0] counter;

    always @(posedge i_clk_100MHz) begin
        if (i_clr) begin
            counter <= 0;
            o_clk_1Hz <= 0;
        end else if (counter == COUNT_TO) begin
            o_clk_1Hz <= ~o_clk_1Hz;
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end

endmodule
