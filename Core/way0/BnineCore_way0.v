module BnineCore_way0 (
    input clk,
    input reset_n,
    input way0_dataOk_i,
    input [31:0] way0_inst_fetch_i,
    output way0_request_o,
    output [31:0] way0_instAddr_fetch_o,
    // To Regfile
    output way0_rs1ReadEnable_o,
    output way0_rs2ReadEnable_o,
    output [1:0] way0_pID_DU_o,
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
    wire [1:0] DU_way0_pId_o;


    // Output MUX
    assign way0_pID_DU_o = DU_way0_pId_o;

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
            .instAddr_o(),
        `endif
        // From IFU
        .valid_i(IFU_way0_valid_o),
        .way0_pID_i(IFU_way0_pID_o),
        .inst_i(IFU_way0_inst_o),
        .rs1ReadData_i(),
        .rs2ReadData_i(),
        // From DU Register
        .ready_i(ready_test),
        // To Regfile
        .way0_rs1Addr_o(way0_rs1Addr_o),
        .way0_rs2Addr_o(way0_rs2Addr_o),
        .way0_rs1ReadEnable_o(way0_rs1ReadEnable_o),
        .way0_rs2ReadEnable_o(way0_rs2ReadEnable_o),
        // To Ex
        .rdAddr_o(),
        .rdWriteEnable_o(),
        .rs1ReadData_o(),
        .rs2ReadData_o(),
        .imm_o(),
        .opCode_o(),
        .funct3_o(),
        .funct7_o(),
        .shamt_o(),
        // To DU Register
        .valid_o(),
        // To IFU
        .ready_o(IFU_way0_ready_i),
        // To DU Register && IFU
        .way0_pID_o(DU_way0_pId_o)
    );

endmodule