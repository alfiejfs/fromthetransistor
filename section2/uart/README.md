# What is a UART?

UART stands for universal asynchronous receiver transmitter. It is one of the simplest methods of communicating with an FPGA.

A UART is an interface that sends out (typically) a byte at a time over a single wire. UARTs can operate in either half-duplex (two transmitters sharing a line) or full-duplex (two transmitters each with their own line).

The baud rate is the rate of transfer, which must be agreed upon by both the transmitter and receiver. A parity bit may be used, perhaps occupying the last bit of every transfer.

# Asynchronous vs Synchronous Information Transfer

Data can arrive in two ways:

- on a clock pulse (synchronous)
- by itself (asynchronous)

UART, as suggested by the full form of the acronym, is an asynchronous interface.

# Sources

I found these sources particularly useful for this exercise:

- https://nandland.com/uart-rs-232-serial-port-com-port/
- https://nandland.com/uart-serial-port-module/
- https://ece353.engr.wisc.edu/serial-interfaces/uart-basics/
