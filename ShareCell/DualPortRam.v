/*
 * @Author: Kai Zhou && zhouk9864@gmail.com
 * @Date: 2022-09-26 20:35:23
 * @LastEditors: Kai Zhou && zhouk9864@gmail.com
 * @LastEditTime: 2022-11-16 09:27:34
 * @FilePath: /Anfield_SOC/vsrc/Anfield/Balotelli/ShareCell/DualPortRam.v
 * @Description: 双口Ram行为级模型。
 * 
 * Copyright (c) 2022 by Kai Zhou zhouk9864@gmail.com, All Rights Reserved. 
 */
`timescale 1ns / 1ps

module DualPortRam
#(
  parameter DataWidth = 64,
  parameter Deepth = 10'h3FF
)
(
  input WClk,
  input [DataWidth - 1 : 0] WData,
  input [((Deepth == 1) ? Deepth : $clog2(Deepth) - 1) : 0] WAddr,
  input WEnc,
  input RClk,
  output reg [DataWidth - 1 : 0] RData,
  input [((Deepth == 1) ? Deepth : $clog2(Deepth) - 1) : 0] RAddr,
  input REnc
);

  reg [DataWidth - 1 : 0] RamMem [Deepth : 0];

  // write
  always @(posedge WClk) begin
    if(WEnc) begin
      /* verilator lint_off WIDTH */
      RamMem[WAddr] <= WData;
	  end
  end

  //read
  always @(posedge RClk) begin
    if(REnc) begin
      /* verilator lint_off WIDTH */
	    RData <= RamMem[RAddr];
    end
  end
  // assign RData = RamMem[RAddr];

endmodule