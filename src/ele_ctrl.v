`ifndef CLK_FREQ
//`define CLK_FREQ 50_000_000 //50MHz
`define CLK_FREQ 100 //10ms
`endif 

module ele_ctrl (
    input clk,sysclr_n,
    input rst,en,
    input [3:0] key,

    output [3:0] led,
    output [3:0] cnt_ms_disp,cnt_s_disp,
    output state_down,state_stay,state_up,
    output beep_en,floor_disp
);  

    localparam CNT_100ms = (`CLK_FREQ/10) - 1,
               CNT_3s    = 29,
               CNT_3p5s  = 34,
               CNT_4s    = 39;
    //Control Signal
    reg cnt_en;
    reg flo_add, flo_sub;
    reg [3:0] key_keep_rst_n;

    //State Signal
    wire cnt_eq_100ms,
         cnt_eq_3s,
         cnt_eq_4s;
    wire flo2_in,flo1_in,down_out,up_out;

/***************** Controllor *****************/    
    reg [1:0] state,next_state;
    localparam S_FLO1 = 2'd0,
               S_FLO2 = 2'd1,
               S_UP   = 2'd2,
               S_DOWN = 2'd3;

    always @(posedge clk or negedge sysclr_n) begin
        if(!sysclr_n)
            state <= S_FLO1;
        else if(en)
            state <= next_state;
        else
            state <= state;
    end

    always @(*) begin
        next_state = state;
        cnt_en = 0;
        flo_add = 0;
        flo_sub = 0;
        key_keep_rst_n = 4'b1111;
        case (state)
            S_FLO1:  begin
                key_keep_rst_n = 4'b1010;
                if(down_out)
                    next_state = S_UP;
                if(flo2_in) 
                    next_state = S_UP;
                if(rst && !en) 
                    key_keep_rst_n = 4'b0000;
            end
            S_FLO2: begin
                key_keep_rst_n = 4'b0101;
                if(rst)
                    next_state = S_DOWN;
                if(up_out)
                    next_state = S_DOWN;
                if(flo1_in)
                    next_state = S_DOWN;
            end
            S_UP  : begin
                cnt_en = 1;
                if(cnt_eq_3s) 
                    flo_add = 1;
                if(cnt_eq_4s) 
                    next_state = S_FLO2;
            end
            S_DOWN: begin
                cnt_en = 1;
                if(cnt_eq_3s) 
                    flo_sub = 1;
                if(cnt_eq_4s) 
                    next_state = S_FLO1; 
            end
            default: next_state = state;
        endcase
    end

    assign state_down = (state == S_DOWN);
    assign state_stay = (state == S_FLO1 || state == S_FLO2);
    assign state_up   = (state == S_UP);
/**********************************************/


/***************** Datapath *******************/
    //Datapath Register
    reg [3:0] key_keep = 4'd0;
    reg [5:0] counter_s;   //100ms per
    reg [31:0] counter_ms; 
    reg [3:0]  cnt_ms,cnt_s;
    reg ele_flo;

    //timecounter
    always @(posedge clk or negedge sysclr_n) begin:timecounter
        if(!sysclr_n) begin
            counter_s <= 0;
            counter_ms <= 0;
        end
        else if(cnt_en) begin
            if(counter_ms == CNT_100ms) begin
                counter_s <= counter_s + 1;
                counter_ms <= 0;
            end
            else begin
                counter_s <= counter_s;
                counter_ms <= counter_ms + 1;
            end
        end
        else begin
            counter_s <= 0;
            counter_ms <= 0;
        end
    end

    assign cnt_eq_100ms = (counter_ms == CNT_100ms);
    assign cnt_eq_3s    = (counter_s == CNT_3s && counter_ms == CNT_100ms);
    assign cnt_eq_4s    = (counter_s == CNT_4s && counter_ms == CNT_100ms);

    //countdown
    always @(posedge clk or negedge sysclr_n) begin:countdown
        if(!sysclr_n) begin
            cnt_ms <= 4'd0;
            cnt_s  <= 4'd4;
        end
        else if(cnt_en) begin
            if(cnt_eq_100ms) begin
                if(cnt_ms == 4'd0) begin
                    cnt_ms <= 4'd9;
                    cnt_s  <= cnt_s - 4'd1;
                end
                else 
                    cnt_ms <= cnt_ms - 4'd1;
            end
            else begin
                cnt_ms <= cnt_ms;
                cnt_s  <= cnt_s;
            end
        end
        else begin
            cnt_ms <= 4'd0;
            cnt_s  <= 4'd4;
        end
    end
    assign cnt_ms_disp = cnt_ms;
    assign cnt_s_disp  = cnt_s ;
    //floor register
    always @(posedge clk or negedge sysclr_n) begin:floorreg
        if(!sysclr_n)
            ele_flo <= 0;
        else if(flo_add)
            ele_flo <= ele_flo + 1;
        else if(flo_sub)
            ele_flo <= ele_flo - 1;
        else
            ele_flo <= ele_flo;
    end
    assign floor_disp = ele_flo;

    // assign beep_en = (counter_s >= CNT_3p5s);
    assign beep_en = 0;

    //key register
    generate
        genvar gv_i;
        for (gv_i = 0; gv_i <4; gv_i = gv_i+1) begin:keydff
            always @(posedge key[gv_i] or negedge key_keep_rst_n[gv_i]) begin
                if(!key_keep_rst_n[gv_i])
                    key_keep[gv_i] <= 0;
                else
                    key_keep[gv_i] <= ~key_keep[gv_i];
            end
        end
    endgenerate
    
    assign {flo2_in,flo1_in,down_out,up_out} = key_keep;
    assign led = key_keep;
/*********************************************/



endmodule
