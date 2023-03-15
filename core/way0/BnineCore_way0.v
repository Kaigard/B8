module BnineCore_way0 (
    input clk,
    input reset_n,
    input way0_dataOk_i,
    input [31:0] way0_inst_fetch_i,
    output way0_request_o,
    output [31:0] way0_instAddr_fetch_o,

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
    wire [31:0] IFU_way0_inst_o;
    wire [31:0] IFU_way0_instAddr_o;


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
        .ready_i(ready_test),
        .jumpFlag_i(jumpFlag_i),
        .dataOk_i(way0_dataOk_i),
        .jumpAddr_i(jumpAddr_i),
        .instAddr_i(PCU_way0_instAddr_o),
        .inst_fetch_i(way0_inst_fetch_i),
        .ready_o(IFU_way0_ready_o),
        .request_o(way0_request_o),
        .instAddr_fetch_o(way0_instAddr_fetch_o),
        .inst_o(IFU_way0_inst_o)
    );

endmodule