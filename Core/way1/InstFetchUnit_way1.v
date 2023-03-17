module InstFetchUnit_way1 (
    `ifdef DebugMode
        output reg [31:0] instAddr_o,
    `endif

    input clk,
    input reset_n,
    input valid_i,
    input ready_i,
    input jumpFlag_i,
    input dataOk_i,
    input [31:0] jumpAddr_i,
    input [31:0] instAddr_i,
    input [31:0] inst_fetch_i,
    output reg ready_o,
    output request_o,
    output reg valid_o,
    output [31:0] instAddr_fetch_o,
    output reg [31:0] inst_o,
    output reg [1:0] way1_pID_o
);
    
    wire WFull;
    wire [31:0] inst_fetch_buffer;

    assign request_o = valid_i;
    assign instAddr_fetch_o = instAddr_i;

    DataBuffer #(.DataWidth(32))
    IFU_Buffer_way1 (
        .Clk(clk),
        .Rst(reset_n),
        .WData(inst_fetch_i),
        .WInc(dataOk_i && ~ready_i),
        .WFull(WFull),
        .RData(inst_fetch_buffer),
        .RInc(WFull && ready_i)
    );

    always @( * ) begin
        if(~reset_n) begin
            ready_o <= 1'b0;
        end else begin
            if(ready_i && dataOk_i) begin
                ready_o <= 1'b1;
            end else begin
                if(WFull && ready_i) begin
                    ready_o <= 1'b1;
                end else begin
                    ready_o <= 1'b0;
                end
            end
        end
    end
    
    /*
    always @(posedge clk or negedge reset_n) begin
        if(~reset_n) begin
            inst_o <= 32'b0;
        end else begin
            if(WFull && ready_i) begin
                inst_o <= inst_fetch;
            end else begin
                inst_o <= inst_fetch_i;
            end
        end
    end
    */

    always @(posedge clk or negedge reset_n) begin
        if(~reset_n) begin
            inst_o <= 32'b0;
            way1_pID_o <= 2'b11;
            valid_o <= 1'b0;
        end else begin
            if(ready_i && dataOk_i) begin
                inst_o <= inst_fetch_i;
                way1_pID_o <= way1_pID_o + 2;
                valid_o <= 1'b1;
            end else begin
                if(WFull && ready_i) begin
                    inst_o <= inst_fetch_buffer;
                    way1_pID_o <= way1_pID_o + 2;
                    valid_o <= 1'b1;
                end else begin
                    inst_o <= inst_o;
                    way1_pID_o <= way1_pID_o;
                    valid_o <= 1'b0;
                end
            end
        end
    end

    `ifdef DebugMode
        wire WFull_test;
        wire [31:0] instAddr_fetch_buffer;

        DataBuffer #(.DataWidth(32))
        IFUAddr_Buffer (
            .Clk(clk),
            .Rst(reset_n),
            .WData(instAddr_i),
            .WInc(dataOk_i && ~ready_i),
            .WFull(WFull_test),
            .RData(instAddr_fetch_buffer),
            .RInc(WFull_test && ready_i)
        );

        always @(posedge clk or negedge reset_n) begin
            if(~reset_n) begin
                instAddr_o <= 32'b0;
            end else begin
                if(ready_i && dataOk_i) begin
                    instAddr_o <= instAddr_i;
                end else begin
                    if(WFull_test && ready_i) begin
                        instAddr_o <= instAddr_fetch_buffer;
                    end else begin
                        instAddr_o <= instAddr_o;
                    end
                end
            end
        end
    `endif

endmodule