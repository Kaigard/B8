module RegFile(
    input clk,
    input reset_n,
    // way0
    input [4:0] way0_rs1Addr_i,
    input [4:0] way0_rs2Addr_i,
    input way0_rs1ReadEnable_i,
    input way0_rs2ReadEnable_i,
    input way0_pID_DU_i,
    // way1
    input [4:0] way1_rs1Addr_i,
    input [4:0] way1_rs2Addr_i,
    input way1_rs1ReadEnable_i,
    input way1_rs2ReadEnable_i,
    input way1_pID_DU_i,

    // To DU
    output [63:0] way0_rs1ReadData_o,
    output [63:0] way0_rs2ReadData_o,
    output [63:0] way1_rs1ReadData_o,
    output [63:0] way1_rs2ReadData_o
);

    reg [63:0] Register [31:0];

    // 数据寄存不复位
    always @(posedge clk) begin
        if()
    end

endmodule