// Small SystemVerilog FSM example used to demonstrate enum/always_comb/always_ff.
module traffic_light_sv (
    input logic clk, input logic reset,
    output logic red, output logic yellow, output logic green
);
    typedef enum logic [1:0] {RED_STATE=2'b00, GREEN_STATE=2'b01,
                             YELLOW_STATE=2'b10} state_t;
    state_t state, next_state;

    always_ff @(posedge clk)
        if (reset) state <= RED_STATE;
        else       state <= next_state;

    always_comb begin
        next_state = state;
        red = 1'b0; yellow = 1'b0; green = 1'b0;
        case (state)
            RED_STATE:    begin red=1'b1;    next_state=GREEN_STATE;  end
            GREEN_STATE:  begin green=1'b1;  next_state=YELLOW_STATE; end
            YELLOW_STATE: begin yellow=1'b1; next_state=RED_STATE;    end
            default:      begin red=1'b1;    next_state=RED_STATE;    end
        endcase
    end
endmodule
