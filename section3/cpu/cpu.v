module cpu
#(
  parameter TODO = 1
)
(
  input wire clk,
  input wire reset
);

// Program counter
reg [7:0] r15;

// Current program status register
reg [7:0] cpsr;

always @(posedge clk) begin

end

endmodule
