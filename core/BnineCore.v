module BnineCore (
    input clk,
    input reset_n,
    //For Test
    input jumpFlag_i,
    input [31:0] jumpAddr_i
);

    //PCU
    wire PCU_valid_o;
    wire PCU_ready_i;
    wire [31:0] PCU_instAddr_o; 

    //FFFU
    wire FFFU_ready_o;
    wire FFFU_valid_o;
    wire [31:0] FFFU_instAddrForFetch_o;
    wire [31:0] FFFU_inst_o;
    wire [31:0] FFFU_inst_i;
    wire FFFU_ready_fetch_i;
    `ifdef TestMode
        wire [31:0] FFFU_instAddr_o;
        wire [31:0] FFU_instAddr_o;
        wire [31:0] IFU_instAddr_o;
    `endif

    //FFU
    wire FFU_ready_o;
    wire FFU_valid_o;
    wire [31:0] FFU_instAddrForFetch_o;
    wire [31:0] FFU_inst_fetch_i;
    wire [31:0] FFU_inst_o;

    //IFU
    wire IFU_ready_o;
    wire IFU_valid_o;
    wire [31:0] IFU_instAddrForFetch_o;
    wire [31:0] IFU_inst_fetch_i;
    wire [31:0] IFU_inst_o;


    wire dataOk;
    wire request;

    testRom u_testRom (
        .clk(clk),
        .reset_n(reset_n),
        .request_i(request),
        .instAddr_i(FFFU_instAddrForFetch_o),
        .inst_o(FFFU_inst_i),
        .dataOk_o(dataOk)
    );


    PCU B_PCU(
        .clk(clk),
        .reset_n(reset_n),
        .ready_i(PCU_ready_i),
        .jumpFlag_i(jumpFlag_i),
        .jumpAddr_i(jumpAddr_i),
        .valid_o(PCU_valid_o),
        .instAddr_o(PCU_instAddr_o)
    );

    PCU_readyControler B_PCU_ready_Controler(
        .readyNextStep_i(FFFU_ready_o),
        .ready_o(PCU_ready_i)
    );

    FrontFrontFetchUnit B_FrontFrontFetchUnit(
        //Test Port
        `ifdef TestMode
            .instAddr_o(FFFU_instAddr_o),
        `endif
    
        .clk(clk),
        .reset_n(reset_n),
        .valid_i(PCU_valid_o),
        .ready_i(1'b1),
        .jumpFlag_i(jumpFlag_i),
        .dataOk_i(dataOk),
        .jumpAddr_i(jumpAddr_i),
        .instAddr_i(PCU_instAddr_o),
        .inst_fetch_i(FFFU_inst_i),
        .ready_o(FFFU_ready_o),
        .request_o(request),
        .instAddr_fetch_o(FFFU_instAddrForFetch_o),
        .inst_o(FFFU_inst_o)
    );

/*
    always @(posedge clk or negedge reset_n) begin
        if(~reset_n) begin
            FFFU_inst_i <= 32'b0;
            FFFU_ready_fetch_i <= 1'b0;
        end else if(jumpFlag_i) begin
            FFFU_inst_i <= 32'hffff;
            FFFU_ready_fetch_i <= 1'b1;
        end else if(|FFFU_instAddrForFetch_o) begin
            FFFU_inst_i <= FFFU_instAddrForFetch_o + 1;
            FFFU_ready_fetch_i <= 1'b1;
        end else 
            FFFU_ready_fetch_i <= 1'b0;
    end

    FrontFetchUnit B_FrontFetchUnit(
        `ifdef TestMode
            .instAddr_i(FFFU_instAddr_o),
            .instAddr_o(FFU_instAddr_o),
        `endif

        .clk(clk),
        .reset_n(reset_n),
        .valid_i(FFFU_valid_o),
        .ready_i(IFU_ready_o),
        .jumpFlag_i(jumpFlag_i),
        .jumpAddr_i(jumpAddr_i),
        .inst_i(FFFU_inst_o),
        .inst_fetch_i(FFU_inst_fetch_i),
        .valid_o(FFU_valid_o),
        .ready_o(FFU_ready_o),
        .instAddrForFetch_o(FFU_instAddrForFetch_o),
        .inst_o(FFU_inst_o)
    );

    always @(posedge clk or negedge reset_n) begin
        if(~reset_n) begin
            FFU_inst_fetch_i <= 32'b0;
        end else if(jumpFlag_i) begin
            FFU_inst_fetch_i <= 32'hf;
        end
    end

    InstFetchUnit B_InstFetchUnit(
        `ifdef TestMode
            .instAddr_i(FFU_instAddr_o),
            .instAddr_o(IFU_instAddr_o),
        `endif

        .clk(clk),
        .reset_n(reset_n),
        .valid_i(FFU_valid_o),
        .ready_i(1'b1),
        .jumpFlag_i(jumpFlag_i),
        .jumpAddr_i(jumpAddr_i),
        .inst_i(FFU_inst_o),
        .inst_fetch_i(IFU_inst_fetch_i),
        .valid_o(),
        .ready_o(IFU_ready_o),
        .instAddrForFetch_o(IFU_instAddrForFetch_o),
        .inst_o(IFU_inst_o)
    );

    always @(posedge clk or negedge reset_n) begin
        if(~reset_n) begin
            IFU_inst_fetch_i <= 32'b0;
        end else if(jumpFlag_i) begin
            IFU_inst_fetch_i <= 32'hff;
        end
    end
*/
endmodule