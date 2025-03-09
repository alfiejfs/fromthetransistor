module cpu
#(
  parameter TODO = 1
)
(
  input wire clk,
  input wire reset
);

// TODO: move to control unit as outputs and have a CU here.

// Function parameter (0, 1, 2, 3)
reg [7:0] r0; // Function return value
reg [7:0] r1;
reg [7:0] r2;
reg [7:0] r3;

// Saved variables
reg [7:0] r4;
reg [7:0] r5;
reg [7:0] r6;
reg [7:0] r7;
reg [7:0] r8;
reg [7:0] r9;
reg [7:0] r10;
reg [7:0] r11;

// Temporary variable
reg [7:0] r12;

// Stack pointer
reg [7:0] r13;

// Link register
reg [7:0] r14;

// Program counter
reg [7:0] r15;

// Current program status register
reg [7:0] cpsr;

always @(posedge clk) begin



end

endmodule
