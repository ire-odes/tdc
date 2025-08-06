module tap (
    input wire in,
    input wire stop,
    output wire [3:0] therm,
    output wire out
    );

(* dont_touch = "yes" *)wire [3:0] delay; // the delay wires that are routes through the carry 4. They will link to each flip flop 

/*** USE AN IF STATEMENT IN THE FOR LOOP **/
CARRY4 carry4_inst (
   .CO(delay),         // 4-bit carry out
   .CI(in),         // 1-bit carry cascade input
   .CYINIT(1'b0), // 1-bit carry initialization
   .DI(4'b0000),         // 4-bit carry-MUX data in
   .S(4'b1111)            // 4-bit carry-MUX select input
);

// generating the 4 ffs for each carry4. 
genvar i;
generate
for (i=0; i< 4; i=i+1)
begin: gen_ff
   (* KEEP_HIERARCHY = "TRUE" *) FDCE #(
        .INIT(1'b0)
       )ff_inst(
        .Q(therm[i]), //each one will generate a 4 bit thermometer code.
        .C(stop),
        .CE(1'b1),
        .CLR(1'b0),
        .D(delay[i]) // take the propgated output into the ff
       );
end
endgenerate
assign out = delay[3]; //the last delay wire will also be wired out
endmodule
