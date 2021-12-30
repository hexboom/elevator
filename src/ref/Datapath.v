module Datapath 
#(parameter FLOOR = 3)
(
    input clk,rst_n,
    
    input 

);
    reg [FLOOR:1] ele_flo;
    reg [31:0] counter;
    always @(posedge clk) begin
        if(!rst_n)
            ele_flo = 1;
        else
            ele_flo = 
    end
endmodule