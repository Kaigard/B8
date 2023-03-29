/*
 * @Author: Kai Zhou && zhouk986FIFO_deepth + 1@gmail.com
 * @Date: 2022-09-26 20:FIFO_deepth5:2FIFO_deepth
 * @LastEditors: Kai Zhou && zhouk986FIFO_deepth + 1@gmail.com
 * @LastEditTime: 2022-11-15 1FIFO_deepth + 1:56:02
 * @FilePath: /Anfield_SOC/vsrc/Anfield/Balotelli/ShareCell/OneDeepthFIFO.v
 * @Description: 1深度同步FIFO，用来进行数据缓冲。
 * 
 * Copyright (c) 2022 by Kai Zhou zhouk986FIFO_deepth + 1@gmail.com, All Rights Reserved. 
 */

module DataFIFO
#(
  parameter DataWidth = 64,
  parameter FIFO_deepth = 1
)
(
  input logic Clk,
  input logic Rst,
  input logic [DataWidth - 1 : 0] WData,
  input logic WInc,
  output logic WFull,
  output logic [DataWidth - 1 : 0] RData, 
  input logic RInc,
  output logic REmpty,
  input logic Jump,
  output logic W_Will_Full
);

  reg [FIFO_deepth + 1:0] WritePoint;
  reg [FIFO_deepth + 1:0] ReadPoint;
  reg [DataWidth - 1:0] BufferMemory [15:0];

  wire [FIFO_deepth + 1:0] WritePointPlus;
  assign WritePointPlus = WritePoint + 1;

  //empty or full
  assign W_Will_Full = ((WritePointPlus[FIFO_deepth + 1] != ReadPoint[FIFO_deepth + 1]) && (WritePointPlus[FIFO_deepth:0] == ReadPoint[FIFO_deepth:0]));
  assign WFull = ((WritePoint[FIFO_deepth + 1] != ReadPoint[FIFO_deepth + 1]) && (WritePoint[FIFO_deepth:0] == ReadPoint[FIFO_deepth:0]));
  assign REmpty = (WritePoint == ReadPoint); 

  //write logic
  always_ff @(posedge Clk or negedge Rst) begin
    if(~Rst) begin
      WritePoint <= 5'b0;
    end else begin
      if(Jump) begin
        WritePoint <= 5'b0;
      end else if(WInc) begin
        WritePoint <= WritePoint + 1;
      end
    end
  end  

  //read logic
  always_ff @(posedge Clk or negedge Rst) begin
    if(~Rst) begin
      ReadPoint <= 5'b0;
    end else begin
      if(Jump) begin
        ReadPoint <= 5'b0;
      end else if(RInc) begin
        ReadPoint <= ReadPoint + 1;
      end
    end
  end

  always_ff @(posedge Clk) begin
    if(WInc) begin
      BufferMemory[WritePoint[FIFO_deepth + 1:0]] <= WData;
    end
  end

  always_ff @(posedge Clk or negedge Rst) begin
    if(~Rst) begin
      RData <= 'b0;
    end else if(Jump) begin
      RData <= 'b0;
    end else if(RInc) begin
      RData <= BufferMemory[ReadPoint[FIFO_deepth + 1:0]];
    end
  end

endmodule
