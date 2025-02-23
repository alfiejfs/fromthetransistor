module uart_rx_tb;
    parameter CLK_FREQ = 50_000_000; // 50 MHz clock
    parameter BAUD_RATE = 9600;      // 9600 baud rate
    parameter CLK_PERIOD = 20; // 20 ns clock period (50Mhz)

    reg clk = 0;
    reg reset = 0;
    reg rx = 1;
    reg rx_en = 1;  // Keep enabled
    wire rx_valid;
    wire [7:0] rx_out;

    // Instantiate the UART module
    uart_rx #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) uut (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .rx_en(rx_en),
        .rx_valid(rx_valid),
        .rx_out(rx_out)
    );

    // Generate Clock (50 MHz)
    always #(CLK_PERIOD / 2) clk <= ~clk;  // 20ns period -> 50MHz

    // Calculate delays based on baud rate
    localparam integer BAUD_DIV = CLK_FREQ / (BAUD_RATE * 16);
    localparam integer BIT_TIME = BAUD_DIV * 16 * CLK_PERIOD; // in ns

    initial begin
        // Initialize
        reset = 1;
        rx = 1;

        #100
        reset = 0;
        // Start bit
        rx = 0;
        #(BIT_TIME);

        // Data bits (LSB first): 10100101
        rx = 1; #(BIT_TIME);
        rx = 0; #(BIT_TIME);
        rx = 1; #(BIT_TIME);
        rx = 0; #(BIT_TIME);
        rx = 0; #(BIT_TIME);
        rx = 1; #(BIT_TIME);
        rx = 0; #(BIT_TIME);
        rx = 1; #(BIT_TIME);

        // Stop bit
        rx = 1;
        #(BIT_TIME);

        // Wait for processing
        #(BIT_TIME);

        // Check results
        $display("Received Data: %h", rx_out);
        $display("Data valid: %b", rx_valid);
        if (rx_out == 8'b10100101 && rx_valid)
            $display("Test Passed!");
        else
            $display("Test Failed!");

        #1000;
        $finish;
    end
endmodule
