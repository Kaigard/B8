module InstFetchUnit_way0 (
    input clk,
    input reset_n,
    input valid_i,
    input ready_i,
    input jumpFlag_i,
    input dataOk_i,
    input [31:0] jumpAddr_i,
    input [31:0] instAddr_i,
    input [31:0] inst_fetch_i,
    output ready_o,
    output request_o,
    output reg valid_o,
    output [31:0] instAddr_fetch_o,
    output reg [31:0] inst_o,
    output reg [31:0] instAddr_o,
    output reg [1:0] way0_pID_o
);
    
    wire WFull;
    wire [31:0] inst_fetch_buffer;
    wire [31:0] instAddr_fetch_buffer;

    assign request_o = valid_i;
    assign instAddr_fetch_o = instAddr_i;
    assign ready_o = (ready_i && dataOk_i) ? 1'b1 :
                        (WFull && ready_i) ? 1'b1 :
                                             1'b0;

    // 数据暂存，防止取回数据但下一级未Ready而导致数据丢失
    DataBuffer #(.DataWidth(32))
    IFU_inst_Buffer_way0 (
        .Clk(clk),
        .Rst(reset_n),
        .WData(inst_fetch_i),
        .WInc(dataOk_i && ~ready_i),
        .WFull(WFull),
        .RData(inst_fetch_buffer),
        .RInc(WFull && ready_i)
    );

    DataBuffer #(.DataWidth(32))
    IFU_instAddr_Buffer_way0 (
        .Clk(clk),
        .Rst(reset_n),
        .WData(instAddr_i),
        .WInc(dataOk_i && ~ready_i),
        .WFull(),
        .RData(instAddr_fetch_buffer),
        .RInc(WFull && ready_i)
    );

    always @(posedge clk or negedge reset_n) begin
        if(~reset_n) begin
            inst_o <= 32'b0;
            instAddr_o <= 32'b0;
            way0_pID_o <= 2'b10;
            valid_o <= 1'b0;
        end else begin
            if(ready_i && dataOk_i) begin
                inst_o <= inst_fetch_i;
                instAddr_o <= instAddr_i;
                way0_pID_o <= way0_pID_o + 2;
                valid_o <= 1'b1;
            end else begin
                if(WFull && ready_i) begin
                    inst_o <= inst_fetch_buffer;
                    instAddr_o <= instAddr_fetch_buffer;
                    way0_pID_o <= way0_pID_o + 2;
                    valid_o <= 1'b1;
                end else begin
                    inst_o <= inst_o;
                    instAddr_o <= instAddr_o;
                    way0_pID_o <= way0_pID_o;
                    valid_o <= 1'b0;
                end
            end
        end
    end
endmodule