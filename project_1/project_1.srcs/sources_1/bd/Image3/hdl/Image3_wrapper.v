//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
//Date        : Mon Nov 21 14:06:30 2022
//Host        : LAPTOP-M8D0H7HH running 64-bit major release  (build 9200)
//Command     : generate_target Image3_wrapper.bd
//Design      : Image3_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module Image3_wrapper
   (BRAM_PORTA_0_addr,
    BRAM_PORTA_0_clk,
    BRAM_PORTA_0_din,
    BRAM_PORTA_0_dout,
    BRAM_PORTA_0_en,
    BRAM_PORTA_0_we);
  input [13:0]BRAM_PORTA_0_addr;
  input BRAM_PORTA_0_clk;
  input [23:0]BRAM_PORTA_0_din;
  output [23:0]BRAM_PORTA_0_dout;
  input BRAM_PORTA_0_en;
  input [0:0]BRAM_PORTA_0_we;

  wire [13:0]BRAM_PORTA_0_addr;
  wire BRAM_PORTA_0_clk;
  wire [23:0]BRAM_PORTA_0_din;
  wire [23:0]BRAM_PORTA_0_dout;
  wire BRAM_PORTA_0_en;
  wire [0:0]BRAM_PORTA_0_we;

  Image3 Image3_i
       (.BRAM_PORTA_0_addr(BRAM_PORTA_0_addr),
        .BRAM_PORTA_0_clk(BRAM_PORTA_0_clk),
        .BRAM_PORTA_0_din(BRAM_PORTA_0_din),
        .BRAM_PORTA_0_dout(BRAM_PORTA_0_dout),
        .BRAM_PORTA_0_en(BRAM_PORTA_0_en),
        .BRAM_PORTA_0_we(BRAM_PORTA_0_we));
endmodule
