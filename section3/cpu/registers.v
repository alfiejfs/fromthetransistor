module registers
#(
  parameter TODO = 1
)
(
  input wire clk,
  input wire reset,

  input wire wr_enable,
  input wire [3:0] wr_addr,
  input wire [31:0] wr_data,  

  input wire rd_addr,
  output reg [31:0] rd_data,
);

  // Create 15 general purpose registers (excludes PC)
  reg [31:0] gp_registers [0:14];
  
  always @(posedge clk) begin

    if (reset) begin
      integer i;
      for (i = 0; i < 15; i = i + 1) begin
        gp_registers[i] <= 32'b0;
      end
    end
    else if (wr_en && wr_addr < 15) begin
      gp_registers[wr_addr] <= wr_data;
    end
  end

  // Set the output 
  always @(*) begin
    rd_data <= (rd_addr < 15) ? gp_registers[rd_addr] : 32'b0;
  end

endmodule
