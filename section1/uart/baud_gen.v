module baud_gen
#(
  parameter CLK_FREQ = 50_000_000,
  parameter BAUD_RATE = 9600
)
(
  input wire clk,
  input wire reset,
  output wire baud_tick
);

localparam integer BAUD_DIV = CLK_FREQ / (16 * BAUD_RATE);

reg tick = 0;

assign baud_tick = tick;

reg [31:0] counter = 0;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    counter <= 0;
    tick <= 0;
  end else begin
    if (counter == BAUD_DIV - 1) begin
      tick <= 1;
      counter <= 0;
    end else begin
      counter <= counter + 1;
      tick <= 0;
    end
  end
end

endmodule
