# CPU Implementation in VHDL

## Overview
This project presents a VHDL implementation of a CPU, along with associated memory and control units. It demonstrates the functionality of a simple processing unit, capable of handling basic operations and memory management.

## Components
- **CPU**: Core processing unit for executing instructions.
- **DataPath**: Manages the flow of data within the CPU.
- **Memory**: Handles data storage and retrieval.
- **Control Unit**: Determines the sequence of operations based on the current instruction.

## Entity Declarations
- **CPU Implementation**:
  - Inputs: Clock (`clk`), Reset (`reset`), and 16 input ports (`port_in_01` to `port_in_16`).
  - Outputs: 16 output ports (`port_out_01` to `port_out_16`).

- **CPU**:
  - Inputs: Clock (`clk`), Reset (`reset`), and data from memory (`from_memory`).
  - Outputs: Address (`address`), data to memory (`to_memory`), and write instruction (`iwrite`).

- **DataPath**:
  - Manages internal data transfers and operations based on inputs from the Control Unit and Memory.
  - Inputs/Outputs: Various control signals and data paths.

- **Memory**:
  - Manages data storage and interfaces with the CPU for data retrieval and storage.
  - Inputs: Control signals, data, and address information.
  - Outputs: Data output and port outputs.

- **Control Unit**:
  - Determines the operation of the CPU based on current instructions.
  - Inputs: Clock (`clk`), Reset (`reset`), Instruction Register (`IR`), and CCR Result.
  - Outputs: Various control signals for the DataPath.

## Architecture
Each component has a defined architecture that specifies the internal logic and connections:

- **CPU Implementation**: Interconnects the CPU, DataPath, and Memory entities, routing signals between them.
- **CPU**: Contains the logic for instruction fetching and execution control.
- **DataPath**: Implements the logic for internal data operations and ALU actions.
- **Memory**: Manages ROM and RW memory instances, along with output ports.
- **Control Unit**: Implements the state machine for controlling the CPU's operation based on the fetched instructions.

## Usage
To utilize this implementation:
1. Set up the VHDL environment and import the provided files.
2. Instantiate the `CPUImplementation` entity in your project.
3. Provide the necessary inputs (clock, reset, and data inputs).
4. Observe the output on the specified output ports.

## Note
This implementation is for educational purposes and demonstrates basic CPU architecture. It can be extended or modified for more complex applications or specific use cases.

