module blink (input clk);
  always @ (posedge clk) begin
    $display("LED = 1");
  end
  always @ (negedge clk) begin
    $display("LED = 0");
  end
endmodule
