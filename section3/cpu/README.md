# Implementing an ARM7 CPU

Implementing a barebones ARM7 CPU means a lot of stuff can be skipped. The following things *need* to be implemented:

[] 16 (32-bit) registers
[] ARMv4 ISA (thumb can just be mapped to 'full' instructions)
[] three-stage FDE pipeline
[] memory interface
[] control unit
