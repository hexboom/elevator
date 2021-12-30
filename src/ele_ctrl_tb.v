`timescale 1ns/1ns
`define CLK_PERI 10

module ele_ctrl_tb;
    reg clk,sysclr_n;
    reg rst,en;
    reg [3:0] key;

    wire [3:0] led; 
    wire state_down,state_stay,state_up;
    wire [3:0] cnt_ms_disp,cnt_s_disp;
    wire beep_en,floor_disp;
    
    initial clk = 0;
    always #(`CLK_PERI/2) clk = ~clk;

    ele_ctrl uut1(
    clk,sysclr_n,
    rst,en,
    key,
    led,
    cnt_ms_disp,cnt_s_disp,
    state_down,state_stay,state_up,
    beep_en,floor_disp);

    wire [1:0] state = uut1.state,
               next_state = uut1.next_state;
    wire cnt_en = uut1.cnt_en;

    wire [5:0] counter_s = uut1.counter_s; 
    wire [31:0] counter_ms = uut1.counter_ms; 
    wire cnt_eq_100m = uut1.cnt_eq_100ms,
         cnt_eq_3s = uut1.cnt_eq_3s,
         cnt_eq_4s = uut1.cnt_eq_4s;
    wire [3:0] key_keep = uut1.key_keep;
    wire [3:0] key_keep_rst_n = uut1.key_keep_rst_n;
    integer check;
    initial begin
        key = 4'd0;
        check = 0;
        #1;
        sysclr_n = 0;
        en = 0;
        rst = 1;
        @(negedge clk);
        sysclr_n = 1;
        en = 1;
        rst = 0;

        //check1
        @(negedge clk);
        check = 1;
        key[3] = 1;
        #(5*`CLK_PERI) key[3] = 0;

        @(state);

        //check2
        @(negedge clk);
        check = 2;
        key[2] = 1;
        #(5*`CLK_PERI) key[2] = 0;

        @(state);

        //check3
        @(negedge clk);
        check = 3;
        key[1] = 1;
        #(5*`CLK_PERI) key[1] = 0;

        @(state);

        //check4
        @(negedge clk);
        check = 4;
        key[0] = 1;
        #(5*`CLK_PERI) key[0] = 0;
        
        @(state);

        //check5 
        @(negedge clk);
        check = 5;
        key[0] = 1;
        #(5*`CLK_PERI) key[0] = 0;
        #(20*`CLK_PERI);

        @(negedge clk);
        key[2] = 1;
        #(5*`CLK_PERI) key[2] = 0;
        #(20*`CLK_PERI);

        //check6
        @(negedge clk);
        check = 6;
        key[3] = 1;
        #(5*`CLK_PERI) key[3] = 0;
        #(5*`CLK_PERI) key[2] = 1;
        #(5*`CLK_PERI) key[2] = 0;

        repeat(3) @(state);

        //check7
        @(negedge clk);
        check = 7;
        key[3] = 1;
        #(5*`CLK_PERI) key[3] = 0;
        #(5*`CLK_PERI) key[0] = 1;
        #(5*`CLK_PERI) key[0] = 0;

        repeat(3) @(state);

        //check8
        @(negedge clk);
        check = 8;
        key[3] = 1;
        #(5*`CLK_PERI) key[3] = 0;

        @(state);

        @(negedge clk);
        key[1] = 1;
        #(5*`CLK_PERI) key[1] = 0;
        #(20*`CLK_PERI);

        @(negedge clk);
        key[3] = 1;
        #(5*`CLK_PERI) key[3] = 0;
        #(20*`CLK_PERI);

        //check9
        @(negedge clk);
        check = 9;
        key[2] = 1;
        #(5*`CLK_PERI) key[2] = 0;
        #(5*`CLK_PERI) key[3] = 1;
        #(5*`CLK_PERI) key[3] = 0;

        repeat(3) @(state);

        //check10
        @(negedge clk);
        check = 10;
        key[2] = 1;
        #(5*`CLK_PERI) key[2] = 0;
        #(5*`CLK_PERI) key[1] = 1;
        #(5*`CLK_PERI) key[1] = 0;

        repeat(3) @(state);

        //check11
        @(negedge clk);
        check = 11;
        rst=1;

        repeat(2) @(state);
        
        //check12
        @(negedge clk);
        check = 12;
        en=0;
        @(negedge clk);
        key = 4'b0001;
        repeat(3) begin
            @(negedge clk);
                key = key << 1;
        end

        #(100*`CLK_PERI) $stop;
    end

    initial begin
        #100000 
        $display("Timeout!");
        $stop;
    end

endmodule