
# ALU Design in Verilog

## Project Overview

This repository contains the Verilog implementation of a parameterized Arithmetic Logic Unit (ALU) capable of performing a wide range of arithmetic and logical operations on 8-bit operands. The design is modular, synthesizable, and verified through automated simulation.

---

## Objectives

- Implement arithmetic and logical operations with signed and unsigned support.
- Include flag generation: carry (COUT), overflow (OFLOW), equal (E), less-than (L), greater-than (G), and error (ERR).
- Delay output by one clock cycle for pipelined integration.
- Handle invalid input cases with appropriate error signaling.
- Validate design using testbenches and waveform analysis.

---

## Architecture Highlights

- Input Stage: Accepts two operands, operation command, and control signals.
- Input Latching: Inputs are latched to ensure stable one-cycle-old data for computation.
- Operation Logic: Executes arithmetic and logical functions using a case-based structure.
- Flag Generation: Sets status flags based on computation results and inputs.
- Parameterization: Operand width and command width are scalable through parameters.

---

## Simulation and Verification

- A self-testing Verilog testbench automates the validation of all supported operations.
- Waveforms confirm flag behavior and one-cycle delay.
- Edge cases such as overflow, zero, equality, and invalid input are covered.

---

## Key Results

- All arithmetic and logical operations function correctly.
- Status flags are generated accurately.
- One-cycle delay between input and output is consistently maintained.

---

## Future Work

- Add pipelining stages for improved performance.
- Include additional operations like multiplication, division, and floating-point support.
- Integrate with standard bus protocols (e.g., AXI, Wishbone).
- Apply formal verification techniques.
- Optimize for power and area efficiency.

---

## Files

Design_Code.v – Verilog source code for the ALU design

Alu_Self_Testbench.v – Self-checking testbench with assertions and pass/fail messages

Alu_Testbench_Simulation.v – Waveform-oriented testbench

stimulus1.txt – Input data file for testbenches (if required)

DESIGN_DOCUMENT_ALU.pdf – Full design specification and documentation
