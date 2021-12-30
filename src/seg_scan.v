module seg_scan (
    input clk,sysclr_n,
    input [6:0] seg_flo,
    input [6:0] seg_state,
    input [6:0] seg_s,seg_100ms,

    output reg [5:0] SEG_SEL_n,
    output [7:0] SEG_DATA
);
    reg [15:0] counter;
    always @(posedge counter[15] or negedge sysclr_n) begin
        if(!sysclr_n)
            SEG_SEL_n <= 6'b11_1110;
        else 
            SEG_SEL_n <= {SEG_SEL_n[5:4],SEG_SEL_n[2:0],SEG_SEL_n[3]};
    end

    assign SEG_DATA[7] = 1'b1;
    assign SEG_DATA[6:0] = (!sysclr_n)               ? 7'b111_1111  :
                           (SEG_SEL_n == 6'b11_1110) ? seg_flo      :
                           (SEG_SEL_n == 6'b11_1101) ? seg_state    :
                           (SEG_SEL_n == 6'b11_1011) ? seg_100ms    :
                           (SEG_SEL_n == 6'b11_0111) ? seg_s        : 
                                                       7'b111_1111;
    always @(posedge clk or negedge sysclr_n) begin
        if(!sysclr_n)
            counter <= 0;
        else
            counter <= counter +1;
    end
endmodule