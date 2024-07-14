`include "../rtl/blink.v"
`timescale 1ns/1ps

module blink_tb;

    // inputs
    reg clk_100M = 0;
    reg clr = 0;

    // outputs
    wire clk_1;

    // design under test
    blink DUT(
        .i_clk_100MHz(clk_100M), 
        .i_clr(clr),
        .o_clk_1Hz(clk_1)
    );

    // generate 100MHz clock signal (10ns period)
    always #5 clk_100M = ~clk_100M;

    initial begin
        $dumpfile("blink_tb.vcd");
        $dumpvars(0, blink_tb);
        $monitor($time, " clk_1=%b", clk_1);

        // init
        clr = 0;
        #25 clr = 1;
        #25 clr = 0;

        wait_ms(50);

        $display("Simulation time: %t", $time);
        $display("Test finished.");
        #1 $finish;
    end

    task wait_ms;
        input integer t;
        begin
            repeat (t) begin
                # 1_000_000;
            end
        end
    endtask

endmodule
