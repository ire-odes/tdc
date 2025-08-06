`timescale 1ns / 1ps

module tap_chain #(
    parameter integer N = 32
    )(
    input wire stop, 
    input wire start,
    output wire [N*4 -1:0] therm
);

wire [N:0] delay_line;
assign delay_line[0] = start;

genvar i;
generate
for (i = 0; i < N; i = i + 1)
begin : chain_gen
    (* KEEP_HIERARCHY = "TRUE" *) tap tap_inst(
        .in(delay_line[i]),
        .stop(stop),
        .therm(therm[i*4 + 3 : i*4]),
        .out(delay_line[i+1])
    );
end
endgenerate    

endmodule

