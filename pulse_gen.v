module pulse_gen #(
    parameter integer N = 32  // this willl be the number of carry4 blocks used
)(
    input wire db_in,
    output wire pulse
);

wire [N*4-1:0] delay;
wire [N-1:0] carry_in; // carry-in to each buffer

assign carry_in[0] = db_in;
genvar i;
generate
for (i = 0; i < N; i = i+1)
begin: gen_chain
   (* KEEP_HIERARCHY = "TRUE" *) CARRY4 carry4_inst (
   .CO(delay[i*4 + 3: i*4]),         // 4-bit carry out
   .CI(carry_in[i]),         // 1-bit carry cascade input
   .CYINIT(1'b0), // 1-bit carry initialization
   .DI(4'b0000),         // 4-bit carry-MUX data in
   .S(4'b1111)            // 4-bit carry-MUX select input
);
    if (i<N-1)
    assign carry_in[i+1] = delay[i*4+3]; // this makes theoutput of one "buffer" the input of the next
end
endgenerate

assign pulse = db_in & ~delay[N*4 -1];

endmodule


