/*
  Legal Notice: Copyright 2016 STC Metrotek.

  This file is part of the CB-CV-SOM FPGA default project.

  CB-CV-SOM FPGA default project is free software: you can redistribute
  it and/or modify it under the terms of the GNU General Public License
  as published by the Free Software Foundation, either version 3 of the
  License, or (at your option) any later version.

  CB-CV-SOM FPGA default project is distributed in the hope that it will
  be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
  of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
  General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with CB-CV-SOM FPGA default project. If not, see
  <http://www.gnu.org/licenses/>.

  Author: Dmitry Hodyrev d.hodyrev@metrotek.spb.ru
  Date: 02.10.2016

  Module led_flicker contains logic to produce LED control
  signal (square wave). Period of this signal can be set 
  via regfile (zero regisrer). One bit of the registers
  value is equal one millisecond. The lower limit is 32 ms.

  Module has avalon-MM pipelined interface, but endpoint logic
  of this interface is placed inside regfile
  */

module led_flicker #(
  parameter             CLOCK_FREQ_MHZ = 25,
  parameter             REGS_CNT       = 1
  )
  (
  input                 clk_i,
  input                 srst_i,

  input [$clog2(REGS_CNT)-1:0]           amm_address_i,
  input [31:0]                           amm_writedata_i,
  input                                  amm_read_i,
  input                                  amm_write_i,
  output logic [31:0]                    amm_readdata_o,
  output logic                           amm_readdatavalid_o,
  output logic                           amm_waitrequest_o,

  output logic                           led_o
  );

localparam CLOCK_PERIODS_IN_1MS = CLOCK_FREQ_MHZ * 1000;
localparam REG_SIZE = 32; // bits

// 32 bit alligning, but 16 bit access
typedef struct packed {
//logic [15:0]          not_used1;
//logic [15:0]          duty_cycle;
  logic [15:0]          not_used;
  logic [15:0]          period;
} registers_t;

registers_t registers;
logic [REGS_CNT-1:0][REG_SIZE-1:0] regs_raw;

led_flicker_regfile #(
  .REG_SIZE                               ( REG_SIZE                ),
  .REGS_CNT                               ( REGS_CNT                ),
  .FIRST_REG_INITIAL_VALUE                ( 500                     )
  ) regfile (
  .clk_i                                  ( clk_i                   ),
  .srst_i                                 ( srst_i                  ),
     // CSR IF
  .amm_address_i                          ( amm_address_i           ),
  .amm_writedata_i                        ( amm_writedata_i         ),
  .amm_read_i                             ( amm_read_i              ),
  .amm_write_i                            ( amm_write_i             ),
  .amm_readdata_o                         ( amm_readdata_o          ),
  .amm_readdatavalid_o                    ( amm_readdatavalid_o     ),
  .amm_waitrequest_o                      ( amm_waitrequest_o       ),

  .regs_o                                 ( regs_raw                )
  );

assign registers = regs_raw;

logic        period_changed;
logic [15:0] period, next_period;

always_ff @( posedge clk_i )
  period <= next_period;

assign next_period = ( registers.period < 16'h20 ) ? 16'h20 : registers.period;
assign period_changed = ( period != next_period );

// Obtain millisecond tick
logic ms_tick;
logic [31:0] ms_counter;
always_ff @( posedge clk_i )
  if( srst_i )
    ms_counter <= '0;
  else
    if( ms_tick )
      ms_counter <= '0;
    else
      ms_counter <= ms_counter + 1'b1;

assign ms_tick = ( ms_counter == CLOCK_PERIODS_IN_1MS);

// obtiain led control signal
logic [15:0] led_time_counter;

always_ff @( posedge clk_i )
  if( srst_i )
    led_time_counter <= '0;
  else
    if( ms_tick ) // ENA
      if( ( led_time_counter >= period ) || period_changed )
        led_time_counter <= '0;
      else
        led_time_counter <= led_time_counter + 1'b1;

always_ff @( posedge clk_i )
  led_o <= ( led_time_counter > ( period >> 1 ) );

endmodule






