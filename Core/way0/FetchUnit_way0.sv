module FetchUnit_way0(
    `ifdef DebugMode
        input logic [31:0] instAddr_i,
        input logic [31:0] inst_i,
        output logic [31:0] instAddr_o,
        output logic [31:0] inst_o, 
        input logic clk,
        input logic reset_n,   
    `endif
    input logic rdWriteEnable_i,
    input logic [4:0] rdAddr_i,
    input logic [63:0] rdData_i,
    input logic valid_i,
    input logic ready_i,
    input logic [1:0] way0_pID_i,
    input logic [2:0] funct3_i,
    // input logic [31:0] readAddr_i,
    // input logic [31:0] writeAddr_i,
    // input logic [63:0] writeData_i,
    // input logic [3:0] writeMask_i, 
    // From RAM
    input logic [63:0] readData_i,
    input logic dataOk_i,
    input logic [2:0] writeState_i,
    // To WBU
    output logic rdWriteEnable_o,
    output logic [4:0] rdAddr_o,
    output logic [63:0] rdData_o,
    output logic valid_o,
    output logic ready_o,
    output logic [1:0] way0_pID_o
    // output logic dataOk_o,
    // output logic [2:0] writeState_o
    // To RAM
    // output logic [31:0] readAddr_o,
    // output logic [31:0] writeAddr_o,
    // output logic [63:0] writeData_o,
    // output logic [3:0] writeMask_o
);
    
    wire [63:0] readData;

    assign rdWriteEnable_o = rdWriteEnable_i;
    assign rdAddr_o = rdAddr_i;
    assign rdData_o = rdData_i;
    assign valid_o = valid_i;
    assign way0_pID_o = way0_pID_i;
    // assign readAddr_o = readAddr_i;
    // assign writeAddr_o = writeAddr_i;
    // assign writeData_o = writeData_i;
    // assign writeMask_o = writeMask_i;
     assign ready_o = ready_i;
    // assign dataOk_o = dataOk_i;
    // assign writeState_o = writeState_i;

    MuxKeyWithDefault #(7, 3, 64) MemTypeData_mux (readData, funct3_i, 64'b0, {
      //Ld
      3'b011, readData_i,
      //Lw
      3'b010, {{32{readData_i[31]}}, readData_i[31:0]},
      //Lh
      3'b001, {{48{readData_i[31]}}, readData_i[15:0]},
      //Lb
      3'b000, {{56{readData_i[31]}}, readData_i[7:0]},
      //Lbu
      3'b100, {{56{1'b0}}, readData_i[7:0]},
      //Lhu
      3'b101, {{48{1'b0}}, readData_i[15:0]},
      //Lwu
      3'b110, {{32{1'b0}}, readData_i[31:0]}
    });

    `ifdef DebugMode
        assign instAddr_o = instAddr_i;
        assign inst_o = inst_i;
    `endif

endmodule