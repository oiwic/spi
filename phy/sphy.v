module sphy (
    p_ck, p_ncs, p_se, p_so, p_si,
    c_ck, c_en, c_se, c_so, c_si
);
    // pad side
    input        p_ck;
    input        p_ncs;
    output [3:0] p_se;
    output [3:0] p_so;
    input  [3:0] p_si;

    // controller side
    output       c_ck;
    output       c_en;
    input  [3:0] c_se;
    input  [7:0] c_so;
    output [7:0] c_si;

    reg       ncs;
    reg [3:0] se, so0, so1, so2, si0, si1, si2;

    // clock buffer
    assign c_ck = p_ck;

    // enable
    assign c_en = ~p_ncs;

    // enable output data
    always @(posedge c_ck) if (c_en) se <= c_se;
    assign p_se = se;

    // output data
    always @(posedge c_ck) if (c_en) so0 <= c_so[3:0];
    always @(posedge c_ck) if (c_en) so1 <= c_so[7:4];
    always @(negedge c_ck) if (c_en) so2 <= so1;
    assign p_so = c_ck ? so0 : so2;

    // input data
    always @(posedge c_ck) if (c_en) si0 <= p_si;
    always @(negedge c_ck) if (c_en) si1 <= p_si;
    always @(posedge c_ck) if (c_en) si2 <= si1;
    assign c_si = {si2, si0};

endmodule
