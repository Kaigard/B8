module InstFetchUnit_way0 (
    input logic clk,
    input logic reset_n,
    input logic valid_i,
    input logic ready_i,
    input logic dataOk_i,
    input logic [31:0] instAddr_i,
    input logic [31:0] inst_fetch_i,
    output logic ready_o,
    output logic request_o,
    output logic valid_o,
    output logic [31:0] instAddr_fetch_o,
    output logic [31:0] inst_o,
    output logic [31:0] instAddr_o,
    output logic [1:0] way0_pID_o
);
    
    wire WFull;
    wire REmpty;
    wire [31:0] inst_fetch_buffer;
    wire [31:0] instAddr_fetch_buffer;

    assign request_o = valid_i;
    assign instAddr_fetch_o = instAddr_i;
    assign ready_o = ~WFull;
    assign valid_o = ~REmpty;

    // 数据暂存，防止取回数据但下一级未Ready而导致数据丢失
    DataBuffer #(.DataWidth(32))
    IFU_inst_Buffer_way0 (
        .Clk(clk),
        .Rst(reset_n),
        .WData(inst_fetch_i),
        .WInc(dataOk_i && ready_o),
        .WFull(WFull),
        .RData(inst_o),
        .RInc(ready_i && valid_o),
        .REmpty(REmpty)
    );

    DataBuffer #(.DataWidth(32))
    IFU_instAddr_Buffer_way0 (
        .Clk(clk),
        .Rst(reset_n),
        .WData(instAddr_i),
        .WInc(dataOk_i && ready_o),
        .WFull(),
        .RData(instAddr_o),
        .RInc(ready_i && valid_o),
        .REmpty()
    );

    always_ff @(posedge clk or negedge reset_n) begin
        if(~reset_n) begin
            way0_pID_o <= 2'b10;
        end else if(ready_i && valid_o) begin
            way0_pID_o <= way0_pID_o + 2;
        end
    end 

endmodule