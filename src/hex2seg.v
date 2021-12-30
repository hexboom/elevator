module hex2seg (
    input en,
    input [3:0] data_in,
    output [6:0] seg_out
);
    assign seg_out =  (!en)             ? 7'b111_1111 : 
                      (data_in == 4'h0) ? 7'b100_0000 :
                      (data_in == 4'h1) ? 7'b111_1001 :
                      (data_in == 4'h2) ? 7'b010_0100 :
                      (data_in == 4'h3) ? 7'b011_0000 :
                      (data_in == 4'h4) ? 7'b001_1001 :
                      (data_in == 4'h5) ? 7'b001_0010 :
                      (data_in == 4'h6) ? 7'b000_0010 :
                      (data_in == 4'h7) ? 7'b111_1000 :
                      (data_in == 4'h8) ? 7'b000_0000 :
                      (data_in == 4'h9) ? 7'b001_0000 :
                      (data_in == 4'ha) ? 7'b000_1000 :
                      (data_in == 4'hb) ? 7'b000_0011 :
                      (data_in == 4'hc) ? 7'b100_0110 :
                      (data_in == 4'hd) ? 7'b010_0001 :
                      (data_in == 4'he) ? 7'b000_0110 :
                      (data_in == 4'hf) ? 7'b000_1110 : 7'b111_1111;
                                        
endmodule