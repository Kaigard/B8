`define TestMode 1
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
        // To I-Cache
        .way0_request_o(way0_request_o),
        .way0_instAddr_fetch_o(way0_instAddr_fetch_o),
        // To RegFile
        .way0_rs1ReadEnable_o(way0_rs1ReadEnable_o),
        .way0_rs2ReadEnable_o(way0_rs2ReadEnable_o),
        .way0_rs1Addr_o(way0_rs1Addr_o),
        .way0_rs2Addr_o(way0_rs2Addr_o),

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
        // To I-Cache
        .way1_request_o(way1_request_o),
        .way1_instAddr_fetch_o(way1_instAddr_fetch_o),
        // To RegFile
        .way1_rs1ReadEnable_o(way1_rs1ReadEnable_o),
        .way1_rs2ReadEnable_o(way1_rs2ReadEnable_o),
        .way1_rs1Addr_o(way1_rs1Addr_o),
        .way1_rs2Addr_o(way1_rs2Addr_o),

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
        .way0_pID_i(),
        // way1
        .way1_rs1Addr_i(way1_rs1Addr_o),
        .way1_rs2Addr_i(way1_rs2Addr_o),
        .way1_rs1ReadEnable_i(way1_rs1ReadEnable_o),
        .way1_rs2ReadEnable_i(way1_rs2ReadEnable_o),
        .way1_pID_i(),
        // To DU
        .way0_rs1ReadData_o(way0_rs1ReadData_i),
        .way0_rs2ReadData_o(way0_rs2ReadData_i),
        .way1_rs1ReadData_o(way1_rs1ReadData_i),
        .way1_rs2ReadData_o(way1_rs2ReadData_i)
    );

endmodule