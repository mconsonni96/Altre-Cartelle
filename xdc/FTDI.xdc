set_input_delay -clock [get_clocks ftdi_clock] -min -add_delay 1.000 [get_ports {FT245_data_io[*]}]
set_input_delay -clock [get_clocks ftdi_clock] -max -add_delay 7.000 [get_ports {FT245_data_io[*]}]
set_input_delay -clock [get_clocks ftdi_clock] -min -add_delay 1.000 [get_ports FT245_rxf]
set_input_delay -clock [get_clocks ftdi_clock] -max -add_delay 7.000 [get_ports FT245_rxf]
set_input_delay -clock [get_clocks ftdi_clock] -min -add_delay 1.000 [get_ports FT245_txe]
set_input_delay -clock [get_clocks ftdi_clock] -max -add_delay 7.000 [get_ports FT245_txe]
set_output_delay -clock [get_clocks ftdi_clock] -min -add_delay 0.000 [get_ports {FT245_data_io[*]}]
set_output_delay -clock [get_clocks ftdi_clock] -max -add_delay 8.000 [get_ports {FT245_data_io[*]}]
set_output_delay -clock [get_clocks ftdi_clock] -min -add_delay 0.000 [get_ports FT245_oe]
set_output_delay -clock [get_clocks ftdi_clock] -max -add_delay 8.000 [get_ports FT245_oe]
set_output_delay -clock [get_clocks ftdi_clock] -min -add_delay 0.000 [get_ports FT245_rd]
set_output_delay -clock [get_clocks ftdi_clock] -max -add_delay 8.000 [get_ports FT245_rd]
set_output_delay -clock [get_clocks ftdi_clock] -min -add_delay 0.000 [get_ports FT245_wr]
set_output_delay -clock [get_clocks ftdi_clock] -max -add_delay 8.000 [get_ports FT245_wr]


# Remember to adjust this !!
# Needed if FT245 clock enter FPGA in non-clock pin. This suppress Vivado error
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets design_1_i/clk_wiz_1/inst/*clk_in*design*]





