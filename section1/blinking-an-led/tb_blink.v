module tb_blink;
  reg clk;
  wire led;
  
  blink uut(
    .clk(clk),
    .led(led)
  );

  reg prev_led;
  always begin
    #1 clk <= ~clk;
    if (led != prev_led) begin
      $display("Time = %0t | LED = %b", $time, led);
      prev_led <= led;
    end
  end

  initial begin
    clk = 0;
    prev_led = 0;
    #1000;
    $finish;
  end
endmodule
