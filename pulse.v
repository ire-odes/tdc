`timescale 1ns / 1ps
module pulse(
    input wire en,
    input wire button,
    input wire CLK12MHZ,
    output wire start,
    output wire stop,
    output wire led
);
wire pulse;
pulse_gen #(.N(128)) pulse_gen_inst (
    .db_in(button),
    .pulse(pulse)
);

reg pulse_reg;
always @(posedge CLK12MHZ)
begin
    if (!en)
        pulse_reg <= 0;
    else
        pulse_reg <= pulse;
end

wire pulse_out;
assign pulse_out = pulse_reg;

one_shot #(.N(16)) one_shot_inst(
    .pulse(pulse_out),
    .start(start),
    .stop(stop)
);


wire fast_clk;
mmcm0 mmcm_inst (
        
       .mmcm_in1(CLK12MHZ),     
       .locked(led),
       .mmcm_out1(fast_clk)     
    );
endmodule

module pulse_gen #(
    parameter integer N = 32  // this willl be the number of carry4 blocks used
)(
    input wire db_in,
    output wire pulse
);

wire [N*4-1:0] delay;
wire [N-1:0] carry_in; // carry-in to each buffer

reg [1:0] counter;

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

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/21/2025 08:06:59 PM
// Design Name: 
// Module Name: one_shot
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module one_shot #(
    parameter integer N = 8 )
    (
    input wire pulse,
    output wire start,
    output wire stop
    );
    
wire [N*4-1:0] delay;
wire [N-1:0] carry_in; // carry-in to each buffer

assign carry_in[0] = pulse;
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

assign start = pulse & ~delay[N*4 -1];
assign stop = ~pulse & delay[N*4 -1];
    
    
endmodule


