module vending (
    input  wire       clk,
    input  wire       reset,
    input  wire       coin_5,
    input  wire       coin_10,

    output reg        dispense,
    output reg        change_5
);

    // State encoding
    parameter IDLE = 2'b00;
    parameter S5   = 2'b01;
    parameter S10  = 2'b10;

    reg [1:0] state, next_state;

    // State register
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next-state logic
    always @(*) begin

        // Default values
        next_state = state;
        dispense   = 1'b0;
        change_5   = 1'b0;

        case (state)

            // No money inserted
            IDLE: begin
                if (coin_5)
                    next_state = S5;

                else if (coin_10) begin
                    dispense   = 1'b1;
                    next_state = IDLE;
                end
            end

            // ?5 inserted
            S5: begin
                if (coin_5) begin
                    // ?5 + ?5 = ?10
                    dispense   = 1'b1;
                    next_state = IDLE;
                end

                else if (coin_10) begin
                    // ?5 + ?10 = ?15
                    dispense   = 1'b1;
                    change_5   = 1'b1;
                    next_state = IDLE;
                end
            end

            // ?10 state (not normally reached)
            S10: begin
                dispense   = 1'b1;
                next_state = IDLE;
            end

            default: begin
                next_state = IDLE;
            end

        endcase
    end

endmodule
