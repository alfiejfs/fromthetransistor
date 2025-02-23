module uart_tb;

// Parameters
parameter CLK_FREQ = 50_000_000;
parameter BAUD_RATE = 9600;
parameter CLK_PERIOD = 20; // Assuming a 50MHz clock

// Signals
reg clk;
reg reset;
reg rx;
reg rx_en;
wire rx_valid;
reg [7:0] rx_out;
reg [7:0] tx_in;
reg tx_en;
/* verilator lint_off UNUSEDSIGNAL */
wire tx;
wire tx_busy;

// Instantiate the uart module
uart #(
  .CLK_FREQ(CLK_FREQ),
  .BAUD_RATE(BAUD_RATE)
) uart_inst (
  .clk(clk),
  .reset(reset),
  .rx(rx),
  .rx_en(rx_en),
  .rx_valid(rx_valid),
  .rx_out(rx_out),
  .tx_in(tx_in),
  .tx_en(tx_en),
  .tx(tx),
  .tx_busy(tx_busy)
);

// Clock generation
always #(CLK_PERIOD / 2) clk <= ~clk; // 20ns period -> 50 MHz

// Calculate delays based on baud rate
localparam integer BAUD_DIV = CLK_FREQ / (BAUD_RATE * 16);
localparam integer BIT_TIME = BAUD_DIV * 16 * CLK_PERIOD; // in ns

// Test procedure
initial begin
  // Initialize signals
  clk = 0;
  rx_en = 0;
  tx_en = 0;
  reset = 1;
  rx = 1;

  #100
  reset = 0;
  
  tx_in = 8'h9E;  // '9E'
  tx_en = 1;
  #(BIT_TIME);
  tx_en = 0;
  
  // Wait until TX is done
  wait(tx_busy == 1); // Wait for transmission to complete
  
  // Now, simulate the received signal (rx) by sending the same byte through rx 
  rx_en = 1; // we have to set the enable and start bit
  rx = 0;
  
  // Sending 0x9E (LSB first)
  #(BIT_TIME) rx = 0;  // Simulating the data 0x9E as 8 bits
  #(BIT_TIME) rx = 1; 
  #(BIT_TIME) rx = 1;
  #(BIT_TIME) rx = 1;
  #(BIT_TIME) rx = 1;
  #(BIT_TIME) rx = 0;
  #(BIT_TIME) rx = 0;
  #(BIT_TIME) rx = 1;

  #(BIT_TIME) rx = 1; // Stop bit
  #(BIT_TIME)
  
  // Wait for the byte to be received
  wait(rx_valid == 1);
    
  // Check if the received byte is the same as the transmitted one
  if (rx_out == 8'h9e) begin
    $display("Echo test passed. Received: %h", rx_out);
  end else begin
    $display("Echo test failed. Received: %h, Expected: 41", rx_out);
  end
  
  $finish;
end

endmodule
