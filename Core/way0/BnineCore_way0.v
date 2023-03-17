module BnineCore_way0 (
    input clk,
    input reset_n,
    input way0_dataOk_i,
    input [31:0] way0_inst_fetch_i,
    // From RegFile
    input [63:0] way0_rs1ReadData_i,
    input [63:0] way0_rs2ReadData_i,
    // To I-Cache
    output way0_request_o,
    output [31:0] way0_instAddr_fetch_o,
    // To RegFile
    output way0_rs1ReadEnable_o,
    output way0_rs2ReadEnable_o,
    output [4:0] way0_rs1Addr_o,
    output [4:0] way0_rs2Addr_o,


    // For Test
    input jumpFlag_i,
    input [31:0] jumpAddr_i,
    input ready_test
);

    // PCU_way0
    wire PCU_way0_valid_o;
    wire PCU_way0_ready_i;
    wire [31:0] PCU_way0_instAddr_o; 

    // IFU_way0
    //wire IFU_way0_dataOk_i;
    //wire IFU_way0_request_o;
    //wire [31:0] IFU_way0_inst_fetch_i;
    //wire [31:0] IFU_way0_instAddr_fetch_o;
    wire IFU_way0_ready_o;
    wire IFU_way0_ready_i;
    wire IFU_way0_valid_o;
    wire [1:0] IFU_way0_pID_o;
    wire [31:0] IFU_way0_inst_o;
    wire [31:0] IFU_way0_instAddr_o;

    // DU_way0
    `ifdef TestMode
        wire [31:0] DU_way0_instAddr_o;
        wire [31:0] DU_way0_inst_o;
    `endif

    wire [4:0] DU_way0_rdAddr_o;
    wire DU_way0_rdWriteEnable_o;
    wire [63:0] DU_way0_rs1ReadData_o;
    wire [63:0] DU_way0_rs2ReadData_o;
    wire [63:0] DU_way0_imm_o;
    wire [6:0] DU_way0_opCode_o;
    wire [2:0] DU_way0_funct3_o;
    wire [6:0] DU_way0_funct7_o;
    wire [5:0] DU_way0_shamt_o;
    wire DU_way0_valid_o;
    wire DU_way0_ready_i;
    wire [1:0] DU_way0_pID_o;

    // EU_way0
    `ifdef TestMode
        wire [31:0] EU_way0_instAddr_i;
        wire [31:0] EU_way0_inst_i;
    `endif

    wire [4:0] EU_way0_rdAddr_i;
    wire EU_way0_rdWriteEnable_i;
    wire [63:0] EU_way0_rs1ReadData_i;
    wire [63:0] EU_way0_rs2ReadData_i;
    wire [63:0] EU_way0_imm_i;
    wire [6:0] EU_way0_opCode_i;
    wire [2:0] EU_way0_funct3_i;
    wire [6:0] EU_way0_funct7_i;
    wire [5:0] EU_way0_shamt_i;
    wire EU_way0_valid_i;
    wire EU_way0_ready_o;
    wire [1:0] EU_way0_pID_i;


    PCU_way0 B_PCU_way0(
        .clk(clk),
        .reset_n(reset_n),
        .ready_i(PCU_way0_ready_i),
        .jumpFlag_i(jumpFlag_i),
        .jumpAddr_i(jumpAddr_i),
        .valid_o(PCU_way0_valid_o),
        .instAddr_o(PCU_way0_instAddr_o)
    );

    PCU_readyControler_way0 B_PCU_readyControler_way0(
        .readyNextStep_i(IFU_way0_ready_o),
        .ready_o(PCU_way0_ready_i)
    );

    InstFetchUnit_way0 B_InstFetchUnit_way0(
        //Test Port
        `ifdef TestMode
            .instAddr_o(IFU_way0_instAddr_o),
        `endif
    
        .clk(clk),
        .reset_n(reset_n),
        .valid_i(PCU_way0_valid_o),
        .ready_i(IFU_way0_ready_i),
        .jumpFlag_i(jumpFlag_i),
        .dataOk_i(way0_dataOk_i),
        .jumpAddr_i(jumpAddr_i),
        .instAddr_i(PCU_way0_instAddr_o),
        .inst_fetch_i(way0_inst_fetch_i),
        .ready_o(IFU_way0_ready_o),
        .request_o(way0_request_o),
        .valid_o(IFU_way0_valid_o),
        .instAddr_fetch_o(way0_instAddr_fetch_o),
        .inst_o(IFU_way0_inst_o),
        .way0_pID_o(IFU_way0_pID_o)
    );

    DecoderUnit_way0 B_DecoderUnit_way0(
        `ifdef TestMode
            .instAddr_i(IFU_way0_instAddr_o),
            .instAddr_o(DU_way0_instAddr_o),
            .inst_o(DU_way0_inst_o),
        `endif
        // From IFU
        .valid_i(IFU_way0_valid_o),
        .way0_pID_i(IFU_way0_pID_o),
        .inst_i(IFU_way0_inst_o),
        .rs1ReadData_i(way0_rs1ReadData_i),
        .rs2ReadData_i(way0_rs2ReadData_i),
        // From DU Register
        .ready_i(DU_way0_ready_i),
        // To Regfile
        .way0_rs1Addr_o(way0_rs1Addr_o),
        .way0_rs2Addr_o(way0_rs2Addr_o),
        .way0_rs1ReadEnable_o(way0_rs1ReadEnable_o),
        .way0_rs2ReadEnable_o(way0_rs2ReadEnable_o),
        // To Ex
        .rdAddr_o(DU_way0_rdAddr_o),
        .rdWriteEnable_o(DU_way0_rdWriteEnable_o),
        .rs1ReadData_o(DU_way0_rs1ReadData_o),
        .rs2ReadData_o(DU_way0_rs2ReadData_o),
        .imm_o(DU_way0_imm_o),
        .opCode_o(DU_way0_opCode_o),
        .funct3_o(DU_way0_funct3_o),
        .funct7_o(DU_way0_funct7_o),
        .shamt_o(DU_way0_shamt_o),
        // To DU Register
        .valid_o(DU_way0_valid_o),
        // To IFU
        .ready_o(IFU_way0_ready_i),
        // To DU Register && IFU
        .way0_pID_o(DU_way0_pID_o)
    );

    DU_Register_way0 B_DU_Register_way0(
        `ifdef TestMode
            .instAddr_i(DU_way0_instAddr_o),
            .instAddr_o(EU_way0_instAddr_i),
            .inst_i(DU_way0_inst_o),
            .inst_o(EU_way0_inst_i),
        `endif
        .clk(clk),
        .reset_n(reset_n),
        .rdAddr_i(DU_way0_rdAddr_o),
        .rdWriteEnable_i(DU_way0_rdWriteEnable_o),
        .rs1ReadData_i(DU_way0_rs1ReadData_o),
        .rs2ReadData_i(DU_way0_rs2ReadData_o),
        .imm_i(DU_way0_imm_o),
        .opCode_i(DU_way0_opCode_o),
        .funct3_i(DU_way0_funct3_o),
        .funct7_i(DU_way0_funct7_o),
        .shamt_i(DU_way0_shamt_o),
        .way0_pID_i(DU_way0_pID_o),
        .valid_i(DU_way0_valid_o),
        .ready_i(EU_way0_ready_o),
        .rdAddr_o(EU_way0_rdAddr_i),
        .rdWriteEnable_o(EU_way0_rdWriteEnable_i),
        .rs1ReadData_o(EU_way0_rs1ReadData_i),
        .rs2ReadData_o(EU_way0_rs2ReadData_i),
        .imm_o(EU_way0_imm_i),
        .opCode_o(EU_way0_opCode_i),
        .funct3_o(EU_way0_funct3_i),
        .funct7_o(EU_way0_funct7_i),
        .shamt_o(EU_way0_shamt_i),
        .way0_pID_o(EU_way0_pID_i),
        .valid_o(EU_way0_valid_i),
        .ready_o(DU_way0_ready_i)
    );

    ExecuteUnit_way0 B_ExecuteUnit_way0(
        `ifdef TestMode
            .instAddr_i(EU_way0_instAddr_i),
            .instAddr_o(),
            .inst_i(EU_way0_inst_i),
            .inst_o(),
        `endif
        .rdAddr_i(EU_way0_rdAddr_i),
        .rdWriteEnable_i(EU_way0_rdWriteEnable_i),
        .rs1ReadData_i(EU_way0_rs1ReadData_i),
        .rs2ReadData_i(EU_way0_rs2ReadData_i),
        .imm_i(EU_way0_imm_i),
        .opCode_i(EU_way0_opCode_i),
        .funct3_i(EU_way0_funct3_i),
        .funct7_i(EU_way0_funct7_i),
        .shamt_i(EU_way0_shamt_i),
        .way0_pID_i(EU_way0_pID_i),
        .valid_i(EU_way0_valid_i),
        .ready_i(ready_test),

        .ready_o(EU_way0_ready_o)
    );

endmodule