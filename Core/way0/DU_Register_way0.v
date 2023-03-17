module DU_Register_way0(
    `ifdef TestMode
        input [31:0] instAddr_i,
        output reg [31:0] instAddr_o,
        input [31:0] inst_i,
        output reg [31:0] inst_o,
    `endif
    input clk,
    input reset_n,
    input [4:0] rdAddr_i,
    input rdWriteEnable_i,
    input [63:0] rs1ReadData_i,
    input [63:0] rs2ReadData_i,
    input [63:0] imm_i,
    input [6:0] opCode_i,
    input [2:0] funct3_i,
    input [6:0] funct7_i,
    input [5:0] shamt_i,
    input valid_i,
    input ready_i,
    output reg [4:0] rdAddr_o,
    output reg rdWriteEnable_o,
    output reg [63:0] rs1ReadData_o,
    output reg [63:0] rs2ReadData_o,
    output reg [63:0] imm_o,
    output reg [6:0] opCode_o,
    output reg [2:0] funct3_o,
    output reg [6:0] funct7_o,
    output reg [5:0] shamt_o,
    output reg valid_o,
    output ready_o
);

    // 如果下一级未准备好，可以接受上一级的数据，在此级停留，但是在此期间valid不许拉低！
    assign ready_o = ready_i;

    always @(posedge clk or negedge reset_n) begin
        if(~reset_n) begin
            valid_o <= 1'b0;
        end else if(ready_i) begin
            valid_o <= valid_i;
        end
    end

    always @(posedge clk or negedge reset_n) begin
        if(~reset_n) begin
            rdAddr_o <= 5'b0;
            rdWriteEnable_o <= 1'b0;
            rs1ReadData_o <= 64'b0;
            rs2ReadData_o <= 64'b0;
            imm_o <= 64'b0;
            opCode_o <= 7'b0;
            funct3_o <= 3'b0;
            funct7_o <= 7'b0;
            shamt_o <= 6'b0;
        end else if(valid_i && ready_o) begin
            rdAddr_o <= rdAddr_i;
            rdWriteEnable_o <= rdWriteEnable_i;
            rs1ReadData_o <= rs1ReadData_i;
            rs2ReadData_o <= rs2ReadData_i;
            imm_o <= imm_i;
            opCode_o <= opCode_i;
            funct3_o <= funct3_i;
            funct7_o <= funct7_i;
            shamt_o <= shamt_i;
        end
    end

    `ifdef TestMode
        always @(posedge clk or negedge reset_n) begin
            if(~reset_n) begin
                instAddr_o <= 32'b0;
                inst_o <= 32'b0
            end else if(valid_i && ready_o) begin
                instAddr_o <= instAddr_i;
                inst_o <= inst_i;
            end
        end
    `endif 

endmodule