module WriteBackUnit_way0(
    `ifdef DebugMode
        input logic [31:0] instAddr_i,
        input logic [31:0] inst_i,
        output logic [31:0] instAddr_o,
        output logic [31:0] inst_o,    
    `endif

    input logic rdWriteEnable_i,
    input logic [4:0] rdAddr_i,
    input logic [63:0] rdData_i,
    input logic valid_i,
    input logic ready_i,
    input logic [1:0] way0_pID_i,

    output logic rdWriteEnable_o,
    output logic [4:0] rdAddr_o,
    output logic [63:0] rdData_o,
    output logic valid_o,
    output logic ready_o,
    output logic [1:0] way0_pID_o
);

    assign rdWriteEnable_o = rdWriteEnable_i;
    assign rdAddr_o = rdAddr_i;
    assign rdData_o = rdData_i;
    assign valid_o = valid_i;
    assign ready_o = ready_i;
    assign way0_pID_o = way0_pID_i;

    `ifdef DebugMode
        assign instAddr_o = instAddr_i;
        assign inst_o = inst_i;
    `endif

endmodule