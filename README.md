# smallAES

A super-tiny, iterative AES-128 encryption core designed for FPGA implementation using SystemVerilog.

## Overview
`smallAES` is a hardware-optimized AES-128 engine. It uses an iterative round-based architecture to minimize logic usage (LUTs), making it ideal for Tang Nano 1K or any resource-constrained FPGA.

## Design Highlights
* **Iterative Datapath:** Uses a single round datapath to ensure minimal footprint.
* **SystemVerilog:** Built using modern IEEE 1800-2012 constructs.
* **Verification:** Includes a SystemVerilog.
* **Portable:** Synthesis-ready for Gowin, Lattice, and Xilinx toolchains.

## Simulation
Verify the design using Icarus Verilog:
```bash
# Compile and simulate
iverilog -g2012 -o aes_sim src/aes_pkg.sv src/smallAES.sv tb/tb_smallAES.sv
vvp aes_sim

## Synthesis layout, replace $(X) with your own details
```bash
yosys -p "read_verilog -sv $(SRC); synth_gowin -top smallAES -json smallAES.json"
	nextpnr-himbaechel --device $(DEVICE) --json smallAES.json --cst $(CST) --write smallAES_out.json

# Licensed 
under the Solderpad Hardware License, v0.51. See the LICENSE file for details.
