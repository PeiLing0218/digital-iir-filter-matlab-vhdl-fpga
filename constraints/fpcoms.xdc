## =========================================================
## Constraint File for Filter_Processing1.vhd
## Target Board: Xilinx KCU105 (XCKU025-FFVA1156-2-E)
## System Clock: 100 MHz (pin Y9)
## =========================================================

## ------------------------------
## CLOCK INPUT (100 MHz)
## ------------------------------
set_property PACKAGE_PIN E19 [get_ports clk]
set_property IOSTANDARD LVCMOS18 [get_ports clk]
create_clock -name sys_clk -period 10.000 [get_ports clk]

## ------------------------------
## RESET INPUT (push button CPU_RESET)
## ------------------------------
set_property PACKAGE_PIN AB12 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]

## ------------------------------
## CLOCK ENABLE INPUT (user switch SW0)
## ------------------------------
set_property PACKAGE_PIN AD11 [get_ports clk_enable]
set_property IOSTANDARD LVCMOS33 [get_ports clk_enable]

## ------------------------------
## DATA INPUT In1[1:0] (DIP switches SW1-SW2)
## ------------------------------
set_property IOSTANDARD LVCMOS33 [get_ports {In1[*]}]
set_property PACKAGE_PIN AC9  [get_ports {In1[0]}]
set_property PACKAGE_PIN AC10 [get_ports {In1[1]}]

## ------------------------------
## DATA OUTPUT Out1[15:0] (LEDs LD0-LD15)
## ------------------------------
set_property IOSTANDARD LVCMOS33 [get_ports {Out1[*]}]
set_property PACKAGE_PIN W19  [get_ports {Out1[0]}]
set_property PACKAGE_PIN V19  [get_ports {Out1[1]}]
set_property PACKAGE_PIN W18  [get_ports {Out1[2]}]
set_property PACKAGE_PIN U19  [get_ports {Out1[3]}]
set_property PACKAGE_PIN U14  [get_ports {Out1[4]}]
set_property PACKAGE_PIN U15  [get_ports {Out1[5]}]
set_property PACKAGE_PIN T16  [get_ports {Out1[6]}]
set_property PACKAGE_PIN U16  [get_ports {Out1[7]}]
set_property PACKAGE_PIN V16  [get_ports {Out1[8]}]
set_property PACKAGE_PIN W16  [get_ports {Out1[9]}]
set_property PACKAGE_PIN W17  [get_ports {Out1[10]}]
set_property PACKAGE_PIN Y17  [get_ports {Out1[11]}]
set_property PACKAGE_PIN Y18  [get_ports {Out1[12]}]
set_property PACKAGE_PIN AA17 [get_ports {Out1[13]}]
set_property PACKAGE_PIN AB17 [get_ports {Out1[14]}]
set_property PACKAGE_PIN AC17 [get_ports {Out1[15]}]

## ------------------------------
## CLOCK ENABLE OUTPUT (ce_out)
## ------------------------------
set_property IOSTANDARD LVCMOS33 [get_ports ce_out]
set_property PACKAGE_PIN Y16 [get_ports ce_out]