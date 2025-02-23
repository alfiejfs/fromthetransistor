module uart
#(
  parameter CLK_FREQ = 50_000_000,
  parameter BAUD_RATE = 9600
)
(
  input wire clk,
  input wire reset,
  
  input wire rx,
  input wire rx_en,
  output wire rx_valid,
  output reg [7:0] rx_out,
  
  input reg [7:0] tx_in,
  input wire tx_en,
  output wire tx,
  output wire tx_busy
);

uart_rx #(.CLK_FREQ(CLK_FREQ), .BAUD_RATE(BAUD_RATE)) uart_rx (
  .clk(clk),
  .reset(reset),
  .rx(rx),
  .rx_en(rx_en),
  .rx_valid(rx_valid),
  .rx_out(rx_out)
);

uart_tx #(.CLK_FREQ(CLK_FREQ), .BAUD_RATE(BAUD_RATE)) uart_tx (
  .clk(clk),
  .reset(reset),
  .tx_in(tx_in),
  .tx_en(tx_en),
  .tx(tx),
  .tx_busy(tx_busy)
);

endmodule
