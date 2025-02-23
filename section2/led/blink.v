module blink (
    input clk,
    output reg led
);

reg [31:0] count;
always @ (posedge clk) begin
  if (count == 4) begin
    count <= 0;
    led <= ~led;
  end else begin
    count <= count + 1;
  end
end
endmodule
