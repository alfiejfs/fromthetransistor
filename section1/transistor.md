# Transistor definition

Wikipedia defines the transistor as:
> A transistor is a semiconductor device used to amplify or switch electrical signals and power.

This explanation defines the transistor correctly, but requires an understanding of semiconductors, and what it means to amplify or switch electrical signals and power, so we will look at that now.

## What is a semiconductor

Recalling from secondary school physics, a conductor is something which allows electrical current to flow through it, and an insulator is something that does not allow electrical current to flow through it (easily). This means the electrical resistance of the conductor is low, and the resistance of the insulator is high.

A semiconductor can then be considered as "something" that has a conductivity ranging between that of an insulator and a conductor.

## Back to the transistor

Understanding now what it means for a transistor to be a semiconductor, we examine the latter half of the definition:
> [...] used to amplify or switch electrical signals and power.

This is simple enough. A transistor is able to amplify or switch a signal, deciding whether to do so based on an input signal it receives. 

# Integrated Circuits

Wikipedia defines an integrated circuit as:
> An integrated circuit (IC) is a set of electronic circuits, consisting of various electronic components (such as transistors, resistors, and capacitors) and their interconnections.

Intergrated circuits consildate these components into a single small chip. This has many obvious benefits:

- miniaturization (we no longer need to fiddle around with individual transistors, so we can make them smaller)
- cost efficiency at scale, as ICs are generally versatile
- reliability, since there is less risk of failure due to poor connections or other external factors

Most modern IC chips are metal-oxide-semiconductor (MOS) integrated circuits, built from MOSFETs.

## MOSFET

The MOSFET (metal-oxide-silicon field-effect transistor) is a type of field-effect transistor (FET). The field-effect transistor is a type of transistor that uses an electric field to control the current through a semiconductor. It has three terminals: source, gate, and drain. FETs control the current by the application of a voltage to the gate, which in turn alters the conductivity between the drain and source. If there is not a sufficient voltage to the gate, no current will flow between the source and the drain (even if there is a potential difference).

# FPGA

The field-programmable gate array (FPGA) is an integrated circuit which allows the owner to reconfigure the hardware to meet speci0fic use case requirement after the manufacturing process (which differs from something like an ASIC).

FPGAs typically consist of:

- an array of logic blocks (configurable logic blocks)
- I/O pads
- routing channels

TODO: explain more about what these components are, but essentially logic blocks for combinatorial logic, I/O pads for MMIO/interfacing with the real world, and routing channels for linking CLBs together, and I/O pads with CLBs.
