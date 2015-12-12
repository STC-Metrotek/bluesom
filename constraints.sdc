set_time_format -unit ns -decimal_places 3

create_clock -name {clk_25} -period 40.000 -waveform { 0.000 20.000 } [get_ports {clk_25m_i}]

derive_pll_clocks -create_base_clocks
derive_clock_uncertainty
