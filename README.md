# ALU (Arithmetic Logic Unit) - VHDL Floating-Point Implementation

## Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Technologies Used](#technologies-used)
- [Project Structure](#project-structure)
- [Operation Selection](#operation-selection)
- [Simulation & Testing](#simulation--testing)
- [Examples](#examples)

## Overview
This project is a VHDL-based simulation of an Arithmetic Logic Unit (ALU) that performs operations on **floating-point numbers**. The design mimics hardware-level ALU behavior and supports basic arithmetic and logic operations using IEEE-754 single precision.

## Features
- Floating-point arithmetic: ADD, SUB
- Logical operations on bitwise representations: AND, OR, XOR, NOT
- IEEE-754 single precision format
- Operation selection via a 3-bit control signal
- Modular design with separate MUX and ALU components
- Integration through a top-level module
- Testbenches for both ALU and MUX

## Technologies Used
- VHDL (VHSIC Hardware Description Language)
- ModelSim / GHDL (or any VHDL simulator)
- IEEE standard libraries for floating-point operations
- Optional: FPGA board for hardware testing

## Project Structure
- `ALU.vhd`: Implements core floating-point arithmetic and logic operations
- `ALU_TB.vhd`: Testbench for validating ALU functionality
- `MUX.vhd`: Multiplexer for output selection
- `MUX_TB.vhd`: Testbench for MUX module
- `TopLevel.vhd`: Integrates ALU and MUX modules
- `TopLevel_TB.vhd`: Testbench for the top-level design

## Operation Selection
The ALU uses a 3-bit control signal to determine which operation to execute. The mapping is as follows:
```
000 - Floating-point ADD
001 - Floating-point SUB
010 - Bitwise AND
011 - Bitwise OR
100 - Bitwise XOR
101 - Bitwise NOT
110 - Reserved / Future Operation
111 - Reserved / Future Operation
```

## Simulation & Testing
1. Open your preferred VHDL simulator (e.g., ModelSim, GHDL).
2. Compile the source files:
```bash
ghdl -a ALU.vhd
ghdl -a ALU_TB.vhd
ghdl -a MUX.vhd
ghdl -a MUX_TB.vhd
ghdl -a TopLevel.vhd
ghdl -a TopLevel_TB.vhd
```
3. Run any testbench:
```bash
ghdl -e TopLevel_TB
ghdl -r TopLevel_TB --vcd=top.vcd
```
4. View waveform using GTKWave:
```bash
gtkwave top.vcd
```

## Examples
The testbenches include floating-point cases such as:
- `1.5 + 2.25 = 3.75`
- `5.0 - 1.25 = 3.75`
- Bitwise operations on IEEE-754 encoded values


