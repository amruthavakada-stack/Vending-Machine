`timescale 1ns/1ps

module tb_vendingmachine;

    reg clk;
    reg reset;
    reg coin_5;
    reg coin_10;

    wire dispense;
    wire change_5;

    // Instantiate DUT
    vendingmachine uut (
        .clk(clk),
        .reset(reset),
        .coin_5(coin_5),
        .coin_10(coin_10),
        .dispense(dispense),
        .change_5(change_5)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin

        // Initialize
        clk    = 0;
        reset  = 1;
        coin_5 = 0;
        coin_10 = 0;

        // Reset
        #10;
        reset = 0;

        // ------------------------------------------------
        // Test 1: Insert ?10
        // Expected: Dispense = 1, Change = 0
        // ------------------------------------------------
        #10;
        coin_10 = 1;

        #10;
        coin_10 = 0;

        // ------------------------------------------------
        // Test 2: Insert ?5 + ?5
        // Expected: Dispense = 1, Change = 0
        // ------------------------------------------------
        #10;
        coin_5 = 1;

        #10;
        coin_5 = 0;

        #10;
        coin_5 = 1;

        #10;
        coin_5 = 0;

        // ------------------------------------------------
        // Test 3: Insert ?5 + ?10
        // Expected: Dispense = 1, Change = 1
        // ------------------------------------------------
        #10;
        coin_5 = 1;

        #10;
        coin_5 = 0;

        #10;
        coin_10 = 1;

        #10;
        coin_10 = 0;

        // End simulation
        #20;

        $finish;
    end

    // Monitor outputs
    initial begin
        $monitor(
            "Time=%0t | Reset=%b | Coin5=%b | Coin10=%b | Dispense=%b | Change5=%b",
            $time,
            reset,
            coin_5,
            coin_10,
            dispense,
            change_5
        );
    end

endmodule