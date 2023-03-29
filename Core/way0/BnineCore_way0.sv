module BnineCore_way0 (
    input logic clk,
    input logic reset_n,
    input logic way0_dataOk_i,
    input logic [31:0] way0_inst_fetch_i,
    // From RegFile
    input logic [63:0] way0_rs1ReadData_i,
    input logic [63:0] way0_rs2ReadData_i,
    // To I-Cache
    output logic way0_request_o,
    output logic [31:0] way0_instAddr_fetch_o,
    // To RegFile
    output logic way0_rs1ReadEnable_o,
    output logic way0_rs2ReadEnable_o,
    output logic [4:0] way0_rs1Addr_o,
    output logic [4:0] way0_rs2Addr_o,

    output logic way0_rdWriteEnable_o,
    output logic [4:0] way0_rdAddr_o,
    output logic [63:0] way0_rdData_o,
    output logic [1:0] way0_pID_o,

    // For Test
    input logic jumpFlag_i,
    input logic [31:0] jumpAddr_i,
    input logic ready_test
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
    `ifdef DebugMode
        wire [31:0] DU_way0_inst_o;
    `endif

    wire [4:0] DU_way0_rdAddr_o;
    wire DU_way0_rdWriteEnable_o;
    wire [31:0] DU_way0_instAddr_o;
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
    `ifdef DebugMode
        wire [31:0] EU_way0_inst_i;
        wire [31:0] EU_way0_inst_o;
        wire [31:0] EU_way0_instAddr_o;
    `endif

    wire [4:0] EU_way0_rdAddr_i;
    wire EU_way0_rdWriteEnable_i;
    wire [31:0] EU_way0_instAddr_i;
    wire [63:0] EU_way0_rs1ReadData_i;
    wire [63:0] EU_way0_rs2ReadData_i;
    wire [63:0] EU_way0_imm_i;
    wire [6:0] EU_way0_opCode_i;
    wire [2:0] EU_way0_funct3_i;
    wire [6:0] EU_way0_funct7_i;
    wire [5:0] EU_way0_shamt_i;
    wire EU_way0_valid_i;
    wire EU_way0_ready_i;
    wire [1:0] EU_way0_pID_i;

    wire EU_way0_rdWriteEnable_o;
    wire [4:0] EU_way0_rdAddr_o;
    wire [63:0] EU_way0_rdData_o;

    wire EU_way0_jumpFlag_o;
    wire [31:0] EU_way0_jumpAddr_o;

    wire [1:0] EU_way0_pID_o;
    wire EU_way0_valid_o;
    wire EU_way0_ready_o;

    wire [6:0] EU_way0_opCode_o;
    wire [2:0] EU_way0_funct3_o;
    wire [31:0] EU_way0_readAddr_o;
    wire [31:0] EU_way0_writeAddr_o;
    wire [63:0] EU_way0_writeData_o;
    wire [3:0] EU_way0_writeMask_o;

    // FU way0
    `ifdef DebugMode
        wire [31:0] FU_way0_instAddr_i;
        wire [31:0] FU_way0_inst_i;
        wire [31:0] FU_way0_instAddr_o;
        wire [31:0] FU_way0_inst_o;
    `endif 
    wire FU_way0_rdWriteEnable_i;
    wire [4:0] FU_way0_rdAddr_i;
    wire [63:0] FU_way0_rdData_i;
    wire FU_way0_valid_i;
    wire FU_way0_ready_i;
    wire [1:0] FU_way0_pID_i;
    wire FU_way0_rdWriteEnable_o;
    wire [4:0] FU_way0_rdAddr_o;
    wire [63:0] FU_way0_rdData_o;
    wire FU_way0_valid_o;
    wire FU_way0_ready_o;
    wire [1:0] FU_way0_pID_o;

    wire [6:0] FU_way0_opCode_i;
    wire [2:0] FU_way0_funct3_i;
    wire [31:0] FU_way0_readAddr_i;
    wire [31:0] FU_way0_writeAddr_i;
    wire [63:0] FU_way0_writeData_i;
    wire [3:0] FU_way0_writeMask_i; 
    
    // WBU way0
    `ifdef DebugMode
        wire [31:0] WBU_way0_instAddr_i;
        wire [31:0] WBU_way0_inst_i;
        wire [31:0] WBU_way0_instAddr_o;
        wire [31:0] WBU_way0_inst_o;
    `endif 
    wire WBU_way0_rdWriteEnable_i;
    wire [4:0] WBU_way0_rdAddr_i;
    wire [63:0] WBU_way0_rdData_i;
    wire WBU_way0_valid_i;
    wire [1:0] WBU_way0_pID_i;
    wire WBU_way0_ready_o;

    PCU_way0 B_PCU_way0(
        .clk(clk),
        .reset_n(reset_n),
        .ready_i(PCU_way0_ready_i),
        // .ready_i(ready_test),
        .dataOk_i(way0_dataOk_i),
        .jumpFlag_i(EU_way0_jumpFlag_o),
        .jumpAddr_i(EU_way0_jumpAddr_o),
        .request_o(way0_request_o),
        .valid_o(PCU_way0_valid_o),
        .instAddr_o(way0_instAddr_fetch_o)
    );

    PCU_readyControler_way0 B_PCU_readyControler_way0(
        .ready_IFU_i(IFU_way0_ready_o),
        .ready_o(PCU_way0_ready_i)
    );

    InstFetchUnit_way0 B_InstFetchUnit_way0(
        // Test Port
        .clk(clk),
        .reset_n(reset_n),
        .valid_i(PCU_way0_valid_o),
        .ready_i(IFU_way0_ready_i),
        .jumpFlag_i(EU_way0_jumpFlag_o),
        // RAM
        .instAddr_i(way0_instAddr_fetch_o),
        .inst_fetch_i(way0_inst_fetch_i),
        // To DU
        .ready_o(IFU_way0_ready_o),
        .valid_o(IFU_way0_valid_o),
        .inst_o(IFU_way0_inst_o),
        .instAddr_o(IFU_way0_instAddr_o),
        .way0_pID_o(IFU_way0_pID_o)
    );

    DecoderUnit_way0 B_DecoderUnit_way0(
        `ifdef DebugMode 
            .inst_o(DU_way0_inst_o),
        `endif
        // From IFU
        .valid_i(IFU_way0_valid_o),
        .way0_pID_i(IFU_way0_pID_o),
        .inst_i(IFU_way0_inst_o),
        .instAddr_i(IFU_way0_instAddr_o),
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
        .instAddr_o(DU_way0_instAddr_o),
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

    EU_Register_way0 B_EU_Register_way0(
        `ifdef DebugMode
            .inst_i(DU_way0_inst_o),
            .inst_o(EU_way0_inst_i),
        `endif
        .clk(clk),
        .reset_n(reset_n),
        .rdAddr_i(DU_way0_rdAddr_o),
        .rdWriteEnable_i(DU_way0_rdWriteEnable_o),
        .instAddr_i(DU_way0_instAddr_o),
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
        .jumpFlag_i(EU_way0_jumpFlag_o),
        .jumpAddr_i(EU_way0_jumpAddr_o),
        .rdAddr_o(EU_way0_rdAddr_i),
        .rdWriteEnable_o(EU_way0_rdWriteEnable_i),
        .instAddr_o(EU_way0_instAddr_i),
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
        `ifdef DebugMode
            .instAddr_o(EU_way0_instAddr_o),
            .inst_i(EU_way0_inst_i),
            .inst_o(EU_way0_inst_o),
        `endif
        .rdAddr_i(EU_way0_rdAddr_i),
        .rdWriteEnable_i(EU_way0_rdWriteEnable_i),
        .instAddr_i(EU_way0_instAddr_i),
        .rs1ReadData_i(EU_way0_rs1ReadData_i),
        .rs2ReadData_i(EU_way0_rs2ReadData_i),
        .imm_i(EU_way0_imm_i),
        .opCode_i(EU_way0_opCode_i),
        .funct3_i(EU_way0_funct3_i),
        .funct7_i(EU_way0_funct7_i),
        .shamt_i(EU_way0_shamt_i),
        .way0_pID_i(EU_way0_pID_i),
        .valid_i(EU_way0_valid_i),
        .ready_i(EU_way0_ready_i),
        .rdWriteEnable_o(EU_way0_rdWriteEnable_o),
        .rdAddr_o(EU_way0_rdAddr_o),
        .rdData_o(EU_way0_rdData_o),
        .valid_o(EU_way0_valid_o),
        .ready_o(EU_way0_ready_o),
        .way0_pID_o(EU_way0_pID_o),
        .opCode_o(EU_way0_opCode_o),
        .funct3_o(EU_way0_funct3_o),
        .readAddr_o(EU_way0_readAddr_o),
        .writeAddr_o(EU_way0_writeAddr_o),
        .writeData_o(EU_way0_writeData_o),
        .writeMask_o(EU_way0_writeMask_o),
        .jumpFlag_o(EU_way0_jumpFlag_o),
        .jumpAddr_o(EU_way0_jumpAddr_o)
    );


    logic [31:0] writeAddr_test;
    logic [31:0] readAddr_test;
    logic [63:0] writeData_test;
    logic [63:0] readData_test;
    logic [2:0] writeState_test;
    logic dataOk_test;
    logic request_test;

    reg [2:0] b;
    class IFtest;
        rand reg[2:0] randseed;
    endclass // test

    IFtest test1;

    // test
    reg [64:0] ram_test [1000:0];
    always @(posedge clk) begin
        test1 = new();
        if(|writeAddr_test) begin
            test1.randomize(randseed);
            b = test1.randseed;
            repeat (b) begin
                @(posedge clk);
            end
            ram_test[writeAddr_test] <= writeData_test;
            writeState_test <= 3'b111;
        end else 
            writeState_test <= 3'b000;
    end
    
    always @(posedge clk) begin
        if(|readAddr_test) begin
            readData_test <= readAddr_test;
            dataOk_test <= 1'b1;
        end else
            dataOk_test <= 1'b0;
    end


    FU_Register_way0 B_FU_Register_way0(
        `ifdef DebugMode
            .instAddr_i(EU_way0_instAddr_o),
            .inst_i(EU_way0_inst_o),
            .instAddr_o(FU_way0_instAddr_i),
            .inst_o(FU_way0_inst_i),
        `endif
        .clk(clk),
        .reset_n(reset_n),
        .rdWriteEnable_i(EU_way0_rdWriteEnable_o),
        .rdAddr_i(EU_way0_rdAddr_o),
        .rdData_i(EU_way0_rdData_o),
        .valid_i(EU_way0_valid_o),
        .ready_i(FU_way0_ready_o),
        .way0_pID_i(EU_way0_pID_o),
        .opCode_i(EU_way0_opCode_o),
        .funct3_i(EU_way0_funct3_o),
        .readAddr_i(EU_way0_readAddr_o),
        .writeAddr_i(EU_way0_writeAddr_o),
        .writeData_i(EU_way0_writeData_o),
        .writeMask_i(EU_way0_writeMask_o),
        .dataOk_i(dataOk_test),
        .writeState_i(writeState_test),
        .rdWriteEnable_o(FU_way0_rdWriteEnable_i),
        .rdAddr_o(FU_way0_rdAddr_i),
        .rdData_o(FU_way0_rdData_i),
        .valid_o(FU_way0_valid_i),
        .ready_o(EU_way0_ready_i),
        .way0_pID_o(FU_way0_pID_i),
        .opCode_o(FU_way0_opCode_i),
        .funct3_o(FU_way0_funct3_i),
        // To RAM
        .readAddr_o(FU_way0_readAddr_i),
        .writeAddr_o(FU_way0_writeAddr_i),
        .writeData_o(FU_way0_writeData_i),
        .writeMask_o(FU_way0_writeMask_i)
    );

    FetchUnit_way0 B_FetchUnit_way0(
        `ifdef DebugMode
            .instAddr_i(FU_way0_instAddr_i),
            .inst_i(FU_way0_inst_i),
            .instAddr_o(FU_way0_instAddr_o),
            .inst_o(FU_way0_inst_o),
            .clk(clk),
            .reset_n(reset_n),
        `endif 
        .rdWriteEnable_i(FU_way0_rdWriteEnable_i),
        .rdAddr_i(FU_way0_rdAddr_i),
        .rdData_i(FU_way0_rdData_i),
        .valid_i(FU_way0_valid_i),
        .ready_i(FU_way0_ready_i),
        .way0_pID_i(FU_way0_pID_i),
        .opCode_i(FU_way0_opCode_i),
        .funct3_i(FU_way0_funct3_i),
        .readAddr_i(FU_way0_readAddr_i),
        .writeAddr_i(FU_way0_writeAddr_i),
        .writeData_i(FU_way0_writeData_i),
        .writeMask_i(FU_way0_writeMask_i),
        // From RAM
        .readData_i(readData_test),
        .dataOk_i(dataOk_test),
        .writeState_i(writeState_test),
        .rdWriteEnable_o(FU_way0_rdWriteEnable_o),
        .rdAddr_o(FU_way0_rdAddr_o),
        .rdData_o(FU_way0_rdData_o),
        .valid_o(FU_way0_valid_o),
        .ready_o(FU_way0_ready_o),
        .way0_pID_o(FU_way0_pID_o),
        // To RAM
        .readAddr_o(readAddr_test),
        .writeAddr_o(writeAddr_test),
        .writeData_o(writeData_test),
        .writeMask_o()
    );

    WBU_Register_way0 B_WBU_Register_way0(
        `ifdef DebugMode
            .instAddr_i(FU_way0_instAddr_o),
            .inst_i(FU_way0_inst_o),
            .instAddr_o(WBU_way0_instAddr_i),
            .inst_o(WBU_way0_inst_i),
        `endif 
        .clk(clk),
        .reset_n(reset_n),
        .rdWriteEnable_i(FU_way0_rdWriteEnable_o),
        .rdAddr_i(FU_way0_rdAddr_o),
        .rdData_i(FU_way0_rdData_o),
        .valid_i(FU_way0_valid_o),
        .ready_i(WBU_way0_ready_o),
        .way0_pID_i(FU_way0_pID_o),
        // .dataOk_i(FU_way0_dataOk_o),
        // .writeState_i(FU_way0_writeState_o),
        .rdWriteEnable_o(WBU_way0_rdWriteEnable_i),
        .rdAddr_o(WBU_way0_rdAddr_i),
        .rdData_o(WBU_way0_rdData_i),
        .valid_o(WBU_way0_valid_i),
        .ready_o(FU_way0_ready_i),
        .way0_pID_o(WBU_way0_pID_i)
    );

    WriteBackUnit_way0 B_WriteBackUnit_way0(
        `ifdef DebugMode
            .instAddr_i(WBU_way0_instAddr_i),
            .inst_i(WBU_way0_inst_i),
            .instAddr_o(),
            .inst_o(),
        `endif 
        .rdWriteEnable_i(WBU_way0_rdWriteEnable_i),
        .rdAddr_i(WBU_way0_rdAddr_i),
        .rdData_i(WBU_way0_rdData_i),
        .valid_i(WBU_way0_valid_i),
        .ready_i(ready_test),
        .way0_pID_i(WBU_way0_pID_i),
        .rdWriteEnable_o(way0_rdWriteEnable_o),
        .rdAddr_o(way0_rdAddr_o),
        .rdData_o(way0_rdData_o),
        .way0_pID_o(way0_pID_o),
        .ready_o(WBU_way0_ready_o)
    );

endmodule