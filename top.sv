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

  1.0 -- Initial release

  */


module top(
  input              clk_25m_i,

  output wire [14:0] memory_mem_a,
  output wire [2:0]  memory_mem_ba,
  output wire        memory_mem_ck,
  output wire        memory_mem_ck_n,
  output wire        memory_mem_cke,
  output wire        memory_mem_cs_n,
  output wire        memory_mem_ras_n,
  output wire        memory_mem_cas_n,
  output wire        memory_mem_we_n,
  output wire        memory_mem_reset_n,
  inout  wire [31:0] memory_mem_dq,
  inout  wire [3:0]  memory_mem_dqs,
  inout  wire [3:0]  memory_mem_dqs_n,
  output wire        memory_mem_odt,
  output wire [3:0]  memory_mem_dm,
  input  wire        memory_oct_rzqin,

  output wire        hps_io_hps_io_emac1_inst_TX_CLK,
  output wire        hps_io_hps_io_emac1_inst_TXD0,
  output wire        hps_io_hps_io_emac1_inst_TXD1,
  output wire        hps_io_hps_io_emac1_inst_TXD2,
  output wire        hps_io_hps_io_emac1_inst_TXD3,
  input  wire        hps_io_hps_io_emac1_inst_RXD0,
  inout  wire        hps_io_hps_io_emac1_inst_MDIO,
  output wire        hps_io_hps_io_emac1_inst_MDC,
  input  wire        hps_io_hps_io_emac1_inst_RX_CTL,
  output wire        hps_io_hps_io_emac1_inst_TX_CTL,
  input  wire        hps_io_hps_io_emac1_inst_RX_CLK,
  input  wire        hps_io_hps_io_emac1_inst_RXD1,
  input  wire        hps_io_hps_io_emac1_inst_RXD2,
  input  wire        hps_io_hps_io_emac1_inst_RXD3,
  inout  wire        hps_io_hps_io_qspi_inst_IO0,
  inout  wire        hps_io_hps_io_qspi_inst_IO1,
  inout  wire        hps_io_hps_io_qspi_inst_IO2,
  inout  wire        hps_io_hps_io_qspi_inst_IO3,
  output wire        hps_io_hps_io_qspi_inst_SS0,
  output wire        hps_io_hps_io_qspi_inst_CLK,
  inout  wire        hps_io_hps_io_sdio_inst_CMD,
  inout  wire        hps_io_hps_io_sdio_inst_D0,
  inout  wire        hps_io_hps_io_sdio_inst_D1,
  output wire        hps_io_hps_io_sdio_inst_CLK,
  inout  wire        hps_io_hps_io_sdio_inst_D2,
  inout  wire        hps_io_hps_io_sdio_inst_D3,
  inout  wire        hps_io_hps_io_usb1_inst_D0,
  inout  wire        hps_io_hps_io_usb1_inst_D1,
  inout  wire        hps_io_hps_io_usb1_inst_D2,
  inout  wire        hps_io_hps_io_usb1_inst_D3,
  inout  wire        hps_io_hps_io_usb1_inst_D4,
  inout  wire        hps_io_hps_io_usb1_inst_D5,
  inout  wire        hps_io_hps_io_usb1_inst_D6,
  inout  wire        hps_io_hps_io_usb1_inst_D7,
  input  wire        hps_io_hps_io_usb1_inst_CLK,
  output wire        hps_io_hps_io_usb1_inst_STP,
  input  wire        hps_io_hps_io_usb1_inst_DIR,
  input  wire        hps_io_hps_io_usb1_inst_NXT,
  input  wire        hps_io_hps_io_uart0_inst_RX,
  output wire        hps_io_hps_io_uart0_inst_TX,
  inout  wire        hps_io_hps_io_i2c0_inst_SDA,
  inout  wire        hps_io_hps_io_i2c0_inst_SCL,
  inout  wire        hps_io_hps_io_gpio_inst_GPIO44,
  inout  wire        hps_io_hps_io_gpio_inst_LOANIO09
);

logic [66:0] hps_loan_io_in;
logic [66:0] hps_loan_io_out;
logic [66:0] hps_loan_io_oe;
logic        pio_led_w;

localparam LED_HPS_PIN_NUM = 9;

// like https://www.altera.com/en_US/pdfs/literature/an/an702.pdf, page 8
assign hps_loan_io_out[ LED_HPS_PIN_NUM ] = pio_led_w;
assign hps_loan_io_oe [ LED_HPS_PIN_NUM ] = 1'b1;

