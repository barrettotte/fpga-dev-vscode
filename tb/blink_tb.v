`timescale 1ns/1ps
`include "rtl/blink.v"

module blink_tb;

    // inputs
    reg clk_100M;

    // outputs
    wire clk_1;

    // design under test
    blink DUT(
        .i_clk_100MHz(clk_100M), 
        .o_clk_1Hz(clk_1)
    );

    // generate 100MHz clock signal (10ns period)
    initial begin
        clk_100M = 0;
        forever #5 clk_100M = ~clk_100M;
    end

    initial begin
        $dumpfile("blink_tb.vcd");
        $dumpvars(0, blink_tb);
        $monitor($time, " clk_1=%b", clk_1);

        #(1_000_000_000); // expected: clk_1 on
        #(1_000_000_000); // expected: clk_1 off
        #(1_000_000_000); // expected: clk_1 on

        $finish;
        $display("Testbench completed");
    end

endmodule
