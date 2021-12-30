// pack 2D-array to 1D-array
`define PACK_ARRAY(PK_WIDTH,PK_LEN,PK_SRC,PK_DEST) \
    generate \
    genvar pk_idx; \
        for (pk_idx=0; pk_idx<(PK_LEN); pk_idx=pk_idx+1) begin \
            assign PK_DEST[((PK_WIDTH)*pk_idx+((PK_WIDTH)-1)):((PK_WIDTH)*pk_idx)] = PK_SRC[pk_idx][((PK_WIDTH)-1):0]; \
        end \
    endgenerate \

// unpack 1D-array to 2D-array
`define UNPACK_ARRAY(PK_WIDTH,PK_LEN,PK_DEST,PK_SRC) \
    generate \
        genvar unpk_idx; \
        for (unpk_idx=0; unpk_idx<(PK_LEN); unpk_idx=unpk_idx+1) begin \
                assign PK_DEST[unpk_idx][((PK_WIDTH)-1):0] = PK_SRC[((PK_WIDTH)*unpk_idx+(PK_WIDTH-1)):((PK_WIDTH)*unpk_idx)]; \
        end \
    endgenerate

module elevator_top 
#(parameter FLOOR = 3)
(
    input clk,rst_n,
    input [FLOOR*2-1:0] KEY_OUT,
    input [1:0] KEY_IN_RUN,
    input KEY_IN_ALR,
    input [FLOOR:1] KEY_IN_FLO,

    output [FLOOR*3-1:0] LED_OUT,
    output [FLOOR*7-1:0] DIG_OUT,
    output [7:0] DIG_IN 

);
    
endmodule
