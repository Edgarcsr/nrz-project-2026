## Clock signal (100 MHz)
set_property PACKAGE_PIN W5 [get_ports clk]							
	set_property IOSTANDARD LVCMOS33 [get_ports clk]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

## Switches (data_in mapeado para os 16 switches da placa)
set_property PACKAGE_PIN V17 [get_ports {data_in[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {data_in[0]}]
set_property PACKAGE_PIN V16 [get_ports {data_in[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {data_in[1]}]
set_property PACKAGE_PIN W16 [get_ports {data_in[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {data_in[2]}]
set_property PACKAGE_PIN W17 [get_ports {data_in[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {data_in[3]}]
set_property PACKAGE_PIN W15 [get_ports {data_in[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {data_in[4]}]
set_property PACKAGE_PIN V15 [get_ports {data_in[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {data_in[5]}]
set_property PACKAGE_PIN W14 [get_ports {data_in[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {data_in[6]}]
set_property PACKAGE_PIN W13 [get_ports {data_in[7]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {data_in[7]}]
set_property PACKAGE_PIN V2 [get_ports {data_in[8]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {data_in[8]}]
set_property PACKAGE_PIN T3 [get_ports {data_in[9]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {data_in[9]}]
set_property PACKAGE_PIN T2 [get_ports {data_in[10]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {data_in[10]}]
set_property PACKAGE_PIN R3 [get_ports {data_in[11]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {data_in[11]}]
set_property PACKAGE_PIN W2 [get_ports {data_in[12]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {data_in[12]}]
set_property PACKAGE_PIN U1 [get_ports {data_in[13]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {data_in[13]}]
set_property PACKAGE_PIN T1 [get_ports {data_in[14]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {data_in[14]}]
set_property PACKAGE_PIN R2 [get_ports {data_in[15]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {data_in[15]}]

## LEDs
# Saída nrz_out mapeada para o LED 0 (mais à direita)
set_property PACKAGE_PIN U16 [get_ports nrz_out]					
	set_property IOSTANDARD LVCMOS33 [get_ports nrz_out]

# Saída bit_idx mapeada para os LEDs 12 a 15 (mais à esquerda)
set_property PACKAGE_PIN P3 [get_ports {bit_idx[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {bit_idx[0]}]
set_property PACKAGE_PIN N3 [get_ports {bit_idx[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {bit_idx[1]}]
set_property PACKAGE_PIN P1 [get_ports {bit_idx[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {bit_idx[2]}]
set_property PACKAGE_PIN L1 [get_ports {bit_idx[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {bit_idx[3]}]

## Buttons
# Reset mapeado para o botão central (btnC)
set_property PACKAGE_PIN U18 [get_ports reset]						
	set_property IOSTANDARD LVCMOS33 [get_ports reset]

## Pmod Header JA (Pino 1)
# Saída para o osciloscópio
set_property PACKAGE_PIN J1 [get_ports tx_pmod]					
	set_property IOSTANDARD LVCMOS33 [get_ports tx_pmod]