module uart_tx_tb;

  // Parameters
  parameter CLK_FREQ = 50_000_000; // 50 MHz clock
  parameter BAUD_RATE = 9600;      // 9600 baud rate
  parameter CLK_PERIOD = 20;       // 20 ns clock period (50 MHz)
  parameter BAUD_PERIOD = (CLK_FREQ / BAUD_RATE); // Number of clock cycles per baud period

  // Signals
  reg clk;
  reg reset;
  reg [7:0] tx_in;
  reg tx_en;
  wire tx;
  wire tx_busy;

  // Instantiate the UART transmitter module
  uart_tx #(
    .CLK_FREQ(CLK_FREQ),
    .BAUD_RATE(BAUD_RATE)
  ) uut (
    .clk(clk),
    .reset(reset),
    .tx_in(tx_in),
    .tx_en(tx_en),
    .tx(tx),
    .tx_busy(tx_busy)
  );

  // Clock generation
  always #(CLK_PERIOD / 2) clk <= ~clk;

  // Testbench stimulus
  initial begin
    // Initialize signals
    clk = 0;
    reset = 1;
    tx_in = 8'h00;
    tx_en = 0;

    // Apply reset
    #100;
    reset = 0;

    // Test case 1: Send a single byte (8'h55)
    tx_in = 8'h55; // Data to transmit
    tx_en = 1;     // Enable transmission
    #(BAUD_PERIOD * CLK_PERIOD / 2);
    tx_en = 0;     // Disable transmission after one clock cycle

    // Wait for transmission to start
    wait (tx_busy == 1);
    $display("Test Case 1: Transmission started.");

    // Check start bit (tx should be 0)
    #(BAUD_PERIOD * CLK_PERIOD / 2);
    assert (tx === 0) else $error("Test Case 1: Start bit incorrect (expected 0, got %b).", tx);

    // Check data bits (LSB first)
    for (int i = 0; i < 8; i = i + 1) begin
      #(BAUD_PERIOD * CLK_PERIOD);
      assert (tx === tx_in[i]) else $error("Test Case 1: Data bit %0d incorrect (expected %b, got %b).", i, tx_in[i], tx);
    end

    // Check stop bit (tx should be 1)
    #(BAUD_PERIOD * CLK_PERIOD);
    assert (tx === 1) else $error("Test Case 1: Stop bit incorrect (expected 1, got %b).", tx);

    // Wait for transmission to complete
    wait (tx_busy == 0);
    $display("Test Case 1: Transmission completed successfully.");

    // Test case 2: Send another byte (8'hAA)
    tx_in = 8'hAA; // Data to transmit
    tx_en = 1;     // Enable transmission

    #(BAUD_PERIOD * CLK_PERIOD / 2);
    tx_en = 0;     // Disable transmission after one clock cycle

    // Wait for transmission to start
    wait (tx_busy == 1);
    $display("Test Case 2: Transmission started.");

    // Check start bit (tx should be 0)
    #(BAUD_PERIOD * CLK_PERIOD / 2);
    assert (tx === 0) else $error("Test Case 2: Start bit incorrect (expected 0, got %b).", tx);

    // Check data bits (LSB first)
    for (int i = 0; i < 8; i = i + 1) begin
      #(BAUD_PERIOD * CLK_PERIOD);
      assert (tx === tx_in[i]) else $error("Test Case 2: Data bit %0d incorrect (expected %b, got %b).", i, tx_in[i], tx);
    end

    // Check stop bit (tx should be 1)
    #(BAUD_PERIOD * CLK_PERIOD);
    assert (tx === 1) else $error("Test Case 2: Stop bit incorrect (expected 1, got %b).", tx);

    // Wait for transmission to complete
    wait (tx_busy == 0);
    $display("Test Case 2: Transmission completed successfully.");

    // End simulation
    #100;
    $display("All test cases completed.");
    $finish;
  end

endmodule
