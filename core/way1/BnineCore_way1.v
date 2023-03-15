module BnineCore_way1 (
    input clk,
    input reset_n,
    input way1_dataOk_i,
    input [31:0] way1_inst_fetch_i,
    output way1_request_o,
    output [31:0] way1_instAddr_fetch_o,

    //For Test
    input jumpFlag_i,
    input [31:0] jumpAddr_i,
    input ready_test
);

    // PCU_way1
    wire PCU_way1_valid_o;
    wire PCU_way1_ready_i;
    wire [31:0] PCU_way1_instAddr_o; 

    // IFU_way1
    //wire IFU_way1_dataOk_i;
    //wire IFU_way1_request_o;
    //wire [31:0] IFU_way1_inst_fetch_i;
    //wire [31:0] IFU_way1_instAddr_fetch_o;
    wire IFU_way1_ready_o;
    wire [31:0] IFU_way1_inst_o;
    wire [31:0] IFU_way1_instAddr_o;

    PCU_way1 B_PCU_way1(
        .clk(clk),
        .reset_n(reset_n),
        .ready_i(PCU_way1_ready_i),
        .jumpFlag_i(jumpFlag_i),
        .jumpAddr_i(jumpAddr_i),
        .valid_o(PCU_way1_valid_o),
        .instAddr_o(PCU_way1_instAddr_o)
    );

    PCU_readyControler_way1 B_PCU_readyControler_way1(
        .readyNextStep_i(IFU_way1_ready_o),
        .ready_o(PCU_way1_ready_i)
    );

    InstFetchUnit_way1 B_InstFetchUnit_way1(
        //Test Port
        `ifdef TestMode
            .instAddr_o(IFU_way1_instAddr_o),
        `endif
    
        .clk(clk),
        .reset_n(reset_n),
        .valid_i(PCU_way1_valid_o),
        .ready_i(ready_test),
        .jumpFlag_i(jumpFlag_i),
        .dataOk_i(way1_dataOk_i),
        .jumpAddr_i(jumpAddr_i),
        .instAddr_i(PCU_way1_instAddr_o),
        .inst_fetch_i(way1_inst_fetch_i),
        .ready_o(IFU_way1_ready_o),
        .request_o(way1_request_o),
        .instAddr_fetch_o(way1_instAddr_fetch_o),
        .inst_o(IFU_way1_inst_o)
    );

endmodule