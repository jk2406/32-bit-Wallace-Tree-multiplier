# Wallace Tree Multiplier – ASIC Implementation (OpenLane / SKY130)

-------------------------------------------------------------------------------
PROJECT OVERVIEW
-------------------------------------------------------------------------------

This project implements a hierarchical Wallace Tree Multiplier in synthesizable
RTL targeting ASIC implementation using:

  • OpenLane Flow
  • SKY130 standard cell library (sky130_fd_sc_hd)

Design scalability:

  4x4  →  8x8  →  16x16  →  32x32

Top-level module:
  wallacetree32x32.sv


-------------------------------------------------------------------------------
ARCHITECTURE FUNDAMENTALS
-------------------------------------------------------------------------------

Multiplication Principle:
  For two N-bit numbers A and B:

    Product = Sum of (A & bj) << j

This produces N² partial products.

Traditional Array Multiplier:
  - Adds row by row
  - Long carry propagation chain
  - O(N) critical path

Wallace Tree Approach:
  - Generates all partial products in parallel
  - Compresses each bit-column using:
        • Half Adders
        • Full Adders (Carry Save Adders)
  - Reduces matrix height logarithmically
  - Final fast carry-propagate adder

Result:
  Reduced logic depth
  Improved timing performance
  Better scalability for large bit-widths


-------------------------------------------------------------------------------
DIRECTORY STRUCTURE
-------------------------------------------------------------------------------
```
black_cell.sv
brent_kung_32.sv
brent_kung_64.sv
cla_4bit.sv
cla_16bit.sv
csa_16bit.sv
csa_32bit.sv
csa_64bit.sv
full_adder.sv
half_adder.sv
wallacetree4x4.sv
wallacetree8x8.sv
wallacetree16x16.sv
wallacetree32x32.sv
```

-------------------------------------------------------------------------------
MODULE DESCRIPTION
-------------------------------------------------------------------------------

1) Primitive Blocks
--------------------

half_adder.sv
  - 2-input combinational adder
  - Outputs sum and carry

full_adder.sv
  - 3-input combinational adder
  - Core element of carry-save compression


2) Carry Save Adders
--------------------

csa_16bit.sv
csa_32bit.sv
csa_64bit.sv

  - Used to reduce three operands into two
  - Eliminates carry propagation between columns
  - Key to Wallace compression speed


3) Carry Lookahead Adders
-------------------------

cla_4bit.sv
cla_16bit.sv

  - Used in lower hierarchy levels
  - Faster than ripple carry
  - Computes carries using propagate/generate logic


4) Parallel Prefix Adders
-------------------------

brent_kung_32.sv
brent_kung_64.sv

  - Logarithmic carry computation
  - Lower wiring congestion compared to Kogge-Stone
  - Used for final addition in large multipliers


5) Wallace Tree Hierarchy
--------------------------

wallacetree4x4.sv
  - Base implementation
  - Manual column compression
  - Used as building block

wallacetree8x8.sv
  - Built using 4x4 blocks
  - CSA-based intermediate reduction

wallacetree16x16.sv
  - Built using 8x8 blocks
  - Larger compression tree

wallacetree32x32.sv  ← TOP MODULE
  - Final hierarchical multiplier
  - Uses CSA + Brent-Kung adder
  - Fully combinational design


-------------------------------------------------------------------------------
SYNTHESIS TARGET
-------------------------------------------------------------------------------

Technology:
  sky130_fd_sc_hd

Flow:
  OpenLane

Design Style:
  - Fully combinational
  - Structural RTL
  - Hierarchical compression
  - No behavioral multipliers (* operator avoided)

Key ASIC Considerations:
  • High routing density due to partial product matrix
  • Fanout management important
  • Final adder dominates critical path
  • Area grows approximately O(N²)


-------------------------------------------------------------------------------
CRITICAL PATH ANALYSIS (THEORETICAL)
-------------------------------------------------------------------------------

For 32x32:

  Partial Product Generation → 1 gate delay
  CSA Compression Tree       → ~log₃/₂(32) levels
  Brent-Kung Final Adder     → log₂(32) stages

Estimated logical depth ≈ 10–14 stages

Performance depends on:
  - Cell sizing
  - Placement density
  - Wire delay
  - Buffer insertion


-------------------------------------------------------------------------------
DESIGN CHARACTERISTICS
-------------------------------------------------------------------------------

• Pure RTL structural arithmetic
• No use of behavioral multiplication
• Synthesizable in ASIC flow
• Suitable for timing optimization experiments
• Scalable hierarchical architecture


-------------------------------------------------------------------------------
HOW TO RUN (OPENLANE)
-------------------------------------------------------------------------------

1) Place RTL inside:
     designs/wallace/src/

2) Configure config.json:
     DESIGN_NAME = "wallacetree32x32"

3) Run OpenLane flow:
     `make mount `
     `flow.tcl -design wallace`

5) Inspect:
     • Synthesis reports
     • Timing reports
     • Floorplan
     • GDS output
   > These reports finally generated provided in the folders provided.


