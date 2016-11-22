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

  A simple blank avalon-mm write-only regfile.
  Specific property -- parameter for zero register initial value. 
  */



module led_flicker_regfile #(
  parameter                         REG_SIZE = 32,
  parameter                         REGS_CNT = 1,
  parameter                         REGS_REAL_CNT = ( REGS_CNT == 1 ) ? 1 : $clog2(REGS_CNT);
  parameter                         FIRST_REG_INITIAL_VALUE = 500
  ) (
  input                             clk_i,
  input                             srst_i,
   // CSR IF
  input [$clog2(REGS_REAL_CNT)-1:0] amm_address_i,
  input [REG_SIZE-1:0]              amm_writedata_i,
  input                             amm_read_i,
  input                             amm_write_i,
  output logic [REG_SIZE-1:0]       amm_readdata_o,
  output logic                      amm_readdatavalid_o,
  output logic                      amm_waitrequest_o,

  output logic [REGS_CNT-1:0][REG_SIZE-1:0] regs_o
  );

logic [REGS_CNT-1:0][REG_SIZE-1:0] regs;

logic [31:0] readdata;
logic        readdatavalid; 

initial regs = FIRST_REG_INITIAL_VALUE;

always_ff @( posedge clk_i )
  if( srst_i )
    regs <= FIRST_REG_INITIAL_VALUE; 
  else
    begin
      if( amm_write_i ) 
       //csr[amm_address_i] <= amm_writedata_i;
        regs <= amm_writedata_i;
    end

always_comb
  begin
    readdata      = '0;
    readdatavalid = '0; 
    if( amm_read_i ) 
      begin
       //readdata      = csr[amm_address_i];
        readdata      = regs;
        readdatavalid = 1'b1;
      end
  end

// delay
always_ff @( posedge clk_i )
  begin
    amm_readdata_o      <= readdata;
    amm_readdatavalid_o <= readdatavalid;
  end
// always ready
assign amm_waitrequest_o = '0;

assign regs_o = regs; 

endmodule 
     
         
         

