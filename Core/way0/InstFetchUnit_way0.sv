module InstFetchUnit_way0 (
    input logic clk,
    input logic reset_n,
    input logic valid_i,
    input logic ready_i,
    input logic [31:0] instAddr_i,
    input logic [31:0] inst_fetch_i,
    output logic ready_o,
    output logic valid_o,
    output logic [31:0] inst_o,
    output logic [31:0] instAddr_o,
    output logic [1:0] way0_pID_o
);

    //************************************************
    // 数据类型定义
    //************************************************
    wire WFull;
    wire REmpty;
    reg WInc;

    //************************************************
    // 连线
    //************************************************
    // assign request_o = valid_i;
    // assign instAddr_fetch_o = instAddr_i;
    assign ready_o = ~WFull;


    // 数据暂存，防止取回数据但下一级未Ready而导致数据丢失
    DataFIFO #(.DataWidth(32), .FIFO_deepth(1))
    IFU_inst_Buffer_way0 (
        .Clk(clk),
        .Rst(reset_n),
        .WData(inst_fetch_i),
        .WInc(valid_i),
        .WFull(),
        .RData(inst_o),
        .RInc(ready_i && ~REmpty),
        .REmpty(REmpty)
    );

    DataFIFO #(.DataWidth(32), .FIFO_deepth(1))
    IFU_instAddr_Buffer_way0 (
        .Clk(clk),
        .Rst(reset_n),
        .WData(instAddr_i),
        .WInc(valid_i),
        .WFull(WFull),
        .RData(instAddr_o),
        .RInc(ready_i && ~REmpty),
        .REmpty()
    );

    always_ff @(posedge clk or negedge reset_n) begin
        if(~reset_n) begin
            valid_o <= 1'b0;
            way0_pID_o <= 2'b10;
        end else if(ready_i && ~REmpty) begin
            valid_o <= 1'b0;
            way0_pID_o <= way0_pID_o + 2;
        end else begin 
            valid_o <= 1'b0;
        end
    end 

endmodule