module seg_encode (
    input [3:0] cnt_ms_disp,cnt_s_disp,
    input state_down,state_stay,state_up,
    input floor_disp,

    output [6:0] seg_flo,
    output [6:0] seg_state,
    output [6:0] seg_s,seg_100ms
);
    //low-level en
    assign seg_flo = (!floor_disp) ? 7'b111_1001 : 7'b010_0100;
    hex2seg 
        U1_hex2seg (!state_stay,cnt_ms_disp, seg_100ms),
        U2_hex2seg (!state_stay,cnt_s_disp, seg_s);
    
    assign seg_state = {state_stay,2'b11,state_down,2'b11,state_up};

endmodule