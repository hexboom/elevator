module Controllor (
    input clk,rst_n,

    //state signal input

    //control signal output 

);
    localparam S_STAY = 2'd0, 
               S_DOWN = 2'd1, 
               S_UP = 2'd2;
    reg [1:0] state, next_state;

    always @(posedge clk) begin
        if(!rst_n)
            state <= S_STAY;
        else
            state <= next_state;
    end

    always @(*) begin
        //fsm
    end

endmodule