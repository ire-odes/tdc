## CLOCK
#set_property -dict {PACKAGE_PIN L17 IOSTANDARD LVCMOS33} [get_ports CLK12MHZ]
#create_clock -period 83.330 -name sys_clk_pin -waveform {0.000 41.660} -add [get_ports CLK12MHZ]

##BUTTON
#set_property -dict {PACKAGE_PIN A18 IOSTANDARD LVCMOS33} [get_ports button]

## PULSE
#set_property -dict {PACKAGE_PIN G17 IOSTANDARD LVCMOS33} [get_ports pulse]

## LED
#set_property -dict {PACKAGE_PIN A17 IOSTANDARD LVCMOS33} [get_ports led]


#********************************************************************************************#
# CLOCK
set_property -dict {PACKAGE_PIN L17 IOSTANDARD LVCMOS33} [get_ports CLK12MHZ]
create_clock -period 83.330 -name sys_clk_pin -waveform {0.000 41.660} -add [get_ports CLK12MHZ]

create_clock -name fast_clk -period 10.000 [get_nets fast_clk]

# BUTTON  
set_property -dict {PACKAGE_PIN A18 IOSTANDARD LVCMOS33} [get_ports button]
set_false_path -from [get_ports button]

# PULSE
set_property -dict {PACKAGE_PIN G17 IOSTANDARD LVCMOS33} [get_ports pulse]

#ONE SHOT
set_property -dict { PACKAGE_PIN G19   IOSTANDARD LVCMOS33 } [get_ports  start ];
set_property -dict { PACKAGE_PIN N18   IOSTANDARD LVCMOS33 } [get_ports  stop ]; 
# LED
set_property -dict {PACKAGE_PIN A17 IOSTANDARD LVCMOS33} [get_ports led]

# Preserve hierarchy for pulse generator timing
set_property KEEP_HIERARCHY TRUE [get_cells -hier -filter {NAME =~ "*pulse_gen_inst*"}]

# Optional: Constrain the combinational delay if timing issues arise
# set_max_delay -from [get_nets -hier -filter {NAME =~ "*debounced_button*"}] \
#              -to [get_nets -hier -filter {NAME =~ "*pulse*"}] 20.0



