module uart_tx
#(
  parameter CLK_FREQ = 50_000_000,
  parameter BAUD_RATE = 9600
)
(
  input wire clk,
  input wire reset,
  input reg [7:0] tx_in,
  input wire tx_en,
  output wire tx,
  output wire tx_busy
);

typedef enum reg [1:0] {
  IDLE  = 2'b00,
  START = 2'b01,
  DATA  = 2'b10,
  STOP  = 2'b11
} state_t;

state_t state = IDLE;

reg [3:0] tick_count = 0; // for 16x oversampling
reg [2:0] shift_idx = 0;

reg tx_reg = 1;

assign tx_busy = (state != IDLE);
assign tx = tx_reg; 

wire baud_tick;
baud_gen #(.CLK_FREQ(CLK_FREQ), .BAUD_RATE(BAUD_RATE)) baud_gen (
  .clk(clk),
  .reset(reset),
  .baud_tick(baud_tick)
);

always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= IDLE;
    tx_reg <= 1;
    tick_count <= 0;
    shift_idx <= 0;
  end else if (baud_tick) begin
    case (state)
      IDLE: begin
        // If we are reading the enable bit and the start bit, move to the start state
        if (tx_en) begin
          state <= START;
          tx_reg <= 0; // send the start bit
          tick_count <= 0;
        end
      end

      START: begin
        if (tick_count == 15) begin // sampling in the middle
            state <= DATA;
            shift_idx <= 0;
            tick_count <= 0;
        end else begin
          tick_count <= tick_count + 1;
        end
      end

      DATA: begin
        if (tick_count == 0) begin
          tx_reg <= tx_in[shift_idx];
        end
        if (tick_count == 15) begin
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
        if (tick_count == 0) begin
          tx_reg <= 1; // set the stop bit
        end
        if (tick_count == 15) begin
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
