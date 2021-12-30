//ref:http://www.labbookpages.co.uk/electronics/debounce.html
`ifndef CLK_FREQ
`define CLK_FREQ 50_000_000 //50MHz
`endif 

module debouncer 
#(parameter N = 1,
            MODE = "Default")
(
    input clk,sysclr_n,
    input [N-1:0] switchin,
    output reg [N-1:0] switchout
);
    localparam  SAMPLE_COUNT_MAX = (`CLK_FREQ/2000) - 1,
                PULSE_COUNT_MAX  = (`CLK_FREQ/100) - 1,
                STABLE_COUNT_MAX  = (`CLK_FREQ/2) - 1;
    reg [logb2(SAMPLE_COUNT_MAX)-1:0] wrap_cnt ;
    reg [logb2(PULSE_COUNT_MAX)-1:0] pulse_cnt [N-1:0];
    // reg [logb2(STABLE_COUNT_MAX)-1:0] stable_cnt;
    reg [N-1:0] swsyn1,swsyn2;
    wire sample;
    wire [N-1:0] deb_en,deb_rst;

    always @(posedge clk or negedge sysclr_n) begin: Synchroniser 
        if(!sysclr_n) begin
            swsyn1 <= 0;
            swsyn2 <= 0;
        end
        else begin
            swsyn1 <= switchin;
            swsyn2 <= swsyn1;
        end
    end

    always @(posedge clk or negedge sysclr_n) begin: SamplePulseGenerator 
        if(!sysclr_n) 
            wrap_cnt <= 0;
        else if(wrap_cnt == SAMPLE_COUNT_MAX)
            wrap_cnt <= 0;
        else
            wrap_cnt <= wrap_cnt + 1;
    end
    assign sample = (wrap_cnt == SAMPLE_COUNT_MAX);
    assign deb_en = {N{sample}} & swsyn2;
    assign deb_rst = ~swsyn2;

    generate
        genvar gv_i;
        for(gv_i = 0;gv_i<N; gv_i = gv_i+1) begin:Debouncer
            always @(posedge clk or negedge sysclr_n) begin
                if(!sysclr_n) begin
                    pulse_cnt[gv_i] <= 0;
                    switchout[gv_i] <= 0;
                end
                else if(deb_rst)
                    pulse_cnt[gv_i] <= 0;     
                else if(deb_en) 
                    if(pulse_cnt[gv_i] == PULSE_COUNT_MAX)
                        switchout[gv_i] <= 1;
                    else
                        pulse_cnt[gv_i] <= pulse_cnt[gv_i] + 1;
            end
        end
    endgenerate


    function integer logb2 (input integer depth);
        for (logb2=0; depth>0; logb2=logb2+1) 
            depth = depth >>1;
    endfunction
endmodule
