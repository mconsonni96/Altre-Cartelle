set_max_delay -datapath_only -from [get_pins -hier *SCK_O_reg_reg/C] -to [get_pins -hier *USRCCLKO] 1.500
set_min_delay -from [get_pins -hier *SCK_O_reg_reg/C] -to [get_pins -hier *USRCCLKO] 0.100
create_generated_clock -name clk_sck -source [get_pins -hierarchical *axi_quad_spi_0/ext_spi_clk] -edges {3 5 7} -edge_shift {7.500 7.500 7.500} [get_pins -hierarchical *USRCCLKO]
create_generated_clock -name clk_sck -source [get_pins -hierarchical *axi_quad_spi_0/ext_spi_clk] -edges {3 5 7} -edge_shift {7.500 7.500 7.500} [get_pins -hierarchical *USRCCLKO]
set_input_delay -clock clk_sck -clock_fall -max 8.300 [get_ports {QSPI_MEMORY_IF_io*_io QSPI_MEMORY_IF_ss_io}]
set_input_delay -clock clk_sck -clock_fall -min 0.300 [get_ports {QSPI_MEMORY_IF_io*_io QSPI_MEMORY_IF_ss_io}]
set_multicycle_path -setup -from clk_sck -to [get_clocks -of_objects [get_pins -hierarchical */ext_spi_clk]] 2
set_multicycle_path -hold -end -from clk_sck -to [get_clocks -of_objects [get_pins -hierarchical */ext_spi_clk]] 1





