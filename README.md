# RISC-V Architecture with Cache Memory
## Overview
This repository outlines the top-level architecture of a RISC-V processor integrated with a cache memory system. The integration of cache memory enhances the performance of the RISC-V processor by reducing memory access latency and optimizing data retrieval.

## RISC-V Architecture
### Components:
Arithmetic Logic Unit (ALU): Performs arithmetic and logical operations.
Control Unit: Manages the flow of instructions and data.
Register File: Stores data and intermediate results.
Program Counter (PC): Keeps track of the memory address of the current instruction.
Unique Features:
Stall and Memory Read Stall Signals: The architecture includes additional signals - stall and memory_read_stall. When stall is set to 1, the PC is stalled, preventing it from incrementing. The memory_read_stall signal, sourced from the control unit, is activated only for the LW (Load Word) instruction opcode. This ensures efficient handling of memory read operations.
## Cache Memory Architecture
### Components:
Cache Controller: Manages cache operations and interfaces with the RISC-V core.
Data Cache: Stores data content for cache lines.
Tag Memory: Stores tags corresponding to data stored in cache lines.
Index Memory: Stores index information for cache lines.
Block Offset Memory: Contains block offset details for cache lines.
