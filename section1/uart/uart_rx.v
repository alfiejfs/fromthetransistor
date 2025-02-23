module uart_rx
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
  output reg [7:0] rx_out
);

typedef enum reg [1:0] {
  IDLE  = 2'b00,
  START = 2'b01,
  DATA  = 2'b10,
  STOP  = 2'b11
} state_t;

state_t state = IDLE;

reg [2:0] shift_idx = 0;
reg valid = 0;
reg [3:0] tick_count = 0; // for 16x oversampling

assign rx_valid = valid;

wire baud_tick;
baud_gen #(.CLK_FREQ(CLK_FREQ), .BAUD_RATE(BAUD_RATE)) baud_gen (
  .clk(clk),
  .reset(reset),
  .baud_tick(baud_tick)
);

always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= IDLE;
    valid <= 0;
    tick_count <= 0;
    shift_idx <= 0;
    rx_out <= 0;
  end else if (baud_tick) begin
    case (state)
      IDLE: begin
        // If we are reading the enable bit and the start bit, move to the start state
        if (rx_en && !rx) begin
          state <= START;
          tick_count <= 0;
          valid <= 0;
        end
      end

      START: begin
        if (tick_count == 7) begin // sampling in the middle
          if (rx == 0) begin
            state <= DATA;
            shift_idx <= 0;
            tick_count <= 0;
          end else begin
            state <= IDLE;
          end
        end else begin
          tick_count <= tick_count + 1;
        end
      end

      DATA: begin
        if (tick_count == 15) begin
          rx_out[shift_idx] <= rx;
          shift_idx <= shift_idx + 1;
          tick_count <= 0;
          if (shift_idx == 7) begin
            state <= STOP;
          end
        end else begin
          tick_count <= tick_count + 1;
        end
      end

      STOP: begin
        if (tick_count == 15) begin
          valid <= (rx == 1);
          state <= IDLE;
          tick_count <= 0;
        end else begin
          tick_count <= tick_count + 1;
        end
      end
    endcase
  end
end
endmodule
