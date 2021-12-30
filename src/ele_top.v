module ele_top (
    input CLK_50MHz, SYSCLR_n,
    // input [1:0] SWITCH,
    input [3:0] KEY,

    output [3:0] LED,
    output [5:0] SEG_SEL_n,
    output [7:0] SEG_DATA,
    output BUZZER
);
    wire clk,sysclr_n;
    assign sysclr_n = SYSCLR_n;
    wire rst,en;
    wire [3:0] key;
    wire [3:0] led;
    assign LED = led;
    wire beep_en = BUZZER;
    // assign {rst,en} = SWITCH;
    assign {rst,en} = 2'b01;
    wire [3:0] cnt_ms_disp,cnt_s_disp;
    wire state_down,state_stay,state_up;
    wire floor_disp;
    wire [6:0] seg_flo;
    wire [6:0] seg_state;
    wire [6:0] seg_s,seg_100ms;

//    IBUFG #(
//        .IOSTANDARD("DEFAULT")  // Specify the input I/O standard
//    ) IBUFG_inst (
//        .O(clk), // Clock buffer output
//        .I(CLK_50MHz)  // Clock buffer input (connect directly to top-level port)
//    );

    ele_ctrl U_ele_ctrl(
        clk,sysclr_n,
        rst,en,
        key,

        led,
        cnt_ms_disp,cnt_s_disp,
        state_down,state_stay,state_up,
        beep_en,floor_disp
    );

    seg_encode U_seg_encode(
        cnt_ms_disp,cnt_s_disp,
        state_down,state_stay,state_up,
        floor_disp,

        seg_flo,
        seg_state,
        seg_s,seg_100ms
    );

    seg_scan U_seg_scan(
        clk,sysclr_n,
        seg_flo,
        seg_state,
        seg_s,seg_100ms,

        SEG_SEL_n,
        SEG_DATA
    );

    debouncer #(.N(4)) U_debouncer (
        clk,sysclr_n,
        KEY,
        key
    );

endmodule