soc soc(
  .memory_mem_a                           ( memory_mem_a                      ),
  .memory_mem_ba                          ( memory_mem_ba                     ),
  .memory_mem_ck                          ( memory_mem_ck                     ),
  .memory_mem_ck_n                        ( memory_mem_ck_n                   ),
  .memory_mem_cke                         ( memory_mem_cke                    ),
  .memory_mem_cs_n                        ( memory_mem_cs_n                   ),
  .memory_mem_ras_n                       ( memory_mem_ras_n                  ),
  .memory_mem_cas_n                       ( memory_mem_cas_n                  ),
  .memory_mem_we_n                        ( memory_mem_we_n                   ),
  .memory_mem_reset_n                     ( memory_mem_reset_n                ),
  .memory_mem_dq                          ( memory_mem_dq                     ),
  .memory_mem_dqs                         ( memory_mem_dqs                    ),
  .memory_mem_dqs_n                       ( memory_mem_dqs_n                  ),
  .memory_mem_odt                         ( memory_mem_odt                    ),
  .memory_mem_dm                          ( memory_mem_dm                     ),
  .memory_oct_rzqin                       ( memory_oct_rzqin                  ),

  .hps_io_hps_io_emac1_inst_TX_CLK        ( hps_io_hps_io_emac1_inst_TX_CLK   ),
  .hps_io_hps_io_emac1_inst_TXD0          ( hps_io_hps_io_emac1_inst_TXD0     ),
  .hps_io_hps_io_emac1_inst_TXD1          ( hps_io_hps_io_emac1_inst_TXD1     ),
  .hps_io_hps_io_emac1_inst_TXD2          ( hps_io_hps_io_emac1_inst_TXD2     ),
  .hps_io_hps_io_emac1_inst_TXD3          ( hps_io_hps_io_emac1_inst_TXD3     ),
  .hps_io_hps_io_emac1_inst_RXD0          ( hps_io_hps_io_emac1_inst_RXD0     ),
  .hps_io_hps_io_emac1_inst_MDIO          ( hps_io_hps_io_emac1_inst_MDIO     ),
  .hps_io_hps_io_emac1_inst_MDC           ( hps_io_hps_io_emac1_inst_MDC      ),
  .hps_io_hps_io_emac1_inst_RX_CTL        ( hps_io_hps_io_emac1_inst_RX_CTL   ),
  .hps_io_hps_io_emac1_inst_TX_CTL        ( hps_io_hps_io_emac1_inst_TX_CTL   ),
  .hps_io_hps_io_emac1_inst_RX_CLK        ( hps_io_hps_io_emac1_inst_RX_CLK   ),
  .hps_io_hps_io_emac1_inst_RXD1          ( hps_io_hps_io_emac1_inst_RXD1     ),
  .hps_io_hps_io_emac1_inst_RXD2          ( hps_io_hps_io_emac1_inst_RXD2     ),
  .hps_io_hps_io_emac1_inst_RXD3          ( hps_io_hps_io_emac1_inst_RXD3     ),
  .hps_io_hps_io_qspi_inst_IO0            ( hps_io_hps_io_qspi_inst_IO0       ),
  .hps_io_hps_io_qspi_inst_IO1            ( hps_io_hps_io_qspi_inst_IO1       ),
  .hps_io_hps_io_qspi_inst_IO2            ( hps_io_hps_io_qspi_inst_IO2       ),
  .hps_io_hps_io_qspi_inst_IO3            ( hps_io_hps_io_qspi_inst_IO3       ),
  .hps_io_hps_io_qspi_inst_SS0            ( hps_io_hps_io_qspi_inst_SS0       ),
  .hps_io_hps_io_qspi_inst_CLK            ( hps_io_hps_io_qspi_inst_CLK       ),
  .hps_io_hps_io_sdio_inst_CMD            ( hps_io_hps_io_sdio_inst_CMD       ),
  .hps_io_hps_io_sdio_inst_D0             ( hps_io_hps_io_sdio_inst_D0        ),
  .hps_io_hps_io_sdio_inst_D1             ( hps_io_hps_io_sdio_inst_D1        ),
  .hps_io_hps_io_sdio_inst_CLK            ( hps_io_hps_io_sdio_inst_CLK       ),
  .hps_io_hps_io_sdio_inst_D2             ( hps_io_hps_io_sdio_inst_D2        ),
  .hps_io_hps_io_sdio_inst_D3             ( hps_io_hps_io_sdio_inst_D3        ),
  .hps_io_hps_io_usb1_inst_D0             ( hps_io_hps_io_usb1_inst_D0        ),
  .hps_io_hps_io_usb1_inst_D1             ( hps_io_hps_io_usb1_inst_D1        ),
  .hps_io_hps_io_usb1_inst_D2             ( hps_io_hps_io_usb1_inst_D2        ),
  .hps_io_hps_io_usb1_inst_D3             ( hps_io_hps_io_usb1_inst_D3        ),
  .hps_io_hps_io_usb1_inst_D4             ( hps_io_hps_io_usb1_inst_D4        ),
  .hps_io_hps_io_usb1_inst_D5             ( hps_io_hps_io_usb1_inst_D5        ),
  .hps_io_hps_io_usb1_inst_D6             ( hps_io_hps_io_usb1_inst_D6        ),
  .hps_io_hps_io_usb1_inst_D7             ( hps_io_hps_io_usb1_inst_D7        ),
  .hps_io_hps_io_usb1_inst_CLK            ( hps_io_hps_io_usb1_inst_CLK       ),
  .hps_io_hps_io_usb1_inst_STP            ( hps_io_hps_io_usb1_inst_STP       ),
  .hps_io_hps_io_usb1_inst_DIR            ( hps_io_hps_io_usb1_inst_DIR       ),
  .hps_io_hps_io_usb1_inst_NXT            ( hps_io_hps_io_usb1_inst_NXT       ),
  .hps_io_hps_io_uart0_inst_RX            ( hps_io_hps_io_uart0_inst_RX       ),
  .hps_io_hps_io_uart0_inst_TX            ( hps_io_hps_io_uart0_inst_TX       ),
  .hps_io_hps_io_i2c0_inst_SDA            ( hps_io_hps_io_i2c0_inst_SDA       ),
  .hps_io_hps_io_i2c0_inst_SCL            ( hps_io_hps_io_i2c0_inst_SCL       ),
  .hps_io_hps_io_gpio_inst_GPIO44         ( hps_io_hps_io_gpio_inst_GPIO44    ),
  .hps_io_hps_io_gpio_inst_LOANIO09       ( hps_io_hps_io_gpio_inst_LOANIO09  ),

  .clk_25m_clk                            ( clk_25m_i                         ),

  .hps_loan_io_in                         ( hps_loan_io_in                    ),
  .hps_loan_io_out                        ( hps_loan_io_out                   ),
  .hps_loan_io_oe                         ( hps_loan_io_oe                    ),

  .pio_led_external_export                ( pio_led_w                         )
);


endmodule
