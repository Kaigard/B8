`define DebugMode 1
`define RegFileTest 1
module BnineCore (
    input clk,
    input reset_n,
    //For Test
    input jumpFlag_i,
    input [31:0] jumpAddr_i,
    input ready_test
);

    // To Mem
    wire way0_dataOk_i;
    wire way0_request_o;
    wire way1_dataOk_i;
    wire way1_request_o;
    wire [31:0] way0_inst_fetch_i;
    wire [31:0] way0_instAddr_fetch_o;
    wire [31:0] way1_inst_fetch_i;
    wire [31:0] way1_instAddr_fetch_o;

    // JumpCtrl
    wire way0_jumpFlag_o;
    wire [31:0] way0_jumpAddr_o;
    wire [1:0] way0_EU_pID_o;
    wire way0_jumpFlag_i;
    wire [31:0] way0_jumpAddr_i;
    
    wire way1_jumpFlag_o;
    wire [31:0] way1_jumpAddr_o;
    wire [1:0] way1_EU_pID_o;
    wire way1_jumpFlag_i;
    wire [31:0] way1_jumpAddr_i;

    // RegFile
    // DU
    wire [1:0] way0_DU_pID_o;
    wire [1:0] way1_DU_pID_o;
    // WBU
    wire way0_rdWriteEnable_o;
    wire [4:0] way0_rdAddr_o;
    wire [63:0] way0_rdData_o;
    wire [1:0] way0_WBU_pID_o;
    
    wire way1_rdWriteEnable_o;
    wire [4:0] way1_rdAddr_o;
    wire [63:0] way1_rdData_o;
    wire [1:0] way1_WBU_pID_o;

    // WBU
    wire way0_ready_i;
    wire way1_ready_i;

    testRom u_testRom_way0 (
        .clk(clk),
        .reset_n(reset_n),
        .request_i(way0_request_o),
        .instAddr_i(way0_instAddr_fetch_o),
        .inst_o(way0_inst_fetch_i),
        .dataOk_o(way0_dataOk_i)
    );

    testRom u_testRom_way1 (
        .clk(clk),
        .reset_n(reset_n),
        .request_i(way1_request_o),
        .instAddr_i(way1_instAddr_fetch_o),
        .inst_o(way1_inst_fetch_i),
        .dataOk_o(way1_dataOk_i)
    );

    wire way0_rs1ReadEnable_o;
    wire way0_rs2ReadEnable_o;
    wire [4:0] way0_rs1Addr_o;
    wire [4:0] way0_rs2Addr_o;
    wire [63:0] way0_rs1ReadData_i;
    wire [63:0] way0_rs2ReadData_i;

    wire way1_rs1ReadEnable_o;
    wire way1_rs2ReadEnable_o;
    wire [4:0] way1_rs1Addr_o;
    wire [4:0] way1_rs2Addr_o;
    wire [63:0] way1_rs1ReadData_i;
    wire [63:0] way1_rs2ReadData_i;

    BnineCore_way0 B_BnineCore_way0(
        .clk(clk),
        .reset_n(reset_n),
        .way0_dataOk_i(way0_dataOk_i),
        .way0_inst_fetch_i(way0_inst_fetch_i),
        // From RegFile
        .way0_rs1ReadData_i(way0_rs1ReadData_i),
        .way0_rs2ReadData_i(way0_rs2ReadData_i),
        .way0_ready_i(way0_ready_i),
        // From JumpCtrl
        .way0_jumpFlag_i(way0_jumpFlag_i),
        .way0_jumpAddr_i(way0_jumpAddr_i),
        // To I-Cache
        .way0_request_o(way0_request_o),
        .way0_instAddr_fetch_o(way0_instAddr_fetch_o),
        // DU to RegFile
        .way0_rs1ReadEnable_o(way0_rs1ReadEnable_o),
        .way0_rs2ReadEnable_o(way0_rs2ReadEnable_o),
        .way0_rs1Addr_o(way0_rs1Addr_o),
        .way0_rs2Addr_o(way0_rs2Addr_o),
        .way0_DU_pID_o(way0_DU_pID_o),
        // WBU to RegFile
        .way0_rdWriteEnable_o(way0_rdWriteEnable_o),
        .way0_rdAddr_o(way0_rdAddr_o),
        .way0_rdData_o(way0_rdData_o),
        .way0_WBU_pID_o(way0_WBU_pID_o),
        // To JumpCtrl
        .way0_jumpFlag_o(way0_jumpFlag_o),
        .way0_jumpAddr_o(way0_jumpAddr_o),
        .way0_EU_pID_o(way0_EU_pID_o),
        // For Test
        .jumpFlag_i(jumpFlag_i),
        .jumpAddr_i(jumpAddr_i),
        .ready_test(ready_test)
    );

    BnineCore_way1 B_BnineCore_way1(
        .clk(clk),
        .reset_n(reset_n),
        .way1_dataOk_i(way1_dataOk_i),
        .way1_inst_fetch_i(way1_inst_fetch_i),
        // From RegFile
        .way1_rs1ReadData_i(way1_rs1ReadData_i),
        .way1_rs2ReadData_i(way1_rs2ReadData_i),
        .way1_ready_i(way1_ready_i),
        // From JumpCtrl
        .way1_jumpFlag_i(way1_jumpFlag_i),
        .way1_jumpAddr_i(way1_jumpAddr_i),
        // To I-Cache
        .way1_request_o(way1_request_o),
        .way1_instAddr_fetch_o(way1_instAddr_fetch_o),
        // DU to RegFile
        .way1_rs1ReadEnable_o(way1_rs1ReadEnable_o),
        .way1_rs2ReadEnable_o(way1_rs2ReadEnable_o),
        .way1_rs1Addr_o(way1_rs1Addr_o),
        .way1_rs2Addr_o(way1_rs2Addr_o),
        .way1_DU_pID_o(way1_DU_pID_o),
        // WBU to RegFile
        .way1_rdWriteEnable_o(way1_rdWriteEnable_o),
        .way1_rdAddr_o(way1_rdAddr_o),
        .way1_rdData_o(way1_rdData_o),
        .way1_WBU_pID_o(way1_WBU_pID_o),
        // To JumpCtrl
        .way1_jumpFlag_o(way1_jumpFlag_o),
        .way1_jumpAddr_o(way1_jumpAddr_o),
        .way1_EU_pID_o(way1_EU_pID_o),
        // For Test
        .jumpFlag_i(jumpFlag_i),
        .jumpAddr_i(jumpAddr_i),
        .ready_test(ready_test)
    );

    RegFile B_RegFile(
        .clk(clk),
        .reset_n(reset_n),
        // way0
        .way0_rs1Addr_i(way0_rs1Addr_o),
        .way0_rs2Addr_i(way0_rs2Addr_o),
        .way0_rs1ReadEnable_i(way0_rs1ReadEnable_o),
        .way0_rs2ReadEnable_i(way0_rs2ReadEnable_o),
        .way0_DU_pID_i(way0_DU_pID_o),
        // way1
        .way1_rs1Addr_i(way1_rs1Addr_o),
        .way1_rs2Addr_i(way1_rs2Addr_o),
        .way1_rs1ReadEnable_i(way1_rs1ReadEnable_o),
        .way1_rs2ReadEnable_i(way1_rs2ReadEnable_o),
        .way1_DU_pID_i(way1_DU_pID_o),

        // WBU
        .way0_rdWriteEnable_i(way0_rdWriteEnable_o),
        .way0_rdAddr_i(way0_rdAddr_o),
        .way0_rdData_i(way0_rdData_o),
        .way0_WBU_pID_i(way0_WBU_pID_o),
        .way1_rdWriteEnable_i(way1_rdWriteEnable_o),
        .way1_rdAddr_i(way1_rdAddr_o),
        .way1_rdData_i(way1_rdData_o),
        .way1_WBU_pID_i(way1_WBU_pID_o),

        // To DU
        .way0_rs1ReadData_o(way0_rs1ReadData_i),
        .way0_rs2ReadData_o(way0_rs2ReadData_i),
        .way1_rs1ReadData_o(way1_rs1ReadData_i),
        .way1_rs2ReadData_o(way1_rs2ReadData_i),
        
        // To WBU
        .way0_ready_o(way0_ready_i),
        .way1_ready_o(way1_ready_i)
    );

    JumpCtrl B_JumpCtrl(
        // way0
        .way0_jumpFlag_i(way0_jumpFlag_o),
        .way0_jumpAddr_i(way0_jumpAddr_o),
        .way0_EU_pID_i(way0_EU_pID_o),
        // way1
        .way1_jumpFlag_i(way1_jumpFlag_o),
        .way1_jumpAddr_i(way1_jumpAddr_o),
        .way1_EU_pID_i(way1_EU_pID_o),
        // To way0
        .way0_jumpFlag_o(way0_jumpFlag_i),
        .way0_jumpAddr_o(way0_jumpAddr_i),
        // To way1
        .way1_jumpFlag_o(way1_jumpFlag_i),
        .way1_jumpAddr_o(way1_jumpAddr_i)
    );

endmodule