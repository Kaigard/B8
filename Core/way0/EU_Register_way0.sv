module EU_Register_way0(
    `ifdef DebugMode
        input logic [31:0] inst_i,
        output logic [31:0] inst_o,
    `endif
    input logic clk,
    input logic reset_n,
    input logic [4:0] rdAddr_i,
    input logic rdWriteEnable_i,
    input logic [31:0] instAddr_i,
    input logic [63:0] rs1ReadData_i,
    input logic [63:0] rs2ReadData_i,
    input logic [63:0] imm_i,
    input logic [6:0] opCode_i,
    input logic [2:0] funct3_i,
    input logic [6:0] funct7_i,
    input logic [5:0] shamt_i,
    input logic [1:0] way0_pID_i,
    input logic valid_i,                                        //表示该级数据有效
    input logic ready_i,
    output logic [4:0] rdAddr_o,
    output logic rdWriteEnable_o,
    output logic [31:0] instAddr_o,
    output logic [63:0] rs1ReadData_o,
    output logic [63:0] rs2ReadData_o,
    output logic [63:0] imm_o,
    output logic [6:0] opCode_o,
    output logic [2:0] funct3_o,
    output logic [6:0] funct7_o,
    output logic [5:0] shamt_o,
    output logic [1:0] way0_pID_o,
    output logic valid_o,
    output logic ready_o
);

    // assign ready_o = ready_i;
    always_ff @(posedge clk or negedge reset_n) begin
        if(~reset_n) begin
            ready_o <= 1'b1;
        end else begin
            ready_o <= ready_i;
        end
    end

    // valid只表明数据有效，不具备握手功能
    always_ff @(posedge clk or negedge reset_n) begin
        if(~reset_n) begin
            valid_o <= 1'b0;
        end else if(ready_o) begin
            valid_o <= 1'b1;
        end else begin
            valid_o <= 1'b0;
        end
    end

    always_ff @(posedge clk or negedge reset_n) begin
        if(~reset_n) begin
            rdAddr_o <= 5'b0;
            rdWriteEnable_o <= 1'b0;
            instAddr_o <= 32'b0;
            rs1ReadData_o <= 64'b0;
            rs2ReadData_o <= 64'b0;
            imm_o <= 64'b0;
            opCode_o <= 7'b0;
            funct3_o <= 3'b0;
            funct7_o <= 7'b0;
            shamt_o <= 6'b0;
            way0_pID_o <= 2'b0;
        end else if(ready_o) begin
            rdAddr_o <= rdAddr_i;
            rdWriteEnable_o <= rdWriteEnable_i;
            instAddr_o <= instAddr_i; 
            rs1ReadData_o <= rs1ReadData_i;
            rs2ReadData_o <= rs2ReadData_i;
            imm_o <= imm_i;
            opCode_o <= opCode_i;
            funct3_o <= funct3_i;
            funct7_o <= funct7_i;
            shamt_o <= shamt_i;
            way0_pID_o <= way0_pID_i;
        end
    end

    `ifdef DebugMode
        always_ff @(posedge clk or negedge reset_n) begin
            if(~reset_n) begin
                inst_o <= 32'b0;
            end else if(ready_o) begin
                inst_o <= inst_i;
            end
        end
    `endif 

endmodule