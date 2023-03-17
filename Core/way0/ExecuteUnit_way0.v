module ExecuteUnit_way0(
    `ifdef TestMode
        input [31:0] instAddr_i,
        output [31:0] instAddr_o,
        input [31:0] inst_i,
        output [31:0] inst_o,
    `endif
    input [4:0] rdAddr_i,
    input rdWriteEnable_i,
    input [63:0] rs1ReadData_i,
    input [63:0] rs2ReadData_i,
    input [63:0] imm_i,
    input [6:0] opCode_i,
    input [2:0] funct3_i,
    input [6:0] funct7_i,
    input [5:0] shamt_i,
    input [1:0] way0_pID_i,
    input valid_i,
    input ready_i,

    output ready_o

);
    assign ready_o = ready_i;


endmodule