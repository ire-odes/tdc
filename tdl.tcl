
current_instance tap_chain0
set_property ALLOW_COMBINATORIAL_LOOPS true [get_nets -hierarchical]
current_instance -quiet

set N 92

for {set a 60} {$a < $N} {incr a} {
    
   
    set i [expr {$a - 60}]

   
    for {set b 0} {$b < 4} {incr b} {
        set_property LOC "SLICE_X36Y$a" [get_cells "tap_chain0/chain_gen\[$i\].tap_inst/gen_ff\[$b\].ff_inst"]
    }

   
    set_property LOC "SLICE_X36Y$a" [get_cells "tap_chain0/chain_gen\[$i\].tap_inst/carry4_inst"]
}


# FIRST TAP
#set_property LOC SLICE_X36Y59 [get_cells first_tap0/ff_inst]
#set_property BEL DFF [get_cells first_tap0/ff_inst]

#CLOCK 
set_property -dict {PACKAGE_PIN L17 IOSTANDARD LVCMOS33} [get_ports CLK12MHZ]
create_clock -period 83.330 -name sys_clk_pin -waveform {0.000 41.660} -add [get_ports CLK12MHZ]
create_clock -name fast_clk -period 3.333 [get_nets fast_clk]

#BUTTON aka start
set_property -dict { PACKAGE_PIN A18   IOSTANDARD LVCMOS33 } [get_ports  start_pulse ]; #IO_L19N_T3_VREF_16 Sch=btn[0]
#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets start_pulse_IBUF]
#LED
set_property -dict {PACKAGE_PIN A17 IOSTANDARD LVCMOS33} [get_ports led]

