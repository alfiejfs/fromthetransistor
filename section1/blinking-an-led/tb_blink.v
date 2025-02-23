module tb_blink;
  reg clk;

  blink uut(
    .clk(clk)
  );

  always begin
    #25 clk <= ~clk;
  end

  initial begin
    clk = 0;
    #500;
    $finish;
  end
endmodule
